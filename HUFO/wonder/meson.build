# The speaker configurations need to have the same folder structure for the twonder start script to work.
# Also the speaker configurations need to start with twonder.
nodename = get_option('node')
if nodename == renderername + '02' or nodename == renderername + '03'
    install_subdir('twonder/' + nodename, strip_directory : true, install_dir : get_option('sysconfdir') / 'wonder' + install_postfix / 'twonder')


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
endif