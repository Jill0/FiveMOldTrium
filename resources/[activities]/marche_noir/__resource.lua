dependency 'essentialmode'
dependency 'vdk_inventory'

client_script {
	'client.lua',
	'gui.lua'
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

dependency 'vdk_inventory'