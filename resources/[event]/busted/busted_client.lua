local ped = GetPlayerPed(-1)


--[[
local checked_current_vehicle = false

local isRadarExtended = false

Citizen.CreateThread(function()

	while true do

		Wait(1)

		-- show blips
		for id = 0, 32 do

			if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1) then

				ped = GetPlayerPed(id)
				blip = GetBlipFromEntity(ped)

				-- HEAD DISPLAY STUFF --

				-- Create head display (this is safe to be spammed)
				headId = Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, GetPlayerName( id ), false, false, "", false )

				-- Speaking display
				if NetworkIsPlayerTalking( id ) then
					Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 9, true ) -- Add speaking sprite
				else
					Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 9, false ) -- Remove speaking sprite
				end

				-- BLIP STUFF --

				if not DoesBlipExist( blip ) then -- Add blip and create head display on player

					blip = AddBlipForEntity( ped )
					SetBlipSprite( blip, 1 )
					Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator

				else -- update blip

					veh = GetVehiclePedIsIn( ped, false )
					blipSprite = GetBlipSprite( blip )

					if veh then

						vehClass = GetVehicleClass( veh )
						vehModel = GetEntityModel( veh )
						
						SetBlipSprite( blip, 42 )
						Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator

					else

						-- Remove leftover number
						HideNumberOnBlip( blip )

						if blipSprite ~= 1 then -- default blip

							SetBlipSprite( blip, 1 )
							Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true ) -- Player Blip indicator

						end

					end

					SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) ) -- update rotation
					SetBlipNameToPlayerName( blip, id ) -- update blip name
					SetBlipScale( blip,  0.85 ) -- set scale
					SetBlipAlpha( blip, 255 )
	
				end

			end

		end

	end

end) ]]--

bustedMenu = Menu.new("Busted!", "", 0.15, 0.14, 0.28, 0.4, 0)
bustedMenu.config.pcontrol = false
bustedMenu:addButton("Police", "Assigne le véhicule de police")
bustedMenu:addButton("Fuyard", "Assigne le véhicule du fuyard")
--bustedMenu:addButton("Go !", "Lance la course")
--bustedMenu:addButton("Busted!", "Stop la course quand le fuyard s'est fait attraper")

RegisterNetEvent('busted:openMenu')
AddEventHandler('busted:openMenu', function()
	bustedMenu:Open()
end)

function setRunaway()
	if IsPedSittingInAnyVehicle(ped) then 
        local vehRunaway = GetVehiclePedIsIn(ped, false)
		print(vehRunaway)
		SetEntityAsMissionEntity(vehRunaway, true, true)
		--vehSettings(vehRunaway)
		local blipRunaway = AddBlipForEntity(vehRunaway)
		SetBlipSprite(blipRunaway, 4)
		--SetBlipColour(blipRunaway, 1)
		SetBlipDisplay(blipRunaway, 2)
		SetBlipCategory(blipRunaway, 2)
		--SetBlipAsFriendly(blipRunaway, false)
		
		SetDisableVehiclePetrolTankDamage(vehRunaway, false)
		SetDisableVehiclePetrolTankFires(vehRunaway, false)
		SetVehicleCanBeVisiblyDamaged(vehRunaway, true)
		SetVehicleCanBreak(vehRunaway, false)
		SetVehicleEngineCanDegrade(vehRunaway, false)
		SetVehicleExplodesOnHighExplosionDamage(vehRunaway, true)
		SetVehicleStrong(vehRunaway, true)
		SetVehicleTyresCanBurst(vehRunaway, false)
		SetVehicleWheelsCanBreak(vehRunaway, false)
		SetVehicleNumberPlateText(vehRunaway, "CATCHMEIFUCAN")
		--TriggerServerEvent('ls:refreshid', GetVehicleNumberPlateText(vehRunaway), vehRunaway)
	end
	ShowNotif("Véhicule de ~r~fuyard~s~ prêt")
end

function setPolice()
	if IsPedSittingInAnyVehicle(ped) then 
        local vehPolice = GetVehiclePedIsIn(ped, false)
		SetEntityAsMissionEntity(vehPolice, true, true)
		--vehSettings(vehPolice)
				local blipPolice = AddBlipForEntity(vehPolice)	
		if GetVehicleClass(vehPolice) == 15 then
			SetBlipSprite(blipPolice, 15)
		else
			SetBlipSprite(blipPolice, 42)
		end
		--SetBlipColour(blipRunaway, 1)
		--SetBlipDisplay(blipRunaway, 2)
		--SetBlipCategory(blipRunaway, 2)
		--SetBlipAsFriendly(blipRunaway, false)

		SetDisableVehiclePetrolTankDamage(vehPolice, false)
		SetDisableVehiclePetrolTankFires(vehPolice, false)
		SetVehicleCanBeVisiblyDamaged(vehPolice, true)
		SetVehicleCanBreak(vehPolice, false)
		SetVehicleEngineCanDegrade(vehPolice, false)
		SetVehicleExplodesOnHighExplosionDamage(vehPolice, true)
		SetVehicleStrong(vehPolice, true)
		SetVehicleTyresCanBurst(vehPolice, false)
		SetVehicleWheelsCanBreak(vehPolice, false)
		SetVehicleNumberPlateText(vehPolice, "POLICE")
		--TriggerServerEvent('ls:refreshid', GetVehicleNumberPlateText(vehPolice), vehPolice)
	end
	ShowNotif("Véhicule de ~b~police~s~ prêt")
end

function startRace()
	ShowNotif("La course va ~g~démarrer")
	--start timer
	--start race
end

function bustedScreen()			
	StartScreenEffect("DeathFailOut", 0, 0)
	if not locksound then
		PlaySoundFrontend(-1, "Bed", "WastedSounds", 1)
		locksound = true
	end
	ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)			
	local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
	if HasScaleformMovieLoaded(scaleform) then
		Wait(0)
		PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		BeginTextComponent("STRING")
		AddTextComponentString("~r~wasted")
		EndTextComponent()
		PopScaleformMovieFunctionVoid()
		Wait(500)
		PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
        while IsEntityDead(PlayerPedId()) do
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			Wait(0)
		end 
		StopScreenEffect("DeathFailOut")
		locksound = false
	end
end

function stopRace()
	SetFadeInAfterDeathArrest(true)
	wait(1000)
	SetFadeInAfterDeathArrest(false)
	bustedScreen()
	SetFadeOutAfterDeath(true)
	wait(1000)
	SetFadeOutAfterDeath(false)
	--Has last .. time
	--bringall + erase car
	ShowNotif("La course est ~r~finie")
end

function bustedMenu:onButtonSelected(name,btn)
	if name == "Fuyard" then
		setRunaway()
	elseif name == "Police" then
		setPolice()
	elseif name == "Go !" then
		startRace()
	elseif name == "Busted!" then
		stopRace()
	end
	bustedMenu:Close()
end