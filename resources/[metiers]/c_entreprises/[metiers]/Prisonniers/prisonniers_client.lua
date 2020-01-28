local isInServicePrisonnier = false

function isInServicePrisonnierBool()
    return isInServicePrisonnier
end

function SetServicePrisonnier()
	isInServicePrisonnier = true
	GetSkinPrisonnier()
end
function SetPrisonnier()
	if isInServicePrisonnier then
        DisplayHelpText('Vous êtes de nouveau libre', 0, 1, 0.5, 0.8, 0.6, 155, 105, 95, 255)
        TriggerServerEvent("skin_customization:SpawnPlayer")
		TriggerServerEvent('metiers:jobsadminadmin',1)
        isInServicePrisonnier = not isInServicePrisonnier
    else
		TriggerServerEvent('metiers:jobsadminadmin',28)
        DisplayHelpText('Vous êtes désormais incarcéré à la Prison Fédérale de Los Santos', 0, 1, 0.5, 0.8, 0.6, 155, 105, 95, 255)
		GetSkinPrisonnier()
        isInServicePrisonnier = true
    end
	end


function GetSkinPrisonnier()
    local hashSkin = GetHashKey("mp_m_freemode_01")
    Citizen.CreateThread(function()
        if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
            SetPedComponentVariation(GetPlayerPed(-1), 11, 5, 0, 2) -- Top
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) -- under coat
            SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 7, 2) -- Pants
            SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 6, 2) -- shoes
            SetPedComponentVariation(GetPlayerPed(-1), 3, 5, 0, 2) -- under skin
        else
            SetPedComponentVariation(GetPlayerPed(-1), 11, 73, 0, 2) -- Top
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) -- under coat
            SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 15, 2) -- Pants
            SetPedComponentVariation(GetPlayerPed(-1), 6, 27, 0, 2) -- shoes
            SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2) -- under skin
        end
    end)
end
function RangerCamion(result)
    local vehiculeDetected = GetClosestVehicle(result.coordx, result.coordy, result.coordz, 6.0, 0, 70)
    if DoesEntityExist(vehiculeDetected) then
        SetEntityAsMissionEntity(vehiculeDetected, true, true)
        DeleteVehicle(vehiculeDetected)
    end
    Menu.hidden = true
end

function GetVehiclePrisonnier(x, y, z, vehicules,PlayerId)
    ClearMenu()
    options.menu_title = "Prisonniers"
    options.menu_subtitle = "Vehicules"
    Menu.selection = 1
    for k, v in pairs(vehicules) do
        Menu.addButton(v.nom, "PrisonnierSpawnCar", {model = v.model, coordx = x, coordy = y, coordz = z,id=PlayerId})
    end
	Menu.addButton("Ranger le Camion", "RangerCamion", {coordx = x, coordy = y, coordz = z})
end

function PrisonnierSpawnCar(result)
    local vehiculeDetected = GetClosestVehicle(result.coordx, result.coordy, result.coordz, 6.0, 0, 70)
    if not DoesEntityExist(vehiculeDetected) and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        local myPed = GetPlayerPed(-1)
        local vehicle = GetHashKey(result.model)
		local id=result.id
		local Nb = math.random(100, 900)
		
		local Prefix= "PR"
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
