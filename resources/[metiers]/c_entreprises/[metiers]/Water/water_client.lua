local isInServiceWater = false


function isInServiceWaterBool()
    return isInServiceWater
end
function GetServiceWater()
    local playerPed = GetPlayerPed(-1)
    if isInServiceWater then
        DisplayHelpText('Fin du service', 0, 1, 0.5, 0.8, 0.6, 155, 105, 95, 255)
        TriggerServerEvent("skin_customization:SpawnPlayer")
        isInServiceWater = not isInServiceWater
    else
        DisplayHelpText('Début du service', 0, 1, 0.5, 0.8, 0.6, 155, 105, 95, 255)
        GetSkinWater()
        isInServiceWater = true
    end
end

function GetSkinWater()
    local hashSkin = GetHashKey("mp_m_freemode_01")
    Citizen.CreateThread(function()
        if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
            SetPedComponentVariation(GetPlayerPed(-1), 11, 66, 1, 2) -- Top
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) -- under coat
            SetPedComponentVariation(GetPlayerPed(-1), 4, 39, 1, 2) -- Pants
            SetPedComponentVariation(GetPlayerPed(-1), 6, 27, 0, 2) -- shoes
            SetPedComponentVariation(GetPlayerPed(-1), 3, 66, 0, 2) -- under skin
        else
            SetPedComponentVariation(GetPlayerPed(-1), 11, 60, 1, 2) -- Top
            SetPedComponentVariation(GetPlayerPed(-1), 8, 2, 0, 0) -- under coat
            SetPedComponentVariation(GetPlayerPed(-1), 4, 39, 1, 2) -- Pants
            SetPedComponentVariation(GetPlayerPed(-1), 6, 26, 0, 2) -- shoes
            SetPedComponentVariation(GetPlayerPed(-1), 3, 75, 0, 2) -- under skin
        end
    end)
end

function GetVehicleWater(x, y, z, vehicules,PlayerId)
    ClearMenu()
    options.menu_title = "Waters"
    options.menu_subtitle = "Vehicules"
    Menu.selection = 1
    for k, v in pairs(vehicules) do
        Menu.addButton(v.nom, "WaterSpawnCar", {model = v.model, coordx = x, coordy = y, coordz = z,id=PlayerId})
		Menu.addButton("Ranger le Camion", "water_RangerCamion", {coordx = x, coordy = y, coordz = z})
        
    end
end

function water_RangerCamion(result)
    local vehiculeDetected = GetClosestVehicle(result.coordx, result.coordy, result.coordz, 6.0, 0, 70)
    if DoesEntityExist(vehiculeDetected) then
        SetEntityAsMissionEntity(vehiculeDetected, true, true)
        DeleteVehicle(vehiculeDetected)
    end
    Menu.hidden = true
end

function WaterSpawnCar(result)
    local vehiculeDetected = GetClosestVehicle(result.coordx, result.coordy, result.coordz, 6.0, 0, 70)
    if not DoesEntityExist(vehiculeDetected) and not DoesEntityExist(trailDetected) and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        -- CAMION
        local vehicle = GetHashKey(result.model)
		local id=result.id
		local Nb = math.random(100, 900)
		
		local Prefix= "WA"
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
        local existingVeh = CreateVehicle(vehicle, result.coordx, result.coordy, result.coordz, 270.0, true, false)
		SetVehicleNumberPlateText(existingVeh,plateNb)
        SetVehicleHasBeenOwnedByPlayer(existingVeh, true)
        local id = NetworkGetNetworkIdFromEntity(existingVeh)
        SetNetworkIdCanMigrate(id, true)
        SetEntityInvincible(existingVeh, false)
        SetVehicleOnGroundProperly(existingVeh)
        SetEntityAsMissionEntity(existingVeh, true, true)
        SetVehicleFuelLevel(existingVeh, 100)
        local plate = GetVehicleNumberPlateText(existingVeh)
		SetVehicleMod(existingVeh,11,4) -- Engine
		SetVehicleMod(existingVeh,13,2) -- transmission
		ToggleVehicleMod(existingVeh,18,true) -- Turbo
        SetPedIntoVehicle(GetPlayerPed(-1), existingVeh, -1)
        TriggerServerEvent('ls:recevoircles', string.lower(plate), existingVeh)
        --
        
        Menu.hidden = true
    else
        DisplayHelpText('Zone Encombrée', 0, 1, 0.5, 0.8, 0.6, 155, 105, 95, 255)
        Menu.hidden = true
        Citizen.Wait(2000)
    end
end
