RegisterServerEvent("antitroll:checkNewbie")
RegisterServerEvent("antitroll:ExplosiveDetected")
RegisterServerEvent("antitroll:ArmorDetected")
RegisterServerEvent("antitroll:LifeDetected")
RegisterServerEvent("antitroll:InvisibleDetected")
RegisterServerEvent("antitroll:InvincibleDetected")
RegisterServerEvent("antitroll:SpectatorDetected")
RegisterServerEvent("antitroll:CauseOfDeath")
RegisterServerEvent("antitroll:Seethrough")
RegisterServerEvent("antitroll:RetourHopitalDetected")
RegisterServerEvent("antitroll:SpawnVehDetected")
RegisterServerEvent("antitroll:VehForbidenDetected")
RegisterServerEvent("antitroll:TeleportCheatDetected")

local PlayerSourceForBan = {}

AddEventHandler("antitroll:checkNewbie", function()
    local player = exports["essentialmode"]:getPlayerFromId(source)
    local Montant_Banque = player.func.getBank()
    local Time_Played = player.func.getTimePlayed()
    TriggerClientEvent('antitroll:isNewbieValid', player.source, Montant_Banque, Time_Played)
end)

AddEventHandler("antitroll:TeleportCheatDetected", function(distance)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(user)
    if(user.permission_level == 0) then
        --CheckForBan(user, "Spectate")
        TriggerEvent('discord:antiCheat', "REPORT :airplane: : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") vient de se téléporter (**"..distance.."m**) ! " .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
        -- Vérification de tous les joueurs connectés
        exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
            for k, v in pairs(users_connected) do
                if(v.permission_level > 0) then
                    TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") vient de se téléporter " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
                end
            end
        end)
    end
    --end)
end)

AddEventHandler("antitroll:Seethrough", function()
    local user = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(user)
    --if(user.permission_level == 0) then
    CheckForBan(user, "Vision Thermique")
    TriggerEvent('discord:antiCheat', "REPORT :eyeglasses:  " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") UTILISE LA VISION THERMIQUE! Pas besoin de ça pour savoir que PiLouf est chaude" .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
    -- Vérification de tous les joueurs connectés
    exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
        for k, v in pairs(users_connected) do
            if(v.permission_level > 0) then
                TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") UTILISE LA VISION THERMIQUE " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
            end
        end
    end)
    -- end
    --end)
end)

AddEventHandler("antitroll:SpectatorDetected", function()
    local user = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(user)
    if(user.permission_level == 0) then
        CheckForBan(user, "Spectate")
        TriggerEvent('discord:antiCheat', "REPORT ** :eye: ** : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") est en mode Spectateur ! On ne pique pas le Job de Jacx comme ça ! " .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
        -- Vérification de tous les joueurs connectés
        exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
            for k, v in pairs(users_connected) do
                if(v.permission_level > 0) then
                    TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") est en mode spectateur " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
                end
            end
        end)
    end
    --end)
end)

AddEventHandler("antitroll:ExplosiveDetected", function()
    local user = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(user)
    if(user.permission_level == 0) then
        CheckForBan(user, "Arme Explosive")
        TriggerEvent('discord:antiCheat', "REPORT ** :fire: ** : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") UTILISE UNE ARME EXPLOSIVE ! La Millice attaque !" .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
        -- Vérification de tous les joueurs connectés
        exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
            for k, v in pairs(users_connected) do
                if(v.permission_level > 0) then
                    TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") UTILISE UNE ARME EXPLOSIVE " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
                end
            end
        end)
    end
    --end)
end)

AddEventHandler("antitroll:ArmorDetected", function(Armure)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(user)
    if(user.permission_level == 0) then
        CheckForBan(user, "Armor")
        TriggerEvent('discord:antiCheat', "REPORT **** : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") a trop d'armure (**" .. Armure .. "** au lieu de 100) ! Mais il n'a pas mis de casque ... " .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
        exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
            for k, v in pairs(users_connected) do
                if(v.permission_level > 0) then
                    TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") a trop d'armure (" .. Armure .. " au lieu de 100) " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
                end
            end
        end)
    end
    --end)
end)

AddEventHandler("antitroll:LifeDetected", function(Vie)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(user)
    if(user.permission_level == 0) then
        CheckForBan(user, "life")
        TriggerEvent('discord:antiCheat', "REPORT **** : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") a trop de vie (**" .. Vie .. "** au lieu de 200) ! Tout le monde meurt, tu ne peux rien y faire " .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
        exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
            for k, v in pairs(users_connected) do
                if(v.permission_level > 0) then
                    TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") a trop de vie (" .. Vie .. " au lieu de 200) " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
                end
            end
        end)
    end
    --end)
end)

AddEventHandler("antitroll:InvisibleDetected", function()
    local user = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(user)
    if(user.permission_level == 0) then
        CheckForBan(user, "Invisible")
        
        TriggerEvent('discord:antiCheat', "REPORT **** : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") est invisible ! Tout ça pour aller dans les vestiaires des femmes ... " .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
        exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
            for k, v in pairs(users_connected) do
                if(v.permission_level > 0) then
                    TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") est invisible " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
                end
            end
        end)
    end
    
    --end)
end)

