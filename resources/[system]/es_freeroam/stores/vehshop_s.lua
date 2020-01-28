
RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(name, vehicle, price)
  TriggerEvent('es:getPlayerFromId', source, function(user)
  if(user) then
    local player = user.identifier
    local vehicle = vehicle
    local name = name
    local price = tonumber(price)
    local result = MySQL.Sync.fetchAll('SELECT ID FROM user_vehicle WHERE identifier = @username',{['@username'] = player})
	local vehicles = {}
    if (result) then
      count = 0
      for _ in pairs(result) do
        count = count + 1
      end
      if count == 10 then
        TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
          icon = "CHAR_SIMEON",
            title = "Simeon",
            text = "Garage plein!\n",
        })
      else
        if (tonumber(user.money) >= tonumber(price)) then
          user.func.removeMoney((price))
          TriggerClientEvent('FinishMoneyCheckForVeh', user.source, name, vehicle, price)
          TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                  icon = "CHAR_SIMEON",
                  title = "Simeon",
                  text = "Bonne route!\n",
              })
		  local result = MySQL.Sync.fetchAll('SELECT ID,vehicle_model,vehicle_name,vehicle_state,vehicle_plate FROM user_vehicle WHERE identifier = @username',{['@username'] = player})

			if (result) then
				for _, v in ipairs(result) do
					t = { ["id"] = v.ID, ["vehicle_model"] = v.vehicle_model, ["vehicle_name"] = v.vehicle_name, ["vehicle_state"] = v.vehicle_state, ["vehicle_plate"] = v.vehicle_plate}
					vehicles[tonumber(v.ID)] = t
				end
			TriggerClientEvent('garages:getVehicles', user.source, vehicles)
			end
        else
          TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                  icon = "CHAR_SIMEON",
                  title = "Simeon",
                  text = "Fonds insuffisants!\n",
              })
       end
      end
   else
      if (tonumber(user.money) >= tonumber(price)) then
        user.func.removeMoney((price))
        TriggerClientEvent('FinishMoneyCheckForVeh', user.source, name, vehicle, price)
        TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_SIMEON",
                title = "Simeon",
                text = "Bonne route!\n",
            })
		local result = MySQL.Sync.fetchAll('SELECT ID,vehicle_model,vehicle_name,vehicle_state,vehicle_plate FROM user_vehicle WHERE identifier = @username',{['@username'] = player})

		if (result) then
        for _, v in ipairs(result) do
            t = { ["id"] = v.ID, ["vehicle_model"] = v.vehicle_model, ["vehicle_name"] = v.vehicle_name, ["vehicle_state"] = v.vehicle_state, ["vehicle_plate"] = v.vehicle_plate}
            vehicles[tonumber(v.ID)] = t
        end
         TriggerClientEvent('garages:getVehicles', user.source, vehicles)
    end
      else
        TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_SIMEON",
                title = "Simeon",
                text = "Fonds insuffisants!\n",
            })
      end
    end
	else
		TriggerEvent("es:bug")
		end
  end)
end)

RegisterServerEvent('BuyForVeh')
AddEventHandler('BuyForVeh', function(name, vehicle, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
  TriggerEvent('es:getPlayerFromId', source, function(user)
if(user) then
    local player = user.identifier
    local name = name
    local price = price
    local vehicle = vehicle
    local state = "Sorti"
    local primarycolor = primarycolor
    local secondarycolor = secondarycolor
    local pearlescentcolor = pearlescentcolor
    local wheelcolor = wheelcolor
    MySQL.Async.execute('INSERT INTO user_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_price`, `vehicle_plate`, `vehicle_state`, `vehicle_colorprimary`, `vehicle_colorsecondary`, `vehicle_pearlescentcolor`, `vehicle_wheelcolor`) VALUES (@username, @name, @vehicle, @price, @plate, @state, @primarycolor, @secondarycolor, @pearlescentcolor, @wheelcolor)',
    {['@username'] = player, ['@name'] = name, ['@vehicle'] = vehicle, ['@price'] = price, ['@plate'] = plate, ['@state'] = state, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor})
else
		TriggerEvent("es:bug")
		end
  end)
end)
