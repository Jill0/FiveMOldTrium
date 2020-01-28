local listMissionsAmbulancier = {}
local listPersonnelAmbulancierActive = {}
local acceptMultiAmbulancier = false
local preFixEventNameAmbulancier = 'ambulancier'
local CALL_INFO_WAIT = 2
local CALL_INFO_OK = 1
local CALL_INFO_NONE = 0

-- Notifyle changement de status des missions
function notifyMissionChangeAmbulancier(target)
    target = target or - 1
    TriggerClientEvent(preFixEventNameAmbulancier .. ':MissionChange', target, listMissionsAmbulancier)
end

-- Notify le changement de status des missions
function notifyPersonnelAmbulancierChange(target)
    target = target or - 1
    TriggerClientEvent(preFixEventNameAmbulancier .. ':personnelChange', target, getNbPersonnelActiveAmbulancier(), getNbPersonnelDispoAmbulancier())
end

-- Notify un message a tout les personnels
function notifyAllPersonnelAmbulancier(MESS)
    TriggerClientEvent(preFixEventNameAmbulancier .. ':PersonnelMessage', -1, MESS)
end

-- Notify un message un personnel
function notifyPersonnelAmbulancier(source, MESS)
    TriggerClientEvent(preFixEventNameAmbulancier .. ':PersonnelMessage', source, MESS)
end

-- Notify un message un client
function notifyClientAmbulancier(source, MESS)
    TriggerClientEvent(preFixEventNameAmbulancier .. ':ClientMessage', source, MESS)
end

-- Not use || Notify a message a tout le monde
function notifyAllClientAmbulancier(MESS)
    TriggerClientEvent(preFixEventNameAmbulancier .. ':ClientMessage', -1, MESS)
end

-- Notify call status change
function notifyCallStatusAmbulancier(source, status)
    TriggerClientEvent(preFixEventNameAmbulancier .. ':callStatus', source, status)
end

function addMissionAmbulancier(source, type, positionBackUp)
    local sMission = listMissionsAmbulancier[source]
    if sMission == nil then
        local date = os.date(" %X")
        listMissionsAmbulancier[source] = {
            id = source, 
            acceptBy = {}, 
            type = type, 
            date = date, 
            positionBackUp = positionBackUp, 
        }
        notifyClientAmbulancier(source, 'CALL_RECU')
        notifyCallStatusAmbulancier(source, CALL_INFO_WAIT)
        notifyAllPersonnelAmbulancier('MISSION_NEW')
        notifyMissionChangeAmbulancier()
    else -- Missions deja en cours
        notifyClientAmbulancier(source, 'CALL_EN_COURS')
    end
end

RegisterServerEvent('ambulancier:setService')
AddEventHandler('ambulancier:setService', function (inService)
    TriggerEvent('es:getPlayerFromId', source, function (Player)
        Player.func.setSessionVar('ambuInService', inService)
    end)
end)

function closeMissionAmbulancier(source, missionId)
    if listMissionsAmbulancier[missionId] ~= nil then
        for _, v in pairs(listMissionsAmbulancier[missionId].acceptBy) do
            if v ~= source then
                notifyPersonnelAmbulancier(v, 'MISSION_ANNULE')
            end
            setInactivePersonnelAmbulancier(v)
        end
        listMissionsAmbulancier[missionId] = nil
        notifyClientAmbulancier(missionId, 'CALL_FINI')
        notifyCallStatusAmbulancier(missionId, CALL_INFO_NONE)
        notifyMissionChangeAmbulancier()
        notifyPersonnelAmbulancierChange()
    end
end

function personelAcceptMissionAmbulancier(source, missionId)
    local sMission = listMissionsAmbulancier[missionId]
    if sMission == nil then
        notifyPersonnelAmbulancier(source, 'MISSION_INCONNU')
    elseif #sMission.acceptBy ~= 0 and not acceptMultiAmbulancier then
        notifyPersonnelAmbulancier(source, 'MISSION_EN_COURS')
    else
        removePersonnelAmbulancier(source)
        if #sMission.acceptBy >= 1 then
            if sMission.acceptBy[1] ~= source then
                for _, m in pairs(sMission.acceptBy) do
                    notifyPersonnelAmbulancier(m, 'MISSION_CONCURENCE')
                end
                table.insert(sMission.acceptBy, source)
            end
        else
            table.insert(sMission.acceptBy, source)
            notifyClientAmbulancier(sMission.id, 'CALL_ACCEPT')
            notifyPersonnelAmbulancier(source, 'MISSION_ACCEPT')
        end
        TriggerClientEvent(preFixEventNameAmbulancier .. ':MissionAccept', source, sMission)
        notifyCallStatusAmbulancier(missionId, CALL_INFO_OK)
        setActivePersonnelAmbulancier(source)
        notifyMissionChangeAmbulancier()
        notifyPersonnelAmbulancierChange()
    end
