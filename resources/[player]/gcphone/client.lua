--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================
local handCuffed = false
-- Configuration
local KeyToucheCloseEvent = {
  { code = 172, event = 'ArrowUp' },
  { code = 173, event = 'ArrowDown' },
  { code = 174, event = 'ArrowLeft' },
  { code = 175, event = 'ArrowRight' },
  { code = 176, event = 'Enter' },
  { code = 177, event = 'Backspace' }
}
local KeyOpenClose = 289
local menuIsOpen = false
local contacts = {}
local messages = {}
local myPhoneNumber = ''
local isDead = false
local isJournaliste = false
--====================================================================================
--  
--====================================================================================
 
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsEntityDead(GetPlayerPed(-1))then
      if menuIsOpen == false then
        TooglePhone()
      end
    end
    if IsControlJustPressed(1, KeyOpenClose) and handCuffed == false then
      TooglePhone()
    end
    if menuIsOpen == true then
      DeadCheck()
      for _, value in ipairs(KeyToucheCloseEvent) do
        if IsControlJustPressed(1, value.code) then
          SendNUIMessage({keyUp = value.event})
        end
      end
    end
  end
end)
 
function DeadCheck() 
  local dead = IsEntityDead(GetPlayerPed(-1))
  if dead ~= isDead then 
    isDead = dead
    SendNUIMessage({event = 'updateDead', isDead = isDead})
  end
end

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end
--====================================================================================
--  Events
--====================================================================================
RegisterNetEvent("gcPhone:handCuffed")
AddEventHandler("gcPhone:handCuffed", function(bool)
	handCuffed = bool
end)

RegisterNetEvent("gcPhone:myPhoneNumber")
AddEventHandler("gcPhone:myPhoneNumber", function(_myPhoneNumber)
  myPhoneNumber = tostring(_myPhoneNumber)
  SendNUIMessage({event = 'updateYyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)

RegisterNetEvent("gcPhone:contactList")
AddEventHandler("gcPhone:contactList", function(_contacts)
  SendNUIMessage({event = 'updateContacts', contacts = _contacts})
  contacts = _contacts
end)

RegisterNetEvent("gcPhone:allMessage")
AddEventHandler("gcPhone:allMessage", function(_messages)
  SendNUIMessage({event = 'updateMessages', messages = _messages})
  messages = _messages
end)

RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage", function(message)
  table.insert(messages, message)
  SendNUIMessage({event = 'updateMessages', messages = messages})
--  Citizen.Trace('sendMessage: ' .. json.encode(messages))
  if message.owner == 0 then
    local mess = ""
	local susp = ""
	if string.len(message.message) >= 55 then
		susp = "..."
		for i = 1, 55 do
			if i==1 then
				mess = string.sub(message.message, i, i)
			else
				mess = mess .. string.sub(message.message, i, i)
			end
		end
	else
		mess = message.message
	end
    Notify('~o~Nouveau message~n~~s~' .. mess .. susp)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    Citizen.Wait(300)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
  end
end)

RegisterNetEvent("gcPhone:newArticle")
AddEventHandler("gcPhone:newArticle", function(titre)
	local mess = ""
	local susp = ""
	if string.len(titre) >= 55 then
		susp = "..."
		for i = 1, 55 do
			if i==1 then
				mess = string.sub(titre, i, i)
			else
				mess = mess .. string.sub(titre, i, i)
			end
		end
	else
		mess = titre
	end
    Notify('~r~Weazle News~n~~s~' .. mess .. susp)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
end)

RegisterNetEvent("gcPhone:allArticle")
AddEventHandler("gcPhone:allArticle", function(_articles, _puce)
    SendNUIMessage({event = 'updateArticles', articles = _articles})
end)

RegisterNetEvent("gcPhone:getsolde")
AddEventHandler("gcPhone:getsolde", function(_solde)
  SendNUIMessage({event = 'updateBank', solde = _solde})
end)

RegisterNetEvent("gcPhone:getnumcompte")
AddEventHandler("gcPhone:getnumcompte", function(_numcompte)
  SendNUIMessage({event = 'updateNumCompte', numcompte = tostring(_numcompte)})
end)

RegisterNetEvent("gcPhone:checkJournaliste")
AddEventHandler("gcPhone:checkJournaliste", function(checkJournaliste)
  if checkJournaliste then
    isJournaliste = checkJournaliste
  end
end)

--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num) 
  TriggerServerEvent('gcPhone:addContact', display, num)
end

function deleteContact(num) 
  TriggerServerEvent('gcPhone:deleteContact', num)
end
--====================================================================================
--  Function client | Articles
--====================================================================================
function sendArticle(titre, article)
  TriggerServerEvent('gcPhone:sendArticle', titre, article)
end

function deleteArticle(artId)
  TriggerServerEvent('gcPhone:deleteArticle', artId)
end

function modifyArticle(artId, artTitre, artArticle)
  TriggerServerEvent('gcPhone:modifyArticle', artId, artTitre, artArticle)
end
--====================================================================================
--  Function client | Messages
--====================================================================================
function sendMessage(num, message)
  TriggerServerEvent('gcPhone:sendMessage', num, message)
end

function deleteMessage(msgId)
  TriggerServerEvent('gcPhone:deleteMessage', msgId)
  for k, v in ipairs(messages) do 
    if v.id == msgId then
      table.remove(messages, k)
      SendNUIMessage({event = 'updateMessages', messages = messages})
      return
    end
  end
end

function deleteMessageContact(num)
  TriggerServerEvent('gcPhone:deleteMessageNumber', num)
end

function deleteAllMessage()
  TriggerServerEvent('gcPhone:deleteAllMessage')
end

function setReadMessageNumber(num)
  TriggerServerEvent('gcPhone:setReadMessageNumber', num)
  for k, v in ipairs(messages) do 
    if v.transmitter == num then
      v.isRead = true
    end
  end
end

function requestAllMessages()
  TriggerServerEvent('gcPhone:requestAllMessages')
end

function requestAllContact()
  TriggerServerEvent('gcPhone:requestAllContact')
end
--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)
--  Citizen.Trace('NUI Log | ' .. json.encode(data))
  cb()
