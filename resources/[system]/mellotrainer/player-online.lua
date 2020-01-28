-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.

local drawRouteTarget = nil

-- Returns all player names in alphabetical order.
function getOnlinePlayersAndNames()
    local players = {}
    local me = PlayerId(-1)
    for i = 0, maxPlayers, 1 do
        if(NetworkIsPlayerConnected(i) and i ~= me) then
            local playerName = GetPlayerName(i)
            local scoreboardID = GetPlayerServerId(i)
            
            table.insert(players, {
                ['ped'] = GetPlayerPed(i),
                ['menuName'] = playerName,
                ['data'] = {
                    ['sub'] = "playeroptions",
                    ['share'] = scoreboardID
                },
                ['id'] = i
            })
        end
    end
    return players
end

-- DEBANNIR UN JOUEUR
local TablePlayerInBanList = {}

function getBannedPlayerFromName()
    TablePlayerInBanList = {}
    drawNotification("Veuillez écrire une partie du nom du joueur (rien écrire pour annuler, echap pour sortir)")
    DisplayOnscreenKeyboard(1, "Nom :", "", "", "", "", "", 20)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        res = tostring(GetOnscreenKeyboardResult())
        if (res ~= nil) then
            drawNotification("Recherche du nom : ~n~~b~<C>" .. res .. " en cours...")
            TriggerServerEvent("mellotrainer:SearchBannedPlayer", res)
        end
    end
end

RegisterNetEvent("mellotrainer:receiveBannedList")
AddEventHandler("mellotrainer:receiveBannedList", function(bannedlist)
    if(bannedlist ~= nil) then
        for k, v in pairs(bannedlist) do
            table.insert(TablePlayerInBanList, {
                ['menuName'] = v.nom .. " " .. v.prenom .. " / " .. v.dateNaissance,
                ['data'] = {
                    ['sub'] = "playeroptions",
                    ['share'] = scoreboardID
                },
                ['identifier'] = v.identifier
            })
        end
    else
        TablePlayerInBanList = {}
    end
end)

RegisterNUICallback("getbannedplayers", function(data, cb)
    --Citizen.Trace("Get Online Players")
    getBannedPlayerFromName()
    Citizen.CreateThread(function()
        Citizen.Wait(5000)
        if(TablePlayerInBanList ~= nil) then
            local players = TablePlayerInBanList
            local playerCount = getTableLength(players)
            
            if(playerCount < 1)then
                drawNotification("~r~Aucun joueur trouvé.")
                return
            end
            
            local playerJSON = json.encode(players, {indent = true})
            --Citizen.Trace(playerJSON)
            
            SendNUIMessage({
                createallplayersmenu = true,
                menuName = "getbannedplayers",
                menudata = playerJSON
            })
        end
    end)
end)

RegisterNUICallback("unbanplayer", function(data, cb)
    local playerPed = GetPlayerPed(-1) -- Yourself
    local targetServerID; -- Target
    
    local bannedList = TablePlayerInBanList
    
    local action = data.action
    local newstate = data.newstate
    
    local target = nil
    if action == "relationship" then
        targetServerID = tonumber(data.data[4])
    else
        targetServerID = tonumber(data.data[3])
    end
    for _, value in pairs(bannedList) do
        if(tostring(value.data.share) == tostring(targetServerID))then
            target = value
        end
    end
    
    if(action == "unban") then
        --banoutplayer(target, false)
        print("débannir " .. target['menuName'] .. " / " .. target['identifier'])
    end
    
    cb("ok")
end)
--
-- LISTE DE TOUS LES JOUEURS
local allplayers = {}

RegisterNetEvent("overhead:setNomPrenom")
AddEventHandler("overhead:setNomPrenom", function(allplayerslist)
    allplayers = {}
    for k, v in pairs(allplayerslist) do
        local count = 0
        local autorisation = true
        if(allplayers ~= nil) then
            for e, t in pairs(allplayers) do
                if(t['steamid'] == v.steamid) then
                    count = count + 1
                    if(count > 0) then
                        t['id'] = v.id
                        t['data']['share'] = v.id
                        t['menuName'] = "(ID : " .. v.id .. ") " .. v.nom .. " " .. v.prenom
                        autorisation = false
                        break
                    end
                end
            end
        else
            autorisation = true
        end
        if(autorisation) then
            local nom = v.nom
            local prenom = v.prenom
            if(NetworkIsPlayerConnected(v.id)) then
                if(v.nom == nil or v.nom == "" or v.prenom == nil or v.prenom == "") then
                    nom = "(Nouveau) " .. GetPlayerName(v.id)
                    prenom = ""
                end
            end
            table.insert(allplayers, {
                ['ped'] = GetPlayerPed(v.id),
                ['menuName'] = "(ID : " .. v.id .. ") " .. nom .. " " .. prenom,
                ['nom'] = v.nom,
                ['prenom'] = v.prenom,
                ['data'] = {
                    ['sub'] = "playeroptions",
                    ['share'] = v.id
                },
                ['steamid'] = v.steamid,
                ['id'] = v.id
            })
        end
    end
end)

