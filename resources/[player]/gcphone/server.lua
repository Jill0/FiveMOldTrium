--====================================================================================
-- #Author: Jonathan D @Gannon #Modified by Routmoute
--====================================================================================
--====================================================================================
--  
--====================================================================================

--====================================================================================
--  Utils
--====================================================================================

function getPhoneRandomNumber()
    return '0' .. math.random(600000000,799999999)
end

function getBankRandomNumber()
    return math.random(100000,999999)
end

function getSourceFromIdentifier(identifier, cb)
    --TriggerEvent("es:getAllPlayerConnected", function(users)
    exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
        for k , user in pairs(users_connected) do
            if user.func.getIdentifier() == identifier then
                cb(k)
                return
            end
        end
    end)
    --end)
    cb(nil)
end

function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end

function getIdentifierByPhoneNumber(phone_number)
    local result = MySQL.Sync.fetchAll('SELECT identifier FROM users WHERE phone_number = @phone_number', {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return nil
end
--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)
    local result = MySQL.Sync.fetchAll('SELECT id, number, display FROM phone_users_contacts WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })
    return result
end

function addContact(source, identifier, number, display)
    MySQL.Sync.execute('INSERT INTO phone_users_contacts (`identifier`, `number`,`display`) VALUES(@identifier, @number, @display)', {
        ['@identifier'] = identifier,
        ['@number'] = number,
        ['@display'] = display,
    })
    notifyContactChange(source, identifier)
end

function updateContact(source, identifier, id, number, display)
    MySQL.Sync.execute('UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id', { 
        ['@number'] = number,
        ['@display'] = display,
        ['@id'] = id,
    })
    notifyContactChange(source, identifier)
end

function deleteContact(source, identifier, id)
    MySQL.Sync.execute('DELETE FROM phone_users_contacts WHERE `identifier` = @identifier AND `id` = @id', {
        ['@identifier'] = identifier,
        ['@id'] = id,
    })
    notifyContactChange(source, identifier)
end

function deleteAllContact(identifier)
    MySQL.Sync.execute('DELETE FROM phone_users_contacts WHERE `identifier` = @identifier', {
        ['@identifier'] = identifier
    })
end

function notifyContactChange(source, identifier)
    if source ~= nil then 
        TriggerClientEvent("gcPhone:contactList", source, getContacts(identifier))
    end
end

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
    local identifier = GetPlayerIdentifiers(source)[1]
    addContact(source, identifier, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
    local identifier = GetPlayerIdentifiers(source)[1]
    updateContact(source, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
    local identifier = GetPlayerIdentifiers(source)[1]
    deleteContact(source, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    -- local result = MySQL.Sync.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {
    --     ['@identifier'] = identifier
    -- })
    -- -- A CHANGER !!!!!!!
    -- for k, v in ipairs(result) do  
    --     v.time = os.time(v.time) + math.floor(0) - 2*60*60
    -- end
    -- return result
	
	
	
	MySQL.Sync.fetchScalar("SELECT COUNT(*) FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", { ['@identifier'] = identifier } ,function(countPlayer)
    if countPlayer >= 25 then
	  deleteAllMessage(identifier)
	  end
	end)
	
      
        
    return MySQL.Sync.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {
        ['@identifier'] = identifier
    })
	
end

function _internalAddMessage(transmitter, receiver, message, owner)
    -- print('ADD MESSAGE: ' .. transmitter .. receiver .. message .. owner)
    -- MySQL.Sync.execute("INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner)", {
    --     ['@transmitter'] = transmitter,
    --     ['@receiver'] = receiver,
    --     ['@message'] = message,
    --     ['@isRead'] = owner,
    --     ['@owner'] = owner
    -- })
    Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner)"
    local Query2 = 'SELECT * FROM `phone_messages` WHERE `transmitter` = @transmitter  ORDER BY `phone_messages`.`id` DESC LIMIT 1 '

     MySQL.Sync.execute(Query, Parameters)

    --phase2
   
    return MySQL.Sync.fetchAll(Query2, {['@transmitter'] = transmitter})[1]
end

function addMessage(source, identifier, phone_number, message)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    if otherIdentifier ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        getSourceFromIdentifier(otherIdentifier, function (osou)
            if osou ~= nil then 
                -- TriggerClientEvent("gcPhone:allMessage", osou, getMessages(otherIdentifier))
                TriggerClientEvent("gcPhone:receiveMessage", osou, tomess)
            end
        end) 
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    -- TriggerClientEvent("gcPhone:allMessage", source, getMessages(identifier))
    TriggerClientEvent("gcPhone:receiveMessage", source, memess)

end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(identifier, phone_number)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {
        ['@mePhoneNumber'] = mePhoneNumber,
        ['@phone_number'] = phone_number
    })
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
    local identifier = GetPlayerIdentifiers(source)[1]
    print(identifier)
    addMessage(source, identifier, phoneNumber, message)
end)

RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
    local identifier = GetPlayerIdentifiers(source)[1]
    deleteAllMessageFromPhoneNumber(identifier, number)
    TriggerClientEvent("gcPhone:allMessage", source, getMessages(identifier))
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
    local identifier = GetPlayerIdentifiers(source)[1]
    deleteAllMessage(identifier)
    TriggerClientEvent("gcPhone:allMessage", source, getMessages(identifier))
end)

RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
    local identifier = GetPlayerIdentifiers(source)[1]
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
    local identifier = GetPlayerIdentifiers(source)[1]
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    TriggerClientEvent("gcPhone:contactList", source, {})
    TriggerClientEvent("gcPhone:allMessage", source, {})
