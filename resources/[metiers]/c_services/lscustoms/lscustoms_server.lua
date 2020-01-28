local tbl = {
	[1] = {locked = false},
	[1] = {locked = false}
}

garagea = 0

AddEventHandler('playerDropped', function()
	if garagea ~= 0 then
		tbl[tonumber(garagea)].locked = false
		TriggerClientEvent('lockGarage',-1,tbl)
		print(json.encode(tbl))
	end
end)

RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	garagea = tonumber(garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		garagea = 0
	end
	TriggerClientEvent('lockGarage',-1,tbl)
	print(json.encode(tbl))
end)

RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
	print(json.encode(tbl))
end)

RegisterServerEvent('CheckMoneyForCus')
AddEventHandler('CheckMoneyForCus', function(price)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.money) >= tonumber(price)) then
			-- Pay the shop (price)
			user.func.removeMoney((price))
			TriggerClientEvent('FinishMoneyCheckForCus',source)

			TriggerClientEvent("ft_libs:AdvancedNotification", source, {
			  	icon = "CHAR_BANK_MAZE",
			  	title = "Maze Bank",
			  	text = "Tu as payer : ~g~"..price.." ~g~$",
			})

		else
			TriggerClientEvent('CusNoMoney',source)
			-- Inform the player that he needs more money

			TriggerClientEvent("ft_libs:AdvancedNotification", source, {
				icon = "CHAR_BANK_MAZE",
			  	title = "Maze Bank",
			  	text = "T'as pas assez de thune !\n",
			})

		end
	end)
end)
