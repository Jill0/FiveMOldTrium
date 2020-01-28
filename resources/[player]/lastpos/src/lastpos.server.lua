
--Intégration de la position dans MySQL
RegisterServerEvent("project:savelastpos")
AddEventHandler("project:savelastpos", function( LastPosX , LastPosY , LastPosZ , LastPosH )

	local source = source
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local identifier = user.identifier
	local LastPos = "{" .. LastPosX .. ", " .. LastPosY .. ",  " .. LastPosZ+0.05 .. ", " .. LastPosH .. "}"

	MySQL.Async.execute('UPDATE `users` SET `lastpos`=@lastpos WHERE `identifier` = @identifier',
        {['@identifier'] = identifier, ['@lastpos'] = LastPos}, function(result)
            TriggerClientEvent("project:notify", user.source, "Position Sauvegardée")
    end)
end)

--Récupération de la position depuis EssentialMode
RegisterServerEvent("project:SpawnPlayer")
AddEventHandler("project:SpawnPlayer", function()

	local source = source
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local lastpos = user.lastpos

	if lastpos ~= nil and lastpos ~= "" then

		-- Décodage des données récupérées
		local ToSpawnPos = json.decode(lastpos)

		-- Intégration des données dans les variables dédiées
		local PosX = ToSpawnPos[1]
		local PosY = ToSpawnPos[2]
		local PosZ = ToSpawnPos[3]
		local PosH = ToSpawnPos[4]
		-- On envoie la derniere position vers le client pour le spawn
		TriggerClientEvent("project:spawnlaspos", user.source, PosX, PosY, PosZ)

	end

end)
