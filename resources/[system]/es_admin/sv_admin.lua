local permission = {
	kick = 1,
	ban = 4
}

TriggerEvent("es:addGroup", "owner", "superadmin", function(group) end)
TriggerEvent("es:addGroup", "mod", "user", function(group) end)

TriggerEvent('es:addCommand', 'admin', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Niveau de permission: ^2" .. user['permission_level'])
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Groupe: ^2" .. user.group.group)
end)


-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "admin", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			print("oui")

			-- -- User permission check
			-- local target = exports["essentialmode"]:getPlayerFromId()
			-- local admin = exports["essentialmode"]:getPlayerFromId()
			-- if(tonumber(target.permission_level) > tonumber(user.permission_level))then
			-- 	TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "vous ne pouvez pas cibler cette personne")
			-- 	return
			-- end
			--
			-- local reason = args
			-- table.remove(reason, 1)
			-- table.remove(reason, 1)
			-- if(#reason == 0)then
			-- 	reason = "Kicker: Vous avez été kicker du serveur"
			-- else
			-- 	reason = "Kicked: " .. table.concat(reason, " ")
			-- end
			-- TriggerEvent('discord:kickban', "INFORMATION ** :love_letter: : **" .. admin.nom .. " ".. admin.prenom ..  "** a kick **" .. target.prenom .. " " .. target.nom.."** pour "..reason)
			-- print("INFORMATION ** :love_letter: : **" .. admin.nom .. " ".. admin.prenom ..  "** a kick **" .. target.prenom .. " " .. target.nom.."** pour "..reason)
			--
			--
			-- TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, "Le joueur ^2" .. GetPlayerName(player) .. "^0 a été kicker(^2" .. reason .. "^0)")
			-- DropPlayer(player, reason)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "ID du joueur incorrecte !")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Vous n'avez pas la permission !")
end)


TriggerEvent('es:addGroupCommand', 'kick', "mod", function(source, args, user)

	if(GetPlayerName(tonumber(args[2])))then
		local playerID = tonumber(args[2])
		local admin = exports["essentialmode"]:getPlayerFromId(source)
		local player = exports["essentialmode"]:getPlayerFromId(playerID)
		if(tonumber(admin.permission_level) > tonumber(admin.permission_level))then
			TriggerClientEvent("chatMessage", source, "ERREUR", {255, 0, 0}, "Permissions insuffisante pour kicker ce joueur")
			return
		end
		local reason = args
		table.remove(reason, 1)
		table.remove(reason, 1)
		if(#reason == 0)then
			reason = "Kick: Tu as été kick, merci d'aller en attente de staff pour connaitre la raison"
		else
			reason = "Kicked: " .. table.concat(reason, " ")
		end
		TriggerEvent('discord:kickban', "**INFORMATION** :love_letter: : **" .. admin.nom .. " ".. admin.prenom ..  "** a kick **" .. player.prenom .. " " .. player.nom .."** pour " .. reason)
		TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, "Le joueur ^2" .. player.prenom .. " " .. player.nom .. "^0 a été kicker pour (^2" .. reason .. "^0)")
		DropPlayer(playerID, reason)
	else
		TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "ID incorrecte")
	end

end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante!")
end)

TriggerEvent('es:addGroupCommand', 'viewname', "admin", function(source, args, user)
    TriggerClientEvent("overhead:viewname", source)
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante")
end)

TriggerEvent('es:addCommand', 'name', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "NOM", {50, 200, 230}, GetPlayerName(source))
end)

TriggerEvent('es:addCommand', 'id', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ID", {50, 200, 230}, ""..source.."")
end)

TriggerEvent('es:addCommand', 'dice?', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SERVEUR", {255, 0, 0}, "Tapez ^3/dice^0 puis l'^3ID^0 de votre partenaire pour qu'il puisse recevoir le résultat des 2 dés sur sa console")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Pour connaitre sa propre ^5ID^0, tapez ^3/id^0")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Exemple: '^3/dice 87^0'")
end)

