local enableWeatherControl = true
-- Set this to true if you want this resource to set the weather to xmas for you.
-- DO NOT SET THIS TO TRUE IF YOU HAVE ANOTHER RESOURCE ALREADY MANAGING/SYNCING THE WEATHER FOR YOU.
-- No need to touch anything below.
Citizen.CreateThread(function()
    showHelp = true
    while true do
        if enableWeatherControl then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
            SetWeatherTypeNowPersist('XMAS')
        end
        Citizen.Wait(0) -- prevent crashing
        if IsNextWeatherType('XMAS') then
            RequestAnimDict('anim@mp_snowball') -- pre-load the animation
            if IsControlJustReleased(0, 119) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPlayerFreeAiming(PlayerId()) and not IsPedSwimming(PlayerPedId()) and not IsPedSwimmingUnderWater(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedRunning(PlayerPedId()) and not IsPedSprinting(PlayerPedId()) then -- check if the snowball should be picked up
                TaskPlayAnim(PlayerPedId(), 'anim@mp_snowball', 'pickup_snowball', 8.0, -1, -1, 0, 1, 0, 0, 0) -- pickup the snowball
                Citizen.Wait(1950) -- wait 1.95 seconds to prevent spam clicking and getting a lot of snowballs without waiting for animatin to finish.
                GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_SNOWBALL'), 2, false, true) -- get 2 snowballs each time.
            end
            if not IsPedInAnyVehicle(GetPlayerPed(-1), true) --[[and not IsPlayerFreeAiming(PlayerId())]] then
                if showHelp then
                    showHelpNotification()
                end
                showHelp = false
            else
                showHelp = true
            end
        end
        if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey('WEAPON_SNOWBALL') then
            --SetPlayerWeaponDamageModifier(PlayerId(), 0.0)
            SetPedSuffersCriticalHits(GetPlayerPed(-1), false)
            NetworkSetFriendlyFireOption(false)
			SetCanAttackFriendly(playerPed, false, false)
        else
        	NetworkSetFriendlyFireOption(true)
			SetCanAttackFriendly(playerPed, true, true)
            SetPedSuffersCriticalHits(GetPlayerPed(-1), true)
        end
    end
end)

function showHelpNotification()
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName("Appuie sur ~INPUT_VEH_FLY_VERTICAL_FLIGHT_MODE~ à pied pour ramasser 2 ~b~boules de neige~w~ !")
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

AddEventHandler('playerSpawned', function()
    showHelpNotification()
end)
