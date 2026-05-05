program_name = 'showcontrol'

install_subdir('config', strip_directory : true, install_dir : get_option('sysconfdir') / program_name + install_postfix)

if get_option('versioned_install')
meson.add_install_script(
	'sh', '-c',
	'ln -s -f -n @0@ @1@'.format(
        get_option('prefix') / get_option('sysconfdir') / program_name + install_postfix + '/',
        get_option('prefix') / get_option('sysconfdir') / program_name)
)
endif