TriggerEvent('es:addCommand', 'bug?', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SERVEUR", {255, 0, 0}, "Tapez ^3/bug^0 puis la ^3raison^0 (8 mots minimum) de votre bug avec un maximum de détails. (n'indiquez pas votre nom ni votre serveur).")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Exemple: '^3/bug j'ai crash et perdu mon run poisson valeur 2000$'")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Utilisez cette commande pour report n'importe quel bug ou anomalie lié au jeu ou pour un remboursement suite à un crash")
end)

TriggerEvent('es:addCommand', 'report?', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SERVEUR", {255, 0, 0}, "Tapez ^3/report^0 puis la ^3raison^0 (5 mots minimum) de votre report avec un maximum de détails. (n'indiquez pas votre nom ni votre serveur).")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Exemple: '^3/report carkill devant le commisariat, homme t-shirt blanc dans voiture rouge^0'")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^1Ne pas utiliser le report pour une question !^0")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Allez directement en ^6Attente de staff^0 sur discord pour ça ou allez MP un ^2modérateur^0")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "N'utilisez que le report que pour les raisons suivante: ^1bug^0, ^1usebug^0, ^1cheateur^0, ^1moddeur^0, ^1insultes^0, ^1HRP^0, ^1freekill^0 et ^1carkill^0")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Pour un besoin de ^3modération dans votre scène RP^0, tapez /modo")
end)

TriggerEvent('es:addCommand', 'modo?', function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ADMIN", {255, 0, 0}, "Tapez ^3/modo^0 puis la ^3raison^0 de votre demande de modération. (n'indiquez pas votre nom ni votre serveur)")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Exemple: '^3/report conflit sur un braquage^0'")
	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Exemple: '^3/report le joueur michel n'a pas respecter les règles du RP^0'")
end)

TriggerEvent('es:addCommand', 'dice', function(source, args, user)
	table.remove(args, 1)
	if args[1] == nil then
		TriggerClientEvent('chatMessage', source, "SERVEUR", {255, 0, 0}, "^1Merci de rentrer l'ID de votre partenaire^0")
		TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Pour plus d'info, tapez ^3/dice?^0")
	else
		TriggerClientEvent('chatMessage', source, "DICE", {255, 128, 0}, "Les dés sont jetés par le joueur "..GetPlayerName(source).."")
		TriggerClientEvent('chatMessage', source, "RESULTAT", {255, 128, 0}, math.random(0,6).." et "..math.random(0,6))
	end
end)

TriggerEvent('es:addCommand', 'bug', function(source, args, user)
	table.remove(args, 1)
	if args[8] == nil then
		TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "^1Merci de préciser la raison de votre bug en 8 mots minimum^0")
		TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Pour plus d'info, tapez ^3/bug?^0")
	else
		TriggerClientEvent('chatMessage', source, "BUG", {255, 0, 0}, " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))
		TriggerEvent("discord:report", "@everyone BUG : (" .. GetPlayerName(source) .." | "..source..") "..  table.concat(args, " "))
		exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
			for k,v in pairs(users_connected) do
				if(v.permission_level > 0)then
					TriggerClientEvent('chatMessage', v.source, "BUG", {255, 0, 0}, " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))
				end
			end
		end)
		--TriggerClientEvent('chatMessage', k, "REPORT", {255, 0, 0}, " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))
	end
end)

TriggerEvent('es:addCommand', 'report', function(source, args, user)
	table.remove(args, 1)
	if args[5] == nil then
		TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "^1Merci de préciser la raison de votre report en 5 mots minimum^0")
		TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Pour plus d'info, tapez ^3/report?^0")
	else
	    --TriggerEvent("es:getPlayerFromId", source, function(user)
	    	local user = exports["essentialmode"]:getPlayerFromId(source)
		    local nom = user.nom
		    local prenom = user.prenom
        	TriggerClientEvent('chatMessage', source, "REPORT", {255, 0, 0}, " (^2"..prenom.." "..nom.."^0) "..table.concat(args, " "))
	    	TriggerEvent("discord:report", "@everyone REPORT : ("..source.." | "..prenom.." "..nom.." | "..GetPlayerName(source)..") "..table.concat(args, " "))
		    exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
				for k,v in pairs(users_connected) do
					if(v.permission_level > 0)then
						TriggerClientEvent('chatMessage', v.source, "REPORT", {255, 0, 0}, " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))
					end
				end
			end)
		--end)
	end
end)

TriggerEvent('es:addCommand', 'modo', function(source, args, user)
	table.remove(args, 1)
	if args[5] == nil then
		TriggerClientEvent('chatMessage', source, "ERREUR", {0, 205, 35}, "^1Merci de préciser la raison de votre demande de modération^0")
		TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "Pour plus d'info, tapez ^3/modo?^0")
	else
		TriggerClientEvent('chatMessage', source, "MODO", {0, 205, 35}, " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))
		TriggerEvent("discord:report", "@everyone MODERATION : (" .. GetPlayerName(source) .." | "..source..") "..  table.concat(args, " "))
		exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
			for k,v in pairs(users_connected) do
				if(v.permission_level > 0)then
					TriggerClientEvent('chatMessage', v.source, "REPORT", {255, 0, 0}, " (^2" .. GetPlayerName(source) .." | "..source.."^0) " .. table.concat(args, " "))
				end
			end
		end)
	end
end)