-- Return all player names to the trainer
RegisterNUICallback("getallplayers", function(data, cb)
    --Citizen.Trace("Get Online Players")
    local players = allplayers
    local playerCount = getTableLength(players)
    
    if(playerCount < 1)then
        drawNotification("~r~No players in session.")
        return
    end
    
    local playerJSON = json.encode(players, {indent = true})
    --Citizen.Trace(playerJSON)
    
    SendNUIMessage({
        createallplayersmenu = true,
        menuName = "getallplayers",
        menudata = playerJSON
    })
end)

RegisterNUICallback("allplayers", function(data, cb)
    local playerPed = GetPlayerPed(-1) -- Yourself
    local targetServerID; -- Target
    
    local allPlayers = allplayers
    
    local action = data.action
    local newstate = data.newstate
    
    local target = nil
    if action == "relationship" then
        targetServerID = tonumber(data.data[4])
    else
        targetServerID = tonumber(data.data[3])
    end
    for _, value in pairs(allPlayers) do
        if(tostring(value.data.share) == tostring(targetServerID))then
            target = value
        end
    end
    
    if(action == "ban") then
        banoutplayer(target, true)
    end
    
    if(action == "unban") then
        banoutplayer(target, false)
    end
    
    if(action == "tempban") then
        tempbanplayer(target)
    end
    
    cb("ok")
end)

function banoutplayer(target, ban)
    drawNotification("Vous avez banni:~n~~b~<C>"..target['menuName'] .. "</C>.")
    TriggerServerEvent("mellotrainer:banAwayTriumCheater", target['steamid'], target['id'], ban)
end

function tempbanplayer(target)
    drawNotification("Veuillez indiquer le temps de ban en heure (0 pour annuler, echap pour sortir)")
    DisplayOnscreenKeyboard(1, "Temps :", "", "", "", "", "", 10)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        res = tonumber(GetOnscreenKeyboardResult())
        if (type(res) == "number") and (res ~= nil) and (math.floor(res) > 0) then
            drawNotification("Vous avez banni:~n~~b~<C>"..target['menuName'] .. "</C> pendant " .. res .. " heures")
            TriggerServerEvent("mellotrainer:TimedBanTriumCheater", target, res)
        end
    end
end
--

-- Spectate target player.
function spectatePlayer(target)
    local playerPed = GetPlayerPed(-1) -- yourself
    print(target)
    
    if(featureSpectate)then
        if (not IsScreenFadedOut() and not IsScreenFadingOut()) then
            DoScreenFadeOut(1000)
            while (not IsScreenFadedOut()) do
                Wait(0)
            end
            
            local targetpos = GetEntityCoords(target['ped'], false)
            
            RequestCollisionAtCoord(targetpos['x'], targetpos['y'], targetpos['z'])
            NetworkSetInSpectatorMode(true, target['ped'])
            
            if(IsScreenFadedOut()) then
                DoScreenFadeIn(1000)
            end
        end
        TriggerServerEvent('mellotrainer:SpectateMsg', GetPlayerServerId(tonumber(target['id'])), true)
        drawNotification("Spectating ~b~<C>"..target['menuName'] .. "</C>.")
    else
        if(not IsScreenFadedOut() and not IsScreenFadingOut()) then
            DoScreenFadeOut(1000)
            while (not IsScreenFadedOut()) do
                Wait(0)
            end
            
            local targetpos = GetEntityCoords(playerPed, false)
            
            RequestCollisionAtCoord(targetpos['x'], targetpos['y'], targetpos['z'])
            NetworkSetInSpectatorMode(false, target['ped'])
            
            if(IsScreenFadedOut()) then
                DoScreenFadeIn(1000)
            end
        end
        TriggerServerEvent('mellotrainer:SpectateMsg', GetPlayerServerId(tonumber(target['id'])), false)
        drawNotification("Stopped Spectating ~b~<C>"..target['menuName'] .. "</C>.")
    end
