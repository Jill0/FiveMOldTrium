
items_players = {}
items_saved_cache = {}
-- SAUVEGARDE STOCKAGES

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) -- 5 minutes
        SavePlayersStockage()
    end
end)

function SavePlayersStockage()
    print("[VDK-INV] SAUVEGARDE DES INVENTAIRES DES JOUEURS")
    for k, _ in pairs(items_players) do
        for e, t in pairs(items_players[k]) do
            if(t.update) then
                MySQL.Sync.execute('UPDATE stockage SET quantity = @qty WHERE type = "player_pocket" AND identifier = @identifier AND item_id = @id', {['@identifier'] = k, ['@qty'] = tonumber(t.quantity), ['@id'] = tonumber(e)})
                t.update = false
                Citizen.Wait(100)
            end
        end
    end
end

AddEventHandler('playerDropped', function()
    local mysource = source
    local identifier = getPlayerID(mysource)
    for k, _ in pairs(items_players) do
        if(k == identifier) then
            for e, t in pairs(items_players[k]) do
                if(t.update) then
                    MySQL.Sync.execute('UPDATE stockage SET quantity = @qty WHERE type = "player_pocket" AND identifier = @identifier AND item_id = @id', {['@identifier'] = k, ['@qty'] = tonumber(t.quantity), ['@id'] = tonumber(e)})
                    t.update = false
                    Citizen.Wait(100)
                end
            end
        end
    end
end)

function GetPlayerStockage(identifier)
    return items_players[identifier]
end

RegisterServerEvent("item:getItems")
AddEventHandler("item:getItems", function()
    local mysource = source
    local identifier = getPlayerID(mysource)
    MySQL.Async.fetchAll('SELECT DISTINCT stockage.quantity, stockage.item_id, items.value, items.libelle, items.type, items.weapon_model FROM stockage JOIN items ON stockage.item_id = items.id WHERE stockage.type = "player_pocket" AND stockage.identifier = @identifier', {['@identifier'] = identifier}, function(item_list)
        if item_list ~= nil and items_players[identifier] == nil then
            items_players[identifier] = {}
            for _, v in ipairs(item_list) do
                items_players[identifier][tonumber(v.item_id)] = {}
                items_players[identifier][tonumber(v.item_id)] = {["quantity"] = v.quantity, ["libelle"] = v.libelle, ["value"] = v.value, ["type"] = v.type, ["item_id"] = v.item_id, ["weapon_model"] = v.weapon_model, ["update"] = false}
            end
        end
        TriggerClientEvent("gui:getItems", mysource, items_players[identifier])
    end)
end)

RegisterServerEvent("item:setItem")
AddEventHandler("item:setItem", function(item, quantity)
    local updating = false
    local mysource = source
    local identifier = getPlayerID(mysource)
    if(updating == false) then
        Citizen.CreateThread(function()
            MySQL.Sync.execute('INSERT INTO stockage (`identifier`, `item_id`, `quantity`, `type`) VALUES (@identifier, @item, @qty, "player_pocket")', {['@identifier'] = identifier, ['@item'] = item, ['@qty'] = quantity})
            TriggerClientEvent("ft_libs:Notification", mysource, "Veuillez patienter...")
            updating = true
            Citizen.Wait(1000)
            if(items_players[identifier][item] ~= nil) then
                items_players[identifier][item].quantity = quantity
                updating = false
                TriggerClientEvent("ft_libs:Notification", mysource, "Vous venez de recevoir " .. quantity .. " " .. items_players[identifier][item].libelle)
                TriggerClientEvent("gui:getItems", mysource, items_players[identifier])
            else
                MySQL.Async.fetchAll('SELECT DISTINCT stockage.quantity, stockage.item_id, items.value, items.libelle, items.type, items.weapon_model FROM stockage JOIN items ON stockage.item_id = items.id WHERE stockage.type = "player_pocket" AND stockage.identifier = @identifier', {['@identifier'] = identifier}, function(item_list)
                    if item_list ~= nil then
                        for _, v in ipairs(item_list) do
                            if(v.item_id == item) then
                                items_players[identifier][item] = {}
                                items_players[identifier][item] = {["quantity"] = v.quantity, ["libelle"] = v.libelle, ["value"] = v.value, ["type"] = v.type, ["item_id"] = v.item_id, ["weapon_model"] = v.weapon_model, ["update"] = true}
                                updating = false
                                TriggerClientEvent("ft_libs:Notification", mysource, "Vous venez de recevoir " .. quantity .. " " .. items_players[identifier][item].libelle)
                                TriggerClientEvent("gui:getItems", mysource, items_players[identifier])
                                break
                            end
                        end
                    end
                end)
            end
        end)
    else
        TriggerClientEvent("ft_libs:Notification", mysource, "Veuillez patienter...")
    end
end)