end

function removePersonnelAmbulancier(personnelId)
    for _, mission in pairs(listMissionsAmbulancier) do
        for k, v in pairs(mission.acceptBy) do
            if v == personnelId then
                table.remove(mission.acceptBy, k)
                if #mission.acceptBy == 0 then
                    notifyClientAmbulancier(mission.id, 'CALL_CANCEL')
                    TriggerClientEvent(preFixEventNameAmbulancier .. ':callStatus', mission.id, 2)
                    notifyCallStatusAmbulancier(mission.id, CALL_INFO_WAIT)
                    notifyAllPersonnelAmbulancier('MISSION_NEW')
                end
                break
            end
        end
    end
    removePersonelServiceAmbulancier(personnelId)
    notifyPersonnelAmbulancierChange()
end

function removeClientAmbulancier(clientId)
    if listMissionsAmbulancier[clientId] ~= nil then
        for _, v in pairs(listMissionsAmbulancier[clientId].acceptBy) do
            notifyPersonnelAmbulancier(v, 'MISSION_ANNULE')
            setInactivePersonnelAmbulancier(v)
        end
        listMissionsAmbulancier[clientId] = nil
        notifyCallStatusAmbulancier(clientId, CALL_INFO_NONE)
        notifyMissionChangeAmbulancier()
        notifyPersonnelAmbulancierChange()
    end
end


--=========================================================================
--  Gestion des personnels en service & activité
--=========================================================================

function addPersonelServiceAmbulancier(source)
    listPersonnelAmbulancierActive[source] = false
end

function removePersonelServiceAmbulancier(source)
    listPersonnelAmbulancierActive[source] = nil
end

function setActivePersonnelAmbulancier(source)
    listPersonnelAmbulancierActive[source] = true
end

function setInactivePersonnelAmbulancier(source)
    listPersonnelAmbulancierActive[source] = false
end

function getNbPersonnelActiveAmbulancier()
    local dispo = 0
    for _, v in pairs(listPersonnelAmbulancierActive) do
        dispo = dispo + 1
    end
    return dispo
end

function getNbPersonnelDispoAmbulancier()
    local dispo = 0
    for _, v in pairs(listPersonnelAmbulancierActive) do
        if v == false then
            dispo = dispo + 1
        end
    end
    return dispo
end

function getNbPersonnelBusyAmbulancier()
    local dispo = 0
    for _, v in pairs(listPersonnelAmbulancierActive) do
        if v == true then
            dispo = dispo + 1
        end
    end
    return dispo
end


RegisterServerEvent(preFixEventNameAmbulancier .. ':takeService')
AddEventHandler(preFixEventNameAmbulancier .. ':takeService', function ()
    addPersonelServiceAmbulancier(source)
    notifyPersonnelAmbulancierChange()
end)

RegisterServerEvent(preFixEventNameAmbulancier .. ':endService')
AddEventHandler(preFixEventNameAmbulancier .. ':endService', function ()
    removePersonnelAmbulancier(source)
    removePersonelServiceAmbulancier(source)
end)

RegisterServerEvent(preFixEventNameAmbulancier .. ':requestMission')
AddEventHandler(preFixEventNameAmbulancier .. ':requestMission', function ()
    notifyMissionChangeAmbulancier(source)
end)

RegisterServerEvent(preFixEventNameAmbulancier .. ':requestPersonnel')
AddEventHandler(preFixEventNameAmbulancier .. ':requestPersonnel', function ()
    notifyPersonnelAmbulancierChange(source)
end)

RegisterServerEvent(preFixEventNameAmbulancier .. ':Call')
AddEventHandler(preFixEventNameAmbulancier .. ':Call', function (type, positionBackUp)
    addMissionAmbulancier(source, type, positionBackUp)
end)

RegisterServerEvent(preFixEventNameAmbulancier .. ':CallCancel')
AddEventHandler(preFixEventNameAmbulancier .. ':CallCancel', function ()
    removeClientAmbulancier(source)
end)

RegisterServerEvent(preFixEventNameAmbulancier .. ':AcceptMission')
AddEventHandler(preFixEventNameAmbulancier .. ':AcceptMission', function (id)
    personelAcceptMissionAmbulancier(source, id)
end)

RegisterServerEvent(preFixEventNameAmbulancier .. ':FinishMission')
AddEventHandler(preFixEventNameAmbulancier .. ':FinishMission', function (id)
    closeMissionAmbulancier(source, id)
end)

RegisterServerEvent(preFixEventNameAmbulancier .. ':cancelCall')
AddEventHandler(preFixEventNameAmbulancier .. ':cancelCall', function ()
    removeClientAmbulancier(source)
end)

