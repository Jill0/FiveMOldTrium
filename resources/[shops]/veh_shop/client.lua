--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 21/06/2017
-- Time: 14:27
-- To change this template use File | Settings | File Templates.
--

local boats = {
    { name= 'dinghy', model="dinghy", price = 265000 },
    { name= 'jetmax', model="jetmax", price = 470000 },
    { name= 'marquis', model="marquis", price = 413950 },
    { name= 'seashark', model="seashark", price = 40000 },
    { name= 'speeder', model="speeder", price = 530000 },
    { name= 'squalo', model="squalo", price = 280000 },
    { name= 'suntrap', model="suntrap", price = 250000 },
    { name= 'toro', model="toro", price = 850000 },
    { name= 'tropic', model="tropic", price = 250000 },
}

local copter = {
    { name= 'Buzzard2' ,model= "buzzard2", price = 1750000 },
    { name= 'Frogger' ,model= "frogger", price = 1300000 },
    { name= 'Maverick' ,model="maverick", price = 780000 },
    { name= 'Supervolito2' ,model="supervolito2", price = 3300000 },
    { name= 'Swift' ,model="swift", price = 1800000 },
    { name= 'Swift2' ,model="Swift2", price = 5150000 },
    { name= 'Volatus' ,model="volatus", price = 2300000 }
}

local cars = {}
local planes = {}
local currentUiState = false
local currentspawnzone = { x=0, y=0, z=0, direction = 0 }
local currentActionZone = { x=0, y=0, z=0 }


local locations = {
    { name= 'Achat de bateau', x = -778.807312011719, y= -1494.95544433594, z= 1.94091629981995, direction =  109.849670410156, spawn_x = -800.128967285156, spawn_y= -1504.12890625, spawn_z= 1.074324464797974, activationDist=10.5, markerWidth = 1.05001, markerType= 410, markerColor= 70, spawnable=2 },
    { name= "Achat d'helicoptères", x = -734.538696289063, y= -1456.7744140625, z= 5.00052165985107, direction = 124.473701477051, spawn_x = -743.796203613281, spawn_y= -1466.3525390625, spawn_z= 5.00051927566528, activationDist=10.5, markerWidth = 1.05001, markerType= 43, markerColor= 70, spawnable=3 },
    --{ name= "Achat d'helicoptères", x = 1745.947265625, y= 3251.03198242188, z= 41.5154838562012, direction = 87.4193420410156, spawn_x = 1744.2939453125, spawn_y= 3238.42846679688, spawn_z= 40.8155670166016, activationDist=10.5, markerWidth = 1.05001, markerType= 43, markerColor= 70, spawnable=3 }
}

RegisterNetEvent('garages:addvhltothelist')
AddEventHandler('garages:addvhltothelist', function(vhl)
    local toadd = { key= vhl.name, model=vhl.model, state= vhl.state, plate= vhl.plate }
    SendNUIMessage({addlist = json.encode(toadd)})
end)

function openGui(spawnable)
    SetNuiFocus(true)
    SendNUIMessage({ openUI = true })
    SendNUIMessage({ spawnable = json.encode({spawnable = spawnable}) })
end
function closeGui()
    SetNuiFocus(false)
    SendNUIMessage({ closeUI = true })
    FreezeEntityPosition(GetPlayerPed(-1),false)
    SetEntityVisible(GetPlayerPed(-1),true)
    currentUiState = false
end

-------------------------------------------------- NUI LISTENER --------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('close', function(data, cb)
    closeGui()
    cb('ok')
end)

RegisterNetEvent('veh_shop:closeGui')
AddEventHandler('veh_shop:closeGui', function()
    closeGui()
end)

RegisterNUICallback('init', function(data, cb)
    local list = {}
    local type = 0
    if data.spawnable == 1 then
        list = cars
        type = 1
    elseif data.spawnable == 2 then
        list = boats
        type = 2
    elseif data.spawnable == 3 then
        list = copter
        type = 3
    elseif data.spawnable == 4 then
        list = planes
        type = 4
    else
        cb('ok')
        closeGui()
        CancelEvent()
    end
    for k, vhl in ipairs(list)  do
        local toadd = { key= vhl.name, model= vhl.model, visible = true, price= vhl.price, type= type }
        if k > 10 then
            toadd.visible = false
        end
        SendNUIMessage({addlist = json.encode(toadd)})
    end
    cb('ok')
end)

local oldSpawned = 0
RegisterNUICallback('showcase', function(data, cb)
    if oldSpawned then
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(oldSpawned))
    end
    FreezeEntityPosition(GetPlayerPed(-1),true)
    SetEntityVisible(GetPlayerPed(-1),false)
    local car = GetHashKey(data.model)
    RequestModel(car)
    if not data.model then
        SetEntityCoords(GetPlayerPed(-1), currentActionZone.x,currentActionZone.y,currentActionZone.z, 1, 0, 0, 1)
    else
        while not HasModelLoaded(car) do
            Citizen.Wait(0)
        end
        local veh = CreateVehicle(car, currentspawnzone.x,currentspawnzone.y,currentspawnzone.z,  currentspawnzone.direction, false, false)
        oldSpawned = veh
        FreezeEntityPosition(veh,true)
        SetEntityInvincible(veh,true)
        SetVehicleDoorsLocked(veh,4)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1),veh,-1)
        local id = NetworkGetNetworkIdFromEntity(veh)
        SetNetworkIdCanMigrate(id, true)
    end
    cb('ok')
end)

RegisterNUICallback('buy', function(data, cb)
    data.name = GetDisplayNameFromVehicleModel(data.model)
    TriggerServerEvent('veh_shop:checkMoney', data)
    cb('ok')
end)

