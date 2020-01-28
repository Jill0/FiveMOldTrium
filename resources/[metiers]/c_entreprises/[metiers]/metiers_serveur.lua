RegisterServerEvent('entreprises:CheckMyJobAndLead')
RegisterServerEvent('entreprises:setService')
RegisterServerEvent('entreprises:getUser')


AddEventHandler('entreprises:CheckMyJobAndLead', function(Job_ID)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT job,leader FROM users WHERE identifier = @identifier", {['@identifier'] = user.identifier}, function (result)
        local jobID = result[1].job
        local Leader = result[1].leader
        TriggerClientEvent('entreprises:ReceiveJobAndLead', user.source, jobID, Leader)
    end)
end)


AddEventHandler('entreprises:setService', function (jobName, inService)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    if(user ~= nil) then 
        user.func.setSessionVar(tostring(jobName), inService)
    end
end)

AddEventHandler('entreprises:getUser', function ()
    local user = exports["essentialmode"]:getPlayerFromId(source)
	local playerid=user.source
	TriggerClientEvent('entreprises:ReturnPlayerId',source,playerid)
	
end)

