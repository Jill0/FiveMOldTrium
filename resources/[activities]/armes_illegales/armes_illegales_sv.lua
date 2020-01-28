local foodmenu = 100
local watermenu = 100
local needsmenu = -10
local wc = 100

RegisterServerEvent('armes_illegales:testprix')
AddEventHandler('armes_illegales:testprix', function(item,prixmenu)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if(user.money >= prixmenu)then
			user.func.removeMoney(prixmenu)

			TriggerClientEvent('armes_illegales:getFood',user.source,item)
		end
	end)
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

RegisterServerEvent('armes_illegales:checkIsMafieu')
AddEventHandler('armes_illegales:checkIsMafieu', function()
  --print(source)
  TriggerEvent("es:getPlayerFromId", source, function(user)
    local identifier = user.identifier
    --print(identifier)
    checkIsMafieu2(identifier, user.source)
  end)
end)

function checkIsMafieu2(identifier, source)
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