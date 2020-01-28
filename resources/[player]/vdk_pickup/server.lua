local pickups_activated = {}

RegisterServerEvent('vdk_pickup:addpickup')
AddEventHandler('vdk_pickup:addpickup', function(playerx, playery, playerz, item, qty)
	local idtab = math.random(0, 9999999999)
	if #pickups_activated > 0 then
		while detectconflit(idtab) == true do
			idtab = math.random(0, 9999999999)
		end
	end
	table.insert(pickups_activated, { ['playerx'] = playerx, ['playery'] = playery, ['playerz'] = playerz, ['item'] = item, ['id'] = idtab, ['qty'] = qty })
	TriggerClientEvent('vdk_pickup:addpickupclient', -1, playerx, playery, playerz, item, idtab, qty)
end)

RegisterServerEvent('vdk_pickup:rempickup')
AddEventHandler('vdk_pickup:rempickup', function(idtab)
	for k, v in ipairs(pickups_activated) do
		if v.id == idtab then
			table.remove(pickups_activated, k)
			TriggerClientEvent('vdk_pickup:rempickupclient', -1, idtab)
			break
		end
	end
end)

RegisterServerEvent('vdk_pickup:recuperationpickups')
AddEventHandler('vdk_pickup:recuperationpickups', function()
	local mysource = source
	if #pickups_activated > 0 then
		for k, v in ipairs(pickups_activated) do
			TriggerClientEvent('vdk_pickup:addpickupclient', mysource, v.playerx, v.playery, v.playerz, v.item, v.id, v.qty)
		end
	end
end)

function detectconflit(idtab)
	local conflit = false
	for k, v in ipairs(pickups_activated) do
		if v.id == idtab then
			conflit = true
			break
		end
	end
	return conflit
end
