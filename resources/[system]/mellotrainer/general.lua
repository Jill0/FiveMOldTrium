-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.


local settings = {}


RegisterNetEvent("mellotrainer:receiveConfigSetting")
AddEventHandler("mellotrainer:receiveConfigSetting",function(name,value)
	settings[name] = value
end)



-- Used to turn on global server settings
function initServerConfig()
	NetworkSetFriendlyFireOption(false)
end


--[[
   _____   _           _               _     ______                          _     _                       
  / ____| | |         | |             | |   |  ____|                        | |   (_)                      
 | |  __  | |   ___   | |__     __ _  | |   | |__     _   _   _ __     ___  | |_   _    ___    _ __    ___ 
 | | |_ | | |  / _ \  | '_ \   / _` | | |   |  __|   | | | | | '_ \   / __| | __| | |  / _ \  | '_ \  / __|
 | |__| | | | | (_) | | |_) | | (_| | | |   | |      | |_| | | | | | | (__  | |_  | | | (_) | | | | | \__ \
  \_____| |_|  \___/  |_.__/   \__,_| |_|   |_|       \__,_| |_| |_|  \___|  \__| |_|  \___/  |_| |_| |___/
--]]



-- Teleport to map blip
function teleportToWaypoint()
	local targetPed = GetPlayerPed(-1)
	local targetVeh = GetVehiclePedIsUsing(targetPed)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = targetVeh
	end

	if(not IsWaypointActive())then
		drawNotification("Map Marker not found.")
		return
	end

	local waypointBlip = GetFirstBlipInfoId(8) -- 8 = Waypoint ID
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())) 



	-- Ensure Entity teleports above the ground
	local ground
	local groundFound = false
	local groundCheckHeights = {100.0, 150.0, 50.0, 0.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}


	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
		Wait(10)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if(ground) then
			z = z + 3
			groundFound = true
			break;
		end
	end

	if(not groundFound)then
		z = 1000
		GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- Parachute
	end

	SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)
	drawNotification("Teleported to waypoint.")
end



