--FX

AddEventHandler("es:playerLoaded", function(user)
	TriggerEvent('es:getPlayerFromId', user, function(user)
		if user.isFirstConnection == 1 then
			TriggerClientEvent('skin:openSkinCreator', user.source)
			TriggerClientEvent('mm:changefirstco', user.source)
		end
	end)
end)

RegisterServerEvent('skin:getOutfits')
AddEventHandler('skin:getOutfits', function(model)
	local mysource = source
	local outfits = MySQL.Sync.fetchAll('SELECT * FROM clothes_outfits WHERE category = "skincreator" AND skin_model=@model', {['@model'] = model})
		local outfitsList = {}
		if outfits[1] then
			for k,outfit in ipairs(outfits)do
				outfitsList[k] = outfit
			end
			TriggerClientEvent('skin:setOutfitList', mysource, outfitsList )
		end

	
end)

RegisterServerEvent('skin:saveOutfitForNewPlayer')
AddEventHandler('skin:saveOutfitForNewPlayer', function(current_skin)
	local mysource = source
	TriggerEvent('es:getPlayerFromId', mysource, function(user)
		MySQL.Async.execute('INSERT INTO modelmenu (identifier, model, head, body_color, hair, hair_colour, beard, beard_color, eyebrows, eyebrows_color, undershirt, undershirt_txt, pants, pants_txt, shoe, shoe_txt, shirt, shirt_txt) VALUES (@id, @a, @b, @c, @d, @e, @f, @g, @h, @i, @j, @k, @l, @m, @n, @o, @p, @q)',
		{
		['@id'] = user.identifier,
		['@a']  = current_skin.model,
		['@b']  = tonumber(current_skin.head) or 0,
		['@c']  = tonumber(current_skin.body_color) or 0,
		['@d']  = tonumber(current_skin.hair) or 0,
		['@e']  = tonumber(current_skin.hair_color) or 0,
		['@f']  = tonumber(current_skin.beard) or 0,
		['@g']  = tonumber(current_skin.beard_color) or 0,
		['@h']  = tonumber(current_skin.eyebrows) or 0,
		['@i']  = tonumber(current_skin.eyebrows_color) or 0,
		['@j']  = tonumber(current_skin.tshirt) or 0,
		['@k']  = tonumber(current_skin.tshirt_txt) or 0,
		['@l']  = tonumber(current_skin.pant) or 0,
		['@m']  = tonumber(current_skin.pant_txt) or 0,
		['@n']  = tonumber(current_skin.shoe) or 0,
		['@o']  = tonumber(current_skin.shoe_txt) or 0,
		['@p']  = tonumber(current_skin.jacket) or 0,
		['@q']  = tonumber(current_skin.jacket_txt) or 0
			})
		MySQL.Async.execute('INSERT INTO clothes_users_outfits (identifier, current, outfit_id ) VALUES (@id, @b, @c)',
			{
				['@id'] = user.identifier,
				['@b']  = 1,
				['@c']  = current_skin.outfit_id
			})
		MySQL.Async.execute('UPDATE users SET `isFirstConnection`=0 WHERE identifier=@id', { ['@id'] = user.identifier })
		TriggerClientEvent('phone:notifs', user.source, "Votre personnnalisation est terminé, bienvenue sur le serveur !")
		TriggerEvent('skin:firstSkinCreated', user.source)
		local plate = "NEW" .. tostring(math.random(10000,99999))
		MySQL.Async.execute('INSERT INTO user_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_price`, `vehicle_plate`,`vehicle_state`,`veh_type`,`veh_location`) VALUES (@username, @name, @vehicle, @price, @plate, @state, @type,0)',
		{['@username'] = user.identifier, ['@name'] = "Noobio", ['@vehicle'] = "faggio", ['@price'] = "500", ['@plate'] = plate,['@state'] = "Rentré", ['@type'] = 1})
	end)
end)

function getSkin(player)
	local mysource = source
	MySQL.Async.fetchAll("SELECT * FROM modelmenu WHERE `identifier` = @name", {['@name'] = player}, function (skin)
		if(skin)then
			for k,v in ipairs(skin)do
				if v.head ~= nil then
					TriggerClientEvent("skin:setPlayerSkin", mysource, v)
				end
			end
		end
	end)
end

function getOutfit(player)
	local mysource = source
	local outfits = MySQL.Sync.fetchAll('SELECT * FROM clothes_users_outfits JOIN clothes_outfits ON `clothes_users_outfits`.`outfit_id` = `clothes_outfits`.`id` WHERE clothes_users_outfits.identifier = @username AND current= 1', {['@username'] = player})
		if outfits~= nil and outfits[1]~= nil then
			for k,outfit in ipairs(outfits)do
				TriggerClientEvent("skin:setPlayerOutfit", mysource, outfit)
			end
			for k,v in ipairs(outfits)do
	                if v.mask ~= nil then
	                    TriggerClientEvent("accessories_switcher:WearMask", mysource, v)
	                end
	            end
		end
	  
end

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

RegisterServerEvent("skin:reloadSkin")
AddEventHandler('skin:reloadSkin', function()
	local player = getPlayerID(source)
	getSkin(player)
end)


RegisterServerEvent('skin:getPlayerModel')
AddEventHandler('skin:getPlayerModel', function()
	local mysource = source
	local player = getPlayerID(source)
	local model = MySQL.Sync.fetchAll('SELECT model FROM modelmenu WHERE identifier = @username', {['@username'] = player})
	if model ~= nil and model[1] ~= nil then
		TriggerClientEvent('skin:getPlayerModelFromDb', mysource, model[1].model)
	else
		TriggerClientEvent('skin:getPlayerModelFromDb', mysource,  "mp_m_freemode_01")
	end
end)

RegisterServerEvent('skin:firstSpawn')
AddEventHandler('skin:firstSpawn', function()
	local player = getPlayerID(source)
	getSkin(player)
end)

RegisterServerEvent("skin:loadSkinAndPosition")
AddEventHandler("skin:loadSkinAndPosition", function()
	local player = getPlayerID(source)
end)

RegisterServerEvent("skin_customization:SpawnPlayer")
AddEventHandler("skin_customization:SpawnPlayer", function()
	TriggerClientEvent("clotheshop:spawnafterjob", source)
end)
