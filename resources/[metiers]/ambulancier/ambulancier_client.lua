
local ambulancierIsInService = false
local spawnAmbulancierVehicleChoix = {}
local KEY_E = 38
local KEY_UP = 96 -- N+
local KEY_DOWN = 97 -- N-
local KEY_CLOSE = 177
local ambulancier_nbMissionEnAttenteText = '-- Aucune Info --'
local ambulancier_BlipMecano = {}
local ambulancier_showHelp = false
local listMissionsAmbulancier = {}
local currentMissionAmbulancier = nil
local ambulance_call_accept = 0
local ambulance_nbAmbulanceInService = 0
local ambulance_nbAmbulanceDispo = 0
----
local myVehiculeEntity = 0
local ambulancier_blipsTemp
local ambulancier_markerBool = false
local existingVeh = nil
isAmbulancier = false
local TEXTAMBUL = {
    SpawnVehicleImpossible = '~R~ Impossible, aucune place disponible',
    InfoAmbulancierNoAppel = '~g~Aucun appel en attente',
    InfoAmbulancierNbAppel = '~w~ Appel en attente',
    NoPatientFound = '~b~ Aucun patient a proximité',
    CALL_INFO_NO_PERSONNEL = '~r~Aucun ambulancier en service',
    CALL_INFO_ALL_BUSY = '~o~Tous nos ambulancier sont occupés',
    CALL_INFO_WAIT = '~b~Votre appel est sur attente',
    CALL_INFO_OK = '~g~Un ambulancier va arriver',
    CALL_RECU = 'Confirmation\nVotre appel à été enregistré',
    CALL_ACCEPT = 'Votre appel a été accepté, un ambulancier est en route',
    CALL_CANCEL = 'L\'ambulancier vient d\'abandonné votre appel',
    CALL_FINI = 'Votre appel a été résolu',
    CALL_EN_COURS = 'Vous avez déjà une demande en cours ...',
    MISSION_NEW = 'Un nouveau patient a été signalé, il y été ajouté dans votre liste de mission',
    MISSION_ACCEPT = 'Mission acceptée, mettez vous en route',
    MISSION_ANNULE = 'Votre patient s\'est décommandé',
    MISSION_CONCURENCE = 'Vous êtes plusieurs sur le coup',
    MISSION_INCONNU = 'Cette mission n\'est plus d\'actualité',
    MISSION_EN_COURS = 'Cette mission est déjà en cours de traitement'
}
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("ambulancier:checkIsAmbulancier")
    TriggerServerEvent("ambulancier:checkDead")
