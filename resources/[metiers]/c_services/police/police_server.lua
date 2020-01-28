local inServiceCops = {}

RegisterServerEvent('police:lockunlockjaildoor')
AddEventHandler('police:lockunlockjaildoor', function(door)
	for k, v in pairs(portes) do
		if v.id == door then
			if v.freeze == false then
				TriggerClientEvent("police:lockunlockdoor", -1, v, true)
				v.freeze = true
			else
				TriggerClientEvent("police:lockunlockdoor", -1, v, false)
				v.freeze = false
			end
		end
	end
end)

RegisterServerEvent('police:lockunlockjaildoorSpawn')
AddEventHandler('police:lockunlockjaildoorSpawn', function(id)
	for k, v in pairs(portes) do
		if v.id == id then
			TriggerClientEvent("police:lockunlockdoor", source, v, v.freeze)
		end
	end
end)

function addCop(identifier)
	MySQL.Async.execute('UPDATE users SET `job`=2,`leader`=0 WHERE identifier = @identifier',{['@identifier'] = identifier})

end

function remCop(identifier)
	MySQL.Async.execute('UPDATE users SET `job`=1,`leader`=0 WHERE identifier = @identifier',{['@identifier'] = identifier})
end

RegisterServerEvent('police:removeCop')
AddEventHandler('police:removeCop', function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local identifier = user.identifier
		MySQL.Async.execute('DELETE FROM police WHERE identifier = @identifier', { ['@identifier'] = identifier})
	end)
end)

function checkIsCop(identifier,source)
	 MySQL.Async.fetchAll("SELECT job,leader FROM users WHERE identifier = @identifier", {['@identifier'] = identifier}, function (result)
        local jobID = result[1].job
        local Leader = result[1].leader
	TriggerClientEvent('police:receiveIsCop', source, jobID)
	end)
end

function checkInventory(target)
	local zaeazea = GetPlayerName(target).." possede : "
	local identifier = ""
    TriggerEvent("es:getPlayerFromId", target, function(player)
		local money = player.dirty_money
		zaeazea = zaeazea .. money .. " d'argent sale , "
		player.func.setDirty_Money(0)
		identifier = player.identifier
		local result = MySQL.Sync.fetchAll('SELECT stockage.quantity, stockage.item_id, items.libelle FROM stockage JOIN items ON stockage.item_id = items.id WHERE stockage.type = "player_pocket" AND stockage.identifier = @identifier', { ['@identifier'] = identifier })
		print(json.encode(result))
		if (result) then
			for _, v in ipairs(result) do
				if(v.quantity ~= 0) then
					zaeazea = zaeazea .. v.quantity .. " de " .. v.libelle .. ", "
				end
				if(v.isIllegal == "True") then
					TriggerClientEvent('police:dropIllegalItem', player.source, v.item_id)
				end
			end
		end

		zaeazea = zaeazea .. " / "

		local result = MySQL.Sync.fetchAll('SELECT * FROM user_weapons WHERE identifier = @username', { ['@username'] = identifier })
		if (result) then
			for _, v in ipairs(result) do
					zaeazea = zaeazea .. "possession de " .. v.weapon_model .. ", "
			end
			TriggerEvent("weaponshop:RemoveWeaponsToPlayer",player.source)
		end
	end)

    return zaeazea
end

AddEventHandler('playerDropped', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil

		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)



RegisterServerEvent('police:checkIsCop')
AddEventHandler('police:checkIsCop', function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		local identifier = user.identifier
		checkIsCop(identifier, user.source)
	end)
end)

RegisterServerEvent('police:takeService')
AddEventHandler('police:takeService', function()
	if(not inServiceCops[source]) then
		inServiceCops[source] = GetPlayerName(source)

		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:breakService')
AddEventHandler('police:breakService', function()
	if(inServiceCops[source]) then
		inServiceCops[source] = nil

		for i, c in pairs(inServiceCops) do
			TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
		end
	end
end)

RegisterServerEvent('police:getAllCopsInService')
AddEventHandler('police:getAllCopsInService', function()
	TriggerClientEvent("police:resultAllCopsInService", source, inServiceCops)
end)

RegisterServerEvent('police:checkingPlate')
AddEventHandler('police:checkingPlate', function(plate)
	local result = MySQL.Sync.fetchAll('SELECT Nom FROM user_vehicle JOIN users ON user_vehicle.identifier = users.identifier WHERE vehicle_plate = @plate', { ['@plate'] = plate })
	if (result[1]) then
		for _, v in ipairs(result) do
			TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, "Le vehicule #"..plate.." appartient a " .. v.Nom)
		end
	else
		TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, "Le vehicule #"..plate.." n'est pas enregistré !")
	end