AddEventHandler('playerDropped', function()
    removePersonnelAmbulancier(source)
    removeClientAmbulancier(source)
end)

RegisterServerEvent('ambulancier:payRescue')
AddEventHandler('ambulancier:payRescue', function(id)
    TriggerClientEvent("ft_libs:AdvancedNotification", source, {
        icon = "CHAR_CALL911", 
        title = "Urgence", 
        text = "Nous venons de transférer ~o~300~g~$ ~w~pour votre intervention !", 
    })

    local player = tonumber(id)
    TriggerEvent("es:getPlayerFromId", player, function(target)
        target.func.removeMoney(300)
        TriggerClientEvent("ft_libs:AdvancedNotification", target.source, {
            icon = "CHAR_CALL911", 
            title = "Urgence", 
            text = "Votre banque vient de transférer ~o~300~g~$ ~w~pour l'intervention !", 
        })

    end)
end)

RegisterServerEvent('ambulancier:rescueHim')
AddEventHandler('ambulancier:rescueHim', function(id)
    if(source == id)then
        TriggerClientEvent('ambulancier:forceRespawn', source)
    else
        TriggerClientEvent('ambulancier:rescue', listMissionsAmbulancier[id].id)
    end
end)

RegisterServerEvent('ambulancier:needs')
AddEventHandler('ambulancier:needs', function()
    local player = source
    TriggerEvent('gabs:addcustomneeds', player, 50, 50, 50)
end)

RegisterServerEvent('ambulancier:askSelfRespawn')
AddEventHandler('ambulancier:askSelfRespawn', function()
    removeClientAmbulancier(source)
    TriggerClientEvent('ambulancier:forceRespawn', source)
end)

RegisterServerEvent('ambulancier:healHim')
AddEventHandler('ambulancier:healHim', function(idToHeal)
    TriggerClientEvent('ambulancier:HealMe', -1, idToHeal)
end)

RegisterServerEvent('ambulancier:doethylotest')
AddEventHandler('ambulancier:doethylotest', function(idToTest)
    TriggerClientEvent('item:ethylotest', -1, source, idToTest)
end)

RegisterServerEvent('ambulancier:checkIsAmbulancier')
AddEventHandler('ambulancier:checkIsAmbulancier', function()
    --print(source)
    TriggerEvent("es:getPlayerFromId", source, function(user)
        local identifier = user.identifier
        --print(identifier)
        checkIsAmbulancier(identifier, user.source)
    end)
end)

RegisterServerEvent('ambulancier:setDead')
AddEventHandler('ambulancier:setDead', function(deadOrAlive)
    TriggerEvent("es:getPlayerFromId", source, function(user)
        local identifier = user.identifier
        print("Mort : " .. deadOrAlive)
        MySQL.Async.execute('UPDATE users SET player_dead = @statut WHERE identifier = @identifier', {['@statut'] = deadOrAlive, ['@identifier'] = identifier})
    end)
end)

RegisterServerEvent('ambulancier:checkDead')
AddEventHandler('ambulancier:checkDead', function()
    TriggerEvent("es:getPlayerFromId", source, function(user)
        local identifier = user.identifier
        MySQL.Async.fetchAll("SELECT player_dead FROM users WHERE identifier = @identifier", {['@identifier'] = identifier}, function(result)
            if (result[1].player_dead == 1) then
                TriggerClientEvent('ambulancier:killIt', user.source)
            end
        end)
    end)
end)

function checkIsAmbulancier(identifier, source)
    --[[local result = MySQL.Sync.fetchAll('SELECT job FROM users WHERE identifier = @identifier', { ['@identifier'] = identifier})
--print("TOTO")
--print('----Result' .. result[1].rank .. '----')
if(result[1].job ~= 15) then
TriggerClientEvent('ambulancier:receiveIsAmbulancier', source, '0')
else
TriggerClientEvent('ambulancier:receiveIsAmbulancier', source, '1')
end ]]--
    --
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if(user.jobId ~= 15) then
            TriggerClientEvent('ambulancier:receiveIsAmbulancier', source, '0')
        else
            TriggerClientEvent('ambulancier:receiveIsAmbulancier', source, '1')
        end
    end)
end

function s_checkIsAmbulancier(identifier)
    --[[local result = MySQL.Sync.fetchAll('SELECT job FROM users WHERE identifier = @identifier', { ['@identifier'] = identifier})
if(result[1].job ~= 15) then
return false
else
return true
end]]--
    --
    local isAmbulancier = false
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if(user.jobId == 15) then
            isAmbulancier = true
        end
    end)
    if(isAmbulancier) then
        return true
    else
        return false
    end
end