RegisterServerEvent("item:updateQuantity")
AddEventHandler("item:updateQuantity", function(qty, id)
    local mysource = source
    local player = getPlayerID(mysource)
    if(items_players[player][id] ~= nil) then
        items_players[player][id].quantity = qty
        items_players[player][id].update = true
    else
        print("[VDK-INV] Une erreur 'item:updateQuantity' est survenue (" .. id.." / " .. qty .. ")")
    end
    --MySQL.Async.execute('UPDATE stockage SET quantity = @qty WHERE type = "player_pocket" AND identifier = @identifier AND item_id = @id', {['@identifier'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id)})
end)

RegisterServerEvent("item:reset")
AddEventHandler("item:reset", function()
    local mysource = source
    local user = exports["essentialmode"]:getPlayerFromId(mysource)
    user.func.setMoney(0)
    user.func.setDirty_Money(0)
    TriggerEvent('gabs:addcustomneeds', user.source, 50, 50, 50)
    print("[VDK-INV] Reset inventaire après mort du joueur")
    if(items_players[user.identifier]) then
        for k, v in pairs(items_players[user.identifier]) do
            v.quantity = 0
            v.update = true
        end
    end
    --[[local mysource = source
    local user = exports["essentialmode"]:getPlayerFromId(mysource)
    MySQL.Async.execute('UPDATE stockage SET `quantity` = @qty WHERE type = "player_pocket" AND `identifier` = @identifier', {['@identifier'] = user.identifier, ['@qty'] = 0}, function()
        user.func.setMoney(0)
        user.func.setDirty_Money(0)
        TriggerEvent('gabs:addcustomneeds', mysource, 50, 50, 50)
    end)]]--
end)

RegisterServerEvent("item:sell")
AddEventHandler("item:sell", function(id, qty, price)
    local mysource = source
    local user = exports["essentialmode"]:getPlayerFromId(mysource)
    if(items_players[user.identifier][id] ~= nil) then
        items_players[user.identifier][id].quantity = qty
        items_players[user.identifier][id].update = true
        user.func.addMoney(tonumber(price))
    else
        print("[VDK-INV] Une erreur 'item:sell' est survenue (" .. id.." / " .. qty .. ")")
    end
    --[[local mysource = source
    local user = exports["essentialmode"]:getPlayerFromId(mysource)
    MySQL.Async.execute('UPDATE stockage SET quantity = @qty WHERE type = "player_pocket" AND identifier = @identifier AND item_id = @id', {['@identifier'] = user.identifier, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id)}, function()
        user.func.addMoney(tonumber(price))
    end)]]--
end)

RegisterServerEvent("item:sellsale")
AddEventHandler("item:sellsale", function(id, qty, price)
    local mysource = source
    local user = exports["essentialmode"]:getPlayerFromId(mysource)
    if(items_players[user.identifier][id] ~= nil) then
        items_players[user.identifier][id].quantity = qty
        items_players[user.identifier][id].update = true
        user.func.addDirty_Money(tonumber(price))
    else
        print("[VDK-INV] Une erreur 'item:sellsale' est survenue (" .. id.." / " .. qty .. ")")
    end
    --[[
    local mysource = source
    local user = exports["essentialmode"]:getPlayerFromId(mysource)
    MySQL.Async.execute('UPDATE stockage SET quantity = @qty WHERE type = "player_pocket" AND identifier = @identifier AND item_id = @id', {['@identifier'] = user.identifier, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id)}, function()
        user.func.addDirty_Money(tonumber(price))
    end)
    --]]
end)

