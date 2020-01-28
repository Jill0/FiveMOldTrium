
Citizen.CreateThread(function()
    local angle = 0.0
    local speed = 0.0
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        if DoesEntityExist(veh) then
            local tangle = GetVehicleSteeringAngle(veh)
            if tangle > 10.0 or tangle < -10.0 then
                angle = tangle
            end
            speed = GetEntitySpeed(veh)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
            if speed < 0.1 and DoesEntityExist(vehicle) and not GetIsTaskActive(PlayerPedId(), 151) and not GetIsVehicleEngineRunning(vehicle) then
                SetVehicleSteeringAngle(GetVehiclePedIsIn(PlayerPedId(), true), angle)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
            local engineWasRunning = GetIsVehicleEngineRunning(GetVehiclePedIsIn(ped, true))
            Citizen.Wait(1000)
            if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
                local veh = GetVehiclePedIsIn(ped, true)
                if (engineWasRunning) then
                    SetVehicleEngineOn(veh, true, true, true)
                end
            end
        end
    end
end)
