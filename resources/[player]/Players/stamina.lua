Citizen.CreateThread( function()
 while true do
    Citizen.Wait(1)
    RestorePlayerStamina(playerPed, 1.0)
	-- it's that simple
	end
end)