RegisterServerEvent("player:giveItem")
AddEventHandler("player:giveItem", function(item, name, qty, target)
    local mysource = source
    local player = getPlayerID(mysource)
    local targetid = getPlayerID(target)
    local quantity_tot_target = 0
    if(items_players[targetid]) then
        for k, v in pairs(items_players[targetid]) do
            quantity_tot_target = quantity_tot_target + v.quantity
        end
        if quantity_tot_target ~= nil then
            if (quantity_tot_target + qty < 101) then
                TriggerClientEvent("player:looseItem", mysource, item, qty)
                TriggerClientEvent("player:receiveItem", target, item, qty)
                TriggerClientEvent("ft_libs:Notification", target, "Vous venez de recevoir " .. qty .. " " .. name .. ".")
                TriggerClientEvent("ft_libs:Notification", mysource, "Vous venez de donner " .. qty .. " " .. name .. ".")
            else
                TriggerClientEvent("ft_libs:Notification", mysource, "Quantité trop grande pour l'inventaire du joueur " .. qty .. " " .. name .. ".")
            end
        end
    end
    --[[MySQL.Async.fetchScalar('SELECT SUM(quantity) FROM stockage WHERE type = "player_pocket" AND identifier = @identifier', {['@identifier'] = targetid}, function(total)
        if total ~= nil then
            if (total + qty < 101) then
                TriggerClientEvent("player:looseItem", mysource, item, qty)
                TriggerClientEvent("player:receiveItem", target, item, qty)
                TriggerClientEvent("ft_libs:Notification", target, "Vous venez de recevoir " .. qty .. " " .. name .. ".")
                TriggerClientEvent("ft_libs:Notification", mysource, "Vous venez de donner " .. qty .. " " .. name .. ".")
            else
                TriggerClientEvent("ft_libs:Notification", mysource, "Quantité trop grande pour l'inventaire du joueur " .. qty .. " " .. name .. ".")
            end
        end
    end)]]--
end)

RegisterServerEvent("player:useItem")
AddEventHandler("player:useItem", function(item, name, qty)
    local mysource = source
    local player = getPlayerID(source)
    local quantity_play_target = 0
    if(items_players[player][item] ~= nil) then
        if(items_players[player][item].quantity >= qty and menus[item] ~= nil) then
            TriggerEvent('gabs:addcustomneeds', mysource, menus[item].calories, menus[item].water, menus[item].needs)
            TriggerClientEvent("item:drunk", mysource, item)
            TriggerClientEvent("item:drug", mysource, item)
            TriggerClientEvent("player:looseItem", mysource, item, qty)
            TriggerClientEvent("ft_libs:Notification", mysource, "Vous utilisez " .. qty .. " " .. name)
        end
    else
        TriggerClientEvent("ft_libs:Notification", mysource, "Vous ne pouvez pas utiliser cet item")
    end
    --[[
    MySQL.Async.fetchScalar('SELECT SUM(quantity) FROM stockage WHERE type = "player_pocket" AND identifier = @identifier', {['@identifier'] = player}, function(total)
        if total ~= nil then
            if menus[item] ~= nil then
                if (tonumber(total) - qty >= 0) then
                    TriggerEvent('gabs:addcustomneeds', mysource, menus[item].calories, menus[item].water, menus[item].needs)
                    TriggerClientEvent("item:drunk", mysource, item)
                    TriggerClientEvent("item:drug", mysource, item)
                    TriggerClientEvent("player:looseItem", mysource, item, qty)
                    TriggerClientEvent("ft_libs:Notification", mysource, "Vous utilisez " .. qty .. " " .. name)
                end
            else
                TriggerClientEvent("ft_libs:Notification", mysource, "Vous ne pouvez pas utiliser cet item")
            end
        end
    end)
    ]]--
end)

RegisterServerEvent("item:envoitauxalcool")
AddEventHandler("item:envoitauxalcool", function(demandeur, tauxalcool)
    TriggerClientEvent("item:affichertauxalcool", demandeur, tauxalcool)
end)

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

--################################################
--############### REPORT DISCORD #################
--################################################

RegisterServerEvent('item:TradeMsg')
RegisterServerEvent('item:JetMsg')
RegisterServerEvent('item:RamasseMsg')

AddEventHandler('item:TradeMsg', function(item, quantity, target)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    local destinataire = exports["essentialmode"]:getPlayerFromId(target)
    TriggerEvent('discord:trade', "INFORMATION :envelope_with_arrow: **: **" .. user.nom .. " " .. user.prenom .. "**(ID: "..user.source..") a donné **"..quantity.." "..item.."** à **"..destinataire.nom.." "..destinataire.prenom.."**(ID: "..destinataire.source..")")
end)

AddEventHandler('item:JetMsg', function(item, quantity)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    TriggerEvent('discord:trade', "INFORMATION :outbox_tray: **: **" .. user.nom .. " " .. user.prenom .. "**(ID: "..user.source..") a jeté **"..quantity.." "..item.."**")
end)
AddEventHandler('item:RamasseMsg', function(item, quantity)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    TriggerEvent('discord:trade', "INFORMATION :inbox_tray: **: **" .. user.nom .. " " .. user.prenom .. "**(ID: "..user.source..") a ramassé **"..quantity.." "..item.."**")
end)
