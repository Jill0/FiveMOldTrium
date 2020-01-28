--snippet from hardcap to make PlayerCount work
PlayerCount = 0
list = {}

function ActivateTrain ()
	if (PlayerCount) == 1 then
		TriggerClientEvent('StartTrain', GetHostId())
		print("StartTrain")
	else
		SetTimeout(15000,ActivateTrain)
	end
end

-- yes i know i'm lazy
RegisterServerEvent("ft_libs:OnClientReady")
AddEventHandler('ft_libs:OnClientReady', function()
  if not list[source] then
    PlayerCount = PlayerCount + 1
    list[source] = true
		if (PlayerCount) == 1 then -- new session?
			SetTimeout(15000,ActivateTrain)
		end
  end
end)

--
RegisterServerEvent("playerDropped")
AddEventHandler('playerDropped', function()
  if list[source] then
    PlayerCount = PlayerCount - 1
    list[source] = nil
  end
end)
