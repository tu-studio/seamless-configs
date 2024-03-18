message('Node: ' + get_option('node'))

install_postfix = '-' + get_option('location') + '-' + get_option('node') + install_postfix

message('Install postfix: ' + install_postfix)

install_subdir('jack', install_dir: get_option('sysconfdir') / 'jack' + install_postfix, strip_directory: true)

if get_option('versioned_install')
meson.add_install_script(
	'sh', '-c',
	'ln -s -f @0@ @1@'.format(
        get_option('prefix') / get_option('sysconfdir') / 'jack' + install_postfix + '/',
        get_option('prefix') / get_option('sysconfdir') / 'jack')
)
endif

subdir('wonder')