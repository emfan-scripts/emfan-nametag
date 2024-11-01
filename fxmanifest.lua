fx_version 'cerulean'
game 'gta5'

author 'eMILSOMFAN'
description 'This script provides a customizable nametag feature for players in FiveM, allowing server administrators to manage and display player names effectively.'
version '1.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/cl_main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_main.lua'
}

lua54 'yes'

escrow_ignore {
    ''
}

ui_page 'html/index.html'

files {
    'html/*'
}

dependency {
    'emfan-framework'
}