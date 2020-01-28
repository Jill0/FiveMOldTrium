secondsToWait = 900 -- 30 minutes (1800 secondes)
currentWeatherString = "SMOG" -- Starting Weather Type.
SmartWeatherEnabled = true
currentWeatherData = {["weatherString"] = "CLEAR", ["windEnabled"] = false, ["windHeading"] = math.random(0, 50), ["windSpeed"] = 0}

-- Removed Neutral from possible weather options, had issue with it sometimes turning the sky green.
-- Removed XMAS from possible weather option as it blankets entire map with snow.
weatherTree = {
    ["EXTRASUNNY"] = {"CLEAR", "SMOG", "EXTRASUNNY"},
    ["SMOG"] = {"FOGGY", "CLEAR", "CLEARING", "OVERCAST", "CLOUDS", "EXTRASUNNY"},
    ["CLEAR"] = {"CLOUDS", "EXTRASUNNY", "CLEARING", "SMOG", "FOGGY", "OVERCAST"},
    ["CLOUDS"] = {"CLEAR", "SMOG", "FOGGY", "CLEARING", "OVERCAST"},
    ["FOGGY"] = {"CLEAR", "CLOUDS", "SMOG", "OVERCAST"},
    ["RAIN"] = {"THUNDER", "CLEAR"},
    ["THUNDER"] = {"RAIN", "CLEAR"},
    ["CLEARING"] = {"CLEAR", "CLOUDS", "OVERCAST", "FOGGY", "SMOG", "EXTRASUNNY"},
["OVERCAST"] = {"CLEARING", "RAIN", "FOGGY", "CLOUDS", "CLEAR", "SMOG"}}

windWeathers = {
    ["RAIN"] = true,
    ["THUNDER"] = true,
    ["CLOUDS"] = true
}

function getTableKeys(T)
    local keys = {}
    for k, v in pairs(T) do
        table.insert(keys, k)
    end
    return keys
end

currentWeatherData = {
    ["weatherString"] = currentWeatherString,
    ["windEnabled"] = false,
    ["windHeading"] = 0,
    ["windSpeed"] = 0
}