end)
RegisterNetEvent('ambulancier:killIt')
AddEventHandler('ambulancier:killIt', function()
    Citizen.CreateThread(function()
        Citizen.Wait(10000)
        SetEntityHealth(GetPlayerPed(-1), 0)
        notif("Vous vous êtes déconnecté mort !")
    end)
end)
RegisterNetEvent('ambulancier:receiveIsAmbulancier')
AddEventHandler('ambulancier:receiveIsAmbulancier', function(result)
    Citizen.Trace('isAmbulancier')
    if(result == '0') then
        isAmbulancier = false
        print("VOUS N'ETES PAS AMBULANCIER!")
    else
        isAmbulancier = true
        print("VOUS ETES AMBULANCIER!")
    end
end)
-- restart depanneur
ambulancier_platesuffix = "Ambu" --Suffix de la plaque d'imat
ambulancier_car = {--inutile
    x = 1161.79223632813,
    y = -1500,
    z = 34.0925659179688,
    h = 0.0
}
local ambulancier_Service = {-- Prise de service
    {x = 268.78, y = -1365.22, z = 23.54}, -- Central
    {x = 1828.38, y = 3691.88, z = 33.22}, -- Sandy Shore
    {x = -248.18, y = 6331.25, z = 31.43}-- Paleto Bay
}
--== HELIPAD ==--
local ambulancier_helico = {
    {xSortieV = 313.46, ySortieV = -1465.46, zSortieV = 46.60, hSortieV = 0.0, xMenu = 318.19, yMenu = -1451.77, zMenu = 45.51}, --Central
    {xSortieV = -484.29, ySortieV = 5994.36, zSortieV = 31.33, hSortieV = 284.35, xMenu = -476.64, yMenu = 6010.42, zMenu = 30.30}--Paleto
}
--ambulancier_helico_marqueur = {
--xMenu=318.19,  yMenu=-1451.77, zMenu=46.51, hMenu=0.0,
--}
local Casier_LSES = {
    {x = 263.69, y = -1361.96, z = 23.54} -- Central
}
--== GARAGE ==--
local ambulancier_garage = {-- spawn véhicules
    {xMenu = 390.67, yMenu = -1433.04, zMenu = 28.43, xSortieV = 376.84, ySortieV = -1444.36, zSortieV = 29.43, hSortieV = 229.05}, -- Central
    {xMenu = 1856.69, yMenu = 3704.16, zMenu = 33.27, xSortieV = 1859.93, ySortieV = 3710.07, zSortieV = 32.70, hSortieV = 30.0}, -- Sandy Shore
    {xMenu = -250.77, yMenu = 6339.39, zMenu = 31.49, xSortieV = -260.9, ySortieV = 6344.17, zSortieV = 32.0, hSortieV = 271.9}, -- Paleto Bay

}
--== BLIPS ==--
ambulancier_blips = {
    ["Garage LSES Central"] = {
        id = 50,
        x = 390.67,
        y = -1433.04,
        z = 29.0,
        name = "Garage LSES",
        distanceBetweenCoords = 2,
        distanceMarker = 2
    },
    ["Garage LSES Sandy "] = {
        id = 50,
        x = 1856.69,
        y = 3704.16,
        z = 31.49,
        name = "Garage LSES",
        distanceBetweenCoords = 2,
        distanceMarker = 2
    },
    ["Garage LSES Paleto"] = {
        id = 50,
        x = -250.77,
        y = 6339.39,
        z = 31.49,
        name = "Garage LSES",
        distanceBetweenCoords = 2,
        distanceMarker = 2
    },
    ["Helipad Central"] = {
        id = 43,
        x = 313.46,
        y = -1465.46,
        z = 46.60,
        name = "Helipad LSES",
        distanceBetweenCoords = 2,
        distanceMarker = 2
    },
    ["Helipad Paleto Bay"] = {
        id = 43,
        x = -484.29,
        y = 5994.36,
        z = 31.33,
        name = "Helipad LSES",
        distanceBetweenCoords = 2,
        distanceMarker = 2
    }}
    ambulancier_sortie = {-- coffre ????
        x = 256.1741027832,
        y = -1343.8316650391,
        z = 25.519506454468,
        h = 139.07209777832
    }
    --====================================================================================
    --  Gestion de prise et d'abandon de service
    --====================================================================================
    local function showBlipAmbulancier()
        for key, item in pairs(ambulancier_blips) do
            item.blip = AddBlipForCoord(item.x, item.y, item.z)
            SetBlipSprite(item.blip, item.id)
            SetBlipAsShortRange(item.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(item.name)
            EndTextCommandSetBlipName(item.blip)
        end
        ambulancier_blipsTemp = ambulancier_blips
    end
    local function removeBlipAmbulancier()
        ambulancier_markerBool = false
        for _, item in pairs(ambulancier_blips) do
            RemoveBlip(item.blip)
        end
    end
    local function drawHelpJobAmbulancier()
        local lines = {
            {text = '~o~Vous êtes en service !', isTitle = true, isCenter = true},
            {text = '~g~Votre rôle est de sauver ou de soigner les habitants de cette ville', isCenter = true, addY = 0.04},
            {text = ' - Récupérez un véhicule de fonction dans un des garages (Ambulances ou Hélicos)'},
            {text = ' - Lorsque qu\'une mission arrive, annoncez la en radio puis dirigez vous au plus vite vers la zone'},
            {text = ' - Une fois sur place analysez la situation et sauvez le patient'},
            {text = ' - Prévenez en radio lorsque la mission est terminée'},
            {text = ' - Complétez le formulaire avec le nom du patient ainsi que les soins effectués', addY = 0.04},
            --{ text = '~b~ Votre hiérarchie :', size = 0.4, addY = 0.04 },
            --{ text = '~g~James Hall ~w~ Directeur du LSES.'},
            --{ text = '~g~Matuidi Charo ~w~Chefs des équipes', addY = 0.04},
            --{ text = '~d~Merci de passer par les Chefs en priorité lorsque vous rencontrez un probléme', isCenter = true, addY = 0.06},
            {text = '~b~Soyez sérieux en service ! Bonne route !', isCenter = true},
        }
        DrawRect(0.5, 0.5, 0.48, 0.5, 0, 0, 0, 225)
        local y = 0.31 - 0.025
        local defaultAddY = 0.025
        local addY = 0.025
        for _, line in pairs(lines) do
            y = y + addY
            local caddY = defaultAddY
            local x = 0.275
            local defaultSize = 0.32
            local defaultFont = 8
            if line.isTitle == true then
                defaultFont = 1
                defaultSize = 0.8
                caddY = 0.06
            end
            SetTextFont(line.font or defaultFont)
            SetTextScale(0.0, line.size or defaultSize)
            SetTextCentre(line.isCenter == true)
            if line.isCenter == true then
                x = 0.5
            end
            SetTextDropShadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextColour(255, 255, 255, 255)
            SetTextEntry("STRING")
            AddTextComponentString(line.text)
            DrawText(x, y)
            addY = line.addY or caddY
        end
        SetTextComponentFormat("STRING")
        AddTextComponentString('~INPUT_CELLPHONE_CANCEL~ ~g~Ferme l\'aide')
        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
    end
    function Chat(t)
        TriggerEvent("chatMessage", 'AMBU', {0, 255, 255}, "" .. tostring(t))
    end
    function spawnVehicule(pos, type, livery)
        --deleteVehicle()
        local vehi = GetClosestVehicle(pos.xSortieV, pos.ySortieV, pos.zSortieV, 5.0, 0, 70)
        if not DoesEntityExist(vehi) then
            RequestModel(type)
            while not HasModelLoaded(type) do
                Wait(1)
            end
            local plate = math.random(100, 900)
            myVehiculeEntity = CreateVehicle(type, pos.xSortieV, pos.ySortieV, pos.zSortieV, pos.hSortieV, true, false)
            if type == "polmav" then
                SetVehicleLivery(myVehiculeEntity, 1)
            end
            SetVehicleNumberPlateText(myVehiculeEntity, "Ambu"..plate)
            SetVehicleOnGroundProperly(myVehiculeEntity)
            SetEntityAsMissionEntity(myVehiculeEntity, true, true)

            if (livery ~= nil) then
                SetVehicleLivery(myVehiculeEntity, livery)
            end

            plate = GetVehicleNumberPlateText(myVehiculeEntity)
            TriggerServerEvent('ls:recevoircles', string.lower(plate), myVehiculeEntity)
            local ObjectId = NetworkGetNetworkIdFromEntity(myVehiculeEntity)
            SetNetworkIdExistsOnAllMachines(ObjectId, true)

            local p = GetEntityCoords(myVehiculeEntity, 0)
            local h = GetEntityHeading(myVehiculeEntity)
            SetModelAsNoLongerNeeded(type)
            return
        else
            notif("Zone encombrée.")
        end
        -- Citizen.Trace('impossible')
        notifIcon("CHAR_CALL911", 1, "Urgence", false, TEXTAMBUL.SpawnVehicleImpossible)
    end
    function DeleteHeliLSES(helico_pos)
        local rayHandle = CastRayPointToPoint(helico_pos.xSortieV - 10, helico_pos.ySortieV - 10, helico_pos.zSortieV - 10, helico_pos.xSortieV + 20, helico_pos.ySortieV + 20, helico_pos.zSortieV + 20, 10, GetPlayerPed(-1), 0)
        local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
        if DoesEntityExist(vehicle) then
            DeleteVehicle(vehicle)
        end
    end
    function invokeVehicle(data)
        local pos = {}
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), 0)
        local livery = data.livery
        if data.type == 2 then -- if polmav
            for k, v in pairs(ambulancier_helico) do
                local distance = GetDistanceBetweenCoords(v.xMenu, v.yMenu, v.zMenu, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
                if distance < 10 then
                    pos = v
                    break
                end
            end
        else
            for k, v in pairs(ambulancier_garage) do
                local distance = GetDistanceBetweenCoords(v.xMenu, v.yMenu, v.zMenu, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
                if distance < 10 then
                    pos = v
                    break
                end
            end
        end
        if data.type == 1 then
            spawnVehicule(pos, "ambulance", livery)
        elseif data.type == 2 then
            spawnVehicule(pos, "polmav", livery)
        elseif data.type == 3 then
            spawnVehicule(pos, "lguard", livery)
        elseif data.type == 4 then
            spawnVehicule(pos, "lguard2", livery)
        elseif data.type == 5 then
            spawnVehicule(pos, "emscar", livery)
        elseif data.type == 6 then
            spawnVehicule(pos, "emscar2", livery)
        elseif data.type == 7 then
            spawnVehicule(pos, "emssuv", livery)
        elseif data.type == 8 then
            spawnVehicule(pos, "emsvan", livery)
        elseif data.type == 9 then
            spawnVehicule(pos, "ambulance2", livery)
        elseif data.type == 10 then
            spawnVehicule(pos, "ambulance3", livery)
        elseif data.type == -1 then
            deleteVehicle()
        elseif data.type == -2 then
            DeleteHeliLSES(pos)
        end
    end
    local function toogleServiceAmbulancier()
        ambulancierIsInService = not ambulancierIsInService
        Citizen.Trace("toogleServiceAmbulancier")
        if ambulancierIsInService then
            local hashSkin = GetHashKey("mp_m_freemode_01")
            Citizen.CreateThread(function()
                if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
                    SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)-- pas de collier
                    SetPedComponentVariation(GetPlayerPed(-1), 11,221, 22, 2) --haut
                    SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) -- dessous
                    SetPedComponentVariation(GetPlayerPed(-1), 4, 25, 5, 2) -- pantalon
                    SetPedComponentVariation(GetPlayerPed(-1), 3,93, 0, 2) --bras
                    SetPedComponentVariation(GetPlayerPed(-1), 6, 4, 2, 2) -- chaussures
                else
                    SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)-- pas de collier
                    SetPedComponentVariation(GetPlayerPed(-1), 11, 9, 1, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 8, 13, 6, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 4, 23, 0, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 3, 106, 0, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 6, 4, 2, 2)
                end
            end)
            --GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 200, true, true)
            --GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FIREEXTINGUISHER"), 200, true, true)
            TriggerServerEvent('ambulancier:takeService')
            TriggerServerEvent('ambulancier:requestMission')
            ambulancier_showHelp = true
            TriggerServerEvent('ambulancier:setService', true)
        else
            -- Restaure Ped
            TriggerServerEvent('ambulancier:endService')
            TriggerServerEvent("skin_customization:SpawnPlayer")
            TriggerServerEvent('ambulancier:setService', false)
            RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"))
            RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_FIREEXTINGUISHER"))
        end
    end
	--########################################
	-- ##############CASIER###################
	--########################################
    function givearme(data)
        GiveWeaponToPed(GetPlayerPed(-1), data.weapon, 200, true, true)
        notif("Vous avez retiré ~g~" .. data.text)
    end
    function removearme(data)
        RemoveWeaponFromPed(GetPlayerPed(-1), data.weapon)
        notif("Vous avez déposé ~g~" .. data.text)
    end
	
	
	function TenueChemise()
			local hashSkin = GetHashKey("mp_m_freemode_01")
            Citizen.CreateThread(function()
                if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
                    SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)-- pas de collier
                    SetPedComponentVariation(GetPlayerPed(-1), 11, 13, 3, 2) -- haut
                    SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2) -- dessous
                    SetPedComponentVariation(GetPlayerPed(-1), 4, 24, 5, 2) -- pantalon
                    SetPedComponentVariation(GetPlayerPed(-1), 3, 92, 0, 2) -- bras
                    SetPedComponentVariation(GetPlayerPed(-1), 6, 1, 6, 2) -- chaussures
                else
                    SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)-- pas de collier
                    SetPedComponentVariation(GetPlayerPed(-1), 11, 9, 2, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 8, 13, 6, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 4, 23, 0, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 3, 106, 0, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 6, 4, 2, 2)
                end
			end)
	end
	function TenueDirecteur()
			local hashSkin = GetHashKey("mp_m_freemode_01")
            Citizen.CreateThread(function()
                if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
                    SetPedComponentVariation(GetPlayerPed(-1), 7, 28, 2, 2)-- pas de collier
                    SetPedComponentVariation(GetPlayerPed(-1), 11, 11, 1, 2) -- haut
                    SetPedComponentVariation(GetPlayerPed(-1), 8, 6, 0, 2) -- dessous
                    SetPedComponentVariation(GetPlayerPed(-1), 4, 37, 2, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 3, 92, 0, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 6, 43, 7, 2)
                else
                    SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 2)-- pas de collier
                    SetPedComponentVariation(GetPlayerPed(-1), 11, 7, 0, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 8, 39, 3, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 4, 6, 0, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 3, 104, 0, 2)
                    SetPedComponentVariation(GetPlayerPed(-1), 6, 0, 0, 2)
                end
			end)
	end
	--########################################
	--########################################
	--########################################
    local function gestionServiceAmbulancier()
        -- PRISE DE SERVICE --
        for i = 1, #ambulancier_Service do
            local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), ambulancier_Service[i].x, ambulancier_Service[i].y, ambulancier_Service[i].z, true)
            if distance <= 7 then -- affichage marqueur
                DrawMarker(1, ambulancier_Service[i].x, ambulancier_Service[i].y, ambulancier_Service[i].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
            end
            if distance <= 2 then -- utilisation possible
                if ambulancierIsInService then
                    DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour quitter le ~b~service actif")
                else
                    DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour rentrer en ~b~service actif")
                end
                if IsControlJustPressed(1, KEY_E) then
                    toogleServiceAmbulancier()
                end
            end
        end
        if ambulancierIsInService then
            --CASIER --
            for i, Casier in pairs(Casier_LSES) do
                local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Casier.x, Casier.y, Casier.z, true)
                if distance <= 7 then -- affichage marqueur
                    DrawMarker(1, Casier.x, Casier.y, Casier.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                    if distance <= 2 then -- utilisation possible
                        DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir votre votre ~b~casier")
                        if IsControlJustPressed(1, KEY_E) then
                            openMenuCasier()
                        end
                    end
                end
            end
            -- GARAGES --
            for k, voit in pairs(ambulancier_garage) do
                local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), voit.xMenu, voit.yMenu, voit.zMenu, true)
                if distance <= 7 then -- affichage marqueur
                    DrawMarker(1, voit.xMenu, voit.yMenu, voit.zMenu, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                    if distance <= 2 then -- utilisation possible
                        DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le garage ~b~LSES")
                        if IsControlJustPressed(1, KEY_E) then
                            openMenuChoixVehicleAmbulancier()
                        end
                    end
                end
            end
            -- HELIPAD --
            for j, heli in pairs(ambulancier_helico) do
                local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), heli.xMenu, heli.yMenu, heli.zMenu, true)
                if distance <= 7 then -- affichage marqueur
                    DrawMarker(1, heli.xMenu, heli.yMenu, heli.zMenu, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                    if distance <= 2 then -- utilisation possible
                        DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour faire appairaitre/ranger votre ~b~vehicule")
                        if IsControlJustPressed(1, KEY_E) then
                            openMenuChoixHelicoAmbulancier()
                        end
                    end
                end
            end
        end
    end
    --====================================================================================
    -- Vehicule gestion
    --====================================================================================
    function notif(message)
        SetNotificationTextEntry("STRING")
        AddTextComponentString(message)
        DrawNotification(false, false)
    end
    --restart metiers
    function jobsSystemAmbulancier()
        if currentMissionAmbulancier == nil then
            return
        end
        RemoveBlip(ambulancier_blip_currentMission)
        local patientPed = GetPlayerPed(GetPlayerFromServerId(currentMissionAmbulancier.id));
        local posPatient = currentMissionAmbulancier.positionBackUp
        if patientPed ~= nil and patientPed ~= 0 and patientPed ~= GetPlayerPed(-1) then
            posPatient = GetEntityCoords(patientPed)
        end

        ambulancier_blip_currentMission = AddBlipForCoord(posPatient.x, posPatient.y, posPatient.z)
        SetBlipAsShortRange(ambulancier_blip_currentMission, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Urgence")
        EndTextCommandSetBlipName(ambulancier_blip_currentMission)
        local mypos = GetEntityCoords(GetPlayerPed(-1))
        local dist = GetDistanceBetweenCoords(mypos, posPatient.x, posPatient.y, posPatient.z, false)
        if dist < 13.0 then
            DrawMarker(1, posPatient.x, posPatient.y, 0.0, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 350.0, 0, 155, 255, 64, 0, 0, 0, 0)
        end
        if dist < 3.0 then
            if tostring(currentMissionAmbulancier.type) == "Coma" then
                notif('Appuyez sur E pour réanimer le joueur')
                if (IsControlJustReleased(1, KEY_E)) then
                    TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                    Citizen.Wait(8000)
                    ClearPedTasks(GetPlayerPed(-1));
                    TriggerServerEvent('ambulancier:rescueHim', currentMissionAmbulancier.id)
                    TriggerServerEvent('entreprises:sellpartage', 300)
                    TriggerServerEvent('ambulancier:payRescue', currentMissionAmbulancier.id)
                    finishMissionAmbulancier()
                    --break
                end
            elseif tostring(currentMissionAmbulancier.type) == "Demande" then
                finishMissionAmbulancier()
            end
        end
    end
    function startMissionAmbulancier(missions)
        currentMissionAmbulancier = missions
        local posPatient = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(currentMissionAmbulancier.id)))
        SetNewWaypoint(posPatient.x, posPatient.y)

    end
    function finishMissionAmbulancier()
        TriggerServerEvent('ambulancier:FinishMission', currentMissionAmbulancier.id)
        RemoveBlip(ambulancier_blip_currentMission)
        currentMissionAmbulancier = nil
    end
    --
    function showInfoClientAmbulancier()
        if ambulance_call_accept ~= 0 then
            local offsetX = 0.87
            local offsetY = 0.22
            DrawRect(offsetX, offsetY, 0.23, 0.035, 0, 0, 0, 215)
            SetTextFont(1)
            SetTextScale(0.0, 0.5)
            SetTextCentre(true)
            SetTextDropShadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextColour(255, 255, 255, 255)
            SetTextEntry("STRING")
            if ambulance_call_accept == 1 then
                AddTextComponentString(TEXTAMBUL.CALL_INFO_OK)
            else
                if ambulance_nbAmbulanceInService == 0 then
                    AddTextComponentString(TEXTAMBUL.CALL_INFO_NO_PERSONNEL)
                elseif ambulance_nbAmbulanceDispo == 0 then
                    AddTextComponentString(TEXTAMBUL.CALL_INFO_ALL_BUSY)
                else
                    AddTextComponentString(TEXTAMBUL.CALL_INFO_WAIT)
                end
            end
            DrawText(offsetX, offsetY - 0.015)
        end
    end
    function showInfoJobsAmbulancier()
        local offsetX = 0.9
        local offsetY = 0.280
        DrawRect(offsetX, offsetY, 0.15, 0.07, 0, 0, 0, 215)
        SetTextFont(1)
        SetTextScale(0.0, 0.5)
        SetTextCentre(true)
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        AddTextComponentString('~o~Ambulancier Info')
        DrawText(offsetX, offsetY - 0.03)
        SetTextFont(1)
        SetTextScale(0.0, 0.5)
        SetTextCentre(false)
        SetTextDropShadow(0, 0, 0, 0, 0)
        SetTextEdge(0, 0, 0, 0, 0)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        AddTextComponentString(ambulancier_nbMissionEnAttenteText)
        DrawText(offsetX - 0.065, offsetY - 0.002)
    end
    function deleteVehicle()
        if myVehiculeEntity ~= nil then
            local plate = GetVehicleNumberPlateText(myVehiculeEntity)
            TriggerServerEvent('ls:retirercles', plate)
            DeleteVehicle(myVehiculeEntity)
            myVehiculeEntity = nil
        end
    end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            local statusHUD = exports["Players"]:getStatusHUD()
            if isAmbulancier then
                gestionServiceAmbulancier()
                jobsSystemAmbulancier()
                if ambulancierIsInService and not statusHUD then
                    showInfoJobsAmbulancier()
                end
            end
            if ambulancier_showHelp == true then
                drawHelpJobAmbulancier()
                if IsControlJustPressed(0, KEY_CLOSE) then
                    ambulancier_showHelp = false
                end
            end
            if ambulance_call_accept ~= 0 and not statusHUD then
                showInfoClientAmbulancier()
            end
        end
    end)
    --
    RegisterNetEvent('ambulancier:drawMarker')
    AddEventHandler('ambulancier:drawMarker', function (boolean)
        isAmbulancier = boolean
        ambulancierIsInService = false
        if isAmbulancier then
            showBlipAmbulancier()
        else
            removeBlipAmbulancier()
        end
    end)
    RegisterNetEvent('ambulancier:drawBlips')
    AddEventHandler('ambulancier:drawBlips', function ()
    end)
    RegisterNetEvent('ambulancier:marker')
    AddEventHandler('ambulancier:marker', function ()
    end)
    RegisterNetEvent('ambulancier:deleteBlips')
    AddEventHandler('ambulancier:deleteBlips', function ()
        isAmbulancier = false
        TriggerServerEvent('ambulancier:endService')
        TriggerServerEvent("skin_customization:SpawnPlayer")
        removeBlipAmbulancier()
    end)
    --====
    function acceptMissionAmbulancier(data)
        local mission = data.mission
        TriggerServerEvent('ambulancier:AcceptMission', mission.id)
    end
    function needAmbulance(type)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        TriggerServerEvent('ambulancier:Call', type, {x = pos.x, y = pos.y, z = pos.z})
    end
    --====================================================================================
    -- Serveur - Client Trigger
    -- restart depanneur
    --====================================================================================
    function notifIcon(icon, type, sender, title, text)
        Citizen.CreateThread(function()
            Wait(1)

            SetNotificationTextEntry("STRING");
            if TEXTAMBUL[text] ~= nil then
                text = TEXTAMBUL[text]
            end
            AddTextComponentString(text);
            SetNotificationMessage(icon, icon, true, type, sender, title, text);
            DrawNotification(false, true);
        end)
    end
    RegisterNetEvent("ambulancier:PersonnelMessage")
    AddEventHandler("ambulancier:PersonnelMessage", function(message)
        if ambulancierIsInService then
            notifIcon("CHAR_CALL911", 1, "Urgence Info", false, message)
        end
    end)
    RegisterNetEvent("ambulancier:ClientMessage")
    AddEventHandler("ambulancier:ClientMessage", function(message)
        notifIcon("CHAR_CALL911", 1, "Urgence", false, message)
    end)
    function updateMenuMissionAmbulancier()
        local items = {
        {['Title'] = 'Retour', ['ReturnBtn'] = true}}
        for _, m in pairs(listMissionsAmbulancier) do
            -- Citizen.Trace('item mission')
            local targetCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(m.id), 0))
            local item = {
                Title = 'Mission ' .. m.id .. ' (' .. math.floor(GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), targetCoords["x"], targetCoords["y"], targetCoords["z"], true)) .. 'm)',
                mission = m,
                Function = acceptMissionAmbulancier
            }
            if #m.acceptBy ~= 0 then
                item.Title = item.Title .. ' (En cours)'
                item.TextColor = {39, 174, 96, 255}
            end
            table.insert(items, item)
        end
        if currentMissionAmbulancier ~= nil then
            table.insert(items, {['Title'] = 'Terminer la mission', ['Function'] = finishMissionAmbulancier})
        end
        table.insert(items, {['Title'] = 'Fermer'})
        menu = {['Title'] = 'Missions en cours', ['SubMenu'] = {
            ['Title'] = 'Missions en cours', ['Items'] = items
        }}
        updateMenu(menu)
    end
    RegisterNetEvent('ambulancier:MissionAccept')
    AddEventHandler('ambulancier:MissionAccept', function (mission)
        startMissionAmbulancier(mission)
    end)
    RegisterNetEvent('ambulancier:MissionChange')
    AddEventHandler('ambulancier:MissionChange', function (missions)
        if not ambulancierIsInService then
            return
        end
        listMissionsAmbulancier = missions
        -- if currentMissionAmbulancier ~= nil then
        local nbMissionEnAttente = 0
        --     local find = false
        for _, m in pairs(listMissionsAmbulancier) do
            --       if m.id == currentMissionAmbulancier.id then
            --           find = true
            --      end
            if #m.acceptBy == 0 then
                nbMissionEnAttente = nbMissionEnAttente + 1
            end
        end
        if nbMissionEnAttente == 0 then
            ambulancier_nbMissionEnAttenteText = TEXTAMBUL.InfoAmbulancierNoAppel
        else
            ambulancier_nbMissionEnAttenteText = '~g~ ' .. nbMissionEnAttente .. ' ' .. TEXTAMBUL.InfoAmbulancierNbAppel
        end
        --     Citizen.Trace('ok')
        --     if not find then
        --         currentMissionAmbulancier = nil
        --         notifIcon("CHAR_CALL911", 1, "Mecano", false, TEXTAMBUL.MissionCancel)
        --         if currentBlip ~= nil then
        --             RemoveBlip(currentBlip)
        --         end
        --     end
        -- end
        updateMenuMissionAmbulancier()
    end)
    local function showMessageInformation(message, duree)
        duree = duree or 2000
        ClearPrints()
        SetTextEntry_2("STRING")
        AddTextComponentString(message)
        DrawSubtitleTimed(duree, 1)
    end

    RegisterNetEvent('ambulancier:openMenu')
    AddEventHandler('ambulancier:openMenu', function()
        if ambulancierIsInService then
            TriggerServerEvent('ambulancier:requestMission')
            openMenuGeneralAmbulancier()
        else
            showMessageInformation("~r~Vous devez etre en service pour acceder au menu")
        end
    end)
    RegisterNetEvent('ambulancier:callAmbulancier')
    AddEventHandler('ambulancier:callAmbulancier', function(data)
        needAmbulance(data.type)
    end)
    RegisterNetEvent('ambulancier:callStatus')
    AddEventHandler('ambulancier:callStatus', function(status)
        ambulance_call_accept = status
    end)
    RegisterNetEvent('ambulancier:personnelChange')
    AddEventHandler('ambulancier:personnelChange', function(nbPersonnel, nbDispo)
        --Citizen.Trace('nbPersonnel : ' .. nbPersonnel .. ' dispo' .. nbDispo)
        ambulance_nbAmbulanceInService = nbPersonnel
        ambulance_nbAmbulanceDispo = nbDispo
    end)
    RegisterNetEvent('ambulancier:cancelCall')
    AddEventHandler('ambulancier:cancelCall', function(data)
        TriggerServerEvent('ambulancier:cancelCall')
    end)
    RegisterNetEvent('ambulancier:selfRespawn')
    AddEventHandler('ambulancier:selfRespawn', function()
        local CurrentCountDown = GetCurrentCountDown()
        if(CurrentCountDown == 0) then
            ResetCountDown()
            TriggerServerEvent('ambulancier:askSelfRespawn')
        else
            showMessageInformation("~r~Retour hôpital interdit !")
        end
    end)
    function GetAmbulancierInServiceManager()
        return ambulance_nbAmbulanceInService
    end

    function GetPlayers()
        local players = {}
        for i = 0, 68 do
            if NetworkIsPlayerActive(i) then
                table.insert(players, i)
            end
        end
        return players
    end
    function GetClosestPlayer()
        local players = GetPlayers()
        local closestDistance = -1
        local closestPlayer = -1
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        for index, value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
                if(closestDistance == -1 or closestDistance > distance) then
                    closestPlayer = value
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance
    end
    RegisterNetEvent('ambulancier:HealMe')
    AddEventHandler('ambulancier:HealMe',
        function (idToHeal)
            if idToHeal == PlayerId() then
                SetEntityHealth(GetPlayerPed(-1), GetPedMaxHealth(GetPlayerPed(-1)))
            end
        end)
        RegisterNetEvent('ambulancier:Heal')
        AddEventHandler('ambulancier:Heal',
            function()
                Citizen.CreateThread(function()
                    local closestPlayer, closestDistance = GetClosestPlayer()
                    if closestDistance < 2.0 and closestDistance ~= -1 then
                        TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                        Citizen.Wait(8000)
                        ClearPedTasks(GetPlayerPed(-1));
                        TriggerServerEvent('ambulancier:healHim', closestPlayer)
                    else
                        showMessageInformation(TEXTAMBUL.NoPatientFound)
                    end
                end)
            end)
            RegisterNetEvent('ambulancier:ethylotest')
            AddEventHandler('ambulancier:ethylotest',
                function()
                    Citizen.CreateThread(function()
                        local closestPlayer, closestDistance = GetClosestPlayer()
                        if closestDistance < 2.0 and closestDistance ~= -1 then
                            TriggerServerEvent('ambulancier:doethylotest', closestPlayer)
                        else
                            showMessageInformation(TEXTAMBUL.NoPatientFound)
                        end
                    end)
                end)
                -- Affichage en haut à gauche ( propre ..)
                function DisplayHelpText(str)
                    BeginTextCommandDisplayHelp("STRING")
                    AddTextComponentSubstringPlayerName(str)
                    EndTextCommandDisplayHelp(0, 0, 1, -1)
                end
                --====================================================================================
                -- ADD Blip for All Player
                --====================================================================================
                --Citizen.Trace("Mecano load")
                TriggerServerEvent('ambulancier:requestPersonnel')
































