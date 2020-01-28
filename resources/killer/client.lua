RegisterNetEvent('showNotification')
AddEventHandler('showNotification', function(text)
	ShowNotification(text)
end)
function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end


Citizen.CreateThread(function()
    -- main loop thing
	alreadyDead = false
    while true do
        Citizen.Wait(50)
		local playerPed = GetPlayerPed(-1)
		if IsEntityDead(playerPed) and not alreadyDead then
			killer = GetPedKiller(playerPed) 
           
			
			  
			 
			 carkiller = GetPedInVehicleSeat(killer , -1)
			killername = false
			killername2 = false
			killerid = 0
			for id = 0, 119 do
				if killer == GetPlayerPed(id)then
					killername = GetPlayerName(id) 
					
					killerid = id
				end		
				
			end
			
			for id = 0, 119 do
				if  carkiller == GetPlayerPed(id) then
					killername2 = GetPlayerName(id) 
					
					killerid = id
				end		
				
			end
			if killer == playerPed  then
				TriggerServerEvent('playerDied',0,0)
			elseif killername and killername ~= "**Invalid**"  then
				
				TriggerServerEvent('playerDied',killername,1)
				
			elseif killername2 and killername2 ~= "**Invalid**" then
			TriggerServerEvent('playerDied',killername2,1)
			else
				TriggerServerEvent('playerDied',"tu " ,2)
			end
			alreadyDead = true
			
		end
		if not IsEntityDead(playerPed) and alreadyDead then
		
			alreadyDead = false
		end
	end
end)