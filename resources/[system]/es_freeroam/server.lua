AddEventHandler('es:playerLoaded', function(source)
	-- Get the players money amount
	TriggerEvent("es:getPlayerFromId", source, function(user)
		user.func.setMoney(user.money)
		user.func.setDirty_Money(user.dirty_money)
	end)
end)

RegisterServerEvent('mission:completed')
AddEventHandler('mission:completed', function(total)
	-- Get the players money amount
	TriggerEvent('es:getPlayerFromId', source, function(user)
	-- update player money amount
		user.func.addMoney((total))
		TriggerClientEvent("ft_libs:AdvancedNotification", source, {
	    	icon = "CHAR_BANK_MAZE",
	        title = "Maze Bank",
	        text = "You received ~g~$".. tonumber(total),
	    })
	end)
end)

RegisterServerEvent('es_freeroam:pay')
AddEventHandler('es_freeroam:pay', function(amount)
	-- Get the players money amount
	TriggerEvent("es:getPlayerFromId", source, function(user)
		if(user.money > amount) then
			TriggerClientEvent("ft_libs:AdvancedNotification", source, {
		    	icon = "CHAR_BANK_MAZE",
		        title = "Maze Bank",
		        text = "Your transaction is ~g~completed.",
		    })
			user.func.removeMoney((amount))
		else
			TriggerClientEvent("ft_libs:AdvancedNotification", source, {
		    	icon = "CHAR_BANK_MAZE",
		        title = "Maze Bank",
		        text = "Your transaction is ~r~rejected.",
		    })
		end
	end)
end)

RegisterServerEvent("scoreboard:isAdmin")
AddEventHandler("scoreboard:isAdmin", function()
	TriggerEvent('es:getPlayerFromId', source, function(player)
		TriggerClientEvent("scoreboard:setAdmin", source, player.group.group)
	end)
end)