end)

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
	TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, GetPlayerName(t).. " est sortit !")
	TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(t)
	TriggerClientEvent('chatMessage', t, 'LSPD', {0, 0, 255}, "un agent vient de vous fouiller")
	TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, checkInventory(t))
end)

RegisterServerEvent('police:dragRequest')
AddEventHandler('police:dragRequest', function(t)
	TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, GetPlayerName(t).. " est attrapé !")
	TriggerClientEvent('police:toggleDrag', t, source)
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(t, amount, reason)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	sendAmende(user,t,amount,reason)
	TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, GetPlayerName(t).. " à payé $"..amount.." d'amende pour" .. reason)
	TriggerClientEvent('police:payTriumFinesOuicchiant', t, amount, reason)
end)

RegisterServerEvent('police:DropWeapons')
AddEventHandler('police:DropWeapons', function(t)
	TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, "Vous venez de récupérer les armes de ".. GetPlayerName(t))
	TriggerClientEvent('police:LooseWeapons', t)
end)

RegisterServerEvent('police:mettremenottesnouvchangementcasse')
AddEventHandler('police:mettremenottesnouvchangementcasse', function(t)
	TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, GetPlayerName(t).. " menotes enlevées !")
	TriggerClientEvent('police:getArrestedetouicchiant', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
	TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, GetPlayerName(t).. " entre dans la voiture)")
	TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

RegisterServerEvent('police:checkplate')
AddEventHandler('police:checkplate', function(plate)
	Mysource = ""
	Mysource = source

    local result = MySQL.Sync.fetchAll('SELECT vehicle_model, vehicle_plate, identifier  FROM user_vehicle WHERE vehicle_plate = @name', {['@name'] = tostring(plate)})
    if (#result > 0) then
      local result1 = MySQL.Sync.fetchAll('SELECT prenom, nom, phone_number  FROM users WHERE identifier = @name', {['@name'] = tostring(result[1].identifier)})
      if (#result1  > 0) then
        local vehitems = {}
        vehitems = {plate=result[1].vehicle_plate, model=result[1].vehicle_model , name=tostring(result1[1].prenom.." "..result1[1].nom), num=tostring(result1[1].phone_number)}

        TriggerClientEvent("notify:car", Mysource, vehitems)
      end
    else
      TriggerClientEvent("notify:car", Mysource,{name="Véhicule volé"})
    end
end)
-----------------------------------------------------------------------
----------------------EVENT SPAWN POLICE VEH---------------------------
-----------------------------------------------------------------------
RegisterServerEvent('CheckPoliceVeh')
AddEventHandler('CheckPoliceVeh', function(vehicle)
	TriggerEvent('es:getPlayerFromId', source, function(user)

			TriggerClientEvent('FinishPoliceCheckForVeh',user.source)
			-- Spawn police vehicle
			TriggerClientEvent('policeveh:spawnVehicle', user.source, vehicle)
	end)
end)

-----------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP COP-------------------
-----------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'copadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, "Utilisation : /copadd [ID]")
	else
	mysoure = source
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				addCop(target.identifier)
				TriggerClientEvent('chatMessage', mysoure, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", target.source, {
					icon = "CHAR_ANDREAS",
					title = "LSPD",
					text = "Vous êtes désormais un de nos agents !",
				})

				TriggerClientEvent('police:nowCop', target.source)
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,2)
			end)
		else
			TriggerClientEvent('chatMessage', mysoure, 'LSPD', {0, 0, 255}, "Pas de joueur avec cet ID")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', mysoure, 'LSPD', {0, 0, 255}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'coprem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'LSPD', {0, 0, 255}, "Utilisation : /coprem [ID]")
	else
	mysoure = source
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				remCop(target.identifier)
				TriggerClientEvent("ft_libs:AdvancedNotification", target.source, {
					icon = "CHAR_ANDREAS",
					title = "LSPD",
					text = "Vous n'êtes plus un de nos agents !",
				})

				TriggerClientEvent('chatMessage', target.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('police:noLongerCop',target.source)
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', mysoure, 'GOUVERNEMENT', {255, 0, 0}, "Pas de joueur avec cet ID")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', mysoure, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

RegisterServerEvent('police:setService')
AddEventHandler('police:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
		Player.func.setSessionVar('policeInService', inService)
	end)
end)
function sendAmende(cop,t,amende,motif)
	TriggerEvent('discord:LSPD', "INFORMATION :moneybag: : **" .. cop.nom .. " ".. cop.prenom ..  "** a fait payé **"..amende.."** $ d'amende à "..GetPlayerName(t).. "("..t..") pour "..motif)
end