function updateWeatherString()
    local newWeatherString = nil
    local windEnabled = false
    local windHeading = 0
    -- Lua random requires an updated randomseed to ensure randomnees between same range values.
    math.randomseed(GetGameTimer())
    
    local tableKeys = getTableKeys(weatherTree)
    
    if(currentWeatherData["weatherString"] == nil)then
        newWeatherString = tableKeys[math.random(1, #weatherTree)]
    else
        local currentOptions = weatherTree[currentWeatherData["weatherString"]]
        newWeatherString = currentOptions[math.random(1, #currentOptions)]
    end
    
    -- 50/50 Chance to enabled wind at a random heading for the specified weathers.
    if(windWeathers[newWeatherString] and (math.random(0, 1) == 1))then
        windEnabled = true
        windHeading = math.random(0, 360)
        windSpeed = 11.99
    end
    
    currentWeatherData = {
        ["weatherString"] = newWeatherString,
        ["windEnabled"] = windEnabled,
        ["windHeading"] = windHeading,
        ["windSpeed"] = windSpeed
    }
    
    print("Mise à jour automatique de la météo par '"..newWeatherString.."' pour tout les joueurs.")
    TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData)
end

-- Sync Weather once player joins.
RegisterServerEvent("smartweather:syncWeather")
AddEventHandler("smartweather:syncWeather", function()
    print("Météo synchronisée pour : " .. GetPlayerName(source))
    TriggerClientEvent("smartweather:updateWeather", source, currentWeatherData, 10.0)
end)

Citizen.CreateThread(function()
    while true do
        Wait(secondsToWait * 1000)
        if SmartWeatherEnabled then
            updateWeatherString()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local text1 = "~r~Tempête dans 30 minutes !"
        local text2 = "~r~Tempête dans 15 minutes !"
        local text3 = "~r~Tempête dans 10 minutes !"
        local text4 = "~r~Tempête dans 5 minutes !\nRestez à l'abris et rentrez chez vous !"
        local date_local = os.date('%H:%M:%S', os.time())
        
        if date_local == '05:30:00' or date_local == '19:30:00' then
            TriggerClientEvent("ft_libs:AdvancedNotification", -1, {
                icon = "CHAR_MP_MORS_MUTUAL",
                title = "URGENCE METEOROLOGIQUE",
                text = text1,
            })
        elseif date_local == '05:45:00' or date_local == '19:45:00' then
            TriggerClientEvent("ft_libs:AdvancedNotification", -1, {
                icon = "CHAR_MP_MORS_MUTUAL",
                title = "URGENCE METEOROLOGIQUE",
                text = text2,
            })
            SmartWeatherEnabled = false
            math.randomseed(GetGameTimer())
            currentWeatherData = {["weatherString"] = "RAIN", ["windEnabled"] = true, ["windHeading"] = math.random(0, 360), ["windSpeed"] = 11.99}
            TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData)
            
        elseif date_local == '05:50:00' or date_local == '19:50:00' then
            TriggerClientEvent("ft_libs:AdvancedNotification", -1, {
                icon = "CHAR_MP_MORS_MUTUAL",
                title = "URGENCE METEOROLOGIQUE",
                text = text3,
            })
            SmartWeatherEnabled = false
            math.randomseed(GetGameTimer())
            currentWeatherData = {["weatherString"] = "THUNDER", ["windEnabled"] = true, ["windHeading"] = math.random(0, 360), ["windSpeed"] = 11.99}
            TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData)
            
        elseif date_local == '05:55:00' or date_local == '19:55:00' then
            TriggerClientEvent("ft_libs:AdvancedNotification", -1, {
                icon = "CHAR_MP_MORS_MUTUAL",
                title = "URGENCE METEOROLOGIQUE",
                text = text4,
            })
            SmartWeatherEnabled = false
            math.randomseed(GetGameTimer())
            currentWeatherData = {["weatherString"] = "HALLOWEEN", ["windEnabled"] = false, ["windHeading"] = math.random(0, 360), ["windSpeed"] = 0.0}
            TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData)
            
        elseif date_local == '05:59:00' or date_local == '19:59:00' then
            exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
                for _, v in pairs(users_connected) do
                    DropPlayer(v.source, "La tempête vous a balayé(e).")
                end
            end)
        end
    end
end)

TriggerEvent('es:addGroupCommand', 'setweather', "admin", function(source, args, user)
    if(not args[2]) then
        TriggerClientEvent('chatMessage', source, 'METEO : ', {255, 0, 0}, "Utilisation : /setweather [WEATHER]")
    else
        args[2] = string.upper(args[2])
        if(weatherTree[args[2]] == nil)then
            TriggerClientEvent('chatMessage', source, 'METEO : ', {255, 0, 0}, "Cette Météo n'existe pas ou n'est pas autorisé")
        else
            currentWeatherData = {["weatherString"] = args[2], ["windEnabled"] = false, ["windHeading"] = 0.0, ["windSpeed"] = 0.0}
            TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData)
            TriggerClientEvent('chatMessage', source, 'METEO : ', {255, 0, 0}, "Météo changée en " .. args[2])
            print("Mise à jour manuel de la météo par "..user.nom.. " " ..user.prenom.." en '"..args[2] .. "' pour tout les joueurs.")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'METEO : ', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)

TriggerEvent('es:addGroupCommand', 'toggleweather', "admin", function(source, args, user)
    if SmartWeatherEnabled then
        SmartWeatherEnabled = false
        TriggerClientEvent('chatMessage', source, 'METEO : ', {255, 0, 0}, "Mise à jour automatique de la météo désactivé")
    else
        SmartWeatherEnabled = true
        TriggerClientEvent('chatMessage', source, 'METEO : ', {255, 0, 0}, "Mise à jour automatique de la météo activé")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'METEO : ', {255, 0, 0}, "Vous n'avez pas la permission de faire ça !")
end)
