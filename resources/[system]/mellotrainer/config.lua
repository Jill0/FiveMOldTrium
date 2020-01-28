local adminOnlyTrainer = true
local admins = {}
local firststart = true

Citizen.CreateThread(function ()
    if(firststart) then
        firststart = false
        Citizen.Wait(1000)
        -- STAFF ID
        local staffid = MySQL.Sync.fetchAll("SELECT identifier FROM users WHERE permission_level > 0")
        local var = 0
        for k, v in pairs(staffid) do
            var = var + 1
            table.insert(admins, staffid[var].identifier)
        end
        --for key,value in pairs(admins) do print(key,value) end
    end
    
    while true do
        --Citizen.Wait(5000)
        Citizen.Wait(3600000)
        print("Mise à jour des TIMESTAMP des bannis...")
        MySQL.Async.execute('UPDATE bans SET timestamp=CURRENT_TIMESTAMP', {})
        Citizen.Wait(10000)
        local banlist = MySQL.Sync.fetchAll('SELECT banned, expires, timestamp FROM bans', {})
        for k, v in pairs(banlist) do
            if(os.date(v.expires) <= os.date(v.timestamp)) then
                print(v.banned .. " est maintenant debanni")
                MySQL.Async.execute('DELETE FROM bans WHERE banned=@identifier', {['@identifier'] = v.banned})
                MySQL.Async.execute('UPDATE users SET vip=1 WHERE identifier=@identifier', {['@identifier'] = v.banned})
                Citizen.Wait(1000)
            end
        end
    end
end)

--local pvpEnabled = true
--local maxPlayers = 64

-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.

Config = {}
Config.settings = {
    --pvpEnabled = pvpEnabled,
    --maxPlayers = maxPlayers,
    
    adminOnlyTrainer = adminOnlyTrainer,
    admins = admins
}

function getPlayerLevel()
    local ban = MySQL.Sync.fetchAll('SELECT vip FROM users WHERE identifier=@identifier', {['@identifier'] = GetPlayerIdentifiers(source)[1]})
    if ban[1] ~= nil then
        return ban[1].vip
    else
        ban = 1
        return ban
    end
end

AddEventHandler('playerConnecting', function(identifier, setCallback)
    if getPlayerLevel() == 0 then
        setCallback("Vous êtes bannis, merci de venir discord si vous penser être victime d'injustice.")
        CancelEvent()
    end
    
end)

RegisterServerEvent("mellotrainer:SearchBannedPlayer")
AddEventHandler("mellotrainer:SearchBannedPlayer", function(nametosearch)
    local mysource = source
    MySQL.Async.fetchAll("SELECT nom, prenom, identifier, dateNaissance FROM users WHERE vip='0' AND nom LIKE @nom", {['@nom'] = "%" .. nametosearch .. "%"}, function(bannedlist)
        TriggerClientEvent("mellotrainer:receiveBannedList", mysource, bannedlist)
    end)
end)

--
RegisterServerEvent("mellotrainer:TimedBanTriumCheater")
AddEventHandler("mellotrainer:TimedBanTriumCheater", function(player, bantime)
    local modo = exports["essentialmode"]:getPlayerFromId(source)
    local time = tonumber(bantime)
    
    local message = ""
    
    time = os.time() + (tonumber(time) * 60 * 60)
    
    local tstamp = os.date("*t", time)
    local tstamp2 = os.date("*t", os.time())
    
    DropPlayer(player["id"], "Vous êtes bannis jusqu'au " .. tstamp.day .. "/" .. tstamp.month .. " " .. tstamp.hour .. "h")
    TriggerEvent('discord:kickban', "INFORMATION ** :name_badge: : **" .. player['nom'] .. " " .. player['prenom'] .. "** est banni temporairement** pendant **" .. bantime .. "h** par " .. modo.prenom .. " " .. modo.nom)
    
    Citizen.CreateThread(function ()
        MySQL.Async.execute('UPDATE users SET vip=0 WHERE identifier=@identifier', {['@identifier'] = player['steamid']})
        MySQL.Async.execute('DELETE FROM bans WHERE banned=@identifier', {['@identifier'] = player['steamid']})
        Citizen.Wait(5000)
        MySQL.Async.execute("INSERT INTO bans (`banned`, `reason`, `expires`, `banner`, `timestamp`) VALUES (@username, @reason, @expires, @banner, @now)",
        {['@username'] = player['steamid'], ['@reason'] = "Banni : " .. player['prenom'] .. " " .. player['nom'], ['@expires'] = os.date(tstamp.year .. "-" .. tstamp.month .. "-" .. tstamp.day .. " " .. tstamp.hour .. ":" .. tstamp.min .. ":" .. tstamp.sec), ['@banner'] = modo.prenom .. " " .. modo.nom, ['@now'] = os.date(tstamp2.year .. "-" .. tstamp2.month .. "-" .. tstamp2.day .. " " .. tstamp2.hour .. ":" .. tstamp2.min .. ":" .. tstamp2.sec)})
    end)
end)

RegisterServerEvent("mellotrainer:banAwayTriumCheater")
AddEventHandler("mellotrainer:banAwayTriumCheater", function(steamid, playerid, ban)
    local modo = exports["essentialmode"]:getPlayerFromId(source)
    local banni = exports["essentialmode"]:getPlayerFromId(playerid)
    if(ban) then
        MySQL.Async.execute('UPDATE users SET vip=0 WHERE identifier=@identifier', {['@identifier'] = steamid})
        TriggerEvent('discord:kickban', "INFORMATION :name_badge: : **" .. banni.nom .. " " .. banni.prenom .. "** est banni définitivement par " .. modo.prenom .. " " .. modo.nom)
        DropPlayer(banni.source, "Vous êtes bannis définitivement")
    else
        MySQL.Async.execute('UPDATE users SET vip=1 WHERE identifier=@identifier', {['@identifier'] = steamid})
    end
end)

