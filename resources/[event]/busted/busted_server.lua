TriggerEvent('es:addCommand', 'busted', function(source, args, user)
	TriggerClientEvent('busted:openMenu', source)
end)