AddEventHandler("antitroll:InvincibleDetected", function()
    local user = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(user)
    if(user.permission_level == 0) then
        CheckForBan(user, "GodMod")
        
        TriggerEvent('discord:antiCheat', "REPORT **** : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") est **invincible** ! " .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
        exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
            for k, v in pairs(users_connected) do
                if(v.permission_level > 0) then
                    TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") est invincible " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
                end
            end
        end)
        
    end
    --end)
end)

AddEventHandler("antitroll:SpawnVehDetected", function()
    local user = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(user)
    if(user.permission_level == 0) then
        CheckForBan(user, "Spawn Vehicle")
        
        TriggerEvent('discord:antiCheat', "REPORT :red_car: : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") utilise un véhicule spawn ! " .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
        exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
            for k, v in pairs(users_connected) do
                if(v.permission_level > 0) then
                    TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") utilise un véhicule spawn ! " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
                end
            end
        end)
        
    end
    --end)
end)

AddEventHandler("antitroll:VehForbidenDetected", function(veh)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    if(user.permission_level == 0) then
        CheckForBan(user, "Vehicule interdit :("..veh..")")
        
        TriggerEvent('discord:antiCheat', "REPORT :red_car: : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") utilise un **"..veh.."** ! " .. GetConvar("current_server", "SERVEUR TEST")) -- msg Discord
        exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
            for k, v in pairs(users_connected) do
                if(v.permission_level > 0) then
                    TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, " " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") utilise un **"..veh.."** ! " .. GetConvar("current_server", "SERVEUR TEST")) -- msg IG aux admins
                end
            end
        end)
        
    end
    --end)
end)

AddEventHandler("antitroll:CauseOfDeath", function(Joueur, Raison, Arme, Tueur)
    local Victim = exports["essentialmode"]:getPlayerFromId(Joueur)
    local Killer = exports["essentialmode"]:getPlayerFromId(Tueur)
    
    if(Tueur ~= nil and Raison ~= nil and Arme ~= nil) then
        TriggerEvent('discord:antiCheat', "**INFORMATION ** :gun:**: **" .. GetPlayerName(Joueur) .. "** (" ..Victim.prenom.." "..Victim.nom.." ID: "..Victim.source..") est mort tué par **" .. GetPlayerName(Tueur) .. "** (" ..Killer.prenom.." "..Killer.nom.." ID: "..Killer.source..") avec **" .. Arme.. "** ("..Raison..")") -- msg Discord
    elseif(Tueur ~= nil and Raison == nil and Arme == nil)then
        TriggerEvent('discord:antiCheat', "**INFORMATION ** :gun:**: **" .. GetPlayerName(Joueur) .. "** (" ..Victim.prenom.." "..Victim.nom.." ID: "..Victim.source..") est mort tué par **" .. GetPlayerName(Tueur) .. "** (" ..Killer.prenom.." "..Killer.nom.." ID: "..Killer.source..") avec **Arme Inconnue** (Raison inconnue)") -- msg Discord
    elseif(Tueur ~= nil and Raison == nil)then
        TriggerEvent('discord:antiCheat', "**INFORMATION ** :gun:**: **" .. GetPlayerName(Joueur) .. "** (" ..Victim.prenom.." "..Victim.nom.." ID: "..Victim.source..") est mort tué par **" .. GetPlayerName(Tueur) .. "** (" ..Killer.prenom.." "..Killer.nom.." ID: "..Killer.source..") avec **" .. Arme.. "** (Raison inconnue)") -- msg Discord
    elseif(Tueur ~= nil and Arme == nil)then
        TriggerEvent('discord:antiCheat', "**INFORMATION ** :gun:**: **" .. GetPlayerName(Joueur) .. "** (" ..Victim.prenom.." "..Victim.nom.." ID: "..Victim.source..") est mort tué par **" .. GetPlayerName(Tueur) .. "** (" ..Killer.prenom.." "..Killer.nom.." ID: "..Killer.source..") avec **Arme inconnue** ("..Raison..")") -- msg Discord
    end
end)

AddEventHandler("antitroll:RetourHopitalDetected", function(Joueur)
    TriggerEvent('discord:antiCheat', "INFORMATION ** :syringe:**: **" .. Joueur .. "** a fait un retour hopital ") -- msg Discord
end)

function CheckForBan(user, reason)
    -- if (PlayerSourceForBan[player_source] ~= nil) then
    --if(PlayerSourceForBan[player_source].count > 5) then
    MySQL.Async.execute('UPDATE users SET vip=0 WHERE identifier = @identifier', {['@identifier'] = user.identifier})
    DropPlayer(user.source, "Vous êtes banni pour avoir utilisé un cheat ou un exploit. Si vous considerez que vous n'êtes pas un cheater alors vous pouvez venir négocier sur le Discord.")
    TriggerEvent('discord:kickban', "REPORT :name_badge: : " ..user.prenom.." "..user.nom.."( ID:" .. user.identifier .. ") vient d'être banni par l'anti-cheat (**"..reason.."**) ! Un point de plus pour les Dev, pourquoi s'embeter à aller en ville ... " .. GetConvar("current_server", "SERVEUR TEST"))
    -- else
    --     PlayerSourceForBan[player_source].count = PlayerSourceForBan[player_source].count + 1
    --   end
    --  else
    --      PlayerSourceForBan[player_source] = {count = 1}
    -- end
end