function appendNewPos(msg)
	local file = io.open('resources/[essential]/es_admin/positions.txt', "a")
	newFile = msg
	file:write(newFile)
	file:flush()
	file:close()
end

RegisterServerEvent('es_admin:givePos')
AddEventHandler('es_admin:givePos', function(str)
	appendNewPos(str)
end)

TriggerEvent('es:addGroupCommand', 'ghost', "admin", function(source, args, user)
	TriggerClientEvent("es_admin:noclip", source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante")
end)

TriggerEvent('es:addGroupCommand', 'ban', "mod", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])) ~= nil)then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
					if(tonumber(target.permission_level) > tonumber(user.permission_level))then
						TriggerClientEvent("chatMessage", source, "ERREUR", {255, 0, 0}, "Permissions insuffisante pour ban ce joueur")
						return
					end
				local time = args[3]
				local message = ""
				local bantime
				if string.find(time, "m") then
					time = string.gsub(time, "m", "")
					bantime = (tonumber(time) * 60)
					message = time .. " minute(s)"
				elseif string.find(time, "h") then
					time = string.gsub(time, "h", "")
					message = time .. " hour(s)"
					bantime = (tonumber(time) * 60 * 60)
				elseif string.find(time, "d") then
					time = string.gsub(time, "d", "")
					message = time .. " day(s)"
					bantime = (tonumber(time) * 60 * 60 * 24)
				else
					bantime = 60 * 60 * 24 *365 * 10
					message = '10 years'
				end
				local reason = args
				table.remove(reason, 1)
				table.remove(reason, 1)
				table.remove(reason, 1)
				reason = "Banned: " .. table.concat(reason, " ")
				if(reason == "Banned: ")then
					reason = reason .. "You have been banned for: ^1" .. message .. "^r^0."
					DropPlayer(player, "Tu as été banni pour: " .. message)
				else
					DropPlayer(player, "Banni: " .. reason)
				end
				TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, "Le joueur ^2" .. GetPlayerName(player) .. "^0 a été ban pour (^2" .. reason .. "^0)")
				print("Mickou: current time = " .. tonumber(os.time()))
				print("Mickou: expire time = " .. tonumber(os.time() + bantime))
				local tstamp = os.time() + bantime
				local tstamp2 = os.time()
				MySQL.Async.execute("INSERT INTO bans (`banned`, `reason`, `expires`, `banner`, `timestamp`) VALUES (@username, @reason, @expires, @banner, @now)",
				{['@username'] = target.identifier, ['@reason'] = reason, ['@expires'] = tstamp, ['@banner'] = user.identifier, ['@now'] = tstamp2})
			end)
		else
			TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "ID incorrectee")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante")
end)

function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end
  return t
end

TriggerEvent('es:addGroupCommand', 'say', "mod", function(source, args, user)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "ANNONCE", {255, 0, 0}, "" .. table.concat(args, " "))
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante")
end)

