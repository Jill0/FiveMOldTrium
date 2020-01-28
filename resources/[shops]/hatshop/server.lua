

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

RegisterServerEvent("hatshop:getModelAndList")
AddEventHandler("hatshop:getModelAndList", function()
    local pedSource = source
    local identifier = GetPlayerIdentifiers(pedSource)[1]
	TriggerEvent('hatshop:getHats', pedSource)
	TriggerEvent('hatshop:getDressingHats', identifier, pedSource)
end)

RegisterServerEvent('hatshop:getDressingHats')
AddEventHandler('hatshop:getDressingHats', function(identifier, lasource)
    MySQL.Async.fetchAll("SELECT clothes_hats.id, clothes_hats.item_name, clothes_users_props.* FROM clothes_users_props JOIN clothes_hats ON `clothes_users_props`.`prop_id` = `clothes_hats`.`prop_id` AND `clothes_users_props`.`prop_txt` = `clothes_hats`.`prop_txt` WHERE identifier = @username AND `clothes_users_props`.`category`='hat' ORDER BY clothes_hats.id", {['@username'] = identifier},
      function(hats)
	    if hats and hats[1] then
		    local dressingHatList = {}
	        for k,hat in ipairs(hats)do
	            dressingHatList[k] = hat
	        end
	        TriggerClientEvent('hatshop:setDressingHatsList', lasource, dressingHatList)
	    end
    end)
end)

RegisterServerEvent('hatshop:getHats')
AddEventHandler('hatshop:getHats', function(source)
    MySQL.Async.fetchAll("SELECT * FROM clothes_hats", {}, function(hats)
	    local hatsList = {}
	    if hats and hats[1] then
	        for k,hat in ipairs(hats)do
	            hatsList[k] = hat
	        end
	        TriggerClientEvent('hatshop:setHatsList', source, hatsList )
	    end
      end)
end)

RegisterServerEvent('hatshop:buyProp')
AddEventHandler('hatshop:buyProp', function(prop)
    local source = source
    if not checkProp(source, prop.item_id, prop.txt) then
        TriggerEvent('es:getPlayerFromId', source, function(user)
            if tonumber(user.money) >= tonumber(prop.price) and tonumber(user.money) > 0 then
                MySQL.Async.execute("UPDATE clothes_users_props SET `current`=0 WHERE identifier=@id AND `clothes_users_props`.`category`='hat'", {['@id'] = user.identifier}, function()
                    MySQL.Async.execute("INSERT INTO clothes_users_props ( identifier, category, current, prop_id, prop_txt ) VALUES ( @id, 'hat','1', @prop, @prop_txt)", {
                        ['@prop']       = prop.item_id,
                        ['@prop_txt']   = prop.txt,
                        ['@id']         = user.identifier
                    })
                end)
                user.func.removeMoney(prop.price)
                TriggerEvent('hatshop:getDressingHats', user.identifier, source)
                TriggerClientEvent('hatshop:notifs', source, "Vous venez de payer ~y~"..prop.price.."$ pour cet article"  )
                TriggerClientEvent('hatshop:notifs', source, "Cet article à été enregistré !"  )
            else
                TriggerClientEvent('hatshop:notifs', source, "Vous n'avez pas assez d'argent en poche"  )
            end
        end)
    end
end)


RegisterServerEvent('hatshop:wearHatProp')
AddEventHandler('hatshop:wearHatProp', function(item_id, item_txt)
	local mysource= source
    MySQL.Async.execute("UPDATE clothes_users_props SET `current`=0 WHERE identifier=@id AND `clothes_users_props`.`category`='hat'", { ['@id'] = getPlayerID(mysource) }, function()
        MySQL.Async.execute("UPDATE clothes_users_props SET `current`=1 WHERE identifier=@id AND prop_id=@prop_id AND prop_txt=@prop_txt AND `clothes_users_props`.`category`='hat'", { ['@id'] = getPlayerID(mysource), ['@prop_id'] = item_id, ['@prop_txt'] = item_txt }, function()
            TriggerClientEvent('hatshop:notifs', mysource, "Vous avez changé de chapeau !"  )
        end)
    end)
end)

function checkProp(source, prop, proptxt)
    local user_prop = MySQL.Sync.fetchScalar("SELECT prop_id FROM clothes_users_props WHERE prop_id=@prop AND prop_txt=@proptxt AND identifier=@id AND `clothes_users_props`.`category`='hat'", {['@prop'] = prop, ['@proptxt'] = proptxt, ['@id'] =  getPlayerID(source)})
    if user_prop ~= nil then
        TriggerClientEvent('hatshop:notifs', source, "Vous possédez déjà cet article" )
        return true
    end
    return false
end
