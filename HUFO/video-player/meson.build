res = run_command('sh', '-c', 'echo $USER', check: true)
user = res.stdout().strip()
conf_path = '/home' / user / '.config' / 'mpv'

dir = 'follower'
 
if get_option('node').startswith(videoname + '1')
    dir = 'leader'
endif

install_subdir(dir, install_dir: conf_path + install_postfix, strip_directory: true)
install_subdir('scripts', install_dir: conf_path + install_postfix / 'scripts', strip_directory: true)
install_subdir('systemd', install_dir: '/etc/systemd/user', strip_directory: true )

if get_option('versioned_install')
    meson.add_install_script(
    	'sh', '-c',
    	'ln -s -f -n @0@ @1@'.format(
            conf_path + install_postfix + '/',
            conf_path)
    )
endif

