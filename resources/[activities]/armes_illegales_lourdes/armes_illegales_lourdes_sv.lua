RegisterServerEvent('armes_illegales_lourdes:testprix')
RegisterServerEvent('armes_illegales_lourdes:checkIsMafieu')


AddEventHandler('armes_illegales_lourdes:testprix', function(item,prixmenu)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if(user.money >= prixmenu)then
			user.func.removeMoney(prixmenu)
			TriggerClientEvent('armes_illegales:getFood',user.source,item)
		end
	end)
end)




AddEventHandler('armes_illegales_lourdes:checkIsMafieu', function()
  TriggerEvent("es:getPlayerFromId", source, function(user)
    local identifier = user.identifier
    checkIsMafieu2(identifier, user.source)
  end)
end)

function checkIsMafieu2(identifier, source)
	MySQL.Async.fetchAll("SELECT trafiquant FROM users WHERE identifier = @identifier", {['@identifier'] = identifier}, function(result)
	
        if (result[1].trafiquant == 1) then
			TriggerClientEvent('armes_illegales_lourdes:receiveIsMafieu', source, result[1].trafiquant)
        else
			TriggerClientEvent('armes_illegales_lourdes:receiveIsMafieu', source, "0")  
		end
    end)
end
