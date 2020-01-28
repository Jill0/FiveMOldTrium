local CARS = {}
local ply = {}
local maxCapacity2 = 99

AddEventHandler('onMySQLReady', function ()
	MySQL.Async.fetchAll('SELECT vehicle_plate AS plate, items.`id` AS id, items.`libelle` AS libelle , quantity FROM user_vehicle LEFT JOIN vehicle_inventory  ON user_vehicle.`vehicle_plate` = vehicle_inventory.`plate` LEFT JOIN items ON vehicle_inventory.`item` = items.`id` WHERE quantity IS NOT NULL AND quantity > 0', {}, function(result)
		if #result > 0 then
			for _, v in ipairs(result) do
				if CARS[v.plate] == nil then
		    		CARS[v.plate] = {}
				end
    			if v.id and v.libelle and v.quantity then
					if CARS[v.plate][v.id] then
						CARS[v.plate][v.id].quantity = v.quantity
					else
						CARS[v.plate][v.id] = {libelle = v.libelle, quantity = v.quantity}
					end
				end
			end
		end
	end)
end)

RegisterServerEvent("car:getItems")
AddEventHandler("car:getItems", function(plate)
	local Mysource = source
    local res = nil
	if plate ~= nil then
    	if CARS[plate] then
			res = CARS[plate]
		end
		if getPods2(plate) > 0 then
    		TriggerClientEvent("car:hoodContent", Mysource, res)
		end
	end
end)


RegisterServerEvent("car:PgetItems")
AddEventHandler("car:PgetItems", function()
	--[[local identifier = getPlayerID(source)
	local Mysource = source
	MySQL.Async.fetchAll('SELECT identifier AS plate, items.id AS id, items.libelle AS libelle, quantity FROM stockage LEFT JOIN items ON stockage.item_id = items.id WHERE quantity IS NOT NULL AND stockage.quantity >= 0 AND stockage.type = "player_pocket" AND identifier = @identifier', {['@identifier'] = identifier}, function(results)
		for _, v in ipairs(results) do
    		if ply[v.plate] == nil then
    			ply[v.plate] = {}
			end
			if ply[v.plate][v.id] then
				ply[v.plate][v.id].quantity = v.quantity
			else
    			if v.id and v.libelle and v.quantity then
					ply[v.plate][v.id] = {libelle = v.libelle, quantity = v.quantity}
		   		end
			end
		end
		local res = nil
    	if ply[identifier] then
    		local res = ply[identifier]
			TriggerClientEvent("car:invContent", Mysource, res)
		end
	end)]]--
	local identifier = getPlayerID(source)
	ply[identifier] = exports["vdk_inventory"]:GetPlayerStockage(identifier)
	TriggerClientEvent("car:invContent", source, ply[identifier])
end)


RegisterServerEvent("car:receiveItem")
AddEventHandler("car:receiveItem", function(arg)
	local id = getPlayerID(source)
	local Mysource = source
	local lib = arg[4]
	local item = arg[2]
	local plate = arg[1]
	local quantity = arg[3]
	local modelcar = arg[5]
	local maxcap = arg[6]
	local citem = ply[id][item]
	local countitem = ply[id][item].quantity
	if ( countitem >= quantity) then
	    if (getPods(plate) + quantity <= maxcap) then
			if CARS[plate] == nil then
				CARS[plate] = {}
				CARS[plate][item] = {libelle = lib, quantity = quantity}
				local pl = getplate(plate)
				local goquerry= false
				if pl then
					goquerry= true
				end
				if goquerry then
					MySQL.Async.execute('INSERT INTO vehicle_inventory (`quantity`,`plate`,`item`) VALUES (@qty,@plate,@item)',{ ['@plate'] = plate, ['@qty'] = quantity, ['@item'] = item })
				end
				deleteP({ item, quantity, id, citem })
        		TriggerClientEvent("player:looseItem", Mysource, item, quantity)
			else
				add({ item, quantity, plate, lib })
				deleteP({ item, quantity, id, citem })
        		TriggerClientEvent("player:looseItem", Mysource, item, quantity)
			end
	    end
	end
end)


RegisterServerEvent("car:looseItem")
AddEventHandler("car:looseItem", function(arg)
	local Mysource = source
	local lib = arg[4]
	local item = arg[2]
	local plate = arg[1]
	local quantity = arg[3]
	local modelcar = arg[5]
	local cItem = CARS[plate][item]
	local id = getPlayerID(Mysource)
    if (cItem.quantity >= quantity) then
		if (getPodsPed(id) + quantity <= maxCapacity2) then
        	delete({ item, quantity, plate, cItem })
			if ply[id] == nil then
				ply[id] = {}
				ply[id][item]= {libelle = lib, quantity = quantity}
				TriggerClientEvent("player:receiveItem", Mysource, tonumber(item), tonumber(quantity))
			else
				addP({ item, quantity, id, lib})
		  		TriggerClientEvent("player:receiveItem", Mysource, tonumber(item), tonumber(quantity))
		 	end
		end
	end
end)


