res = run_command('sh', '-c', 'echo $USER', check: true)
user = res.stdout().strip()
 
install_subdir('config', install_dir: '/home' / user / '.config' / 'IEMAudioPlugins' + install_postfix, strip_directory: true)

install_subdir('systemd', install_dir: '/etc/systemd/user', strip_directory: true )

if get_option('versioned_install')
meson.add_install_script(
	'sh', '-c',
	'ln -s -f -n @0@ @1@'.format(
        '/home' / user / '.config' / 'IEMAudioPlugins' + install_postfix + '/',
        '/home' / user / '.config' / 'IEMAudioPlugins')
)
endif