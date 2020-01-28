resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
    'ambulancier_server.lua',
	'@mysql-async/lib/MySQL.lua'
} 

client_scripts {
	'ambulancier_client.lua',
	'healthPlayerManager.lua',
	'ambulancier_Menu.lua'
}

