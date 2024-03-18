install_data('osc-kreuz_conf.yml', install_dir: get_option('sysconfdir') / 'osc-kreuz' + install_postfix)

if get_option('versioned_install')
meson.add_install_script(
	'sh', '-c',
	'ln -s -f @0@ @1@'.format(
        get_option('prefix') / get_option('sysconfdir') / 'osc-kreuz' + install_postfix + '/',
        get_option('prefix') / get_option('sysconfdir') / 'osc-kreuz')
)
endif