local frozen = {}
TriggerEvent('es:addGroupCommand', 'freeze', "mod", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(tonumber(target.permission_level) > tonumber(user.permission_level))then
					TriggerClientEvent("chatMessage", source, "ERREUR", {255, 0, 0}, "Permissions insuffisante pour freezer cette personne")
					return
				end
				if(frozen[player])then
					frozen[player] = false
				else
					frozen[player] = true
				end
				TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])
				local state = "défreezé"
				if(frozen[player])then
					state = "freezé"
				end
				TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "Tu as été " .. state .. " par ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Le joueur ^2" .. GetPlayerName(player) .. "^0 a été " .. state)
			end)
		else
			TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "ID incorrecte")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante")
end)

local frozen = {}
TriggerEvent('es:addGroupCommand', 'bring', "mod", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(tonumber(target.permission_level) > tonumber(user.permission_level))then
					TriggerClientEvent("chatMessage", source, "ERREUR", {255, 0, 0}, "Permissions insuffisante pour bring ce joueur")
					return
				end
				TriggerClientEvent('es_admin:teleportUser', player, source)
				TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "Tu as été téléporter par ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Le joueur ^2" .. GetPlayerName(player) .. "^0 a été amené")
			end)
		else
			TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "ID incorrectee")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante")
end)

local frozen = {}
TriggerEvent('es:addGroupCommand', 'slap', "admin", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(tonumber(target.permission_level) > tonumber(user.permission_level))then
					TriggerClientEvent("chatMessage", source, "ERREUR", {255, 0, 0}, "Permissions insuffisante pour slaper ce joueur")
					return
				end
				TriggerClientEvent('es_admin:slap', player)
				TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "Tu a été bifflé par ^2" .. GetPlayerName(source))
				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Je joueur ^2" .. GetPlayerName(player) .. "^0 a été bifflé dans les airs!")
			end)
		else
			TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "ID incorrecte")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante")
end)

local frozen = {}
TriggerEvent('es:addGroupCommand', 'goto', "mod", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(target)then
					if(tonumber(target.permission_level) > tonumber(user.permission_level))then
						TriggerClientEvent("chatMessage", source, "ERREUR", {255, 0, 0}, "Permissions insuffisante pour se TP vers ce joueur")
						return
					end
					TriggerClientEvent('es_admin:teleportUser', source, player)
					TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "Le joueur ^2"..GetPlayerName(source).." s'est téléporté sur toi")
					TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Téléportation vers le joueur ^2"..GetPlayerName(player).."")
				end
			end)
		else
			TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "ID incorrecte")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante")
end)

TriggerEvent('es:addCommand', 'suscide', function(source, args, user)
	TriggerClientEvent('es_admin:kill', source)
	TriggerClientEvent('chatMessage', source, "", {0,0,0}, "^1Tu t'es suscidé ! RIP")
end)

TriggerEvent('es:addCommand', 'drunk', function(source, args, user)
	TriggerClientEvent('es_admin:drunk', source)
end)

TriggerEvent('es:addCommand', 'rmcar', function(source, args, user)
	TriggerClientEvent('es_admin:rmcar', source)
end)

TriggerEvent('es:addGroupCommand', 'revive', "mod", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(tonumber(target.permission_level) > tonumber(user.permission_level))then
					TriggerClientEvent("chatMessage", source, "ERREUR", {255, 0, 0}, "Permissions insuffisante pour réanimé ce joueur")
					return
				end
				TriggerClientEvent('es_admin:revive', player)
				TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "^1Tu a été réanimé par "..GetPlayerName(source).."")
				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Le joueur ^2" .. GetPlayerName(player) .. "^0 a bien été réanimé")
				end)
		else
			TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "ID incorrecte")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "ERREUR", {255, 0, 0}, "Permissions insuffisante")
end)

TriggerEvent('es:addGroupCommand', 'kill', "mod", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(tonumber(target.permission_level) > tonumber(user.permission_level))then
					TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Permissions insuffisante pour tuer ce joueur")
					return
				end
				TriggerClientEvent('es_admin:kill', player)
				TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "Tu as été tué par ^2"..GetPlayerName(source)..". Ceci est un avertissement")
				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Le joueur ^2" .. GetPlayerName(player) .. "^0 a bien été tué")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "ID incorrectee")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Permissions insuffisante")
