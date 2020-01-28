local Cars = {}

RegisterServerEvent("ls:checkallkeys")
AddEventHandler("ls:checkallkeys", function()
	local identifier = GetPlayerIdentifiers(source)[1]
	for k, v in pairs(Cars) do
		local owner = v.get('owner')
		if owner == identifier then
			TriggerClientEvent('vehicleMenu:addkey', source, v.get('plate'), false)
		else
			local owners = v.get('owners')
			for g, h in pairs(owners) do
				if h == identifier then
					TriggerClientEvent('vehicleMenu:addkey', source, v.get('plate'), true)
				end
			end
		end
	end
end)

RegisterServerEvent("ls:mainCheck")
AddEventHandler("ls:mainCheck", function(plate, vehicle, isPlayerInside)
	local src = source
	local identifier = GetPlayerIdentifiers(src)[1]
	local plate = string.gsub(string.lower(plate), " ", "")
	local car = Cars[plate]
	if(car ~= nil)then
		if(car.get('status') ~= 'blocked')then
			if(car.isOwner(identifier) == true)then
				TriggerClientEvent('ls:lock', src)
			else
				Notify(src, "Ce n'est pas votre vehicule.")
			end
		else
			Notify(src, "Les clés ne sont pas là.")
		end
	else
		if(isPlayerInside)then
			if(TryToSteal() == true)then
				Cars[plate] = CreateCar(vehicle, plate, identifier, src)
				Notify(src, "Vous avez trouvé les clés.")
				TriggerClientEvent('vehicleMenu:addkey', src, plate, false)
			else
				Cars[plate] = CreateCar(vehicle, plate, identifier, src, "blocked")
				Notify(src, "Vous n'avez pas trouvé les clés.")
			end
		end
	end
end)

RegisterServerEvent('ls:recevoircles')
AddEventHandler('ls:recevoircles', function(plate, vehicle)
	if plate and vehicle then
		local identifier = GetPlayerIdentifiers(source)[1]
		local plate = string.gsub(string.lower(plate), " ", "")
		local exist = false
		if (Cars[plate] ~= nil) then
			for k, v in pairs(Cars) do
				if v.get('plate') == plate then
					exist = true
					break
				end
			end
		end
		if not exist then
			Cars[plate] = CreateCar(vehicle, plate, identifier, source)
			TriggerClientEvent('vehicleMenu:addkey', source, plate, false)
		end
	end
end)

RegisterServerEvent('ls:retirercles')
AddEventHandler('ls:retirercles', function(plate)
	if plate then
		local identifier = GetPlayerIdentifiers(source)[1]
		local plate = string.gsub(string.lower(plate), " ", "")
		if Cars[plate] then
			if Cars[plate].get('owner') == identifier then
				for k, v in pairs(Cars) do
					if k == plate then
						Cars[k] = nil
						break
					end
				end
			else
				local owners = Cars[plate].get('owners')
				for k, v in pairs(owners) do
					if v == identifier then
						table.remove(owners, k)
						Cars[plate].set('owners', owners)
						break
					end
				end
			end
		end
		TriggerClientEvent('vehicleMenu:delkey', source, plate)
	end
end)

RegisterServerEvent('ls:givekey')
AddEventHandler('ls:givekey', function(player, plate)
	if (Cars[plate] ~= nil) then
		local identifier = GetPlayerIdentifiers(player)[1]
		local owners = Cars[plate].get('owners')
		local plate = string.gsub(string.lower(plate), " ", "")
		local isexist = false
		for k, v in pairs(owners) do
			if v == identifier then
				isexist = true
			end
		end
		if not isexist then
			Cars[plate].giveKey(source, player)
		end
	else
		Notify("~r~Le vehicule avec cette plaque n'existe pas.")
	end
end)

-- Piece of code from Scott's InteractSound script : https://forum.fivem.net/t/release-play-custom-sounds-for-interactions/8282
RegisterServerEvent('InteractSound_SV:PlayWithinDistance')
AddEventHandler('InteractSound_SV:PlayWithinDistance', function(maxDistance, soundFile, soundVolume)
    TriggerClientEvent('InteractSound_CL:PlayWithinDistance', -1, source, maxDistance, soundFile, soundVolume)
end)