local isInServiceArboriculteur = false

function isInServiceArboriculteurBool()
    return isInServiceArboriculteur
end
function GetServiceArboriculteur()
    local playerPed = GetPlayerPed(-1)
    if isInServiceArboriculteur then
        DisplayHelpText('Fin du service', 0, 1, 0.5, 0.8, 0.6, 155, 105, 95, 255)
        TriggerServerEvent("skin_customization:SpawnPlayer")
        isInServiceArboriculteur = not isInServiceArboriculteur
    else
        DisplayHelpText('Début du service', 0, 1, 0.5, 0.8, 0.6, 155, 105, 95, 255)
        GetSkinArboriculteur()
        isInServiceArboriculteur = true
    end
end

function GetSkinArboriculteur()
    local hashSkin = GetHashKey("mp_m_freemode_01")
    Citizen.CreateThread(function()
        if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
            SetPedComponentVariation(GetPlayerPed(-1), 11, 208, 18, 0) -- Top
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0) -- under coat
            SetPedComponentVariation(GetPlayerPed(-1), 4, 59, 6, 0) -- Pants
            SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 0) -- shoes
            SetPedComponentVariation(GetPlayerPed(-1), 3, 151, 18, 0) -- under skin
        else
            SetPedComponentVariation(GetPlayerPed(-1), 11, 212, 18, 0) -- Top
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0) -- under coat
            SetPedComponentVariation(GetPlayerPed(-1), 4, 11, 3, 0) -- Pants
            SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 0) -- shoes
            SetPedComponentVariation(GetPlayerPed(-1), 3, 198, 18, 0) -- under skin
        end
    end)
end

function GetVehicleArboriculteur(x, y, z, vehicules,PlayerId)
    ClearMenu()
    options.menu_title = "Arboriculteurs"
    options.menu_subtitle = "Vehicules"
    Menu.selection = 1
    for k, v in pairs(vehicules) do
        Menu.addButton(v.nom, "ArboriculteurSpawnCar", {model = v.model, coordx = x, coordy = y, coordz = z,id=PlayerId})
    end
end

function ArboriculteurSpawnCar(result)
    local vehiculeDetected = GetClosestVehicle(result.coordx, result.coordy, result.coordz, 6.0, 0, 70)
    if not DoesEntityExist(vehiculeDetected) and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        local myPed = GetPlayerPed(-1)
        local vehicle = GetHashKey(result.model)
		local id=result.id
		local Nb = math.random(100, 900)
		
		local Prefix= "AR"
		if id < 10 then 
			plateNb = (Nb..Prefix.."00"..id)
		elseif id < 100 then 
			plateNb = (Nb..Prefix.."0"..id)
		elseif id < 1000 then 
			plateNb = (Nb..Prefix..""..id)
		elseif id < 10000  then
			plateNb = (id..id)
		end
        RequestModel(vehicle)
        while not HasModelLoaded(vehicle) do
            Wait(1)
        end
        local existingVeh = CreateVehicle(vehicle, result.coordx, result.coordy, result.coordz, 90.0, true, false)
		SetVehicleNumberPlateText(existingVeh,plateNb)
        SetVehicleHasBeenOwnedByPlayer(existingVeh, true)
        local id = NetworkGetNetworkIdFromEntity(existingVeh)
        SetNetworkIdCanMigrate(id, true)
        SetEntityInvincible(existingVeh, false)
        SetVehicleOnGroundProperly(existingVeh)
        SetEntityAsMissionEntity(existingVeh, true, true)
        SetVehicleFuelLevel(existingVeh, 100)
        local plate = GetVehicleNumberPlateText(existingVeh)
        SetPedIntoVehicle(myPed, existingVeh, -1)
        TriggerServerEvent('ls:recevoircles', string.lower(plate), existingVeh)
        Menu.hidden = true
    else
        DisplayHelpText('Zone Encombrée', 0, 1, 0.5, 0.8, 0.6, 155, 105, 95, 255)
        Menu.hidden = true
        Citizen.Wait(2000)
        SetEntityAsMissionEntity(vehiculeDetected, true, true)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehiculeDetected))
    end
end
