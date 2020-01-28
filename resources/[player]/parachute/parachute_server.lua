RegisterServerEvent("parachute:buy")
AddEventHandler("parachute:buy", function()
    TriggerEvent("es:getPlayerFromId", source, function(user)
		if(tonumber(price) <= tonumber(user.money)) then
			user.func.removeMoney(price)
		else
			TriggerClientEvent('parachute:notif', source, "~r~Vous n'avez pas assez d'argent.")
		end
	end)
end)