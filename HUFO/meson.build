message('Node: ' + get_option('node'))

install_postfix = '-' + get_option('location') + '-' + get_option('node') + install_postfix

message('Install postfix: ' + install_postfix)

install_subdir('jack', install_dir: get_option('sysconfdir') / 'jack' + install_postfix, strip_directory: true)

if get_option('versioned_install')
meson.add_install_script(
	'sh', '-c',
	'ln -s -f -n @0@ @1@'.format(
        get_option('prefix') / get_option('sysconfdir') / 'jack' + install_postfix + '/',
        get_option('prefix') / get_option('sysconfdir') / 'jack')
)
endif

playername = 'playstation'
renderername = 'renderer'

nodename = get_option('node')

# do node specific installations
# empty cases to check correctness of nodes
if nodename == 'none'
    error('Please specify node with -Dnode=...')
elif nodename == renderername + '01'
    subdir('osc-kreuz')
    subdir('ambisonics')
elif nodename.startswith(renderername)
    subdir('wonder')
elif nodename == playername
    subdir('showcontrol')
else
    error('Unknown node specified.')
endif

subdir('jack-connection-manager')

# do installations for all renderers
if nodename.startswith(renderername)
    subdir('audio-matrix')
endif