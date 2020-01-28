--
-- @Project: Trium
-- @License: No License
--

local owner = "steam:110000104e439e3" -- Alexandre  McKelly
local subOwner = "steam:110000102592438"
local name = "auction"

function changeStatus(source, vehicle_plate, vehicle_state)
	MySQL.Async.execute("UPDATE user_vehicle SET `vehicle_state` = @vehicle_state, `identifier` = @identifier WHERE vehicle_plate = @vehicle_plate",
		{ ['@vehicle_plate'] = vehicle_plate, ['@vehicle_state'] = vehicle_state, ['@identifier'] = name })
end

RegisterServerEvent('auction:stroreVehicule')
AddEventHandler('auction:stroreVehicule', function (vehicle_plate, vehicle_state)

	local source = source
	local user = exports["essentialmode"]:getPlayerFromId(source)

 	if user.identifier == owner or user.identifier == subOwner then
		changeStatus(source, vehicle_plate, vehicle_state)
		TriggerClientEvent("auction:stroreVehicule", source)
	else
		TriggerClientEvent("ft_libs:Notification", source, "Vous ne pouvez pas faire ceci !")
	end

end)

RegisterServerEvent('auction:changeStatus')
AddEventHandler('auction:changeStatus', function (vehicle_plate, vehicle_state)
	changeStatus(source, vehicle_plate, vehicle_state)
end)

RegisterServerEvent('auction:changeOwner')
AddEventHandler('auction:changeOwner', function (vehicle_plate, playerID)
	local user = exports["essentialmode"]:getPlayerFromId(playerID)
	MySQL.Async.execute("UPDATE user_vehicle SET `identifier` = @identifier WHERE vehicle_plate = @vehicle_plate",
		{ ['@identifier'] = user.identifier, ['@vehicle_plate'] = vehicle_plate })
end)

RegisterServerEvent('auction:openMenu')
AddEventHandler('auction:openMenu', function (total)

	local source = source
	local user = exports["essentialmode"]:getPlayerFromId(source)

  if user.identifier == owner or user.identifier == subOwner then
    MySQL.Async.fetchAll(
			"SELECT * FROM user_vehicle WHERE identifier = @identifier",
      { ['@identifier'] = name },
      function (result)
        if result[1] ~= nil then
					TriggerClientEvent("auction:openMenu", source, result)
        else
        	TriggerClientEvent("ft_libs:Notification", source, "Il n'y à pas de vehicule disponible !")
        end
      end
    )

  else
    TriggerClientEvent("ft_libs:Notification", source, "Vous ne pouvez pas ouvrir ce menu !")
  end

end)
