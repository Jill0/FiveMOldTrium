
function loadUser(identifier, source)

    local source = source
    local identifier = identifier

    if(string.find(identifier, "steam")) then

        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier}, function(result)

            if result[1] ~= nil then
                local user = result[1]
                local group = groups[user.group]
                Users[source] = Player(source, user)
                TriggerEvent('es:playerLoaded', source, Users[source])
                TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source].func.getPermissions())
                TriggerClientEvent('es:setMoneyIcon', source, settings.defaultSettings.moneyIcon)
                updateLastSeen(identifier)
                -- Ajout des urgences
                exports["c_services"]:AddEmergencyConnected(Users[source].jobId)
                --

                TriggerEvent('es:initialized', source)
                justJoined[source] = true

                if(settings.defaultSettings.pvpEnabled)then
                    TriggerClientEvent("es:enablePvp", source)
                end
            else

                MySQL.Async.execute(
                    "INSERT INTO users (`identifier`, `permission_level`, `money`, `group`) VALUES (@username, '0', @money, 'user')", 
                    {['@username'] = identifier, ['@money'] = settings.defaultSettings.startingCash}, 
                    function(result)
                        TriggerEvent('es:newPlayerLoaded', source, Users[source])
                        loadUser(identifier, source)
                    end
                )

            end

        end)

    else
        DropPlayer(source, "Vous devez lancer STEAM avant de vous connecter sur notre serveur !")
    end
end

function updateLastSeen(identifier)
    MySQL.Async.execute("UPDATE users SET last_seen_at = CURRENT_TIMESTAMP WHERE identifier = '@identifier'", 
    {['@identifier'] = identifier})
end

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

function isWhiteListed(identifier)
    local result = MySQL.Sync.fetchAll("SELECT listed FROM whitelist WHERE identifier = @name", {['@name'] = identifier})
    if(result)then
        for k, v in ipairs(result)do
            if v.listed == 1 or v.listed == 99 then
                return false
            end
        end
    end
    return true
end

function isLoggedIn(source)
    if(Users[GetPlayerName(source)] ~= nil)then
        if(Users[GetPlayerName(source)]['isLoggedIn'] == 1) then
            return true
        else
            return false
        end
    else
        return false
    end
end

AddEventHandler("es:setPlayerData", function(user, k, v, cb)
    if(Users[user])then
        if(Users[user][k])then

            if(k ~= "money") then
                Users[user][k] = v

                MySQL.Async.execute("UPDATE users SET " ..k.."=@value WHERE identifier = @identifier", 
                {['@value'] = v, ['@identifier'] = Users[user]['identifier']})
            end

            if(k == "group")then
                Users[user].group = groups[v]
            end

            cb("Player data edited.", true)
        else
            cb("Column does not exist!", false)
        end
    else
        cb("User could not be found!", false)
    end
end)

AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
    MySQL.Async.execute("UPDATE users SET " ..k.."=@value WHERE identifier = @identifier", 
    {['@value'] = v, ['@identifier'] = user})

    cb("Player data edited.", true)
end)

-- getPlayerFromId for export
function getPlayerFromId(user)
    if(Users)then
        if(Users[user])then
            return Users[user]
        else
            return nil
        end
    else
        return nil
    end
end

-- getPlayerFromId for event
AddEventHandler("es:getPlayerFromId", function(user, cb)
    cb(getPlayerFromId(user))
end)

AddEventHandler("es:getAllPlayerConnected", function(cb)
    return cb(Users)
end)

function getAllPlayerConnected(cb)
    return cb(Users)
end

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @name", {['@name'] = identifier})
    if(result and result[1])then
        cb(result[1])
    else
        cb(nil)
    end
end)

AddEventHandler("es:getAllPlayers", function(cb)
    local result = MySQL.Sync.fetchAll("SELECT * FROM users", {})
    if(result)then
        cb(result)
    else
        cb(nil)
    end
end)
