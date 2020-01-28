Citizen.CreateThread(function()
    local isDead = false
    local hasBeenDead = false
    local diedAt

    while true do
        Wait(0)

        Citizen.Trace(getWeaponName(3218215474))

        local player = PlayerId()

        if NetworkIsPlayerActive(player) then
            local ped = PlayerPedId()

            if IsPedFatallyInjured(ped) and not isDead then
                isDead = true
                if not diedAt then
                    diedAt = GetGameTimer()
                end

                local killer, killerweapon = NetworkGetEntityKillerOfPlayer(player)
                local killerentitytype = GetEntityType(killer)
                local pedKiller = GetPedSourceOfDeath(GetPlayerPed(-1))
                local deathCauseHash = GetPedCauseOfDeath(GetPlayerPed(-1))
                local killertype = -1
                local killerinvehicle = false
                local killervehiclename = ''
                local killervehicleseat = 0
                if killerentitytype == 1 then
                    killertype = GetPedType(killer)
                    if IsPedInAnyVehicle(killer, false) == 1 then
                        killerinvehicle = true
                        killervehiclename = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(killer)))
                        killervehicleseat = GetPedVehicleSeat(killer)
                    else
                        killerinvehicle = false
                    end
                end

                local killerid = GetPlayerByEntityID(killer)
                if killer ~= ped and killerid ~= nil and NetworkIsPlayerActive(killerid) then
                    killerid = GetPlayerServerId(killerid)
                else
                    killerid = -1
                end

                if killer == ped or killer == -1 then
                    TriggerServerEvent('antitroll2:onPlayerDied', killertype, { table.unpack(GetEntityCoords(ped)) })
                    hasBeenDead = true
                else
                    TriggerServerEvent('antitroll2:onPlayerKilled', killerid, {
                        pedKiller = pedKiller,
                        deathCauseHash = deathCauseHash,
                        killerType = killertype,
                        weaponHash = killerweapon,
                        killerInVeh = killerinvehicle,
                        killerVehSeat = killervehicleseat,
                        killerVehName = killervehiclename,
                        weaponName = getWeaponName(killerweapon),
                        -- weaponLabel = getWeaponName(GetLabelText(weapon)),
                        killerPos = {table.unpack(GetEntityCoords(ped))}
                    })
                    Citizen.Trace("Name")
                    -- Citizen.Trace(getWeaponName(killerweapon))
                    hasBeenDead = true
                end
            elseif not IsPedFatallyInjured(ped) then
                isDead = false
                diedAt = nil
            end

            -- check if the player has to respawn in order to trigger an event
            if not hasBeenDead and diedAt ~= nil and diedAt > 0 then
                TriggerServerEvent('antitroll2:onPlayerWasted', { table.unpack(GetEntityCoords(ped)) })
                hasBeenDead = true
            elseif hasBeenDead and diedAt ~= nil and diedAt <= 0 then
                hasBeenDead = false
            end
        end
    end
end)

function GetPlayerByEntityID(id)
    for i=0,32 do
        if (NetworkIsPlayerActive(i) and GetPlayerPed(i) == id) then
            return i
        end
    end
    return nil
end
