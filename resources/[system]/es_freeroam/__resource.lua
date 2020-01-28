--resource_type 'gametype' { name = 'es_freeroam'}

description 'FiveM es_freeroam'

-- Requiring essentialmode
dependency 'essentialmode'

-- General
client_scripts {
  'client.lua',
  'player/map.lua',
  'player/scoreboard.lua',
  'stores/vehshop.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua',
  'stores/vehshop_s.lua',
}