end

-- Draw Route to player on map.

-- Draw Initial Route
function drawRoute(target)
    local targetId = tonumber(target['id'])
    if (featureDrawRoute) then
        if (DoesEntityExist(target['ped'])) then
            local drawroute = GetEntityCoords(target['ped'], false)
            SetNewWaypoint(drawroute['x'], drawroute['y'])
            TriggerServerEvent('mellotrainer:LocateMsg', GetPlayerServerId(tonumber(target['id'])))
            drawNotification("Drawing Live Route To:~n~~b~<C>"..target['menuName'] .. "</C>.")
        end
    else
        SetWaypointOff()
        drawNotification("Route Removed.")
    end
end

function ban(target)
    local targetId = tonumber(target['id'])
    print(GetPlayerServerId(targetId))
    if (DoesEntityExist(target['ped'])) then
        drawNotification("Vous avez banni:~n~~b~<C>"..target['menuName'] .. "</C>.")
        TriggerServerEvent("mellotrainer:banTriumCheater", GetPlayerServerId(targetId))
    end
end

function tempban(target)
    local targetId = tonumber(target['id'])
    print(GetPlayerServerId(targetId))
    if (DoesEntityExist(target['ped'])) then
        drawNotification("Vous avez banni temporairement :~n~~b~<C>"..target['menuName'] .. "</C>.")
        TriggerServerEvent("mellotrainer:tempbanPlayer", GetPlayerServerId(targetId))
    end
end
-- Update draw route.
function updateDrawRoute()
    if(not IsWaypointActive())then
        featureDrawRoute = false
        return
    end
    
    local target = drawRouteTarget
    local targetId = target['id']
    if(featureDrawRoute)then
        if(NetworkIsPlayerConnected(targetId))then
            local drawroute = GetEntityCoords(target['ped'], false)
            
            SetNewWaypoint(drawroute['x'], drawroute['y'])
        else
            SetWaypointOff()
            featureDrawRoute = false
            drawRouteTarget = nil
            drawNotification("Player "..target['menuName'] .. " has ~r~<C>disconnected</C>.")
        end
    end
end

-- Fouiller
function FouillerJoueur(target)
    if(DoesEntityExist(target['ped'])) then
        TriggerServerEvent('mellotrainer:FouilleMsg', GetPlayerServerId(tonumber(target['id'])))
        TriggerServerEvent("mellotrainer:targetCheckInventoryAdmin", GetPlayerServerId(target['id']))
    else
        TriggerEvent('chatMessage', 'STAFF', {255, 0, 0}, "Le joueur n'existe pas")
    end
end
-- Teleport to Player
function teleportToPlayer(target)
    local playerPed = GetPlayerPed(-1) -- Yourself
    
    if(DoesEntityExist(target['ped']))then
        -- Turns off spectator mode just in case.
        NetworkSetInSpectatorMode(false, target['ped'])
        featureSpectate = false
    end
    
    local targetPed = playerPed
    if(IsPedInAnyVehicle(playerPed, 0))then
        local v = GetVehiclePedIsUsing(playerPed)
        if(GetPedInVehicleSeat(v, -1) == playerPed) then
            targetPed = v
        end
    else
        ClearPedTasksImmediately(playerPed)
    end
    
    local x, y, z = table.unpack(GetEntityCoords(target['ped']))
    --Citizen.Trace("XYZ: "..tostring(x).." "..tostring(y).." "..tostring(z))
    z = z + 3.5
    RequestCollisionAtCoord(x, y, z)
    SetEntityCoordsNoOffset(targetPed, x, y, z, 0, 0, 1)
    TriggerServerEvent('mellotrainer:TpMsg', GetPlayerServerId(tonumber(target['id'])))
    drawNotification("Teleported to ~b~<C>"..target['menuName'] .. "</C>.")
end

