--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 24/05/2017
-- Time: 02:37
-- To change this template use File | Settings | File Templates.
--
-----------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("accessories_switcher:server_wearHat")
RegisterServerEvent("accessories_switcher:server_wearPercing")
RegisterServerEvent("accessories_switcher:server_wearGlasses")
RegisterServerEvent("accessories_switcher:server_wearMask")

AddEventHandler("accessories_switcher:server_wearHat", function()
	local mysource = source
    TriggerEvent('es:getPlayerFromId', mysource, function(user)
        MySQL.Async.fetchAll("SELECT prop_id, prop_txt FROM clothes_users_props WHERE identifier = @username AND `current` = 1 AND category='hat'", {['@username'] = user.identifier},
          function(skin)
	        if skin[1] then
	            TriggerClientEvent("accessories_switcher:WearHat", mysource, skin[1])
	        end
          end)
    end)
end)

AddEventHandler("accessories_switcher:server_wearGlasses", function()
	local mysource = source
    TriggerEvent('es:getPlayerFromId', mysource, function(user)
        MySQL.Async.fetchAll("SELECT prop_id, prop_txt FROM clothes_users_props WHERE identifier = @username AND `current` = 1 AND category='glasse'", {['@username'] = user.identifier},
          function(skin)
	        if skin[1] then
	            TriggerClientEvent("accessories_switcher:WearGlasses", mysource, skin[1])
	        end
          end)
    end)
end)

AddEventHandler("accessories_switcher:server_wearPercing", function()
	local mysource = source
    TriggerEvent('es:getPlayerFromId', mysource, function(user)
        MySQL.Async.fetchAll("SELECT percing FROM skin WHERE identifier = @username", {['@username'] = user.identifier},
          function(skin)
	        if(skin)then
	            for k,v in ipairs(skin)do
	                if v.percing ~= nil then
	                    TriggerClientEvent("accessories_switcher:WearPercing", mysource, v)
	                end
	            end
	        end
          end)
    end)
end)

AddEventHandler("accessories_switcher:server_wearMask", function()
	local mysource = source
    TriggerEvent('es:getPlayerFromId', mysource, function(user)
        MySQL.Async.fetchAll("SELECT prop_id, prop_txt FROM clothes_users_props WHERE identifier = @username AND `current` = 1 AND category='mask'", {['@username'] = user.identifier},
          function(skin)
	        if skin[1] then
	            TriggerClientEvent("accessories_switcher:WearMask", mysource, skin[1])
	        end
          end)
    end)
end)