
ui_page 'notifs/index.html'

files {
	'notifs/index.html',
	'notifs/hotsnackbar.css',
	'notifs/hotsnackbar.js'
}


client_scripts {
	'config.lua',
	'notifs.lua',
	'map.lua',
	'client.lua',
	'GUI.lua',
	'models_c.lua'
}

export 'getelec'

server_scripts {
	'config.lua',
	'server.lua'
}