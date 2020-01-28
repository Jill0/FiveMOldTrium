--====================================================================================
-- #Author: Jonathan D @ Gannon
-- 
-- Développée pour la communauté n3mtv
--      https://www.twitch.tv/n3mtv
--      https://twitter.com/n3m_tv
--      https://www.facebook.com/lan3mtv
--====================================================================================
 
-- Configuration
local KeyToucheClose = 177 -- PhoneCancel
local distMaxCheck = 3
-- Variable | 0 close | 1 Identity | 2 register
local menuIsOpen = 0

local firstspawn = 0

AddEventHandler('playerSpawned', function(spawn)
--On verifie que c'est bien le premier spawn du joueur
  if firstspawn == 0 then
	  TriggerServerEvent("gc:playerLoadedtry")
	  firstspawn = 1
  end
end) 
 
--====================================================================================
--  TEMPORAIRE thead interaction
--====================================================================================
 
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if menuIsOpen ~= 0 then
      if IsControlJustPressed(1, KeyToucheClose) and menuIsOpen == 1 then
        closeGui()
      elseif menuIsOpen == 2 then
        local ply = GetPlayerPed(-1)
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, 24, true)
        DisablePlayerFiring(ply, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 106, true)
        DisableControlAction(0,KeyToucheClose,true)
        if IsDisabledControlJustReleased(0, 142) then
          SendNUIMessage({method = "clickGui"})
        end
      end
    end
  end
end)
 
--====================================================================================
--  User Event
--====================================================================================
RegisterNetEvent("gcl:showItentity")
AddEventHandler("gcl:showItentity", function()
    local p , dist  = GetClosestPlayer(distMaxCheck)
    if p ~= -1 then
        TriggerServerEvent('gc:openIdentity', GetPlayerServerId(p))
    end
end)
 
RegisterNetEvent("gcl:openMeIdentity")
AddEventHandler("gcl:openMeIdentity", function()
    TriggerServerEvent('gc:openMeIdentity')
end)
 
--====================================================================================
--  Gestion des evenements Server
--====================================================================================
RegisterNetEvent("gc:showItentity")
AddEventHandler("gc:showItentity", function(data)
 
  openGuiIdentity(data)
end)
 
RegisterNetEvent("gc:showRegisterItentity")
AddEventHandler("gc:showRegisterItentity", function()
  openGuiRegisterIdentity()
  print('open menu créer player ')
end)
 
 
RegisterNUICallback('register', function(data, cb)
    closeGui()
    TriggerServerEvent('gc:setIdentity', data)
    cb()
end)
 
--====================================================================================
--  Gestion UI
--====================================================================================
function openGuiIdentity(data)
  --SetNuiFocus(true)
  SendNUIMessage({method = 'openGuiIdentity',  data = data})
  Citizen.Trace('Data : ' .. json.encode(data))
  menuIsOpen = 1
end
 
function openGuiRegisterIdentity()
  SetNuiFocus(true)
  SendNUIMessage({method = 'openGuiRegisterIdentity'})
  menuIsOpen = 2
end
 
function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({method = 'closeGui'})
  menuIsOpen = 0
end
 
--====================================================================================
--  Utils function
--====================================================================================
function GetClosestPlayer(distmax)
    local players = GetPlayers()
    local closestDistance = distmax or -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
   
    for _ ,value in ipairs(players) do
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
 
function GetPlayers()
    local players = {}
    for i = 0, 68 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end