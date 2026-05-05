# The speaker configurations need to have the same folder structure for the twonder start script to work.
# Also the speaker configurations need to start with twonder.

if get_option('node') == 'riviera'
    install_subdir('twonder/riviera/speaker-positions', strip_directory : false, install_dir : get_option('sysconfdir') / 'wonder' + install_postfix / 'twonder')
    install_data('twonder/riviera/systemd/twonder.target', install_dir: '/etc/systemd/user')

elif get_option('node') == 'wintermute'
    install_subdir('twonder/wintermute/speaker-positions', strip_directory : false, install_dir : get_option('sysconfdir') / 'wonder' + install_postfix / 'twonder')
    install_data('twonder/wintermute/systemd/twonder.target', install_dir: '/etc/systemd/user')

endif

# Install the remaining files if the node is correct, no error is thrown.
install_data('cluster.conf', install_dir : get_option('sysconfdir') / 'wonder' + install_postfix)
install_data('twonder/twonder_config.xml', install_dir : get_option('sysconfdir') / 'wonder' + install_postfix / 'twonder')

if get_option('versioned_install')
meson.add_install_script(
	'sh', '-c',
	'ln -s -f -n @0@ @1@'.format(
        get_option('prefix') / get_option('sysconfdir') / 'wonder' + install_postfix + '/',
        get_option('prefix') / get_option('sysconfdir') / 'wonder')
)
endif