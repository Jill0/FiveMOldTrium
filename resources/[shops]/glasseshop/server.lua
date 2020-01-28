
function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

RegisterServerEvent("glasseshop:getModelAndList")
AddEventHandler("glasseshop:getModelAndList", function()
    local pedSource = source
    local identifier = GetPlayerIdentifiers(pedSource)[1]
	TriggerEvent('glasseshop:getGlasses', pedSource)
	TriggerEvent('glasseshop:getDressingGlasses', identifier, pedSource)
end)

RegisterServerEvent('glasseshop:getDressingGlasses')
AddEventHandler('glasseshop:getDressingGlasses', function(identifier, lasource)
    MySQL.Async.fetchAll("SELECT clothes_glasses.id, clothes_glasses.item_name, clothes_users_props.* FROM clothes_users_props JOIN clothes_glasses ON `clothes_users_props`.`prop_id` = `clothes_glasses`.`prop_id` AND `clothes_users_props`.`prop_txt` = `clothes_glasses`.`prop_txt` WHERE identifier = @username AND `clothes_users_props`.`category`='glasse' ORDER BY clothes_glasses.id", {['@username'] = identifier},
      function(glasses)
	    if glasses and glasses[1] then
		    local dressingGlasseList = {}
	        for k,glasse in ipairs(glasses)do
	            dressingGlasseList[k] = glasse
	        end
	        TriggerClientEvent('glasseshop:setDressingGlassesList', lasource, dressingGlasseList)
	    end
    end)
end)

RegisterServerEvent('glasseshop:getGlasses')
AddEventHandler('glasseshop:getGlasses', function(source)
    MySQL.Async.fetchAll("SELECT * FROM clothes_glasses", {}, function(glasses)
	    local glassesList = {}
	    if glasses and glasses[1] then
	        for k,glasse in ipairs(glasses)do
	            glassesList[k] = glasse
	        end
	        TriggerClientEvent('glasseshop:setGlassesList', source, glassesList )
	    end
      end)
end)

RegisterServerEvent('glasseshop:buyProp')
AddEventHandler('glasseshop:buyProp', function(prop)
    local source = source
    if not checkProp(source, prop.item_id, prop.txt) then
        TriggerEvent('es:getPlayerFromId', source, function(user)
            if tonumber(user.money) >= tonumber(prop.price) and tonumber(user.money) > 0 then
                MySQL.Async.execute("UPDATE clothes_users_props SET `current`=0 WHERE identifier=@id AND `clothes_users_props`.`category`='glasse'", {['@id'] = user.identifier}, function()
                    MySQL.Async.execute("INSERT INTO clothes_users_props ( identifier, category, current, prop_id, prop_txt ) VALUES ( @id, 'glasse','1', @prop, @prop_txt)", {
                        ['@prop']       = prop.item_id,
                        ['@prop_txt']   = prop.txt,
                        ['@id']         = user.identifier
                    })
                end)
                user.func.removeMoney(prop.price)
                TriggerEvent('glasseshop:getDressingGlasses', user.identifier, source)
                TriggerClientEvent('glasseshop:notifs', source, "Vous venez de payer ~y~"..prop.price.."$ pour cet article"  )
                TriggerClientEvent('glasseshop:notifs', source, "Cet article à été enregistré !"  )
            else
                TriggerClientEvent('glasseshop:notifs', source, "Vous n'avez pas assez d'argent en poche"  )
            end
        end)
    end
end)


RegisterServerEvent('glasseshop:wearGlasseProp')
AddEventHandler('glasseshop:wearGlasseProp', function(item_id, item_txt)
	local mysource= source
    MySQL.Async.execute("UPDATE clothes_users_props SET `current`=0 WHERE identifier=@id AND `clothes_users_props`.`category`='glasse'", { ['@id'] = getPlayerID(mysource) }, function()
        MySQL.Async.execute("UPDATE clothes_users_props SET `current`=1 WHERE identifier=@id AND prop_id=@prop_id AND prop_txt=@prop_txt AND `clothes_users_props`.`category`='glasse'", { ['@id'] = getPlayerID(mysource), ['@prop_id'] = item_id, ['@prop_txt'] = item_txt }, function()
            TriggerClientEvent('glasseshop:notifs', mysource, "Vous avez changé de lunettes !"  )
        end)
    end)
end)

function checkProp(source, prop, proptxt)
    local user_prop = MySQL.Sync.fetchScalar("SELECT prop_id FROM clothes_users_props WHERE prop_id=@prop AND prop_txt=@proptxt AND identifier=@id AND `clothes_users_props`.`category`='glasse'", {['@prop'] = prop, ['@proptxt'] = proptxt, ['@id'] =  getPlayerID(source)})
    if user_prop ~= nil then
        TriggerClientEvent('glasseshop:notifs', source, "Vous possédez déjà cet article" )
        return true
    end
    return false
end