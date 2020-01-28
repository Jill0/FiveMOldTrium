
RegisterServerEvent("magasin_composants:Chambres")
AddEventHandler("magasin_composants:Chambres", function()
	TriggerEvent("es:getPlayerFromId", source, function(target)
	  TriggerClientEvent("magasin_composants:Chambre", target.source)
	  TriggerClientEvent("ft_libs:AdvancedNotification", target.source, {
	  	icon = "CHAR_PROPERTY_BAR_MIRROR_PARK",
	  	title = "Marché noir",
	  	text = "Chambre ~r~+1 !\n",
	  })
	end)
end)

RegisterServerEvent('magasin_composants:checkIsMafieu')
AddEventHandler('magasin_composants:checkIsMafieu', function()
  TriggerEvent("es:getPlayerFromId", source, function(user)
    local identifier = user.identifier
    checkIsMafieu(identifier, user.source)
  end)
end)

function checkIsMafieu(identifier, source)
	MySQL.Async.fetchAll("SELECT mafieu FROM users WHERE identifier = @identifier", {['@identifier'] = identifier}, function(result)
        if (result[1].mafieu == 0) then
            TriggerClientEvent('armes_illegales:receiveIsMafieu', source, "0")
		else
		   TriggerClientEvent('armes_illegales:receiveIsMafieu', source, result[1].mafieu)
		end
    end)
end

function s_checkIsMafieu(identifier)
	MySQL.Async.fetchAll("SELECT mafieu FROM users WHERE identifier = @identifier", {['@identifier'] = identifier}, function(result)
        if (result[1].mafieu == 0) then
            return false
		else
		   return true
		end
    end)
end
