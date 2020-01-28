local listMissionsGouverneur = {}
local listPersonnelGouverneurActive = {}
local acceptMultiGouverneur = false
local preFixEventNameGouverneur = 'Gouverneur'
local CALL_INFO_WAIT = 2 
local CALL_INFO_OK = 1
local CALL_INFO_NONE = 0

RegisterServerEvent('parkingMenuOpen')	
AddEventHandler('parkingMenuOpen', function()
	parkingMenu:Open()
end)

-- Notifyle changement de status des missions
function notifyMissionChangeGouverneur(target)
	target = target or -1
	TriggerClientEvent(preFixEventNameGouverneur .. ':MissionChange', target, listMissionsGouverneur)
end

-- Notify le changement de status des missions
function notifyPersonnelGouverneurChange(target)
	target = target or -1
	TriggerClientEvent(preFixEventNameGouverneur .. ':personnelChange', target,  getNbPersonnelActiveGouverneur(), getNbPersonnelDispoGouverneur())
end

-- Notify un message a tout les personnels
function notifyAllPersonnelGouverneur(MESS)
	TriggerClientEvent(preFixEventNameGouverneur .. ':PersonnelMessage', -1, MESS)
end

-- Notify un message un personnel
function notifyPersonnelGouverneur(source, MESS)
	TriggerClientEvent(preFixEventNameGouverneur .. ':PersonnelMessage', source, MESS)
end

-- Notify un message un client
function notifyClientGouverneur(source, MESS)
	TriggerClientEvent(preFixEventNameGouverneur .. ':ClientMessage', source, MESS)
end

-- Not use || Notify a message a tout le monde
function notifyAllClientGouverneur(MESS)
	TriggerClientEvent(preFixEventNameGouverneur .. ':ClientMessage', -1 , MESS)
end

-- Notify call status change
function notifyCallStatusGouverneur(source, status)
	TriggerClientEvent(preFixEventNameGouverneur .. ':callStatus', source, status)
end

function addMissionGouverneur(source, type, positionBackUp)
	local sMission = listMissionsGouverneur[source]
	if sMission == nil then
		local date=os.date(" %X")
		listMissionsGouverneur[source] = {
			id = source,
			acceptBy = {},
			type = type,
			date = date,
			positionBackUp = positionBackUp,
		}
		notifyClientGouverneur(source, 'Confirmation\nVotre appel à été enregistré')
		notifyCallStatusGouverneur(source, CALL_INFO_WAIT)
		notifyAllPersonnelGouverneur('Un nouvel appel a été signalé, il est ajouté dans votre liste de missions')
		notifyMissionChangeGouverneur()
	else -- Missions deja en cours
		notifyClientGouverneur(source, 'Vous avez déjà une demande en cours ...')
	end
end

RegisterServerEvent('Gouverneur:setService')
AddEventHandler('Gouverneur:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
		Player.func.setSessionVar('gouvInService', inService)
	end)
end)

function closeMissionGouverneur(source, missionId)
	if listMissionsGouverneur[missionId] ~= nil then
		for _, v in pairs(listMissionsGouverneur[missionId].acceptBy) do 
			if v ~= source then
				notifyPersonnelGouverneur(v, 'L\'appel a été annulé')
			end
			setInactivePersonnelGouverneur(v)
		end
		listMissionsGouverneur[missionId] = nil
		notifyClientGouverneur(missionId, 'Votre appel a été résolu')
		notifyCallStatusGouverneur(missionId, CALL_INFO_NONE)
		notifyMissionChangeGouverneur()
		notifyPersonnelGouverneurChange()
	end
end

function personelAcceptMissionGouverneur(source, missionId)
	local sMission = listMissionsGouverneur[missionId]
	if sMission == nil then
		notifyPersonnelGouverneur(source,'Cette mission n\'est plus d\'actualité')
	elseif #sMission.acceptBy ~= 0  and not acceptMultiGouverneur then 
		notifyPersonnelGouverneur(source, 'Cette mission est déjà en cours de traitement')
	else
		removePersonnelGouverneur(source)
		if #sMission.acceptBy >= 1 then
			if sMission.acceptBy[1] ~= source then
				for _, m in pairs(sMission.acceptBy) do
					notifyPersonnelGouverneur(m, 'Vous étes plusieurs sur le coup')
				end
				table.insert(sMission.acceptBy, source)
			end
		else
			table.insert(sMission.acceptBy, source)
			notifyClientGouverneur(sMission.id, 'Votre appel a été accepté, un Gouverneur est en route')
			notifyPersonnelGouverneur(source, 'Mission acceptée, mettez vous en route')
		end
		TriggerClientEvent(preFixEventNameGouverneur .. ':MissionAccept', source, sMission)
		notifyCallStatusGouverneur(missionId, CALL_INFO_OK)
		setActivePersonnelGouverneur(source)
		notifyMissionChangeGouverneur()
		notifyPersonnelGouverneurChange()
	end
end

