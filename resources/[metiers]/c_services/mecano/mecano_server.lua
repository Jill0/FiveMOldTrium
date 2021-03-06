local listMissions = {}
local listPersonnelActive = {}
local acceptMulti = false
local preFixEventName = 'mecano'
local CALL_INFO_WAIT = 2 
local CALL_INFO_OK = 1
local CALL_INFO_NONE = 0

-- Notifyle changement de status des missions
function notifyMissionChange(target)
    target = target or -1
    TriggerClientEvent(preFixEventName .. ':MissionChange', target, listMissions)
end

function notifyMissionCancel(source)
    TriggerClientEvent(preFixEventName .. ':MissionCancel', source)
end

-- Notify le changement de status des missions
function notifyPersonnelChange(target)
    target = target or -1
    TriggerClientEvent(preFixEventName .. ':personnelChange', target,  getNbPerosnnelActive(), getNbPerosnnelDispo())
end

-- Notify un message a tout les personnels
function notifyAllPersonnel(MESS)
    TriggerClientEvent(preFixEventName .. ':PersonnelMessage', -1, MESS)
end

-- Notify un message un personnel
function notifyPersonnel(source, MESS)
    TriggerClientEvent(preFixEventName .. ':PersonnelMessage', source, MESS)
end

-- Notify un message un client
function notifyClient(source, MESS)
    TriggerClientEvent(preFixEventName .. ':ClientMessage', source, MESS)
end

-- Not use || Notify a message a tout le monde
function notifyAllClient(MESS)
    TriggerClientEvent(preFixEventName .. ':ClientMessage', -1 , MESS)
end

-- Notify call status change
function notifyCallStatus(source, status)
    TriggerClientEvent(preFixEventName .. ':callStatus', source, status)
end

RegisterServerEvent('mecano:setService')
AddEventHandler('mecano:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
    	Player.func.setSessionVar('mecaInService', inService)
	end)
end)

function addMission(source, position, type)
    local sMission = listMissions[source]
    if sMission == nil then
        listMissions[source] = {
            id = source,
            pos = position,
            acceptBy = {},
            type = type
        }
        notifyClient(source, 'CALL_RECU')
        notifyCallStatus(source, CALL_INFO_WAIT)
        notifyAllPersonnel('MISSION_NEW')
        notifyMissionChange()
    else -- Missions deja en cours
        notifyClient(source, 'CALL_EN_COURS')
    end
end

function closeMission(source, missionId)
    if listMissions[missionId] ~= nil then
        for _, v in pairs(listMissions[missionId].acceptBy) do 
            if v ~= source then
                notifyPersonnel(v, 'MISSION_ANNULE')
                notifyMissionCancel(v)
            end
            setInactivePersonnel(v)
        end
        listMissions[missionId] = nil
        notifyClient(missionId, 'CALL_FINI')
        notifyCallStatus(missionId, CALL_INFO_NONE)
        notifyMissionChange()
        notifyPersonnelChange()
    end
end

function personelAcceptMission(source, missionId)
    local sMission = listMissions[missionId]
    if sMission == nil then
        notifyPersonnel(source,'MISSION_INCONNU')
    elseif #sMission.acceptBy ~= 0  and not acceptMulti then 
        notifyPersonnel(source, 'MISSION_EN_COURS')
    else
        removeMeccano(source)
        if #sMission.acceptBy >= 1 then
            if sMission.acceptBy[1] ~= source then
                for _, m in pairs(sMission.acceptBy) do
                    notifyPersonnel(m, 'MISSION_CONCURENCE')
                end
                table.insert(sMission.acceptBy, source)
            end
        else
            table.insert(sMission.acceptBy, source)
            notifyClient(sMission.id, 'CALL_ACCEPT')
            notifyPersonnel(source, 'MISSION_ACCEPT')
        end
        TriggerClientEvent(preFixEventName .. ':MissionAccept', source, sMission)
        notifyCallStatus(missionId, CALL_INFO_OK)
        setActivePersonnel(source)
        notifyMissionChange()
        notifyPersonnelChange()
    end
end

function removeMeccano(personnelId)
    for _, mission in pairs(listMissions) do 
        for k, v in pairs(mission.acceptBy) do 
            if v == personnelId then
                table.remove(mission.acceptBy, k)
                if #mission.acceptBy == 0 then
                    notifyClient(mission.id, 'CALL_CANCEL')
                    TriggerClientEvent(preFixEventName .. ':callStatus', mission.id, 2)
                    notifyCallStatus(mission.id, CALL_INFO_WAIT)
                    notifyAllPersonnel('MISSION_NEW')
                end
                break
            end
        end
    end
    removePersonelService(personnelId)
    notifyPersonnelChange()
end

function removeClient(clientId)
    if listMissions[clientId] ~= nil then
        for _, v in pairs(listMissions[clientId].acceptBy) do 
            notifyPersonnel(v, 'MISSION_ANNULE')
            notifyMissionCancel(v)
            setInactivePersonnel(v)
        end
        listMissions[clientId] = nil
        notifyCallStatus(clientId, CALL_INFO_NONE)
        notifyMissionChange()
        notifyPersonnelChange()
    end
end


--=========================================================================
--  Gestion des personnels en service & activité
--=========================================================================

function addPersonelService(source)
    listPersonnelActive[source] = false
end

function removePersonelService(source)
    listPersonnelActive[source] = nil
end

function setActivePersonnel(source)
    listPersonnelActive[source] = true
end

