RegisterServerEvent('concessionnaire:CheckJob')
AddEventHandler('concessionnaire:CheckJob', function(Job_ID)
  TriggerEvent("es:getPlayerFromId", source, function(user)
    local Job_User = user.jobId
    if(Job_User == Job_ID) then
		TriggerClientEvent('concessionnaire:DroitMenu', user.source, "1")
		--print('OK')
	else
		TriggerClientEvent('concessionnaire:DroitMenu', user.source, "0")
		--print('NOK')
	end
  end)
end)

RegisterServerEvent('concessionnaire:CheckLocation')
AddEventHandler('concessionnaire:CheckLocation', function()
 TriggerEvent("es:getPlayerFromId", source, function(user)
	 MySQL.Async.fetchAll("SELECT vehicle_name,nom,prenom FROM user_vehicle INNER JOIN users ON user_vehicle.identifier = users.identifier WHERE user_vehicle.veh_location = 1", {['@identifier'] = user.identifier}, function (result)
		   if (result[1]) then
				--print("DEBUG " ..result[1].nom)
				--print("DEBUG " ..result[1].prenom)
				--print("DEBUG " ..result[1].vehicle_name)
				TriggerClientEvent('concessionnaire:MenuLocation', user.source, result)
			end
		end)
	end)
end)

RegisterServerEvent('concessionnaire:Delete')
AddEventHandler('concessionnaire:Delete', function(nom,prenom,vehicule)
	 local result = MySQL.Sync.fetchAll("SELECT identifier FROM users WHERE nom = @nom AND prenom = @prenom ", {['@nom'] = nom, ['@prenom'] = prenom })
	   if (result) then
			MySQL.Sync.execute("DELETE FROM user_vehicle WHERE identifier = @identifier AND vehicle_name = @model AND vehicle_plate LIKE '%LOCA%'", { ['@identifier'] = result[1].identifier, ['@model'] = vehicule})
			TriggerClientEvent("ft_libs:AdvancedNotification", source, {
				icon = "CHAR_SIMEON",
			  	title = "Loca'Luxe",
			  	text = "Le véhicule (~g~" .. vehicule .. "~w~) de ~o~".. prenom .. " " .. nom .. "~w~ est maintenant ~r~supprimé ~w~ !",
			})

			  TriggerClientEvent('concessionnaire:RetourMenu', source)
		end
end)

RegisterServerEvent('concessionnaire:VendreVeh')
AddEventHandler('concessionnaire:VendreVeh',function(idcible, vehicle, price, plate, retraitcoffre)

TriggerClientEvent("ft_libs:AdvancedNotification", source, {
	icon = "CHAR_SIMEON",
	title = "Loca'Luxe",
	text = "Vous avez vendu une : ~g~"..vehicle,
})

		local player = tonumber(idcible)
		TriggerEvent("es:getPlayerFromId", player, function(target)
		local cible = target.identifier
		local name = vehicle
		local price = price
		local vehicle = vehicle
		local state = "Sorti"
		--local playername = exports["essentialmode"]:getPlayerFromId(idcible)
		local concessionnaire = exports["essentialmode"]:getPlayerFromId(source)
		MySQL.Async.fetchScalar("SELECT COUNT(*) FROM user_vehicle WHERE `vehicle_plate` = @plate", {['@plate'] = plate}, function(result)
			while result > 0 do
				plate = tostring(math.random(10000000,99999999))
				result = MySQL.Sync.fetchScalar("SELECT COUNT(*) FROM user_vehicle WHERE `vehicle_plate` = @plate", {['@plate'] = plate})
			end
			MySQL.Async.execute('INSERT INTO user_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_price`, `vehicle_plate`,`vehicle_state`,`veh_type`) VALUES (@username, @name, @vehicle, @price, @plate, @state, @type)',
			{['@username'] = cible, ['@name'] = name, ['@vehicle'] = vehicle, ['@price'] = price, ['@plate'] = plate,['@state'] = state, ['@type'] = 1})
			MySQL.Async.execute('UPDATE entreprises_coffres SET solde = solde - @prixadd WHERE job_id = @jobid',{['@prixadd'] = retraitcoffre,['@jobid'] = 25 })

			TriggerClientEvent("ft_libs:AdvancedNotification", target.source, {
				icon = "CHAR_SIMEON",
				title = "Loca'Luxe",
				text = "~o~Votre nouveau vehicule vous attends dehors ! Merci pour votre achat chez ~g~Loca'Luxe ~o~!",
			})

			TriggerEvent('discord:venteConcess',"VENTE :oncoming_automobile: : **" .. concessionnaire.prenom .. " " .. concessionnaire.nom .. "** (ID : " .. concessionnaire.source ..") a vendu " .. vehicle .. "("..plate..") pour **"..price.."** $") -- msg Discord
			TriggerClientEvent("concessionnaire:spawnSoldCar",target.source, vehicle, plate)
		end)
	end)
end)