end)
RegisterNUICallback('focus', function(data, cb)
  cb()
end)

RegisterNUICallback('blur', function(data, cb)
  cb()
end)

RegisterNUICallback('reponseText', function(data, cb)
  local limit = data.limit or 255
  local text = data.text or ''
  local titre = data.titre or ''
  AddTextEntry('FMMC_KEY_TIP1', titre)
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", text, "", "", "", limit)
  while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0);
      Wait(0);
  end
  if (GetOnscreenKeyboardResult()) then
      text = GetOnscreenKeyboardResult()
  end
  cb(json.encode({text = text}))
end)
--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)

RegisterNUICallback('sendMessage', function(data, cb)
  if data.message == '%pos%' then
    local myPos = GetEntityCoords(GetPlayerPed(-1))
    data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
  end
  TriggerServerEvent('gcPhone:sendMessage', data.phoneNumber, data.message)
end)

RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb()
end)

RegisterNUICallback('deleteMessageNumber', function (data, cb)
  deleteMessageContact(data.number)
  cb()
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)
  deleteAllMessage()
  cb()
end)

RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb()
end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb)
--  Citizen.Trace('addContact: ' .. json.encode(data))
  TriggerServerEvent('gcPhone:addContact', data.display, data.phoneNumber)
end)

RegisterNUICallback('updateContact', function(data, cb)
  TriggerServerEvent('gcPhone:updateContact', data.id, data.display, data.phoneNumber)
end)

RegisterNUICallback('setVirement', function(data, cb)
  local charbank = {}
  charbank.icon = "CHAR_BANK_MAZE"
  charbank.titre = "Maze Bank"
  TriggerServerEvent('bank:transfer', data.numero, data.montant, charbank)
end)

RegisterNUICallback('deleteContact', function(data, cb)
  TriggerServerEvent('gcPhone:deleteContact', data.id)
end)

RegisterNUICallback('getContacts', function(data, cb)
  cb(json.encode(contacts))
end)

RegisterNUICallback('setGPS', function(data, cb)
  SetNewWaypoint(tonumber(data.x), tonumber(data.y))
  cb()
end)

RegisterNUICallback('callEvent', function(data, cb)
  if data.data ~= nil then 
    TriggerEvent(data.eventName, {type = data.data})
  else
    TriggerEvent(data.eventName)
  end
  cb()
end)

RegisterNUICallback('deleteALL', function(data, cb)
  TriggerServerEvent('gcPhone:deleteALL')
  cb()
end)

--====================================================================================
--  Event - Articles
--====================================================================================

RegisterNUICallback('deleteArticle', function(data)
  if isJournaliste then
    deleteArticle(data.id)
  else
    Notify("~r~Vous devez être journaliste")
  end
end)

RegisterNUICallback('sendArticle', function()
  if isJournaliste then
    local article = ''
    local titre = ''
    AddTextEntry('FMMC_KEY_TIP1', "Titre")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", titre, "", "", "", 255)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0)
      Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
      titre = GetOnscreenKeyboardResult()
    end
    AddTextEntry('FMMC_KEY_TIP1', "Article")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", article, "", "", "", 3000)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0)
      Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
      article = GetOnscreenKeyboardResult()
    end
    if titre ~= '' and article ~= '' then
      sendArticle(titre, article)
    else
      Notify("~r~Aucun champs ne peut être vide")
    end
  else
    Notify("~r~Vous devez être journaliste")
  end
end)

RegisterNUICallback('modifyArticle', function(data)
  if isJournaliste then
    local article = data.artArticle
    local titre = data.artTitre
    AddTextEntry('FMMC_KEY_TIP1', "Titre")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", titre, "", "", "", 255)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0)
      Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
      titre = GetOnscreenKeyboardResult()
    end
    AddTextEntry('FMMC_KEY_TIP1', "Article")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", article, "", "", "", 3000)
    while (UpdateOnscreenKeyboard() == 0) do
      DisableAllControlActions(0)
      Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
      article = GetOnscreenKeyboardResult()
    end
    if titre ~= '' and article ~= '' then
      modifyArticle(data.artID, titre, article)
    else
      Notify("~r~Aucun champs ne peut être vide")
    end
  else
    Notify("~r~Vous devez être journaliste")
  end
end)

function TooglePhone() 
  menuIsOpen = not menuIsOpen
  SendNUIMessage({show = menuIsOpen})
  if menuIsOpen == true then
    TriggerEvent('indicators:dontuseable', true)
    ePhoneInAnim()
  else
    TriggerEvent('indicators:dontuseable', false)
    ePhoneOutAnim()
  end
end

RegisterNUICallback('closePhone', function(data, cb)
  TriggerEvent('indicators:dontuseable', false)
  menuIsOpen = false
  SendNUIMessage({show = false})
  ePhoneOutAnim()
  cb()
end)
