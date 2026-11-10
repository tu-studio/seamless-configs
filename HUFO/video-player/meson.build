res = run_command('sh', '-c', 'echo $USER', check: true)
user = res.stdout().strip()

conf_path = '/home' / user / '.config' / 'mpv'
dir = 'follower'
systemd_files = ['systemd/mpv.service']

if get_option('node').startswith(videoname + '1')
    dir = 'leader'
    systemd_files += ['systemd/mpv-udp-bridge-leader.service']
else
    systemd_files += ['systemd/mpv-udp-bridge-follower.service']
endif

install_subdir(dir, install_dir: conf_path + install_postfix, strip_directory: true)
install_subdir('scripts', install_dir: conf_path + install_postfix / 'scripts', strip_directory: true)
install_data(systemd_files, install_dir: '/etc/systemd/user')

if get_option('versioned_install')
    meson.add_install_script(
    	'sh', '-c',
    	'ln -s -f -n @0@ @1@'.format(
            conf_path + install_postfix + '/',
            conf_path)
    )
endif

