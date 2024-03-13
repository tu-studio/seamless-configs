project('EN325-config-files', 'cpp',
        version:'0.1.0',
        license:'Apache-2.0',
        default_options:['cpp_std=c++20'])

# subdir('systemd')
message('Location: ' + get_option('location'))

if get_option('location') == 'none'
    error('Please specify location with -Dlocation=...')
elif get_option('location') == 'EN325'
    subdir('EN325')
elif get_option('location') == 'HUFO'
    subdir('HUFO')
else
    error('Invalid location')
endif

if get_option('jack_service')
    install_data('systemd/user/jack.service', install_dir: '/etc/systemd/user')
endif

summary({'Install jack service': get_option('jack_service'),
         'Location': get_option('location'),
         'Node': get_option('node'),
         'Systemd user directory': '/etc/systemd/user',
         'Configuration directory': get_option('prefix') / get_option('sysconfdir')},
         section: 'Configuration')