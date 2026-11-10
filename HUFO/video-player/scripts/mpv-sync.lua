-- mpv-sync.lua - Synchronize two mpv instances via UDP
-- Usage:
--   Leader: mpv --script-opts=sync-role=leader,sync-ip=192.168.10.255,sync-port=12345 video.mp4
--   Follower:  mpv --script-opts=sync-role=follower video.mp4

-- configuration
local opts = {
    role = "leader",                 -- "leader" or "follower"
    ip = "192.168.10.255",           -- target ip
    port = 12345,                    -- target port
    sync_interval = 0.5,             -- seconds between position sync updates
    seek_threshold = 5.0,            -- seconds of difference before hard seeking
    speed_adjust_threshold = 0.02,   -- seconds - below this, reset to normal speed (20ms)
    max_speed_adjust = 0.5,          -- maximum speed adjustment (e.g., 0.5 = 50% faster/slower)
    initial_offset = 0.015,          -- initial offset in seconds (e.g., 0.015 = 15ms)
    show_osd = false,                -- show sync info on screen (toggle with 'i' key on follower)
    verbose = false,                 -- print sync command
    silent = false,                  -- suppress info
}

local function _vprint(msg, v_only, fn)
    v_only = v_only or false
    if opts.silent then return end
    if v_only and not opts.verbose then return end
    fn(msg)
end

local function vwarn(msg, v_only) _vprint(msg, v_only, mp.msg.earn) end
local function vinfo(msg, v_only) _vprint(msg, v_only, mp.msg.info) end
local function verror(msg, v_only) _vprint(msg, v_only, mp.msg.error) end
local function vdebug(msg, v_only) _vprint(msg, v_only, mp.msg.debug) end
local function osd_msg(msg, i)
    if not opts.show_osd then return end
    mp.osd_message(msg, i)
end

local Follower = {
    base_speed = 1.0,
    offset = opts.initial_offset,
}

function Follower:adjust_speed(time_diff, leader_pos, follower_pos)
    local offset_str = ""
    if math.abs(self.offset) > 0.001 then
        offset_str = string.format(" | Offset: %+dms", math.floor(self.offset * 1000 + 0.5))
    end

    if math.abs(time_diff) < opts.speed_adjust_threshold then
        mp.set_property("speed", self.base_speed)
        local msg = string.format("Leader: %.2fs | Follower: %.2fs | Diff: %.3fs | Speed: %.3f (IN SYNC)%s",
            leader_pos, follower_pos, time_diff, self.base_speed, offset_str)
        vinfo("FOLLOWER: " .. msg, true)
        osd_msg(msg, 2)
        return
    end

    local abs_diff = math.abs(time_diff)
    local speed_factor

    if abs_diff < 0.05 then
        speed_factor = abs_diff * 1.0
    elseif abs_diff < 0.2 then
        speed_factor = 0.05 + (abs_diff - 0.05) * 0.5
    elseif abs_diff < 1.0 then
        speed_factor = 0.125 + (abs_diff - 0.2) * 0.25
    else
        speed_factor = math.min(abs_diff / 3.0, opts.max_speed_adjust)
    end

    speed_factor = math.min(speed_factor, opts.max_speed_adjust)

    local new_speed
    local direction
    if time_diff > 0 then
        new_speed = self.base_speed + speed_factor
        direction = "BEHIND (speeding up)"
    else
        new_speed = self.base_speed - speed_factor
        direction = "AHEAD (slowing down)"
    end

    new_speed = math.max(0.5, math.min(2.0, new_speed))

    local correction = ((new_speed / self.base_speed) - 1) * 100
    mp.set_property("speed", new_speed)

    local msg = string.format("Leader: %.2fs | Follower: %.2fs | Diff: %.3fs | Speed: %.3f (%+.1f%%) %s%s",
        leader_pos, follower_pos, time_diff, new_speed, correction, direction, offset_str)
    vinfo("FOLLOWER: " .. msg, true)
    osd_msg(msg, 2)
end

function Follower:sync_position(time)
    local current = mp.get_property_number("time-pos")
    if not current then return end

    local target_pos = time + self.offset
    local diff = target_pos - current

    if math.abs(diff) > opts.seek_threshold then
        local offset_str = ""
        if math.abs(self.offset) > 0.001 then
            offset_str = string.format(" | Offset: %+dms", math.floor(self.offset * 1000 + 0.5))
        end
        local msg = string.format(
            "HARD SEEK: Leader: %.2fs | Follower: %.2fs | Diff: %.2fs (> %.1fs threshold)%s",
            time, current, diff, opts.seek_threshold, offset_str)
        vinfo("FOLLOWER: " .. msg, true)
        osd_msg(msg, 3)
        mp.commandv("seek", target_pos, "absolute")
    else
        self:adjust_speed(diff, time, current)
    end
end

function Follower:init()
    mp.register_script_message("sync-position", function(time)
        local pos = tonumber(time)
        if pos then
            self:sync_position(pos)
        end
    end)

    vinfo("FOLLOWER: registered IPC message handler")

    if math.abs(self.offset) > 0.001 then
        vinfo(string.format("FOLLOWER: Initial offset: %+dms",
            math.floor(self.offset * 1000 + 0.5)), true)
    end
end

Leader = {
    ip = "127.0.0.1",
    port = 9999,
    socat = nil,
    interval = 0.5,
    last_pos = -1.,
}

function Leader:send_command(message, data)
    if data then
        message = message .. "|" .. data
    end

    local cmd, value = message:match("([^|]+)|?(.*)")

    if cmd == "position" then
        local json = require("mp.utils").format_json({
            command = {"script-message", "sync-position", value}
        })
        message = json
    end

    local socat_cmd = string.format(
        "echo '%s' | %s -u - UDP4-DATAGRAM:%s:%d,broadcast 2>/dev/null &",
        message, self.socat, self.ip, self.port
    )

    os.execute(socat_cmd)
end

function Leader:send_position()
    local pos = mp.get_property_number("time-pos")
    if not pos then return end
    if self.last_pos == pos then return end
    self:send_command("position", tostring(pos))
    self.last_pos = pos
end

function Leader:init(ip, port, socat, interval)
    self.ip = ip
    self.port = port
    self.interval = interval
    self.socat = socat

    local _ = mp.add_periodic_timer(self.interval, function()
        self:send_position()
    end)

    vinfo(string.format("LEADER: broadcasting to %s:%d", self.ip, self.port))
end

-- COMMON SET-UP
-- parse script options
(require 'mp.options').read_options(opts, "sync")

local function find_socat(role)
    -- check if `socat` is available
    local socat_path = nil

    for _, cmd in ipairs({"socat", "/usr/bin/socat", "/bin/socat"}) do
        local handle = io.popen("which " .. cmd .. " 2>/dev/null")
        if handle == nil then do return end end
        local result = handle:read("*a")
        handle:close()
        if result and result ~= "" then
            socat_path = cmd
            vinfo(role .. ": Using socat backend: " .. socat_path)
            return true, socat_path
        end
    end

    if socat_path == nil then
        verror(role .. ": socat not found!")
        return false, nil
    end
end

if opts.role == "leader" then
    local ok, socat = find_socat("LEADER")
    if not ok then return end
    Leader:init(opts.ip, opts.port, socat, opts.sync_interval)
    vinfo("LEADER: mpv-sync.lua loaded successfully!")
elseif opts.role == "follower" then
    Follower:init()
    vinfo("FOLLOWER: mpv-sync.lua loaded successfully!")
end
