description 'EssentialMode by Kanersps.'

ui_page 'ui.html'

-- NUI Files
files {
	'ui.html',
	'pdown.ttf'
}

-- Server
server_scripts {
	'server/classes/player.lua',
	'server/classes/groups.lua',
	'server/player/login.lua',
	'server/main.lua',
	'server/util.lua',
	'@mysql-async/lib/MySQL.lua'
}

server_exports {
    'getPlayerFromId',
    'getAllPlayerConnected'
}
-- Client
client_script 'client/main.lua'
