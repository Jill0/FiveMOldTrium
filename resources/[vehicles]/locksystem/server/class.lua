function CreateCar(localVehId, plate, identifier, source, status)
	local self = {}

	self.vehId 		= localVehId 
	self.plate		= plate
	self.status		= status or 0
	self.owner 		= identifier 	-- Main owner
	self.owners		= {identifier} 	-- All owners

	local class = {}

	class.get = function(k)
		return self[k]
	end

	class.set = function(k, v)
		self[k] = v
	end

	class.isOwner = function(identifier)
		local countOwner = 0
		for i=1, (#self.owners)do
			if(self.owners[i] == identifier)then
				countOwner = countOwner + 1
			end
		end
		if(countOwner > 0)then
			return true
		else
			return false
		end
	end

	class.giveKey = function(src, target)
			local srcId = GetPlayerIdentifiers(src)[1]
			local targetId = GetPlayerIdentifiers(target)[1]
			print(tostring(srcId) .. " - " .. tostring(targetId))
		if(srcId ~= targetId)then
			if(self.owner == srcId)then
				table.insert(self.owners, targetId)
				Notify(src, "Double de clés donné à " .. GetPlayerName(target))
				Notify(target, "Double de clés reçu de " .. GetPlayerName(src))
				TriggerClientEvent('vehicleMenu:addkey', target, self.plate, true)
			else
				Notify(src, "Vous ne pouvez pas donner un double")
			end
		else
			TriggerClientEvent('chatMessage', src, '', {255, 255, 255}, '^1You can not target yourself.')
		end
	end

	return class
end