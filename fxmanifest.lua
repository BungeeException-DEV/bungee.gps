fx_version 'cerulean'
game 'gta5'

author 'BungeeException'
description 'GPS Tracker Script'
version '1.0'

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    'client/utils.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'client/utils.lua',
    'server/main.lua'
}