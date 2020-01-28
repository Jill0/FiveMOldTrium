RegisterServerEvent('blanchi:transform')
AddEventHandler('blanchi:transform', function ()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local sale = user.dirty_money

        if (sale > 0) then
            user.func.addMoney(tonumber(sale))
            user.func.removeDirty_Money(tonumber(sale))
        end
        TriggerClientEvent('blanchi:drawTransform', source, sale)
    end)
end)

RegisterServerEvent('blanchi:stestcop')
AddEventHandler('blanchi:stestcop', function()
    getPoliceInService(function(nbPolicier) 
        local nbPolice = nbPolicier
        TriggerClientEvent('blanchi:getcop', -1, nbPolice)
    end)

end)

function getPoliceInService(cb)
    --[[local nbPolicier = 0
local users_connected = exports["essentialmode"]:getAllPlayerConnected()   
for k,v in pairs(users_connected) do
if (v.func.getSessionVar('policeInService') == true) then
        nbPolicier = nbPolicier + 1
    end
end
cb(nbPolicier)
]]--
    local nbPolicier = 0
    nbPolicier = exports["c_services"]:GetPoliceConnected()
    cb(nbPolicier)
end



RegisterServerEvent('blanchi:checkIsBlanchisseur')
AddEventHandler('blanchi:checkIsBlanchisseur', function()
    --print(source)
    TriggerEvent("es:getPlayerFromId", source, function(user)
        local identifier = user.identifier
        --print(identifier)
        checkIsBlanchisseur(identifier, user.source)
    end)
end)

function checkIsBlanchisseur(identifier, source) 
    MySQL.Async.fetchAll("SELECT blanchisseur FROM users WHERE identifier = @identifier", {['@identifier'] = identifier}, function(result)
        if (result[1].blanchisseur == 0) then
            TriggerClientEvent('blanchi:receiveIsBlanchisseur', source, "0")
        else
            TriggerClientEvent('blanchi:receiveIsBlanchisseur', source, result[1].blanchisseur)
        end
    end)
end

function s_checkIsBlanchisseur(identifier)
    MySQL.Async.fetchAll("SELECT blanchisseur FROM users WHERE identifier = @identifier", {['@identifier'] = identifier}, function(result)
        if (result[1].blanchisseur == 0) then
            return false
        else
            return true
        end
    end)
end
