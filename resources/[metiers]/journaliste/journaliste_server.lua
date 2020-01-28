local listMissionsJournaliste = {}
local listPersonnelJournalisteActive = {}
local acceptMultiJournaliste = false
local preFixEventNameJournaliste = 'journaliste'
local CALL_INFO_WAIT = 2 
local CALL_INFO_OK = 1
local CALL_INFO_NONE = 0

RegisterServerEvent('parkingMenuOpen')	
AddEventHandler('parkingMenuOpen', function()
	parkingMenu:Open()
end)

-- Notifyle changement de status des missions
function notifyMissionChangeJournaliste(target)
	target = target or -1
	TriggerClientEvent(preFixEventNameJournaliste .. ':MissionChange', target, listMissionsJournaliste)
end

-- Notify le changement de status des missions
function notifyPersonnelJournalisteChange(target)
	target = target or -1
	TriggerClientEvent(preFixEventNameJournaliste .. ':personnelChange', target,  getNbPersonnelActiveJournaliste(), getNbPersonnelDispoJournaliste())
end

-- Notify un message a tout les personnels
function notifyAllPersonnelJournaliste(MESS)
	TriggerClientEvent(preFixEventNameJournaliste .. ':PersonnelMessage', -1, MESS)
end

-- Notify un message un personnel
function notifyPersonnelJournaliste(source, MESS)
	TriggerClientEvent(preFixEventNameJournaliste .. ':PersonnelMessage', source, MESS)
end

-- Notify un message un client
function notifyClientJournaliste(source, MESS)
	TriggerClientEvent(preFixEventNameJournaliste .. ':ClientMessage', source, MESS)
end

-- Not use || Notify a message a tout le monde
function notifyAllClientJournaliste(MESS)
	TriggerClientEvent(preFixEventNameJournaliste .. ':ClientMessage', -1 , MESS)
end

-- Notify call status change
function notifyCallStatusJournaliste(source, status)
	TriggerClientEvent(preFixEventNameJournaliste .. ':callStatus', source, status)
end

function addMissionJournaliste(source, type, positionBackUp)
	local sMission = listMissionsJournaliste[source]
	if sMission == nil then
		local date=os.date(" %X")
		listMissionsJournaliste[source] = {
			id = source,
			acceptBy = {},
			type = type,
			date = date,
			positionBackUp = positionBackUp,
		}
		notifyClientJournaliste(source, 'Confirmation\nVotre appel à été enregistré')
		notifyCallStatusJournaliste(source, CALL_INFO_WAIT)
		notifyAllPersonnelJournaliste('Un nouvel appel a été signalé, il est ajouté dans votre liste de missions')
		notifyMissionChangeJournaliste()
	else -- Missions deja en cours
		notifyClientJournaliste(source, 'Vous avez déjà une demande en cours ...')
	end
end

RegisterServerEvent('journaliste:setService')
AddEventHandler('journaliste:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
		Player.func.setSessionVar('jourInService', inService)
	end)
end)

function closeMissionJournaliste(source, missionId)
	if listMissionsJournaliste[missionId] ~= nil then
		for _, v in pairs(listMissionsJournaliste[missionId].acceptBy) do 
			if v ~= source then
				notifyPersonnelJournaliste(v, 'L\'appel a été annulé')
			end
			setInactivePersonnelJournaliste(v)
		end
		listMissionsJournaliste[missionId] = nil
		notifyClientJournaliste(missionId, 'Votre appel a été résolu')
		notifyCallStatusJournaliste(missionId, CALL_INFO_NONE)
		notifyMissionChangeJournaliste()
		notifyPersonnelJournalisteChange()
	end
end

function personelAcceptMissionJournaliste(source, missionId)
	local sMission = listMissionsJournaliste[missionId]
	if sMission == nil then
		notifyPersonnelJournaliste(source,'Cette mission n\'est plus d\'actualité')
	elseif #sMission.acceptBy ~= 0  and not acceptMultiJournaliste then 
		notifyPersonnelJournaliste(source, 'Cette mission est déjà en cours de traitement')
	else
		removePersonnelJournaliste(source)
		if #sMission.acceptBy >= 1 then
			if sMission.acceptBy[1] ~= source then
				for _, m in pairs(sMission.acceptBy) do
					notifyPersonnelJournaliste(m, 'Vous étes plusieurs sur le coup')
				end
				table.insert(sMission.acceptBy, source)
			end
		else
			table.insert(sMission.acceptBy, source)
			notifyClientJournaliste(sMission.id, 'Votre appel a été accepté, un journaliste est en route')
			notifyPersonnelJournaliste(source, 'Mission acceptée, mettez vous en route')
		end
		TriggerClientEvent(preFixEventNameJournaliste .. ':MissionAccept', source, sMission)
		notifyCallStatusJournaliste(missionId, CALL_INFO_OK)
		setActivePersonnelJournaliste(source)
		notifyMissionChangeJournaliste()
		notifyPersonnelJournalisteChange()
	end
end

