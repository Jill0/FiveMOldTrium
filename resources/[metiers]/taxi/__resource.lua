--=============================================================================
--  Jonathan D @ Gannon
--=============================================================================

server_script '@mysql-async/lib/MySQL.lua'
-- General
client_scripts {
  'taxi_Menu.lua',
  'taxi_client.lua'
}

server_scripts {
  'taxi_server.lua'
}