--[[
  _______                  _                            _____                   _                    _       
 |__   __|                (_)                          / ____|                 | |                  | |      
    | |     _ __    __ _   _   _ __     ___   _ __    | |        ___    _ __   | |_   _ __    ___   | |  ___ 
    | |    | '__|  / _` | | | | '_ \   / _ \ | '__|   | |       / _ \  | '_ \  | __| | '__|  / _ \  | | / __|
    | |    | |    | (_| | | | | | | | |  __/ | |      | |____  | (_) | | | | | | |_  | |    | (_) | | | \__ \
    |_|    |_|     \__,_| |_| |_| |_|  \___| |_|       \_____|  \___/  |_| |_|  \__| |_|     \___/  |_| |___/
--]]



-- Admin only trainer?
local adminStatus = false
RegisterNetEvent("mellotrainer:receveurtusaurapasadmin24")
AddEventHandler("mellotrainer:receveurtusaurapasadmin24", function(status)
	Citizen.Trace("Your Admin Status: "..tostring(status))
	adminStatus = status
end)

-- Get their admin status once they load in game.
AddEventHandler('onClientMapStart', function()
	TriggerServerEvent("mellotrainer:getAdminStatus")
end)



-- Requests admin status 10 seconds after script restart. 
-- If player is joining this should fire via onClientMapStart.
Citizen.CreateThread(function()
	Wait(10000)
	TriggerServerEvent("mellotrainer:getAdminStatus")
end)

-- should the trainer be shown?
local showtrainer = false


-- Constantly check for trainer movement.
Citizen.CreateThread( function()
	while true do
		Citizen.Wait( 0 )

		if ( IsControlJustReleased( 1, 167 ) or IsDisabledControlJustReleased( 1, 167 ) ) and not IsPauseMenuActive() and not blockinput and ((settings["adminOnlyTrainer"] == true and adminStatus == true) or settings["adminOnlyTrainer"] == false) then -- f6
			if not showtrainer then
				showtrainer = true
				SendNUIMessage({
					showtrainer = true
				})
			else
				showtrainer = false
				SendNUIMessage({
					hidetrainer = true
				})
			end
		end

		if IsControlJustReleased(1, 56) and not blockinput and ((settings["adminOnlyTrainer"] == true and adminStatus == true) or settings["adminOnlyTrainer"] == false) then -- f3
			teleportToWaypoint()
		end

		if showtrainer and not blockinput then
			if ( IsControlJustPressed( 1, 199 ) or IsControlJustPressed( 1, 200 ) ) then 
				showtrainer = false
				SendNUIMessage({
					hidetrainer = true
				})				
			end

			if ( IsControlJustReleased( 1, 201 ) or IsDisabledControlJustReleased( 1, 201 ) ) then -- enter
				SendNUIMessage({
					trainerenter = true
				})
			elseif ( IsControlJustReleased( 1, 202 ) or IsDisabledControlJustReleased( 1, 202 ) ) then -- back
				SendNUIMessage({
					trainerback = true
				})
			end

			if ( IsControlJustReleased( 1, 172 ) or IsDisabledControlJustReleased( 1, 172 ) ) then -- up
				SendNUIMessage({
					trainerup = true
				})
			elseif ( IsControlJustReleased( 1, 173 ) or IsDisabledControlJustReleased( 1, 173 ) ) then -- down
				SendNUIMessage({
					trainerdown = true
				})
			end

			if ( IsControlJustReleased( 1, 174 ) or IsDisabledControlJustReleased( 1, 174 ) ) then -- left
				SendNUIMessage({
					trainerleft = true
				})
			elseif ( IsControlJustReleased( 1, 175 ) or IsDisabledControlJustReleased( 1, 175 ) ) then -- right
				SendNUIMessage({
					trainerright = true
				})
			end
		end
	end
end)




--[[
  _   _   _    _   _____      _____           _   _   _                      _          
 | \ | | | |  | | |_   _|    / ____|         | | | | | |                    | |         
 |  \| | | |  | |   | |     | |        __ _  | | | | | |__     __ _    ___  | | __  ___ 
 | . ` | | |  | |   | |     | |       / _` | | | | | | '_ \   / _` |  / __| | |/ / / __|
 | |\  | | |__| |  _| |_    | |____  | (_| | | | | | | |_) | | (_| | | (__  |   <  \__ \
 |_| \_|  \____/  |_____|    \_____|  \__,_| |_| |_| |_.__/   \__,_|  \___| |_|\_\ |___/
--]]


-- Callbacks from the trainer.
RegisterNUICallback("debug", function(data, cb)
	Citizen.Trace(tostring(data))
end)


RegisterNUICallback("statetoggles", function(data, cb)
	--Citizen.Trace("State Toggles NUI Callback")
	local array = data.data
	local menuID = data.menuid

	-- Wait 100 should be used in most places so lets wait for them to update variables if needed
	-- Before checking.
	Wait(300)
	local results = {}

	for	k,v in pairs(array) do
		results[k] = GetToggleState(k)
		--Citizen.Trace(k.." is "..results[k])
	end
	local jsonResult = json.encode(results,{indent = true})

	SendNUIMessage({
		statetoggles = true,
		statesdata = jsonResult,
		menuid = menuID
	})
end)


RegisterNUICallback("playsound", function(data, cb)
	PlaySoundFrontend(-1, data.name, "HUD_FRONTEND_DEFAULT_SOUNDSET",  true)
	if cb then cb("ok") end
end)


RegisterNUICallback("trainerclose", function(data, cb)
	showtrainer = false
	if cb then cb("ok") end
end)

-- Reset certain non-static menus.
function resetTrainerMenus(message)
	SendNUIMessage({
		resetmenus = message
	})
end



-- Check for ingame Events that should trigger trainer resets.
Citizen.CreateThread(function()
	local inVeh = false
	
	while true do
		Wait(1)
		local playerPed = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsUsing(playerPed)

		if(IsPedInAnyVehicle(playerPed))then
			if(playerPed == GetPedInVehicleSeat(playerVeh, -1))then
				-- Only toggle on first find of new vehicle
				if(not(inVeh))then
					-- Toggle any vehicle settings
					Citizen.Trace("Applying Vehicle Options")
					TriggerEvent('mellotrainer:playerEnteredVehicle')
				end

				inVeh = true
			end
		else
			inVeh = false
		end

	end
end)



initServerConfig()