RegisterNUICallback('removeold', function(data, cb)
    if oldSpawned then
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(oldSpawned))
    end
    SetEntityCoords(GetPlayerPed(-1), currentActionZone.x,currentActionZone.y,currentActionZone.z, 1, 0, 0, 1)
    cb('ok')
end)

RegisterNetEvent('veh_shop:writePlaque')
AddEventHandler('veh_shop:writePlaque', function(vhl)
    closeGui()
    local buyer = GetPlayerPed(-1)
    vhl.primary_red, vhl.primary_green, vhl.primary_blue   = GetVehicleCustomPrimaryColour( oldSpawned )
    vhl.secondary_red, vhl.secondary_green, vhl.secondary_blue = GetVehicleCustomSecondaryColour( oldSpawned )
    vhl.extra ,vhl.wheelcolor = GetVehicleExtraColours(oldSpawned)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "Plaque", "", "", "", 8)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        local result = tostring(GetOnscreenKeyboardResult())
        vhl.plate = result
        SetVehicleNumberPlateText(oldSpawned, result)
        TriggerServerEvent('veh_shop:buyit', vhl)
    else
        SetEntityCoords(buyer, currentActionZone.x,currentActionZone.y,currentActionZone.z, 1, 0, 0, 1)
        closeGui()
    end
end)
RegisterNetEvent('veh_shop:spawnnewvhl')
AddEventHandler('veh_shop:spawnnewvhl', function(vhl)
    FreezeEntityPosition(GetPlayerPed(-1),false)
    SetEntityVisible(GetPlayerPed(-1),true)
    local customs = json.decode(vhl.customs)
    if oldSpawned then
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(oldSpawned))
    end
    local model = tonumber(vhl.model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    local veh = CreateVehicle(model, currentspawnzone.x,currentspawnzone.y,currentspawnzone.z,  currentspawnzone.direction, true, false)
    oldSpawned = veh
    SetPedIntoVehicle(GetPlayerPed(-1), veh, -1)
    SetModelAsNoLongerNeeded(model)
    SetVehicleNumberPlateText(veh, vhl.plate)
    SetVehicleOnGroundProperly(veh)
    SetVehicleHasBeenOwnedByPlayer(veh,true)
    SetEntityAsMissionEntity(veh, true, true)
    local id = NetworkGetNetworkIdFromEntity(veh)
    SetNetworkIdCanMigrate(id, true)

    -- Set ModKit to changes apply
    SetVehicleModKit(veh, 0 )
    -- Set color Primary
    SetVehicleModColor_1(veh, customs.color.type, 0,0)
    SetVehicleCustomPrimaryColour(veh, customs.color.primary.red,  customs.color.primary.green,  customs.color.primary.blue)
    -- Set color Secondary
    SetVehicleModColor_2(veh, customs.color.type, 0,0)
    SetVehicleCustomSecondaryColour(veh, customs.color.secondary.red,  customs.color.secondary.green,  customs.color.secondary.blue)

    -- Set perlescent
    SetVehicleExtraColours(veh, customs.color.perlescent, customs.wheels.color)
end)

RegisterNetEvent('veh_shop:notifs')
AddEventHandler('veh_shop:notifs', function(notif)
    drawNotification(notif)
end)

function DrawMarkers(type, x,y,z,markerWidth, markerColorRed, markerColorGreen, markerColorBlue, markerAlpha)
    -- drawMarker(type, posX, posY, posZ, dirX, dirY, dirZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ, colorR, colorG, colorB, alpha, bobUpAndDown, faceCamera, p19, rotate, textureDict, textureName, drawOnEnts);
    DrawMarker(type, x, y, z, 1.5, 0, 0, 0, 0, 0, markerWidth,  markerWidth,0.751, markerColorRed, markerColorGreen, markerColorBlue,markerAlpha, 1,0,0, 0, 0, 0,0)
end

function setMapMarkers(locations)
    for k,v in ipairs(locations)do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, v.markerType)
        SetBlipColour(blip, v.markerColor)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.name)
        EndTextCommandSetBlipName(blip)
    end
end
function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
Citizen.CreateThread(function()
    setMapMarkers(locations)
    while true do
        Citizen.Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1), false)
        -- local hotdog = GetHashKey('prop_weed_01')
        -- local stand = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0001, hotdog, false, false, false)
        -- zCitizen.Trace(stand)
        for _,d in ipairs( locations )do
            if Vdist(d.x, d.y, d.z, pos.x, pos.y, pos.z) < 200.0 then
                DrawMarkers(29, d.x, d.y, d.z +1.5, d.markerWidth, 255, 215, 0, 200)
            end
            if(Vdist(d.x, d.y, d.z, pos.x, pos.y, pos.z) < d.activationDist ) then
                SetTextComponentFormat("STRING")
                AddTextComponentString(" ~INPUT_CONTEXT~ pour acceder au magasin.")
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end
            if(IsControlJustReleased(1, 38) and Vdist(d.x, d.y, d.z, pos.x, pos.y, pos.z) <  d.activationDist ) then
                if currentUiState == false then
                    openGui(d.spawnable)
                    currentActionZone = {
                        x = d.x,
                        y = d.y,
                        z= d.z,
                    }
                    currentspawnzone = {
                        x = d.spawn_x,
                        y = d.spawn_y,
                        z= d.spawn_z,
                        direction = d.direction
                    }
                    currentUiState = true
                else
                    closeGui()
                    currentUiState = false
                end
            end
        end

    end
end)
