-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.


--    _______ _                    ____        _   _
--   |__   __(_)                  / __ \      | | (_)
--      | |   _ _ __ ___   ___   | |  | |_ __ | |_ _  ___  _ __  ___
--      | |  | | '_ ` _ \ / _ \  | |  | | '_ \| __| |/ _ \| '_ \/ __|
--      | |  | | | | | | |  __/  | |__| | |_) | |_| | (_) | | | \__ \
--      |_|  |_|_| |_| |_|\___|   \____/| .__/ \__|_|\___/|_| |_|___/
--                                      | |
--                                      |_|

--####################################################
--############# SURVEILLANCE MODO ####################
--####################################################
RegisterServerEvent('mellotrainer:FouilleMsg')
RegisterServerEvent('mellotrainer:SpectateMsg')
RegisterServerEvent('mellotrainer:HealMsg')
RegisterServerEvent('mellotrainer:ArmorMsg')
RegisterServerEvent('mellotrainer:GodMsg')
RegisterServerEvent('mellotrainer:InvisibilityMsg')
RegisterServerEvent('mellotrainer:TpMsg')
RegisterServerEvent('mellotrainer:LocateMsg')
RegisterServerEvent('mellotrainer:VehiMsg')

AddEventHandler('mellotrainer:FouilleMsg', function(target)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local Victime = exports["essentialmode"]:getPlayerFromId(target)

		TriggerEvent('discord:mello', "INFORMATION :beginner: : **" .. user.nom .. " ".. user.prenom ..  "** a fouillé **" .. Victime.prenom .. " " .. Victime.nom.."**")
end)
AddEventHandler('mellotrainer:VehiMsg', function(model)
	local user = exports["essentialmode"]:getPlayerFromId(source)
		TriggerEvent('discord:mello', "INFORMATION @everyone :oncoming_automobile: : **" ..user.nom.. " ".. user.prenom ..  "** ID:("..user.id..") a spawn un véhicule ")
end)

AddEventHandler('mellotrainer:SpectateMsg', function(target, state)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local Victime = exports["essentialmode"]:getPlayerFromId(target)
	if state == true then
		TriggerEvent('discord:mello', "INFORMATION :eye: : **" .. user.nom .. " ".. user.prenom ..  "** commence à surveiller **" .. Victime.prenom .. " " .. Victime.nom.."**")
	else
		TriggerEvent('discord:mello', "INFORMATION :eye: : **" .. user.nom .. " ".. user.prenom ..  "** arrete de surveiller **" .. Victime.prenom .. " " .. Victime.nom.."**")
	end
end)

AddEventHandler('mellotrainer:HealMsg', function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	TriggerEvent('discord:mello', "INFORMATION :syringe: : **" .. user.nom .. " ".. user.prenom ..  "** s'est soigné")
end)

AddEventHandler('mellotrainer:ArmorMsg', function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	TriggerEvent('discord:mello', "INFORMATION :cop: : **" .. user.nom .. " ".. user.prenom ..  "** a augmenté son armure")
end)

AddEventHandler('mellotrainer:GodMsg', function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	TriggerEvent('discord:mello', "INFORMATION :trident: : **" .. user.nom .. " ".. user.prenom ..  "** est passé en GodMOD")
end)

AddEventHandler('mellotrainer:InvisibilityMsg', function(state)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if state == true then
		TriggerEvent('discord:mello', "INFORMATION :bust_in_silhouette: : **" .. user.nom .. " ".. user.prenom ..  "** est passé invisible")
	else
		TriggerEvent('discord:mello', "INFORMATION :bust_in_silhouette: : **" .. user.nom .. " ".. user.prenom ..  "** est redevenu visible")
	end
end)
AddEventHandler('mellotrainer:TpMsg', function(target)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local Victime = exports["essentialmode"]:getPlayerFromId(target)

		TriggerEvent('discord:mello', "INFORMATION :cyclone: : **" .. user.nom .. " ".. user.prenom ..  "** s'est téléporté à **" .. Victime.prenom .. " " .. Victime.nom.."**")
end)
AddEventHandler('mellotrainer:LocateMsg', function(target)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local Victime = exports["essentialmode"]:getPlayerFromId(target)

		TriggerEvent('discord:mello', "INFORMATION :round_pushpin: : **" .. user.nom .. " ".. user.prenom ..  "** a localisé **" .. Victime.prenom .. " " .. Victime.nom.."**")
end)

--####################################################
--####################################################
--####################################################


	RegisterServerEvent('mellotrainer:adminTime')
AddEventHandler('mellotrainer:adminTime', function(from, hour, minutes, seconds)
	TriggerClientEvent('mellotrainer:updateTime', -1, hour, minutes, seconds)
end)

RegisterServerEvent('mellotrainer:targetCheckInventoryAdmin')
AddEventHandler('mellotrainer:targetCheckInventoryAdmin', function(t)
	TriggerClientEvent('chatMessage', source, 'STAFF', {255, 0, 0}, checkInventoryAdmin(t))
end)


function checkInventoryAdmin(target)
	local PlayerTarget = GetPlayerName(target).." possede : "
	local identifier = ""
    TriggerEvent("es:getPlayerFromId", target, function(player)
		local money = player.dirty_money
		PlayerTarget = PlayerTarget .. money .. " d'argent sale , "
		identifier = player.identifier
		local result = MySQL.Sync.fetchAll('SELECT stockage.quantity, stockage.item_id, items.libelle FROM stockage JOIN items ON stockage.item_id = items.id WHERE stockage.type = "player_pocket" AND stockage.identifier = @identifier', { ['@identifier'] = identifier })
		print(json.encode(result))
		if (result) then
			for _, v in ipairs(result) do
				if(v.quantity ~= 0) then
					PlayerTarget = PlayerTarget .. v.quantity .. " de " .. v.libelle .. ", "
				end
			end
		end

		PlayerTarget = PlayerTarget .. " / "

		local result = MySQL.Sync.fetchAll('SELECT weapon_model FROM user_weapons WHERE identifier = @username', { ['@username'] = identifier })
		if (result) then
			for _, v in ipairs(result) do
					PlayerTarget = PlayerTarget .. "possession de " .. v.weapon_model .. ", "
			end
		end
	end)

    return PlayerTarget
end
-- __          __        _   _                  ____        _   _
-- \ \        / /       | | | |                / __ \      | | (_)
--  \ \  /\  / /__  __ _| |_| |__   ___ _ __  | |  | |_ __ | |_ _  ___  _ __  ___
--   \ \/  \/ / _ \/ _` | __| '_ \ / _ \ '__| | |  | | '_ \| __| |/ _ \| '_ \/ __|
--    \  /\  /  __/ (_| | |_| | | |  __/ |    | |__| | |_) | |_| | (_) | | | \__ \
--     \/  \/ \___|\__,_|\__|_| |_|\___|_|     \____/| .__/ \__|_|\___/|_| |_|___/
--                                                   | |
--                                                   |_|

RegisterServerEvent('mellotrainer:adminWeather')
AddEventHandler('mellotrainer:adminWeather', function(from, weatherState, persistToggle)
	TriggerClientEvent('mellotrainer:updateWeather', -1, weatherState, persistToggle)
end)


RegisterServerEvent('mellotrainer:adminBlackout')
AddEventHandler('mellotrainer:adminBlackout', function(from, toggle)
	TriggerClientEvent('mellotrainer:updateBlackout', -1, toggle)
end)




RegisterServerEvent('mellotrainer:adminWind')
AddEventHandler('mellotrainer:adminWind', function(from, state, heading)
	TriggerClientEvent('mellotrainer:updateWind', -1, state, heading)
end)