RegisterServerEvent("mellotrainer:banTriumCheater")
AddEventHandler("mellotrainer:banTriumCheater", function(player)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    local Victime = exports["essentialmode"]:getPlayerFromId(player)
    if user.permissionlevel ~= 0 then
        if GetPlayerName(player) then
            banPlayer(player)
            DropPlayer(player, "Bannis")
            TriggerEvent('discord:kickban', "INFORMATION ** :name_badge: : **" .. user.nom .. " " .. user.prenom .. "** a banni **" .. Victime.prenom .. " " .. Victime.nom.."**")
        end
    else
        banPlayer(source)
        DropPlayer(source, "Bannis")
        TriggerEvent('discord:kickban', "@everyone ANTI-CHEAT - un cheater ** :name_badge: : **" .. user.nom .. " " .. user.prenom .. "** a essayer de bannir **" .. Victime.prenom .. " " .. Victime.nom.."** , il à lui-même été bannis")
    end
end)

RegisterServerEvent("mellotrainer:tempbanPlayer")
AddEventHandler("mellotrainer:tempbanPlayer", function(player)
    if GetPlayerName(player) then
        TempBanPlayer(player, 'Vous êtes banni temporairement')
    end
end)

-- Get Setting from Config.settings
RegisterServerEvent("mellotrainer:getConfigSetting")
AddEventHandler("mellotrainer:getConfigSetting", function(stringname)
    local value = Config.settings[stringname]
    TriggerClientEvent("mellotrainer:receiveConfigSetting", source, stringname, value)
end)

function banPlayer(player)
    MySQL.Sync.execute('UPDATE users SET vip=@vip WHERE identifier=@identifier', {['@vip'] = 0, ['@identifier'] = GetPlayerIdentifiers(player)[1]}, function(data)
    end)
end

--[[
  _    _                         __  __                                                              _   
 | |  | |                       |  \/  |                                                            | |  
 | |  | |  ___    ___   _ __    | \  / |   __ _   _ __     __ _    __ _   _ __ ___     ___   _ __   | |_ 
 | |  | | / __|  / _ \ | '__|   | |\/| |  / _` | | '_ \   / _` |  / _` | | '_ ` _ \   / _ \ | '_ \  | __|
 | |__| | \__ \ |  __/ | |      | |  | | | (_| | | | | | | (_| | | (_| | | | | | | | |  __/ | | | | | |_ 
  \____/  |___/  \___| |_|      |_|  |_|  \__,_| |_| |_|  \__,_|  \__, | |_| |_| |_|  \___| |_| |_|  \__|
                                                                   __/ |                                 
                                                                  |___/                                  
--]]

local Users = {}
-- Called whenever someone loads into the server. Users created in variables.lua
RegisterServerEvent('mellotrainer:firstJoinProper')
AddEventHandler('mellotrainer:firstJoinProper', function(id)
    local identifiers = GetPlayerIdentifiers(source)
    for i = 1, #identifiers do
        if(Users[source] == nil)then
            Users[source] = GetPlayerName(source) -- Update to user object?
        end
    end
    
    TriggerClientEvent('mellotrainer:playerJoined', -1, id)
    TriggerEvent('discord:Connexion', "INFORMATION :sun_with_face: "..Users[source] .. " a rejoint la ville")
    TriggerClientEvent("mellotrainer:receiveConfigSetting", source, "adminOnlyTrainer", Config.settings.adminOnlyTrainer)
end)

-- Remove User on playerDropped.
AddEventHandler('playerDropped', function()
    if(Users[source])then
        TriggerEvent('discord:Connexion', "INFORMATION :full_moon_with_face: "..Users[source] .. " a quitté la ville")
        TriggerClientEvent('mellotrainer:playerLeft', -1, Users[source])
        Users[source] = nil
    end
end)

-- Admin Managment
local adminList = Config.settings.admins

-- Is identifier in admin list?
function isAdmin(identifier)
    local adminList = {}
    for _, v in pairs(admins) do
        adminList[v] = true
    end
    identifier = string.lower(identifier)
    identifier2 = string.upper(identifier)
    
    if(adminList[identifier] or adminList[identifier2])then
        return true
    else
        return false
    end
end

-- Is user an admin? Select trainer option
RegisterServerEvent("mellotrainer:isAdmin")
AddEventHandler("mellotrainer:isAdmin", function()
    local identifiers = GetPlayerIdentifiers(source)
    for i = 1, #identifiers, 1 do
        if(isAdmin(identifiers[i]))then
            TriggerClientEvent("mellotrainer:adminstatustriumencoreunautre", source, true)
            break
        end
    end
end)

-- Is user an admin?
RegisterServerEvent("mellotrainer:getAdminStatus")
AddEventHandler("mellotrainer:getAdminStatus", function()
    local identifiers = GetPlayerIdentifiers(source)
    for i = 1, #identifiers, 1 do
        if(isAdmin(identifiers[i]))then
            TriggerClientEvent("mellotrainer:receveurtusaurapasadmin24", source, true)
            TriggerClientEvent("mellotrainer:receveurtusaurapasadmin242", source, true)
            break
        end
    end
end)