function setInactivePersonnel(source)
   listPersonnelActive[source] = false
end

function getNbPerosnnelActive()
    local dispo = 0
    for _, v in pairs(listPersonnelActive) do 
        dispo = dispo + 1
    end
    return dispo
end

function getNbPerosnnelDispo()
    local dispo = 0
    for _, v in pairs(listPersonnelActive) do 
        if v == false then
            dispo = dispo + 1
        end
    end
    return dispo
end

function getNbPerosnnelBusy()
    local dispo = 0
    for _, v in pairs(listPersonnelActive) do 
        if v == true then
            dispo = dispo + 1
        end
    end
    return dispo
end

RegisterServerEvent(preFixEventName .. ':takeService')
AddEventHandler(preFixEventName .. ':takeService', function ()
    addPersonelService(source)
    notifyPersonnelChange()
end)

RegisterServerEvent(preFixEventName .. ':endService')
AddEventHandler(preFixEventName .. ':endService', function ()
    removeMeccano(source)
    removePersonelService(source)
end)

RegisterServerEvent(preFixEventName .. ':requestMission')
AddEventHandler(preFixEventName .. ':requestMission', function ()
    notifyMissionChange(source)
end)

RegisterServerEvent(preFixEventName .. ':requestPersonnel')
AddEventHandler(preFixEventName .. ':requestPersonnel', function ()
    notifyPersonnelChange(source)
end)

RegisterServerEvent(preFixEventName .. ':Call')
AddEventHandler(preFixEventName .. ':Call', function (posX,posY,posZ,type)
    addMission(source, {posX, posY, posZ}, type)
end)

RegisterServerEvent(preFixEventName .. ':CallCancel')
AddEventHandler(preFixEventName .. ':CallCancel', function ()
    removeClient(source)
end)

RegisterServerEvent(preFixEventName .. ':AcceptMission')
AddEventHandler(preFixEventName .. ':AcceptMission', function (id)
    personelAcceptMission(source, id)
end)

RegisterServerEvent(preFixEventName .. ':FinishMission')
AddEventHandler(preFixEventName .. ':FinishMission', function (id)
    closeMission(source, id)
end)

RegisterServerEvent(preFixEventName .. ':cancelCall')
AddEventHandler(preFixEventName .. ':cancelCall', function ()
    removeClient(source)
end)

AddEventHandler('playerDropped', function()
    removeMeccano(source)
    removeClient(source)
end)

RegisterServerEvent('mecano:checkIsMecano')
AddEventHandler('mecano:checkIsMecano', function()
    --print(source)
	TriggerEvent("es:getPlayerFromId", source, function(user)
	   local identifier = user.identifier
		--print(identifier)
		checkIsMecano(identifier, user.source)
	end)
end)

RegisterServerEvent('mecano:buyrepairkit')
AddEventHandler('mecano:buyrepairkit', function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
	    local identifier = user.identifier
	    local result = MySQL.Sync.fetchAll('SELECT leader FROM users WHERE identifier = @identifier AND job=16', { ['@identifier'] = identifier})
	    if(result[1].leader == 1) then
            MySQL.Async.execute('UPDATE entreprises_coffres SET solde = solde - 5000 WHERE job_id = 16')
            TriggerClientEvent('mecano:repairkitbuy',user.source)
        end
    end)
end)

RegisterServerEvent('mecano:checkplate')
AddEventHandler('mecano:checkplate', function(plate)
	local result = MySQL.Sync.fetchAll('SELECT vehicle_model, vehicle_plate, identifier  FROM user_vehicle WHERE vehicle_plate = @name', {['@name'] = tostring(plate)})
	if (#result > 0) then
	  local result1 = MySQL.Sync.fetchAll('SELECT prenom, nom, phone_number FROM users WHERE identifier = @name', {['@name'] = tostring(result[1].identifier)})
	  if (#result1  > 0) then
		local vehitems = {}
		vehitems = {plate=result[1].vehicle_plate, model=result[1].vehicle_model , name=tostring(result1[1].prenom..' '..result1[1].nom), num = result1[1].phone_number}
		TriggerClientEvent('notify:car2', source, vehitems)
	  end
	else
        TriggerClientEvent('notify:car2', source,{name='Véhicule volé'})
	end
end)

function checkIsMecano(identifier, source)
  --[[local result = MySQL.Sync.fetchAll('SELECT job FROM users WHERE identifier = @identifier', { ['@identifier'] = identifier})
  --print("TOTO")
  --print('----Result' .. result[1].rank .. '----')
  if(result[1].job ~= 16) then
	TriggerClientEvent('mecano:receiveIsMecano', source, '0')
	TriggerClientEvent('lscustoms:receiveIsMecano', source, '0')
  else
	TriggerClientEvent('mecano:receiveIsMecano', source, '1')
	TriggerClientEvent('lscustoms:receiveIsMecano', source, '1')
  end]]--
  TriggerEvent("es:getPlayerFromId", source, function(user)
        if(user.jobId ~= 16) then
            TriggerClientEvent('mecano:receiveIsMecano', source, '0')
            TriggerClientEvent('lscustoms:receiveIsMecano', source, '0')
        else
            TriggerClientEvent('mecano:receiveIsMecano', source, '1')
            TriggerClientEvent('lscustoms:receiveIsMecano', source, '1')
        end
    end)
end

function s_checkIsMecano(identifier)
  local isMecano = false
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if(user.jobId == 16) then
            isMecano = true
        end
    end)
    if(isMecano) then
        return true
    else
        return false
    end
end