function removePersonnelGouverneur(personnelId)
	for _, mission in pairs(listMissionsGouverneur) do 
		for k, v in pairs(mission.acceptBy) do 
			if v == personnelId then
				table.remove(mission.acceptBy, k)
				if #mission.acceptBy == 0 then
					notifyClientGouverneur(mission.id, 'Le Gouverneur vient d\'abandonné votre appel')
					TriggerClientEvent(preFixEventNameGouverneur .. ':callStatus', mission.id, 2)
					notifyCallStatusGouverneur(mission.id, CALL_INFO_WAIT)
					notifyAllPersonnelGouverneur('Un nouvel appel a été signalé, il est ajouté dans votre liste de missions')
				end
				break
			end
		end
	end
	removePersonelServiceGouverneur(personnelId)
	notifyPersonnelGouverneurChange()
end

function removeClientGouverneur(clientId)
	if listMissionsGouverneur[clientId] ~= nil then
		for _, v in pairs(listMissionsGouverneur[clientId].acceptBy) do 
			notifyPersonnelGouverneur(v, 'L\'appel a été annulé')
			setInactivePersonnelGouverneur(v)
		end
		listMissionsGouverneur[clientId] = nil
		notifyCallStatusGouverneur(clientId, CALL_INFO_NONE)
		notifyMissionChangeGouverneur()
		notifyPersonnelGouverneurChange()
	end
end


--=========================================================================
--  Gestion des personnels en service & activité
--=========================================================================

function addPersonelServiceGouverneur(source)
	listPersonnelGouverneurActive[source] = false
end

function removePersonelServiceGouverneur(source)
	listPersonnelGouverneurActive[source] = nil
end

function setActivePersonnelGouverneur(source)
	listPersonnelGouverneurActive[source] = true    
end

function setInactivePersonnelGouverneur(source)
	listPersonnelGouverneurActive[source] = false
end

function getNbPersonnelActiveGouverneur()
	local dispo = 0
	for _, v in pairs(listPersonnelGouverneurActive) do 
		dispo = dispo + 1
	end
	return dispo
end

function getNbPersonnelDispoGouverneur()
	local dispo = 0
	for _, v in pairs(listPersonnelGouverneurActive) do 
		if v == false then
			dispo = dispo + 1
		end
	end
	return dispo
end

function getNbPersonnelBusyGouverneur()
	local dispo = 0
	for _, v in pairs(listPersonnelGouverneurActive) do 
		if v == true then
			dispo = dispo + 1
		end
	end
	return dispo
end

RegisterServerEvent(preFixEventNameGouverneur .. ':takeService')
AddEventHandler(preFixEventNameGouverneur .. ':takeService', function ()
	addPersonelServiceGouverneur(source)
	notifyPersonnelGouverneurChange()
end)

RegisterServerEvent(preFixEventNameGouverneur .. ':endService')
AddEventHandler(preFixEventNameGouverneur .. ':endService', function ()
	removePersonnelGouverneur(source)
	removePersonelServiceGouverneur(source)
end)

RegisterServerEvent(preFixEventNameGouverneur .. ':requestMission')
AddEventHandler(preFixEventNameGouverneur .. ':requestMission', function ()
	notifyMissionChangeGouverneur(source)
end)

RegisterServerEvent(preFixEventNameGouverneur .. ':requestPersonnel')
AddEventHandler(preFixEventNameGouverneur .. ':requestPersonnel', function ()
	notifyPersonnelGouverneurChange(source)
end)

RegisterServerEvent(preFixEventNameGouverneur .. ':Call')
AddEventHandler(preFixEventNameGouverneur .. ':Call', function (type, positionBackUp)
	addMissionGouverneur(source, type, positionBackUp)
end)

RegisterServerEvent(preFixEventNameGouverneur .. ':CallCancel')
AddEventHandler(preFixEventNameGouverneur .. ':CallCancel', function ()
	removeClientGouverneur(source)
end)

RegisterServerEvent(preFixEventNameGouverneur .. ':AcceptMission')
AddEventHandler(preFixEventNameGouverneur .. ':AcceptMission', function (id)
	personelAcceptMissionGouverneur(source, id)
end)

RegisterServerEvent(preFixEventNameGouverneur .. ':FinishMission')
AddEventHandler(preFixEventNameGouverneur .. ':FinishMission', function (id)
	closeMissionGouverneur(source, id)
end)

RegisterServerEvent(preFixEventNameGouverneur .. ':cancelCall')
AddEventHandler(preFixEventNameGouverneur .. ':cancelCall', function ()
        removeClientGouverneur(source)
end)

AddEventHandler('playerDropped', function()
	removePersonnelGouverneur(source)
	removeClientGouverneur(source)
end)

RegisterServerEvent('Gouverneur:checkIsGouverneur')
AddEventHandler('Gouverneur:checkIsGouverneur', function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		if user.jobId == 23 then
			TriggerClientEvent('Gouverneur:receiveIsGouverneur', source, '1')
		else
			TriggerClientEvent('Gouverneur:receiveIsGouverneur', source, '0')
		end
	end)
end)
