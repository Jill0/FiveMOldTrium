RegisterServerEvent('velo:CheckMoneyForVel')

AddEventHandler('velo:CheckMoneyForVel', function(name, vehicle, price)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local vehicle = vehicle
    local name = name
    local price = tonumber(price)

        if (tonumber(user.money) >= tonumber(price)) then
          user.func.removeMoney((price))
          TriggerClientEvent('velo:FinishMoneyCheckForVel', user.source, name, vehicle, price)
          TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
            icon = "CHAR_SIMEON",
            title = "Simeon",
            text = "Bonne route!\n",
          })

        else
          TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
            icon = "CHAR_SIMEON",
            title = "Simeon",
            text = "Fonds insuffisants!\n",
          })
       end
    end)
end)
