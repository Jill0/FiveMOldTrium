--=============================================================================
-- #Author: Jonathan D @ Gannon
--=============================================================================

--=============================================================================
--  Config
--=============================================================================
local WeedPlant = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local passwordPreFix = {'Couga', 'Gannon', 'Bastien', 'Corel', 'Soroshiya', 'Mavdol', 'Kriss', 'Tdlc', 'Dictateurfou'}
local currentPassword = ''
local oldPassword = ''
local timeGeneratePassword = 0
local timePasswordValid = 480 * 60-- 8hours
local fileName = 'illegalDataWeed.txt'

--=============================================================================
--  
--=============================================================================
function getTimes()
    return os.time() - 2 * 60 * 60 + math.floor(0)
end

function getPlayerID(source)
    return getIdentifiant(GetPlayerIdentifiers(source))
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end


RegisterServerEvent('illegal:getTimes')
AddEventHandler('illegal:getTimes', function ()
    local stime = getTimes()
    TriggerClientEvent('illegal:setTimes', source, stime)
end)

function loadData()
    local file = io.open(fileName, 'r')
    if file ~= nil then
        currentPassword = file:read()
        oldPassword = file:read()
        timeGeneratePassword = tonumber(file:read())
        file:close(file)
    end
end

function saveData()
    local file = io.open(fileName, 'w+')
    file:write(currentPassword .. '\r\n' .. oldPassword .. '\r\n' .. timeGeneratePassword)
    file:close(file)
end

function initWeed() 
    for i = 1, 19 do 
        WeedPlant[i] = getTimes() - math.floor(math.random(8 * 60))
    end
    loadData()
end

function generatePassword()
    local p = passwordPreFix[math.random(1, #passwordPreFix)] 
    p = p .. string.sub('00' .. math.random(10, 9999), -4)
    timeGeneratePassword = getTimes()
    oldPassword = currentPassword
    currentPassword = p
    saveData()
    return currentPassword
end

function getCurrentPassword()
    local t = getTimes()
    if timeGeneratePassword + timePasswordValid >= t then
        print("PW: " .. tostring(timeGeneratePassword) .. " + " .. tostring(timePasswordValid) .. " time : " .. tostring(t) .. " / " .. tostring(timeGeneratePassword + timePasswordValid))
        return currentPassword
    else
        return generatePassword()
    end

end

initWeed()
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(240000)
        --[[local nbPolicier = 0
--
local users_connected = exports["essentialmode"]:getAllPlayerConnected()   
for k,v in pairs(users_connected) do
if (v.func.getSessionVar('policeInService') == true) then
        nbPolicier = nbPolicier + 1
    end
end
--
--local user = exports["essentialmode"]:getPlayerFromId(source)
]]--
        local nbPolicier = 0
        nbPolicier = exports["c_services"]:GetPoliceConnected()
        TriggerClientEvent('illegal:illegalsetcop', -1, nbPolicier)
        print("POLICIERS :" .. nbPolicier)
    end
end)

--TestCop()
--[[Citizen.CreateThread(function()
    while true do
        TestCop()
        Citizen.Wait(120000)
    end
end)]]--


RegisterServerEvent('illegal:requestFullPlantData')
AddEventHandler('illegal:requestFullPlantData', function ()
    local stime = getTimes()
    TriggerClientEvent('illegal:setFullPlantData', source, WeedPlant, stime)
end)

RegisterServerEvent('illegal:PlanteSeed')
AddEventHandler('illegal:PlanteSeed', function (id)
    local t = getTimes()
    WeedPlant[id] = t
    TriggerClientEvent('illegal:seedChange', source, id, t)
end)


RegisterServerEvent('illegal:weedTryPassowrd')
AddEventHandler('illegal:weedTryPassowrd', function (password, qte)
    local source = source
    local pw = getCurrentPassword()
    print("================================================== " .. getPlayerID(source) .. " ==== password propose : " .. password .. " Password demande : " .. pw)
    if tostring(password) == pw then
        TriggerEvent('es:getPlayerFromId', source, function(Player)
            Player.func.addDirty_Money(qte * JoinVenteFull)
            TriggerClientEvent('illegal:fullVente', Player.source, 1, qte) 
        end)
    elseif password == oldPassword then
        TriggerClientEvent('illegal:fullVente', source, 0, 0)
    else
        TriggerClientEvent('illegal:fullVente', source, -1, 0)
    end
end)

RegisterServerEvent('illegal:needPassword')
AddEventHandler('illegal:needPassword', function ()
    local t = getTimes()
    local resultattime = tonumber(timeGeneratePassword + timePasswordValid - t)
    print(tostring(resultattime))
    TriggerClientEvent('illegal:password', source, getCurrentPassword(), resultattime)
end)

RegisterServerEvent('illegal:recoltWeed')
AddEventHandler('illegal:recoltWeed', function (id)
    local t = WeedPlant[id]
    local d = math.floor(getTimes() - t) / WeedGrowthTime
    if t ~= 0 and d >= 0.5 then
        local qte = 0 
        if d >= 1 then
            qte = 7
        elseif d >= 0.90 then
            qte = math.random(4, 5)
        elseif d >= 0.80 then
            qte = math.random(3, 4)
        elseif d >= 0.70 then
            qte = math.random(2, 3)
        elseif d >= 0.60 then
            qte = math.random(1, 3) 
        elseif d >= 0.50 then
            qte = math.random(1, 2) 
        end 

        TriggerClientEvent('illegal:recoltWeed', source, qte)
        WeedPlant[id] = 0
        TriggerClientEvent('illegal:seedChange', -1, id, 0)
    end
end)
print('---------GC Illegal LOAD--------')


