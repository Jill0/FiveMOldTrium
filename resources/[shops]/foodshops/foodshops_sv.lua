local foodmenu = 100
local watermenu = 100
local needsmenu = -10
local wc = 100
local taxe = 0.76 -- 76 %

RegisterServerEvent('food:testprix')
AddEventHandler('food:testprix', function(item,prixmenu)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if(user.money >= prixmenu)then
			user.func.removeMoney(prixmenu)
			TriggerClientEvent('food:getFood',user.source,item)
			local taxegouv = math.floor(prixmenu * taxe)
			MySQL.Async.execute("UPDATE entreprises_coffres SET `solde`= solde + @montant WHERE job_id = @jobid", {['@montant'] = taxegouv,['@jobid'] = 23})
		end
	end)
end)

RegisterServerEvent('gabs:pipi')
AddEventHandler('gabs:pipi', function()
	TriggerEvent('gabs:removeneeds', source, wc)
end)

--[[AddEventHandler('chatMessage', function(source, name, message)
	if(message:sub(1,1) == "/") then
		local args = splitString(message, " ")
		local cmd = args[1]
		if (cmd == "/pipi") then
			CancelEvent()
			TriggerEvent('gabs:removeneeds', source, wc)
		end
	end
end)]]

TriggerEvent('es:addCommand', 'pipi', function(source, args, user)
	table.remove(args, 1)
	

	CancelEvent()
	TriggerEvent('gabs:removeneeds', source, wc)
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