end)

--[[TriggerEvent('es:addGroupCommand', 'crash', "superadmin", function(source, args, user)
		if(GetPlayerName(tonumber(args[2])))then
			local player = tonumber(args[2])

			-- User permission check
			TriggerEvent("es:getPlayerFromId", player, function(target)
				if(tonumber(target.permission_level) > tonumber(user.permission_level))then
					TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You're not allowed to target this person!")
					return
				end

				TriggerClientEvent('es_admin:crash', player)

				TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been crashed.")
			end)
		else
			TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
		end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end)

-- Position
TriggerEvent('es:addGroupCommand', 'pos', "owner", function(source, args, user)
	TriggerClientEvent('es_admin:givePosition', source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Permissions insuffisante")
end)]]--

AddEventHandler('rconCommand', function(commandName, args)
	if commandName == 'crash' then
		local player = tonumber(args[1])

					RconPrint("crashed")
					TriggerClientEvent('es_admin:crash', player)
					CancelEvent()
	elseif commandName == 'setadmin' then
		if #args ~= 2 then
				RconPrint("Usage: setadmin [user-id] [permission-level]\n")
				CancelEvent()
				return
		end
		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Le joueur n'est pas ingame\n")
			CancelEvent()
			return
		end
		TriggerEvent("es:setPlayerData", tonumber(args[1]), "permission_level", tonumber(args[2]), function(response, success)
			RconPrint(response)

			if(success)then
				print(args[1] .. " " .. args[2])
				TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'rank', tonumber(args[2]), true)
				TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Niveau de permission de ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 a été révisé à ^2" .. args[2])
			end
		end)
		CancelEvent()
	elseif commandName == 'setgroup' then
		if #args ~= 2 then
				RconPrint("Usage: setgroup [user-id] [group]\n")
				CancelEvent()
				return
		end
		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Le joueur n'est pas ingame\n")
			CancelEvent()
			return
		end
		TriggerEvent("es:getAllGroups", function(groups)

			if(groups[args[2]])then
				TriggerEvent("es:setPlayerData", tonumber(args[1]), "group", args[2], function(response, success)
					RconPrint(response)

					if(success)then
						print(args[1] .. " " .. args[2])
						TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'group', tonumber(args[2]), true)
						TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Groupe de ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 a été révisé à ^2" .. args[2])
					end
				end)
			else
				RconPrint("Ce groupe n'existe pas.\n")
			end
		end)

		CancelEvent()
	elseif commandName == 'setmoney' then
			if #args ~= 2 then
					RconPrint("Usage: setmoney [user-id] [money]\n")
					CancelEvent()
					return
			end
			if(GetPlayerName(tonumber(args[1])) == nil)then
				RconPrint("Le joueur n'est pas ingame\n")
				CancelEvent()
				return
			end
			TriggerEvent("es:getPlayerFromId", tonumber(args[1]), function(user)
				if(user)then
					user.func.setMoney((args[2] + 0.0))

					RconPrint("Money set")
					TriggerClientEvent('chatMessage', tonumber(args[1]), "CONSOLE", {0, 0, 0}, "Votre argent est a: €" .. tonumber(args[2]))
				end
			end)
			CancelEvent()
		elseif commandName == 'unban' then
			if #args ~= 1 then
					RconPrint("Usage: unban [ID]\n")
					CancelEvent()
					return
			end
			CancelEvent()
		elseif commandName == 'ban' then
			if #args ~= 1 then
					RconPrint("Usage: ban [ID]\n")
					CancelEvent()
					return
			end
			if(GetPlayerName(tonumber(args[1])) == nil)then
				RconPrint("Le joueur n'est pas ingame\n")
				CancelEvent()
				return
			end
			TriggerEvent("es:setPlayerData", tonumber(args[1]), "banni", 1, function(response, success)
				TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, "Le joueur ^2" .. GetPlayerName(player) .. "^0 a été ban par RCON")
			end)
			CancelEvent()
		end
end)

-- Logging
AddEventHandler("es:adminCommandRan", function(source, command)
end)

function ShowInfo(text, state)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, state, 0, -1)
end
