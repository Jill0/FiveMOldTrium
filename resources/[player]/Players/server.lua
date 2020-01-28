RegisterServerEvent('watermark:getServer')
AddEventHandler('watermark:getServer', function()
	print(check)
	TriggerClientEvent("watermark:displayServer", source, GetConvar("current_server", "SERVEUR TEST"))
end)

RegisterServerEvent('cp:spawnplayer')
AddEventHandler('cp:spawnplayer', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local executed_query = MySQL.Async.execute("UPDATE users SET `Nom` = '@name' WHERE identifier = '@username'",
        {['@name'] = GetPlayerName(user.source), ['@username'] = player})
    end)
end)

RegisterServerEvent("overhead:isAdmin")
AddEventHandler("overhead:isAdmin", function()
    TriggerEvent('es:getPlayerFromId', source, function(player)
        --print("OH/Group : "..player.group.group)
        TriggerClientEvent("overhead:setAdmin", player.source, player.group.group)
    end)
end)

RegisterServerEvent('vk_handsup:getSurrenderStatus')
AddEventHandler('vk_handsup:getSurrenderStatus', function(event, targetID)
    TriggerClientEvent("vk_handsup:getSurrenderStatusPlayer", targetID, event, source)
end)

RegisterServerEvent('vk_handsup:sendSurrenderStatus')
AddEventHandler('vk_handsup:sendSurrenderStatus', function(event, targetID, handsup)
    TriggerClientEvent(event, targetID, handsup)
end)

RegisterServerEvent('vk_handsup:reSendSurrenderStatus')
AddEventHandler('vk_handsup:reSendSurrenderStatus', function(event, targetID, handsup)
    TriggerClientEvent(event, targetID, handsup)
end)

-- OVERHEAD
local nomprenomJoueurs = {}
RegisterServerEvent('overhead:updateListe')
AddEventHandler('overhead:updateListe', function()
    TriggerClientEvent('overhead:setNomPrenom', source, nomprenomJoueurs)
end)

RegisterServerEvent('overhead:getNomPrenom')
AddEventHandler('overhead:getNomPrenom', function()
    local user = exports["essentialmode"]:getPlayerFromId(source)
    if(user.source ~= nil) then
        local nom = user.nom
        local prenom = user.prenom
        local identifier = user.identifier
        local userid = user.source
        local time_played = user.func.getTimePlayed()

        nomprenomJoueurs[user.source] = {id = userid, steamid = identifier, nom = nom, prenom = prenom, time_played = time_played}
        TriggerClientEvent('overhead:setNomPrenom', user.source, nomprenomJoueurs)
    end
end)
--