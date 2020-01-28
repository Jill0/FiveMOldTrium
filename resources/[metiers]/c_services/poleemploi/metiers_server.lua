function MineGetPlayerJobID(playerId,source)
	--local resultPlayerJobID = MySQL.Sync.fetchAll('SELECT job FROM users WHERE identifier = @name', {['@name'] = playerId})
	--return resultPlayerJobID[1].job
	local player_job = 1
	TriggerEvent("es:getPlayerFromId", source, function(user)
        player_job = user.jobId
    end)
    return player_job
end

function MineGetPlayerJobName(JobId)
	local resultPlayerJobName = MySQL.Sync.fetchAll('SELECT job_name FROM `jobs` WHERE `job_id` = @namejob', {['@namejob'] = JobId})
	return resultPlayerJobName[1].job_name
end

RegisterServerEvent('metiers:isChomeur')
AddEventHandler('metiers:isChomeur', function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		--local playerJobID = MineGetPlayerJobID(user.identifier,source)
		local playerJobID = user.jobId
		TriggerClientEvent('metiers:defineJobMenu', user.source, playerJobID)
	end)
end)

RegisterServerEvent('metiers:jobs')
AddEventHandler('metiers:jobs', function(id)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		--local playerJobID = MineGetPlayerJobID(user.identifier,source)
		local playerJobID = user.jobId
		local playerJobName = MineGetPlayerJobName(playerJobID)
		local NewJobName = MineGetPlayerJobName(id)
		local update = false

		for _, item in pairs(metiersList) do
			if item.Aff==1 and item.WL==1 and item.id == id then
				TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
					icon = item.CHAR,
					title = item.Boss,
					text = "Pour devenir ~o~" .. item.vnom .. "~w~, vous devez me contacter au ~g~ " .. item.Num .. " ~w~pour postuler !",
				})
				update = false
			elseif playerJobID == item.id then
				TriggerClientEvent(item.name..":deleteBlips", user.source)
				update = true
			end
		end
		if update then
			MySQL.Async.execute('UPDATE users SET `job`=@value,`leader`=0 WHERE identifier = @identifier', {['@value'] = id, ['@identifier'] = user.identifier})
				TriggerClientEvent("metiers:updateJob", user.source, NewJobName)
				user.func.setJobId(id)
			for _, item in pairs(metiersList) do
				if id == item.id then
					TriggerClientEvent(item.name..":drawBlips", user.source)
					TriggerClientEvent(item.name..":drawMarker", user.source, true)
					TriggerClientEvent(item.name..":marker", user.source)
				end
			end

			TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
				icon = "CHAR_MP_STRIPCLUB_PR",
				title = "Entreprise",
				text = "Votre métier est désormais : ".. NewJobName..". Récupérez votre vehicule spécial à l'entreprise",
			})

			update = false
		end
	end)
end)

RegisterServerEvent('metiers:jobsadminadmin')
AddEventHandler('metiers:jobsadminadmin', function(id)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local playerJobID = user.jobId
		local playerJobName = MineGetPlayerJobName(playerJobID)
			local NewJobName = MineGetPlayerJobName(id)
	for _, item in pairs(metiersList) do
			if playerJobID == item.id then
				TriggerClientEvent(item.name..":deleteBlips", user.source)
			end
		end

		MySQL.Async.execute('UPDATE users SET `job`=@value,`leader`=0 WHERE identifier = @identifier', {['@value'] = id, ['@identifier'] = user.identifier})
			TriggerClientEvent("metiers:updateJob", user.source, NewJobName)
			TriggerClientEvent('metiers:init',user.source)
			user.func.setJobId(id)
			for _, item in pairs(metiersList) do
			if id == item.id then
				TriggerClientEvent(item.name..":drawBlips", user.source)
				TriggerClientEvent(item.name..":drawMarker", user.source, true)
				TriggerClientEvent(item.name..":marker", user.source)
			end
		end

		TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
			icon = "CHAR_MP_STRIPCLUB_PR",
			title = "Entreprise",
			text = "Votre métier est désormais : ".. NewJobName,
		})
	end)
end)

AddEventHandler('es:playerLoaded', function(source)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		--local playerJobID = MineGetPlayerJobID(user.identifier,source)
		local playerJobID = user.jobId
		local playerJobName = MineGetPlayerJobName(playerJobID)

		for _, item in pairs(metiersList) do
			if playerJobID == item.id then
				TriggerClientEvent(item.name..":drawBlips", user.source)
				TriggerClientEvent(item.name..":drawMarker", user.source, true)
				TriggerClientEvent(item.name..":marker", user.source)
			end
		end
		TriggerClientEvent("metiers:updateJob", user.source, playerJobName)
	end)
