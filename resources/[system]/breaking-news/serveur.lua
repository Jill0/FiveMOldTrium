-- Kicking
TriggerEvent('es:addGroupCommand', 'breaknews', "admin", function(source, args, user)
    TriggerClientEvent("breaknews:receiveCommand", source)
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Vous n'avez pas la permission !")
end)

RegisterServerEvent('breaknews:receiveInfosBanner')
AddEventHandler('breaknews:receiveInfosBanner', function(first_line, second_line, third_line)
    TriggerClientEvent("breaknews:showBanner", -1, first_line, second_line, third_line)
end)
