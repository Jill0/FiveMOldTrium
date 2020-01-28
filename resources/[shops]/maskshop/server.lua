
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

RegisterServerEvent("maskshop:getModelAndList")
AddEventHandler("maskshop:getModelAndList", function()
    local pedSource = source
    local identifier = GetPlayerIdentifiers(pedSource)[1]
	TriggerEvent('maskshop:getMasks', pedSource)
	TriggerEvent('maskshop:getDressingMasks', identifier, pedSource)
end)

RegisterServerEvent('maskshop:getDressingMasks')
AddEventHandler('maskshop:getDressingMasks', function(identifier, lasource)
    MySQL.Async.fetchAll("SELECT clothes_masks.id, clothes_masks.item_name, clothes_users_props.* FROM clothes_users_props JOIN clothes_masks ON `clothes_users_props`.`prop_id` = `clothes_masks`.`prop_id` AND `clothes_users_props`.`prop_txt` = `clothes_masks`.`prop_txt` WHERE identifier = @username AND `clothes_users_props`.`category`='mask' ORDER BY clothes_masks.id", {['@username'] = identifier},
      function(masks)
	    if masks and masks[1] then
		    local dressingMaskList = {}
	        for k,mask in ipairs(masks)do
	            dressingMaskList[k] = mask
	        end
	        TriggerClientEvent('maskshop:setDressingMasksList', lasource, dressingMaskList)
	    end
    end)
end)

RegisterServerEvent('maskshop:getMasks')
AddEventHandler('maskshop:getMasks', function(source)
    MySQL.Async.fetchAll("SELECT * FROM clothes_masks", {}, function(masks)
	    local masksList = {}
	    if masks and masks[1] then
	        for k,mask in ipairs(masks)do
              -- print('masksList[k] = prop')
	            masksList[k] = mask
	        end
	        TriggerClientEvent('maskshop:setMasksList', source, masksList )
	    end
      end)
end)

RegisterServerEvent('maskshop:buyProp')
AddEventHandler('maskshop:buyProp', function(prop)
    local source = source
--    print('prop.id == '.. prop.id)
    if not checkProp(source, prop.item_id, prop.txt) then
        TriggerEvent('es:getPlayerFromId', source, function(user)
            if tonumber(user.money) >= tonumber(prop.price) and tonumber(user.money) > 0 then
                MySQL.Async.execute("UPDATE clothes_users_props SET `current`=0 WHERE identifier=@id AND `clothes_users_props`.`category`='mask'", {['@id'] = user.identifier}, function()
                    MySQL.Async.execute("INSERT INTO clothes_users_props ( identifier, category, current, prop_id, prop_txt ) VALUES ( @id, 'mask','1', @prop, @prop_txt)", {
                        ['@prop']       = prop.item_id,
                        ['@prop_txt']   = prop.txt,
                        ['@id']         = user.identifier
                    })
                end)
                user.func.removeMoney(prop.price)
                TriggerEvent('maskshop:getDressingMasks', user.identifier, source)
                TriggerClientEvent('maskshop:notifs', source, "Vous venez de payer ~y~"..prop.price.."$ pour cet article"  )
                TriggerClientEvent('maskshop:notifs', source, "Cet article à été enregistré !"  )
            else
                TriggerClientEvent('maskshop:notifs', source, "Vous n'avez pas assez d'argent en poche"  )
            end
        end)
    end
end)


RegisterServerEvent('maskshop:wearMaskProp')
AddEventHandler('maskshop:wearMaskProp', function(item_id, item_txt)
	local mysource= source
    MySQL.Async.execute("UPDATE clothes_users_props SET `current`=0 WHERE identifier=@id AND `clothes_users_props`.`category`='mask'", { ['@id'] = getPlayerID(mysource) }, function()
        MySQL.Async.execute("UPDATE clothes_users_props SET `current`=1 WHERE identifier=@id AND prop_id=@prop_id AND prop_txt=@prop_txt AND `clothes_users_props`.`category`='mask'", { ['@id'] = getPlayerID(mysource), ['@prop_id'] = item_id, ['@prop_txt'] = item_txt }, function()
            TriggerClientEvent('maskshop:notifs', mysource, "Vous avez changé de masque !"  )
        end)
    end)
end)

function checkProp(source, prop, proptxt)
    local user_prop = MySQL.Sync.fetchScalar("SELECT prop_id FROM clothes_users_props WHERE prop_id=@prop AND prop_txt=@proptxt AND identifier=@id AND `clothes_users_props`.`category`='mask'", {['@prop'] = prop, ['@proptxt'] = proptxt, ['@id'] =  getPlayerID(source)})
    if user_prop ~= nil then
        TriggerClientEvent('maskshop:notifs', source, "Vous possédez déjà cet article" )
        return true
    end
    return false
end