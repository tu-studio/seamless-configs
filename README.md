# Seamless configs
This repo contains all config files used by the [SeamLess System](https://tu-studio.github.io/seamless-docs/) installations managed by the TU Studio. They are laid out in a way that enables installation into the relevant config directories using the meson build system.

Each Location has a location identifier, that corresponds to the outermost directories. Nested in there are the configs for all system components, which in turn might have subfolders corresponding to specific rendering nodes.


## Installation
``` bash
meson setup --wipe build -Dversioned_install=true -Dlocation=<location> -Dnode=<NODE>
meson install -C build
```

| location | available nodes |
|---|---|
|`EN325` | `riviera`, `wintermute`|
| `H0104` | `tengo` (player), `kaoru1` - `kaoru5`|
| `HUFO` | `playstation`, `renderer01` - `renderer03`|

## Versioned install
versioned install enables going back to previous config versions by changing some symlinks around. In meson this is implemented by setting the `install_postfix` in the main build script, that is then added to all installation steps.

## Info on symlink structure for versioned install flag

```path
/usr/local/etc/
├── audio-matrix -> /usr/local/etc/audio-matrix-<location>-<node>-<version>/
├── audio-matrix-<location>-<node>-<version>
├── jack -> /usr/local/etc/jack-<location>-<node>-<version>/
├── jack-<location>-<node>-<version>
├── osc-kreuz -> /usr/local/etc/osc-kreuz-<location>-<node>-<version>/
├── osc-kreuz-<location>-<node>-<version>
├── wonder -> /usr/local/etc/wonder-<location>-<node>-<version>/
└── wonder-<location>-<node>-<version>
```

The systemd service files are not versioned.