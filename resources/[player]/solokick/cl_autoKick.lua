

local seconTry = false
local kick = false
local isSpawn = false

RegisterNetEvent("solo:firstTry")

AddEventHandler("solo:firstTry", function(spawn)
	
	
	 
	 seconTry = true
	
end)


RegisterNetEvent("solo:seconTry")
AddEventHandler("solo:seconTry", function(spawn)
	
	
	 
	 kick = true
	
end)

AddEventHandler('playerSpawned', function(spawn)
--On verifie que c'est pas un fruit pourrit 
			banned = 3
			banned = IsPlayerBanned()
			isSpawn = true
		TriggerServerEvent('bannedtest', banned)

end)


Citizen.CreateThread(function()
	 -- get player ID 
	while true do
        Wait(10000) -- time to refresh script (10 000 for every 1 seconds)
		ptable = GetPlayers()
		playerNumber = 0
		
		for _, i in ipairs(ptable) do
			playerNumber = playerNumber + 1
		end
		
		local name = GetPlayerName(PlayerId())		-- get player name*
		
			
		Wait(38000)
		if isSpawn then
			if playerNumber >= 2 then
				 seconTry = false
				 kick = false
			end
			
		TriggerServerEvent('sendSessionPlayerNumber', playerNumber, name, seconTry, kick)	-- Send infos of number players for client to server
		else 
				seconTry = false
				 kick = false
		end
	end
end)







function GetPlayers() -- function to get players
    local players = {}

    for i = 0, 68 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end