end)

----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP /LIVREUR-------------------
----------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'livradd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /livradd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")

				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais livreur !",
				})

				TriggerClientEvent('metiers:jobadmintriumnontuv',player,14)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'livrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /livrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)

				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus livreur !",
				})

				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

--------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP MECANO-------------------
--------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'mecadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /mecadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais mécano !",
				})

				TriggerClientEvent('metiers:jobadmintriumnontuv',player,16)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'mecrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /mecrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus mécano !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun jour avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

-------------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP AMBULANCIER-------------------
-------------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'ambadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /ambadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais ambulancier !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,15)
				TriggerClientEvent('ambulancier:receiveIsAmbulancier', source, '1')
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'ambrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /ambrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "vous n'êtes plus ambulancier !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
				TriggerClientEvent('ambulancier:receiveIsAmbulancier', source, '0')
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP TAXI-------------------
------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'taxadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /taxadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais Taxi !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,17)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'taxrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /taxrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus Taxi !",
				})

				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

-----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP Raffineur-------------------
-----------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'raffadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /raffadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais Raffineur !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,20)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'raffrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /raffrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus Raffineur !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

------------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP Arboriculteur-------------------
------------------------------------------------------------------------------

TriggerEvent('es:addGroupCommand', 'arbadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /arbadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais Arboriculteur !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,21)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'arbrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /arbrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus Arboriculteur !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)
------------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP Glacier-------------------
------------------------------------------------------------------------------

TriggerEvent('es:addGroupCommand', 'glaadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, "Good'Lickin", {255, 0, 0}, "Utilisation : /glaadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, "Good'Lickin", {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Good'Lickin",
					text = "Vous êtes désormais Glacier !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,27)
			end)
		else
			TriggerClientEvent('chatMessage', source, "Good'Lickin", {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'glarem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, "Good'Lickin", {255, 0, 0}, "Utilisation : /glarem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Good'Lickin",
					text = "Vous n'êtes plus Glacier !",
				})
				TriggerClientEvent('chatMessage', user.source, "Good'Lickin", {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

-----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP vigneron--------------------
-----------------------------------------------------------------------------

TriggerEvent('es:addGroupCommand', 'vignadd', "admin", function(source, args, user)
    if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /vignadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais vigneron !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,13)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'vignrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /vignrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus vigneron !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

-----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP pecheur---------------------
-----------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'pechadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /pechadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais pécheur !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,10)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'pechrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /pechrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus pécheur !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

-----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP water--------------------
-----------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'watadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /watadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais traiteur d'eau !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,7)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'watrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /watrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus traiteur d'eau !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

-----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP mineur----------------------
-----------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'minadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /minadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais mineur !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,9)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'minrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /minrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus mineur !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

-----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP fermier---------------------
-----------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'fermadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /fermadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais fermier !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,6)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'fermrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /fermrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus fermier !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

-----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP brasseur--------------------
-----------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'brasadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /brasadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais brasseur !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,12)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'brasrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /brasrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus brasseur !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP LOCALUXE-------------------
----------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'locadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /locadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "C'est bon !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous travaillez désormais chez LocaLuxe !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,25)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'locrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /locrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous ne travaillez plus chez LocaLuxe !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

--------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP Avocat-------------------
--------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'avocadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /avocadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais avocat !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,22)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'avocrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /avocrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus avocat !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

-------------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP Journaliste-------------------
-------------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'jouradd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /jouradd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais journaliste !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,19)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'jourrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /jourrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous n'êtes plus journaliste !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)


--------------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP Gouvernement-------------------
--------------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'gouvadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /gouvadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous travaillez désormais au Gouvernement !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,23)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'gouvrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /gouvrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Nous ne travaillez plus au Gouvernement !",
				})
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)


-----------------------------------------------------------------------------
---------------------COMMANDE ADMIN AJOUT / SUPP Procureur-------------------
-----------------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'procadd', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /procadd [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Vous êtes désormais Procureur !",
				})
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,24)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'procrem', "admin", function(source, args, user)
     if(not args[2]) then
		TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Utilisation : /procrem [ID]")
	else
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				TriggerClientEvent("ft_libs:AdvancedNotification", player, {
					icon = "CHAR_ANDREAS",
					title = "Gouvernement",
					text = "Nous n'êtes plus Procureur !",
				})

				TriggerClientEvent('chatMessage', user.source, 'GOUVERNEMENT', {255, 0, 0}, "Bien reçu !")
				TriggerClientEvent('metiers:jobadmintriumnontuv',player,1)
			end)
		else
			TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Aucun joueur avec cet ID !")
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)