end)

--====================================================================================
--  Banque
--====================================================================================

function getBank(identifier)
    return MySQL.Sync.fetchScalar("SELECT bankbalance FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
end

function getNumCompte(identifier)
	local result = MySQL.Sync.fetchScalar("SELECT NumCompte FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
	if result == 0 then
		local resultat = 1
		while resultat ~= 0 do
			result = getBankRandomNumber()
			resultat = MySQL.Sync.fetchScalar("SELECT Count(*) FROM users WHERE NumCompte = @numcompte", {
				['@numcompte'] = result
			})
		end
		MySQL.Sync.execute("UPDATE users SET NumCompte = @numcompte WHERE identifier = @identifier", {
			['@numcompte'] = result,
			['@identifier'] = identifier
		})
	end
	return result
end

--====================================================================================
--  Articles
--====================================================================================
local articles = {}

CreateThread(function()
	MySQL.ready(function ()
		articles = MySQL.Sync.fetchAll("SELECT *, DATE_FORMAT(time, 'Le %d/%m/%Y à %Hh%i') as date FROM phone_news")
	end)
end)

function getArticles()
	articles = MySQL.Sync.fetchAll("SELECT *, DATE_FORMAT(time, 'Le %d/%m/%Y à %Hh%i') as date FROM phone_news")
	return articles
end

function deleteArticle(artId)
    MySQL.Async.execute("DELETE FROM phone_news WHERE `id` = @id", {
        ['@id'] = artId
    })
	for k, v in ipairs(articles) do 
		if v.id == artId then
			table.remove(articles, k)
			TriggerClientEvent("gcPhone:allArticle", -1, articles)
		end
	end
end

function sendArticle(titre, article, identifier)
	MySQL.Async.fetchAll("SELECT prenom, nom FROM users WHERE identifier = @identifier", {
		['@identifier'] = identifier
	}, function(result)
		MySQL.Async.execute("INSERT INTO phone_news (`exp`, `titre`, `message`) VALUES (@exp, @titre, @message)", {
			['@exp'] = result[1].prenom .. " " .. result[1].nom .. " - Journaliste",
			['@titre'] = titre,
			['@message'] = article
		}, function()
			TriggerClientEvent("gcPhone:allArticle", -1, getArticles())
			TriggerClientEvent("gcPhone:newArticle", -1, titre)
		end)
	end)
end

function modifyArticle(id, titre, article)
	MySQL.Async.execute("UPDATE phone_news SET `titre` = @titre, `message` = @message WHERE id = @id", {
		['@titre'] = titre,
		['@message'] = article,
		['@id'] = id
	}, function()
		TriggerClientEvent("gcPhone:allArticle", -1, getArticles())
	end)
end

RegisterServerEvent('gcPhone:deleteArticle')
AddEventHandler('gcPhone:deleteArticle', function(artId)
    deleteArticle(artId)
end)

RegisterServerEvent('gcPhone:sendArticle')
AddEventHandler('gcPhone:sendArticle', function(titre, article)
	local identifier = GetPlayerIdentifiers(source)[1]
    sendArticle(titre, article, identifier)
end)

RegisterServerEvent('gcPhone:modifyArticle')
AddEventHandler('gcPhone:modifyArticle', function(id, titre, article)
    modifyArticle(id, titre, article)
end)

RegisterServerEvent('gcPhone:BankUpdate')
AddEventHandler('gcPhone:BankUpdate', function()
    local identifier = GetPlayerIdentifiers(source)[1]
    TriggerClientEvent("gcPhone:getsolde", source, getBank(identifier))
end)

--[[function getIsJournaliste(identifier)
    local journaliste = MySQL.Sync.fetchScalar("SELECT job FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    })
	if journaliste == 19 then
		return true
	end
end]]--

function getIsJournaliste(identifier, source)
	local isJournaliste = false
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if(user.jobId == 19) then
        	isJournaliste = true
        end
    end)
   	if(isJournaliste) then
    	return true
    end
end
--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler('es:playerLoaded',function(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    local myPhoneNumber = tonumber(getNumberPhone(identifier))
	local ok = false
	--print(myPhoneNumber)
    while myPhoneNumber == nil and ok == false or myPhoneNumber == 0 and ok == false  do 
        local randomNumberPhone = getPhoneRandomNumber()
		Citizen.Wait(500)
		local result =  MySQL.Sync.fetchScalar('SELECT COUNT(phone_number) FROM users WHERE phone_number = @randomNumberPhone', { 
            ['@randomNumberPhone'] = randomNumberPhone
        })
		if result == 0 then
		ok = true
        MySQL.Sync.execute('UPDATE users SET phone_number = @randomNumberPhone WHERE identifier = @identifier', { 
            ['@randomNumberPhone'] = randomNumberPhone,
            ['@identifier'] = identifier
        })
		myPhoneNumber = tostring(getNumberPhone(identifier))
		end

    end
		if ok == false then
		 myPhoneNumber = tostring(getNumberPhone(identifier))
		end
    TriggerClientEvent("gcPhone:myPhoneNumber", source, tostring(myPhoneNumber))
    TriggerClientEvent("gcPhone:contactList", source, getContacts(identifier))
    TriggerClientEvent("gcPhone:allMessage", source, getMessages(identifier))
	TriggerClientEvent("gcPhone:allArticle", source, articles)
	TriggerClientEvent("gcPhone:getnumcompte", source, getNumCompte(identifier))
	TriggerClientEvent("gcPhone:checkJournaliste", source, getIsJournaliste(identifier,source))
end)
