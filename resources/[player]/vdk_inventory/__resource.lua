resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
ui_page 'alcool.html'
files {
	'alcool.html',
	'pdown.ttf'
}

server_scripts {
--	'@essentialmode/config.lua',
	'config.lua',
	'server.lua',
	'sv_weapons.lua',
	'@mysql-async/lib/MySQL.lua'
}
client_script {
	'config.lua',
	'vdkinv.lua',
	'GUI.lua',
	'c_menufood.lua',
	'cl_weapons.lua'
}

export 'getQuantity'
export 'notFull'
export 'tryFull'
export 'getPods'
export 'ClosePlayerInventory'
server_export 'GetPlayerStockage'
server_export 'SavePlayersStockage'