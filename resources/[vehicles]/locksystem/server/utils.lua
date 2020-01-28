function TryToSteal()
	local randomNbr = math.random(1, 100)
	local percentage = globalConf['SERVER'].percentage

	if(randomNbr <= percentage)then
		return true
	else
		return false
	end
end

function Notify(source, text)
	TriggerClientEvent('ls:notify', source, text)
end