
RegisterServerEvent('chasse:serverRequest')
AddEventHandler('chasse:serverRequest', function (typeRequest)
	local mysource = source
	TriggerEvent ('es:getPlayerFromId', mysource, function(user)
		local player = user.identifier
		if typeRequest == "SellViande" then
			MySQL.Async.fetchAll('SELECT quantity FROM stockage WHERE type = "player_pocket" AND item_id=23 AND identifier=@identifier', {['@identifier'] = player}, function(result)
				local qte
				for _, v in ipairs(result) do
					qte = v.quantity
				end
				TriggerClientEvent('chasse:drawSellViande',user.source,qte)
			end)
		end
	end)
end)
