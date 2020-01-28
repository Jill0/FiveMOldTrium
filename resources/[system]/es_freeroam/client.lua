AddEventHandler("playerSpawned", function(spawn)
  -- Send notifications
  Citizen.CreateThread(function()
    while true do
      Wait(0)
      SetNotificationTextEntry("STRING")
      AddTextComponentString("Bonjour et bienvenue sur le serveur ~p~Trium RP ~w~!\nPour plus d'info: Tapez ~r~/help")
      SetNotificationMessage("CHAR_ALL_PLAYERS_CONF", "CHAR_ALL_PLAYERS_CONF", true, 1, "~p~Trium RP", "discord.me/trium discord.gg/t5tXee7")
      DrawNotification(false, true)
	    Wait(10000000)
    end
  end)
-- give the player some weapons
end)

RegisterNetEvent("es_freeroam:wanted")
AddEventHandler("es_freeroam:wanted", function()
  Citizen.CreateThread(function()
    SetPlayerWantedLevel(PlayerId(), 0, 0)
    SetPlayerWantedLevelNow(PlayerId(), 0)
  end)
end)

-- Display text
RegisterNetEvent("es_freeroam:displaytext")
AddEventHandler("es_freeroam:displaytext", function(text, time)
  ClearPrints()
 	SetTextEntry_2("STRING")
 	AddTextComponentString(text)
 	DrawSubtitleTimed(time, 1)
end)
