-- OUVRIR AVEC /help --
TriggerEvent('es:addCommand', 'help', function(source, args, user)
    TriggerClientEvent('helper:openHelp', source)
end)