RegisterServerEvent('concessionnaire:TransfertVeh')
AddEventHandler('concessionnaire:TransfertVeh',function(plaque, idcible)
	local acheteur = tonumber(idcible)
	local player = exports["essentialmode"]:getPlayerFromId(acheteur)
	local concessionnaire = exports["essentialmode"]:getPlayerFromId(source)
	--
	local control_plate = MySQL.Sync.fetchScalar("SELECT ID FROM user_vehicle WHERE `vehicle_plate` = @plate", {['@plate'] = plaque})
	if (control_plate ~= nil) then
		MySQL.Async.execute("UPDATE user_vehicle SET identifier = @identacheteur WHERE vehicle_plate = @plaquevendeur", { ['@identacheteur'] = player.identifier, ['@plaquevendeur'] = plaque})

		TriggerClientEvent("ft_libs:AdvancedNotification", source, {
			icon = "CHAR_SIMEON",
			title = "Loca'Luxe",
			text = "~o~Le véhicule " .. plaque .. " appartient maintenant à : " .. player.prenom .. " " .. player.nom,
		})

		TriggerClientEvent("ft_libs:AdvancedNotification", player.source, {
			icon = "CHAR_SIMEON",
			title = "Loca'Luxe",
			text = "~o~Nous venons de vous transférer le véhicule : " .. plaque,
		})
		TriggerEvent('discord:venteConcess',"TRANSFERT DE VEHICULE :red_car: : **" .. concessionnaire.prenom .. " " .. concessionnaire.nom .. "** (ID : " .. concessionnaire.source ..") vient de transférer le véhicule " .. plaque .. " à **" .. player.prenom .. " ".. player.nom .. "** (ID : " .. player.source ..")") -- msg Discord

	else

		TriggerClientEvent("ft_libs:AdvancedNotification", source, {
			icon = "CHAR_SIMEON",
			title = "Loca'Luxe",
			text = "~o~ Ce véhicule n'existe pas !",
		})


	end
end)

RegisterServerEvent('concessionnaire:LouerVeh')
AddEventHandler('concessionnaire:LouerVeh',function(idcible, vehicle,plate)

	TriggerClientEvent("ft_libs:AdvancedNotification", source, {
		icon = "CHAR_SIMEON",
		title = "Loca'Luxe",
		text = "Vous avez loué une : ~g~"..vehicle,
	})

local player = tonumber(idcible)
	TriggerEvent("es:getPlayerFromId", player, function(target)
		local cible = target.identifier
		local name = vehicle
		local price = "0"
		local vehicle = vehicle
		local state = "Sorti"
		MySQL.Async.execute('INSERT INTO user_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_price`, `vehicle_plate`,`vehicle_state`,`veh_type`,`veh_location`) VALUES (@username, @name, @vehicle, @price, @plate, @state, @type,1)',
		{['@username'] = cible, ['@name'] = name, ['@vehicle'] = vehicle, ['@price'] = price, ['@plate'] = plate,['@state'] = state, ['@type'] = 1})
		--MySQL.Async.execute('UPDATE entreprises_coffres SET solde = solde - @prixadd WHERE job_id = @jobid',{['@prixadd'] = retraitcoffre,['@jobid'] = 25 })

		TriggerClientEvent("ft_libs:AdvancedNotification", target.source, {
			icon = "CHAR_SIMEON",
			title = "Loca'Luxe",
			text = "~o~Votre véhicule de Location est là ! ~g~Loca'Luxe ~w~ vous remercie !",
		})

	end)
end)