RegisterServerEvent("car:looseGlitchItem")
AddEventHandler("car:looseGlitchItem", function(arg)
	local Mysource = source
	local lib = arg[4]
	local item = arg[2]
	local plate = arg[1]
	local quantity = arg[3]
	local modelcar = arg[5]
    local cItem = CARS[plate][item]
	local id = getPlayerID(Mysource)
    if (cItem.quantity >= quantity) then
        delete({ item, quantity, plate, cItem })
    end
end)


RegisterServerEvent("BuyForVeh")
AddEventHandler('BuyForVeh', function(name, vehicle, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
    CARS[plate] = {}
end)


function add(arg)
    local itemId = arg[1]
    local qty = arg[2]
    local plate = arg[3]
    local lib = arg[4]
    local query
    local item
	local pl = getplate()
	local goquerry= false
	local goquerryu = false
	if pl then
		goquerry= true
		goquerryu = false
		local pla = getitema(plate)
		for _, v in pairs(pla) do
			if v.plate == itemId then
				goquerry = false
				goquerryu = true
			end
		end
	end
	if goquerry or goquerryu then
		if goquerry then
			CARS[plate][itemId] = {quantity = qty, libelle = lib}
    		item = CARS[plate][itemId]
			query = 'INSERT INTO vehicle_inventory (`quantity`,`plate`,`item`) VALUES (@qty,@plate,@item)'
		end
		if goquerryu then
			item = CARS[plate][itemId]
			query = 'UPDATE vehicle_inventory SET `quantity` = @qty WHERE `plate` = @plate AND `item` = @item'
			item.quantity = item.quantity + qty
		end
        MySQL.Async.execute(query,{ ['@plate'] = plate, ['@qty'] = item.quantity, ['@item'] = itemId })
	else
		if CARS[plate][itemId] then
			item = CARS[plate][itemId]
			item.quantity = item.quantity + qty
			CARS[plate][itemId] = {quantity = item.quantity, libelle = lib}
		else
			CARS[plate][itemId] = {quantity = qty, libelle = lib}
		end
	end
end


function delete(arg)
    local itemId = arg[1]
    local qty = arg[2]
    local plate = arg[3]
    local item = arg[4]
    item.quantity = item.quantity - qty
	local pl = getplate()
	if pl then
    	MySQL.Async.execute('UPDATE vehicle_inventory SET `quantity` = @qty WHERE `plate` = @plate AND `item` = @item',
    	{ ['@plate'] = plate, ['@qty'] = tonumber(item.quantity), ['@item'] = tonumber(itemId) })
	end
end


function addP(arg)
    local itemId = arg[1]
    local qty = arg[2]
	local identifier = arg[3]
    local lib = arg[4]
    local query
    local item
    if ply[identifier][itemId] then
        item = ply[identifier][itemId]
        item.quantity = item.quantity + qty
    else
        ply[identifier][itemId] = {quantity = qty, libelle = lib}
        item = ply[identifier][itemId]
    end
end


function deleteP(arg)
    local itemId = arg[1]
    local qty = arg[2]
    local plate = arg[3]
    local item = arg[4]
    item.quantity = item.quantity - qty
end


function getPods(plate)
    local pods = 0
	if CARS[plate] then
	    for _, v in pairs(CARS[plate]) do
			if v.quantity ~= nil then
				if tonumber(_) > 2 then
        			pods = pods + v.quantity
				end
			end
    	end
	end
    return pods
end


function getPods2(plate)
    local pods = 0
	if CARS[plate] then
	    for _, v in pairs(CARS[plate]) do
			if v.quantity ~= nil then
		        pods = pods + v.quantity
			end
		end
	end
    return pods
end


function getPodsPed(identifier)
    local pods = 0
	if ply[identifier] then
	    for _, v in pairs(ply[identifier]) do
			if v.quantity ~= nil then
				if tonumber(_) > 2 then
    			    pods = pods + v.quantity
				end
			end
	    end
	end
    return pods
end


function getPodsPed2(identifier)
    local pods = 0
	if ply[identifier] then
	    for _, v in pairs(ply[identifier]) do
			if v.quantity ~= nil then
		        pods = pods + v.quantity
			end
    	end
	end
    return pods
end

-- get's the player id without having to use bugged essentials
function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getplate()
	local repo = {}
	local repo = MySQL.Sync.fetchAll('SELECT vehicle_plate AS plate FROM user_vehicle WHERE vehicle_plate = @plate',{['@plate']=plate})
	if repo[1]~= nil then
		return true
	else
		return false
	end
	return repo
end


function getitema(plate)
	local repo = {}
	local repo = MySQL.Sync.fetchAll('SELECT item AS plate FROM vehicle_inventory WHERE plate = @plate',{['@plate']=plate})
	return repo
end

-- gets the actual player id unique to the player,
-- independent of whether the player changes their screen name
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function stringSplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}
  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end
  return t
end