function removePersonnelJournaliste(personnelId)
	for _, mission in pairs(listMissionsJournaliste) do 
		for k, v in pairs(mission.acceptBy) do 
			if v == personnelId then
				table.remove(mission.acceptBy, k)
				if #mission.acceptBy == 0 then
					notifyClientJournaliste(mission.id, 'Le journaliste vient d\'abandonné votre appel')
					TriggerClientEvent(preFixEventNameJournaliste .. ':callStatus', mission.id, 2)
					notifyCallStatusJournaliste(mission.id, CALL_INFO_WAIT)
					notifyAllPersonnelJournaliste('Un nouvel appel a été signalé, il est ajouté dans votre liste de missions')
				end
				break
			end
		end
	end
	removePersonelServiceJournaliste(personnelId)
	notifyPersonnelJournalisteChange()
end

function removeClientJournaliste(clientId)
	if listMissionsJournaliste[clientId] ~= nil then
		for _, v in pairs(listMissionsJournaliste[clientId].acceptBy) do 
			notifyPersonnelJournaliste(v, 'L\'appel a été annulé')
			setInactivePersonnelJournaliste(v)
		end
		listMissionsJournaliste[clientId] = nil
		notifyCallStatusJournaliste(clientId, CALL_INFO_NONE)
		notifyMissionChangeJournaliste()
		notifyPersonnelJournalisteChange()
	end
end


--=========================================================================
--  Gestion des personnels en service & activité
--=========================================================================

function addPersonelServiceJournaliste(source)
	listPersonnelJournalisteActive[source] = false
end

function removePersonelServiceJournaliste(source)
	listPersonnelJournalisteActive[source] = nil
end

function setActivePersonnelJournaliste(source)
	listPersonnelJournalisteActive[source] = true    
end

function setInactivePersonnelJournaliste(source)
	listPersonnelJournalisteActive[source] = false
end

function getNbPersonnelActiveJournaliste()
	local dispo = 0
	for _, v in pairs(listPersonnelJournalisteActive) do 
		dispo = dispo + 1
	end
	return dispo
end

function getNbPersonnelDispoJournaliste()
	local dispo = 0
	for _, v in pairs(listPersonnelJournalisteActive) do 
		if v == false then
			dispo = dispo + 1
		end
	end
	return dispo
end

function getNbPersonnelBusyJournaliste()
	local dispo = 0
	for _, v in pairs(listPersonnelJournalisteActive) do 
		if v == true then
			dispo = dispo + 1
		end
	end
	return dispo
end


RegisterServerEvent(preFixEventNameJournaliste .. ':takeService')
AddEventHandler(preFixEventNameJournaliste .. ':takeService', function ()
	addPersonelServiceJournaliste(source)
	notifyPersonnelJournalisteChange()
end)

RegisterServerEvent(preFixEventNameJournaliste .. ':endService')
AddEventHandler(preFixEventNameJournaliste .. ':endService', function ()
	removePersonnelJournaliste(source)
	removePersonelServiceJournaliste(source)
end)

RegisterServerEvent(preFixEventNameJournaliste .. ':requestMission')
AddEventHandler(preFixEventNameJournaliste .. ':requestMission', function ()
	notifyMissionChangeJournaliste(source)
end)

RegisterServerEvent(preFixEventNameJournaliste .. ':requestPersonnel')
AddEventHandler(preFixEventNameJournaliste .. ':requestPersonnel', function ()
	notifyPersonnelJournalisteChange(source)
end)

RegisterServerEvent(preFixEventNameJournaliste .. ':Call')
AddEventHandler(preFixEventNameJournaliste .. ':Call', function (type, positionBackUp)
	addMissionJournaliste(source, type, positionBackUp)
end)

RegisterServerEvent(preFixEventNameJournaliste .. ':CallCancel')
AddEventHandler(preFixEventNameJournaliste .. ':CallCancel', function ()
	removeClientJournaliste(source)
end)

RegisterServerEvent(preFixEventNameJournaliste .. ':AcceptMission')
AddEventHandler(preFixEventNameJournaliste .. ':AcceptMission', function (id)
	personelAcceptMissionJournaliste(source, id)
end)

RegisterServerEvent(preFixEventNameJournaliste .. ':FinishMission')
AddEventHandler(preFixEventNameJournaliste .. ':FinishMission', function (id)
	closeMissionJournaliste(source, id)
end)

RegisterServerEvent(preFixEventNameJournaliste .. ':cancelCall')
AddEventHandler(preFixEventNameJournaliste .. ':cancelCall', function ()
        removeClientJournaliste(source)
end)

AddEventHandler('playerDropped', function()
	removePersonnelJournaliste(source)
	removeClientJournaliste(source)
end)

RegisterServerEvent('journaliste:checkIsJournaliste')
AddEventHandler('journaliste:checkIsJournaliste', function()
	TriggerEvent("es:getPlayerFromId", source, function(user)
		if user.jobId == 19 then
			TriggerClientEvent('journaliste:receiveIsJournaliste', source, '1')
		else
			TriggerClientEvent('journaliste:receiveIsJournaliste', source, '0')
		end
	end)
end)
