-- Loading MySQL Class
--FX

local max_number_weapons = 6 --maximum number of weapons that the player can buy. Weapons given at spawn doesn't count.
local cost_ratio = 100 --Ratio for withdrawing the weapons. This is price/cost_ratio = cost.
RegisterServerEvent('weashop:testprix')
AddEventHandler('weashop:testprix', function(item, prixmenu)
    local mysource = source
    local user = exports["essentialmode"]:getPlayerFromId(mysource)
    if(user.money >= prixmenu)then
        user.func.removeMoney(prixmenu)
        TriggerClientEvent('weashop:getFood', mysource, item)
        TriggerClientEvent("ft_libs:AdvancedNotification", mysource, {
            icon = "CHAR_AMMUNATION",
            title = "AMMUNATION",
            text = "~g~Merci pour votre achat, Bonne journée !",
        })
        
    else
        TriggerClientEvent("ft_libs:AdvancedNotification", mysource, {
            icon = "CHAR_AMMUNATION",
            title = "AMMUNATION",
            text = "~r~Vous n'avez pas assez d'argent sur vous !",
        })
    end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}; i = 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
RegisterServerEvent('CheckMoneyForWea')
AddEventHandler('CheckMoneyForWea', function(weapon, price)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        
        if (tonumber(user.money) >= tonumber(price)) then
            local player = user.identifier
            local nb_weapon = 0
            local result = MySQL.Sync.fetchAll("SELECT id FROM user_weapons WHERE identifier = @username", {['@username'] = player})
            if result then
                for k, v in ipairs(result) do
                    nb_weapon = nb_weapon + 1
                end
            end
            print(nb_weapon)
            if (tonumber(max_number_weapons) > tonumber(nb_weapon)) then
                -- Pay the shop (price)
                user.func.removeMoney((price))
                MySQL.Async.execute("INSERT INTO user_weapons (identifier,weapon_model,withdraw_cost) VALUES (@username,@weapon,@cost)",
                {['@username'] = player, ['@weapon'] = string.upper(weapon), ['@cost'] = (price) / cost_ratio})
                -- Trigger some client stuff
                TriggerClientEvent('FinishMoneyCheckForWea', user.source)
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_MP_ROBERTO",
                    title = "Vendeur",
                    text = "Voilà, elle est à toi maintenant\n",
                })
            else
                TriggerClientEvent('ToManyWeapons', user.source)
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_MP_ROBERTO",
                    title = "Vendeur",
                    text = "Vous avez atteint le nombre maxi d'armes (max: "..max_number_weapons..")\n",
                })
            end
        end
    end)
end)

RegisterServerEvent("weaponshop:playerSpawned")
AddEventHandler("weaponshop:playerSpawned", function(spawn)
    local Mysource = source
    TriggerEvent('weaponshop:GiveWeaponsToPlayer', Mysource)
end)

RegisterServerEvent("weaponshop:GiveWeaponsToPlayer")
AddEventHandler("weaponshop:GiveWeaponsToPlayer", function(playerID)
    TriggerEvent('es:getPlayerFromId', playerID, function(user)
        local playerID = user.identifier
        local Mysource = user.source
        print(Mysource)
        local delay = nil
        local result = MySQL.Sync.fetchAll("SELECT weapon_model FROM user_weapons WHERE identifier = @username", {['@username'] = playerID})
        delay = 2000
        if(result)then
            for k, v in ipairs(result) do
                TriggerClientEvent("giveWeapon", Mysource, v.weapon_model, delay)
            end
        end
    end)
end)

RegisterServerEvent("weaponshop:RemoveWeaponsToPlayer")
AddEventHandler("weaponshop:RemoveWeaponsToPlayer", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerID = user.identifier or nil
        if (playerID ~= nil) then
            local executed_query = MySQL.Async.execute("DELETE FROM user_weapons WHERE identifier =@username", {['@username'] = playerID})
        end
    end)
end)
