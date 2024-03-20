if get_option('node') == 'riviera'
    install_subdir('riviera', strip_directory : true, install_dir : get_option('sysconfdir') / 'audio-matrix' + install_postfix)
elif get_option('node') == 'wintermute'
    install_subdir('wintermute', strip_directory : true, install_dir : get_option('sysconfdir') / 'audio-matrix' + install_postfix)
endif

if get_option('versioned_install')
meson.add_install_script(
	'sh', '-c',
	'ln -s -f -n @0@ @1@'.format(
        get_option('prefix') / get_option('sysconfdir') / 'audio-matrix' + install_postfix + '/',
        get_option('prefix') / get_option('sysconfdir') / 'audio-matrix')
)
endif