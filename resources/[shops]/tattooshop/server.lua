RegisterServerEvent("tattooshop:spawn")
AddEventHandler("tattooshop:spawn", function()
    local pedSource = source
    local identifier = GetPlayerIdentifiers(pedSource)[1]
    TriggerEvent('tattooshop:GetPlayerTattoos_s', identifier, pedSource)
end)

RegisterServerEvent("tattooshop:GetPlayerTattoos_s")
AddEventHandler("tattooshop:GetPlayerTattoos_s", function(identifier, lasource)
    MySQL.Async.fetchAll("SELECT * FROM clothes_users_tattoos WHERE identifier = @identifier", {['@identifier'] = identifier}, function(result)
        if(result[1] ~= nil) then
            local tattoosList = json.decode(result[1].tattoos)
            TriggerClientEvent("tattooshop:getPlayerTattoos", lasource, tattoosList)
        else
            local tattooValue = json.encode({})
            MySQL.Async.execute("INSERT INTO clothes_users_tattoos (identifier, tattoos) VALUES (@identifier, @tattoo)", {['@identifier'] = identifier, ['@tattoo'] = tattooValue})
            TriggerClientEvent("tattooshop:getPlayerTattoos", lasource, {})
        end
    end)
end)

RegisterServerEvent("tattooshop:getModelAndList")
AddEventHandler("tattooshop:getModelAndList", function()
    local pedSource = source
    local identifier = GetPlayerIdentifiers(pedSource)[1]
	TriggerEvent('tattooshop:getTattoos', pedSource)
    TriggerEvent('tattooshop:GetPlayerTattoos_s', identifier, pedSource)
end)

RegisterServerEvent('tattooshop:getTattoos')
AddEventHandler('tattooshop:getTattoos', function(source)
    MySQL.Async.fetchAll("SELECT * FROM clothes_tattoos", {}, function(tattoos)
	    local tattoosList = {}
	    if tattoos and tattoos[1] then
	        for k,tattoo in ipairs(tattoos)do
	            tattoosList[k] = tattoo
	        end
	        TriggerClientEvent('tattooshop:setTattoosList', source, tattoosList )
	    end
    end)
end)

RegisterServerEvent('tattooshop:buyTattoo')
AddEventHandler('tattooshop:buyTattoo', function(tattoosList, price, value)
    local source = source
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if tonumber(user.money) >= tonumber(price) and tonumber(user.money) > 0 then
--            if not checkTattoo(source, value) then
                table.insert(tattoosList, value)
                MySQL.Async.execute("UPDATE clothes_users_tattoos SET tattoos = @tattoos WHERE identifier = @identifier", {['@tattoos'] = json.encode(tattoosList), ['@identifier'] = user.identifier}, function()
                    user.func.removeMoney(price)
                    TriggerEvent('tattooshop:GetPlayerTattoos_s', user.identifier, source)
                    TriggerClientEvent('tattooshop:notifs', source, "Vous venez de payer ~y~"..price.."$ pour ce tatouage"  )
                end)
--            else
--                TriggerClientEvent('tattooshop:notifs', source, "~r~Vous avez déjà ce tatouage" )
--            end
        else
            TriggerClientEvent('tattooshop:notifs', source, "Vous n'avez pas assez d'argent en poche"  )
            TriggerEvent('tattooshop:GetPlayerTattoos_s', user.identifier, source)
        end
    end)
end)

--function checkTattoo(source, value)
--    local identifier = GetPlayerIdentifiers(source)[1]
--    local user_tattoos = MySQL.Sync.fetchScalar("SELECT tattoos FROM clothes_users_tattoos WHERE identifier=@id", {['@id'] = identifier})
--    user_tattoos = json.decode(user_tattoos)
--    local retour = false
--    for k, v in pairs(user_tattoos) do
--        if v.nameHash == value.nameHash then
--            retour = true
--            break
--        end
--    end
--    return retour
--end