-- Teleport into player Vehicle
function teleportIntoPlayerVehicle(target)
    local playerPed = GetPlayerPed(-1)
    
    -- Prevents false "false" returns by being far away from target.
    local x, y, z = table.unpack(GetEntityCoords(target['ped']))
    RequestCollisionAtCoord(x, y, z)
    
    if(not IsPedInAnyVehicle(target['ped'], false))then
        drawNotification("~b~<C>"..target['menuName'] .. "</C> ~s~is not in any vehicle")
        return
    end
    
    local targetVeh = GetVehiclePedIsIn(target['ped'], false)
    
    if(targetVeh == GetVehiclePedIsIn(playerPed))then
        drawNotification("You are already in " .. "~b~<C>"..target['menuName'] .. "'s</C> ~s~vehicle.")
        return
    end
    
    if(GetVehicleDoorsLockedForPlayer(targetVeh, playerPed))then
        drawNotification("~b~<C>"..target['menuName'] .. "'s</C> ~s~vehicle is locked.")
        return
    end
    
    local seatNum = 0 + GetVehicleNumberOfPassengers(targetVeh)
    local passNum = GetVehicleMaxNumberOfPassengers(targetVeh)
    
    while (seatNum < passNum) do
        if(IsVehicleSeatFree(targetVeh, seatNum))then
            local playerPedID = PlayerPedId()
            ClearPedTasksImmediately(playerPedID)
            SetPedIntoVehicle(playerPed, targetVeh, seatNum)
            NetworkSetInSpectatorMode(false, target['ped'])
            break
        else
            seatNum = seatNum + 1
        end
    end
    
    if (seatNum >= passNum) then
        drawNotification("~b~<C>"..target['menuName'] .. "'s</C> ~s~vehicle is full.")
        return
    end
    TriggerServerEvent('mellotrainer:TpMsg', GetPlayerServerId(tonumber(target['id'])))
    drawNotification("Teleported into ~b~<C>"..target['menuName'] .. "'s</C> ~s~vehicle.")
end

-- Relationship Toggles
function toggleRelationshipBlip(colorID, typeText, target)
    local blip = GetBlipFromEntity(target['ped']);
    SetBlipColour(blip, colorID)
    SetBlipNameToPlayerName(blip, target['menuName'])
    drawNotification("Marked ~b~<C>"..target['menuName'] .. "</C>~s~ as "..typeText)
end

RegisterNUICallback("otherplayer", function(data, cb)
    local playerPed = GetPlayerPed(-1) -- Yourself
    local targetServerID; -- Target
    
    local allPlayers = getOnlinePlayersAndNames() --Active Users
    
    local action = data.action
    local newstate = data.newstate
    
    if action == "relationship" then
        targetServerID = tonumber(data.data[4])
    else
        targetServerID = tonumber(data.data[3])
    end
    
    local target = nil
    for _, value in pairs(allPlayers) do
        if(tostring(value.data.share) == tostring(targetServerID))then
            target = value
        end
    end
    
    if(target == nil)then
        drawNotification("Player has ~r~<C>disconnected</C>.")
        return
    end
    
    local text = "~r~OFF"
    if(newstate) then
        text = "~g~ON"
    end
    
    -- Relationships
    if action == "relationship" then
        local relationshipType = data.data[3]
        
        -- Friendly
        if(relationshipType == "friendly")then
            toggleRelationshipBlip(3, "Friendly", target)
            
            --Normal
        elseif(relationshipType == "normal")then
            toggleRelationshipBlip(0, "Normal", target)
            
            --Hostile
        elseif(relationshipType == "hostile")then
            toggleRelationshipBlip(1, "Hostile", target)
        end
        
        -- Teleport to the player.
    elseif action == "teleportto" then
        teleportToPlayer(target)
        
    elseif action == "fouiller" then
        FouillerJoueur(target)
        
    elseif action == "ban" then
        ban(target)
        
    elseif action == "tempban" then
        tempban(target)
        
        -- Teleport inside their vehicle
    elseif action == "teleportinside" then
        teleportIntoPlayerVehicle(target)
        
        --Draw Route to player
    elseif action == "drawroute" then
        featureDrawRoute = newstate
        drawRouteTarget = target
        drawRoute(target)
        
        -- Spectate player.
    elseif action == "spectate" then
        featureSpectate = newstate
        spectatePlayer(target)
    end
    
    cb("ok")
end)

-- Return all player names to the trainer
RegisterNUICallback("getonlineplayers", function(data, cb)
    --Citizen.Trace("Get Online Players")
    local players = getOnlinePlayersAndNames()
    local playerCount = getTableLength(players)
    
    if(playerCount < 1)then
        drawNotification("~r~No players in session.")
        return
    end
    
    local playerJSON = json.encode(players, {indent = true})
    --Citizen.Trace(playerJSON)
    
    SendNUIMessage({
        createonlineplayersmenu = true,
        menuName = "getonlineplayers",
        menudata = playerJSON
    })
end)

-- Update draw route every 2 seconds
Citizen.CreateThread(function()
    while true do
        Wait(2000)
        
        if(featureDrawRoute)then
            updateDrawRoute()
        end
    end
end)
