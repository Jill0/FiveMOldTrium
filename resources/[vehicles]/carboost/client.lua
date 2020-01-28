AddEventHandler("playerSpawned", function()
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        while true do
            if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
                local veh = GetVehiclePedIsUsing(ped)
                if(GetPedInVehicleSeat(veh, -1) == ped) then
                    if(GetVehicleClass(veh) == 7 or GetVehicleClass(veh) == 8) then
                        SetVehicleEngineTorqueMultiplier(veh, 1 + 1.001)
                        SetVehicleEnginePowerMultiplier(veh, 1.5)
                    end
                    if(GetVehicleClass(veh) == 19 or GetVehicleClass(veh) == 18) then
                    	SetVehicleEngineTorqueMultiplier(veh, 1.5 + 1.001)
                        SetVehicleEnginePowerMultiplier(veh, 2.0)
                    end
                end
            end
            Citizen.Wait(1)
        end
    end)
end)
