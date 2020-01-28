--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 21/06/2017
-- Time: 19:28
-- To change this template use File | Settings | File Templates.
--
--FX

RegisterServerEvent('veh_shop:checkMoney')
AddEventHandler('veh_shop:checkMoney', function(vhl)
    local currentSource = source
    TriggerEvent('es:getPlayerFromId', currentSource, function(user)
        if (tonumber(user.money) >= tonumber(vhl.price)) then
            TriggerClientEvent('veh_shop:writePlaque', currentSource, vhl)
        else
            TriggerClientEvent('veh_shop:notifs', currentSource, "Vous n'avez pas assez d'argent !")
        end

    end)
end)

RegisterServerEvent('veh_shop:buyit')
AddEventHandler('veh_shop:buyit', function(vhl)
    local currentSource = source
    TriggerEvent('es:getPlayerFromId', currentSource, function(user)
        local player = GetPlayerIdentifiers(currentSource)
        local name = vhl.name
        local price = vhl.price
        local plate = string.gsub(vhl.plate, "^%s*(.-)%s*$", "%1")
        local vehicle = vhl.model
        local type = vhl.type
        local state = "Rentré"
        local customs = {
            color = {
                primary = { type= 0, red = vhl.primary_red,green= vhl.primary_green, blue = vhl.primary_blue},
                secondary = { type= 0, red = vhl.secondary_red,green= vhl.secondary_green, blue = vhl.secondary_blue},
                pearlescent = vhl.extra,
                windows = 0
            },
            wheels = {
                type = 0,
                color = vhl.wheelcolor,
            },
            neons = { enabled= 0, red = 255,green= 255, blue = 255},

            tyreburst = {enabled=0, red = 255,green= 255, blue = 255},
            mods = {},
        }
        vhl.customs = json.encode(customs)
        MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE vehicle_model=@model AND vehicle_plate=@plate ORDER BY vehicle_name ASC LIMIT 1", {['@owner'] = player[1], ['@model'] =  vehicle, ['@plate'] = plate }, function(result)

            if not result[1] then
                MySQL.Async.execute("INSERT INTO user_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_price`, `vehicle_plate`, `vehicle_state`, `veh_type`) VALUES (@username, @name, @vehicle, @price, @plate, @state, @type)",{
                    ['@username'] = player[1],
                    ['@name'] = name,
                    ['@vehicle'] = vehicle,
                    ['@price'] = price,
                    ['@plate'] = plate,
                    ['@state'] = state,
                    ['@type'] = 2
                    --['@customs'] = json.encode(customs)
                }, function()
                    user.func.removeMoney((vhl.price))
                    TriggerClientEvent('veh_shop:closeGui', currentSource)
                    TriggerClientEvent('veh_shop:spawnnewvhl', currentSource, vhl)
                end)
            else
                TriggerClientEvent('veh_shop:notifs', currentSource, "Le ~r~meme vehicule~r~ est déjà enregistré avec cette ~r~meme plaque~r~ !")
                TriggerClientEvent('veh_shop:writePlaque', currentSource, vhl)
            end


        end)

    end)
end)
