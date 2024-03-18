project('seamless-configs', 'cpp',
        version: run_command('git', 'describe', '--dirty', check: true).stdout().strip(),
        license:'Apache-2.0',
        default_options:['cpp_std=c++20'])

message('Location: ' + get_option('location'))

if get_option('versioned_install')
  	install_postfix = '-' + meson.project_version()
else
	install_postfix = ''
endif

if get_option('location') == 'none'
    error('Please specify location with -Dlocation=...')
elif get_option('location') == 'EN325'
    subdir('EN325')
elif get_option('location') == 'HUFO'
    subdir('HUFO')
else
    error('Invalid location')
endif

install_data('systemd/user/jack.service', install_dir: '/etc/systemd/user')

summary({'Location': get_option('location'),
         'Node': get_option('node'),
         'Systemd user services install directory': '/etc/systemd/user',
         'Configuration file install directory': get_option('prefix') / get_option('sysconfdir'),
         'Versioned install': get_option('versioned_install')},
         section: 'Options')