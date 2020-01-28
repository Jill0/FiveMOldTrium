local tauxalcool = 0.0
local tauxcanna = 0.0
local tauxecsta = 0.0
local tauxmeth = 0.0
local tauxopium = 0.0
local tauxhero = 0.0
local tauxcoc = 0.0
local tauxdrug = 0.0
local isNow = false
local isNow1 = false

function Chat(t)
	TriggerEvent("chatMessage", 'TRUCKER', { 0, 255, 255}, "" .. tostring(t))
end

RegisterNetEvent('item:ethylotest')
AddEventHandler('item:ethylotest', function (demandeur, idToTest)
    if idToTest == PlayerId() then
        TriggerServerEvent("item:envoitauxalcool", demandeur, tauxalcool)
    end
end)

RegisterNetEvent('item:affichertauxalcool')
AddEventHandler('item:affichertauxalcool', function (tauxalcooldemande)
    Chat("Le taux d'alcoolémie est de : " .. tauxalcooldemande .. "g/l dans le sang")
end)

RegisterNetEvent("item:drunk")
AddEventHandler("item:drunk", function(item)
	local alcoolavant = tauxalcool
	if menus[item].drunk > 0 then
		tauxalcool = tauxalcool + (0.25 * menus[item].drunk)
		if alcoolavant == 0.0 then
			SetTimecycleModifier("Drunk")
			SetTimecycleModifierStrength(0.0)
			SetPedMotionBlur(GetPlayerPed(-1), true)
			SetPedIsDrunk(GetPlayerPed(-1), true)
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
			SetPedConfigFlag(GetPlayerPed(-1), 100, true)
		end
		TriggerEvent('item:updatedrunk')
	elseif menus[item].drunk < 0 then
		tauxalcool = tauxalcool - (0.25 * (menus[item].drunk * -1))
		if tauxalcool < 0.0 then
			tauxalcool = 0.0
		end
		TriggerEvent('item:updatedrunk')
	end
end)

RegisterNetEvent("item:drug")
AddEventHandler("item:drug", function(item)
	local tauxdrugbefore = tauxdrug
	if menus[item].drug == 1 then
		tauxcanna = tauxcanna + 0.25
		tauxdrug = tauxdrug + 0.25
		if tauxecsta > 0.0 or tauxmeth > 0.0 or tauxopium > 0.0 or tauxhero > 0.0 or tauxcoc > 0.0 then
			SetTimecycleModifier("drug_flying_base")
		else
			if tauxdrugbefore == 0.0 then
				SetTimecycleModifier("drug_flying_01")
				SetTimecycleModifierStrength(0.0)
				SetPedMotionBlur(GetPlayerPed(-1), true)
				ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.0)
			else
				SetTimecycleModifier("drug_flying_01")
			end
		end
		TaskStartScenarioInPlace(ped, "WORLD_HUMAN_SMOKING_POT", 0, true)
    elseif menus[item].drug == 2 then
		tauxecsta = tauxecsta + 0.25
		tauxdrug = tauxdrug + 0.25
		if tauxcanna > 0.0 or tauxmeth > 0.0 or tauxopium > 0.0 or tauxhero > 0.0 or tauxcoc > 0.0 then
			SetTimecycleModifier("drug_flying_base")
		else
			if tauxdrugbefore == 0.0 then
				SetTimecycleModifier("drug_drive_blend01")
				SetTimecycleModifierStrength(0.0)
				SetPedMotionBlur(GetPlayerPed(-1), true)
				ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.0)
			else
				SetTimecycleModifier("drug_drive_blend01")
			end
		end
	elseif menus[item].drug == 3 then
		tauxmeth = tauxmeth + 0.25
		tauxdrug = tauxdrug + 0.25
		if tauxcanna > 0.0 or tauxecsta > 0.0 or tauxopium > 0.0 or tauxhero > 0.0 or tauxcoc > 0.0 then
			SetTimecycleModifier("drug_flying_base")
		else
			if tauxdrugbefore == 0.0 then
				SetTimecycleModifier("drug_wobbly")
				SetTimecycleModifierStrength(0.0)
				SetPedMotionBlur(GetPlayerPed(-1), true)
				ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.0)
			else
				SetTimecycleModifier("drug_wobbly")
			end
		end
	elseif menus[item].drug == 4 then
		tauxopium = tauxopium + 0.25
		tauxdrug = tauxdrug + 0.25
		if tauxcanna > 0.0 or tauxecsta > 0.0 or tauxmeth > 0.0 or tauxhero > 0.0 or tauxcoc > 0.0 then
			SetTimecycleModifier("drug_flying_base")
		else
			if tauxdrugbefore == 0.0 then
				SetTimecycleModifier("DRUG_2_drive")
				SetTimecycleModifierStrength(0.0)
				SetPedMotionBlur(GetPlayerPed(-1), true)
				ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.0)
			else
				SetTimecycleModifier("DRUG_2_drive")
			end
		end
	elseif menus[item].drug == 5 then
		tauxhero = tauxhero + 0.25
		tauxdrug = tauxdrug + 0.25
		if tauxcanna > 0.0 or tauxecsta > 0.0 or tauxmeth > 0.0 or tauxopium > 0.0 or tauxcoc > 0.0 then
			SetTimecycleModifier("drug_flying_base")
		else
			if tauxdrugbefore == 0.0 then
				SetTimecycleModifier("DRUG_gas_huffin")
				SetTimecycleModifierStrength(0.0)
				SetPedMotionBlur(GetPlayerPed(-1), true)
				ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.0)
			else
				SetTimecycleModifier("DRUG_gas_huffin")
			end
		end
	elseif menus[item].drug == 6 then
		tauxcoc = tauxcoc + 0.25
		tauxdrug = tauxdrug + 0.25
		if tauxcanna > 0.0 or tauxecsta > 0.0 or tauxmeth > 0.0 or tauxopium > 0.0 or tauxhero > 0.0 then
			SetTimecycleModifier("drug_flying_base")
		else
			if tauxdrugbefore == 0.0 then
				SetTimecycleModifier("drug_drive_blend02")
				SetTimecycleModifierStrength(0.0)
				SetPedMotionBlur(GetPlayerPed(-1), true)
				ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.0)
			else
				SetTimecycleModifier("drug_drive_blend02")
			end
		end
    end
    TriggerEvent('item:updatedrug')
end)

RegisterNetEvent("item:updatedrunk")
AddEventHandler("item:updatedrunk", function()
	if tauxalcool > 0.0 and tauxalcool < 0.15 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.0)
		SetGameplayCamShakeAmplitude(0.0)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxalcool >= 0.15 and tauxalcool < 0.5 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.1)
		SetGameplayCamShakeAmplitude(0.1)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxalcool >= 0.5 and tauxalcool < 1.0 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.2)
		SetGameplayCamShakeAmplitude(0.2)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxalcool >= 1.0 and tauxalcool < 1.5 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.3)
		SetGameplayCamShakeAmplitude(0.3)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxalcool >= 1.5 and tauxalcool < 2.0 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.4)
		SetGameplayCamShakeAmplitude(0.4)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@MODERATEDRUNK", true)
	elseif tauxalcool >= 2.0 and tauxalcool < 2.5 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.5)
		SetGameplayCamShakeAmplitude(0.5)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@MODERATEDRUNK", true)
	elseif tauxalcool >= 2.5 and tauxalcool < 3.0 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.6)
		SetGameplayCamShakeAmplitude(0.6)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@MODERATEDRUNK", true)
	elseif tauxalcool >= 3.0 and tauxalcool < 3.5 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.7)
		SetGameplayCamShakeAmplitude(0.7)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", true)
	elseif tauxalcool >= 3.5 and tauxalcool < 4.0 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.8)
		SetGameplayCamShakeAmplitude(0.8)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", true)
	elseif tauxalcool >= 4.0 and tauxalcool < 4.5 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.9)
		SetGameplayCamShakeAmplitude(0.9)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", true)
	elseif tauxalcool >= 4.5 then
		if tauxdrug == 0.0 then
			SetTimecycleModifier("Drunk")
			ShakeGameplayCam("DRUNK_SHAKE", 0.0)
		end
		SetTimecycleModifierStrength(0.9)
		SetGameplayCamShakeAmplitude(1.0)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", true)
		if isNow then
			SetPedToRagdoll(GetPlayerPed(-1), 3000, 0, 0, true, true, false)
		end
	elseif tauxalcool == 0.0 then
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(GetPlayerPed(-1), 0)
		SetPedIsDrunk(GetPlayerPed(-1), false)
		SetPedMotionBlur(GetPlayerPed(-1), false)
		StopGameplayCamShaking(true)
		SetPedConfigFlag(GetPlayerPed(-1), 100, false)
	end
	if tauxalcool >= 6.0 then
		SetEntityHealth(GetPlayerPed(-1), 0)
		tauxalcool = 5.9
	end
	if tauxalcool == 0.0 then
		SendNUIMessage({
			setalcohol = true,
			alc = tauxalcool,
			setDisplay = true,
			display = 0
		})
	else
		SendNUIMessage({
			setalcohol = true,
			alc = tauxalcool,
			setDisplay = true,
			display = 1
		})
	end
end)

RegisterNetEvent("item:updatedrug")
AddEventHandler("item:updatedrug", function()
	if tauxdrug > 0.0 and tauxdrug < 0.15 then
		SetTimecycleModifierStrength(0.0)
		SetGameplayCamShakeAmplitude(0.0)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxdrug >= 0.15 and tauxdrug < 0.5 then
		SetTimecycleModifierStrength(0.1)
		SetGameplayCamShakeAmplitude(0.1)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxdrug >= 0.5 and tauxdrug < 1.0 then
		SetTimecycleModifierStrength(0.2)
		SetGameplayCamShakeAmplitude(0.2)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxdrug >= 1.0 and tauxdrug < 1.5 then
		SetTimecycleModifierStrength(0.3)
		SetGameplayCamShakeAmplitude(0.3)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxdrug >= 1.5 and tauxdrug < 2.0 then
		SetTimecycleModifierStrength(0.4)
		SetGameplayCamShakeAmplitude(0.4)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxdrug >= 2.0 and tauxdrug < 2.5 then
		SetTimecycleModifierStrength(0.5)
		SetGameplayCamShakeAmplitude(0.5)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxdrug >= 2.5 and tauxdrug < 3.0 then
		SetTimecycleModifierStrength(0.6)
		SetGameplayCamShakeAmplitude(0.6)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	elseif tauxdrug >= 3.0 and tauxdrug < 3.5 then
		SetTimecycleModifierStrength(0.7)
		SetGameplayCamShakeAmplitude(0.7)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@MODERATEDRUNK", true)
	elseif tauxdrug >= 3.5 and tauxdrug < 4.0 then
		SetTimecycleModifierStrength(0.8)
		SetGameplayCamShakeAmplitude(0.8)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@MODERATEDRUNK", true)
	elseif tauxdrug >= 4.0 and tauxdrug < 4.5 then
		SetTimecycleModifierStrength(0.9)
		SetGameplayCamShakeAmplitude(0.9)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", true)
	elseif tauxdrug >= 4.5 then
		SetTimecycleModifierStrength(1.0)
		SetGameplayCamShakeAmplitude(1.0)
		SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", true)
		if isNow1 then
			SetPedToRagdoll(GetPlayerPed(-1), 3000, 0, 0, true, true, false)
		end
	elseif tauxdrug == 0.0 then
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(GetPlayerPed(-1), 0)
		SetPedMotionBlur(GetPlayerPed(-1), false)
		StopGameplayCamShaking(true)
	end
	if tauxdrug >= 6.0 then
		SetEntityHealth(GetPlayerPed(-1), 0)
		tauxdrug = 5.9
	end
--	if tauxdrug == 0.0 then
--		SendNUIMessage({
--			setalcohol = true,
--			alc = tauxcanna,
--			setDisplay = true,
--			display = 0
--		})
--	else
--		SendNUIMessage({
--			setalcohol = true,
--			alc = tauxcanna,
--			setDisplay = true,
--			display = 1
--		})
--	end
end)

Citizen.CreateThread(function()
  if NetworkIsSessionStarted() then
	  while true do
	  Citizen.Wait(10)
      local status = exports["Players"]:getStatusHUD()
	    -- Open game menu
	    if not IsPauseMenuActive() and not IsHudComponentActive(19) and not IsHudComponentActive(16) and not status then
			SendNUIMessage({
				setOpacity = true,
				opacity = 1
			})
			if tauxalcool > 0.0 then
				SetTimecycleModifier("Drunk")
				SetPedMotionBlur(GetPlayerPed(-1), true)
				ShakeGameplayCam("DRUNK_SHAKE", 0.0)
				TriggerEvent('item:updatedrunk')
			end
		else
			SendNUIMessage({
				setOpacity = true,
				opacity = 0
			})
			if tauxalcool > 0.0 then
				ClearTimecycleModifier()
				SetPedMotionBlur(GetPlayerPed(-1), false)
				StopGameplayCamShaking(true)
			end
	    end
	  end
  end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		if not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
			RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
			while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
				Citizen.Wait(1)
			end
		end
		if not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") then
			RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
			while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
				Citizen.Wait(1)
			end
		end
		if not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK") then
			RequestAnimSet("MOVE_M@DRUNK@MODERATEDRUNK")
			while not HasAnimSetLoaded("MOVE_M@DRUNK@MODERATEDRUNK") do
				Citizen.Wait(1)
			end
		end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(25000)
		if tauxalcool > 0.0 then
			tauxalcool = round(tauxalcool - 0.01, 2)
			TriggerEvent('item:updatedrunk')
			isNow = not isNow
		end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(25000)
		if tauxdrug > 0.0 then
			tauxdrug = round(tauxdrug - 0.01, 2)
			if tauxcanna > 0.0 then
				tauxcanna = round(tauxcanna - 0.01, 2)
			elseif tauxecsta > 0.0 then
				tauxecsta = round(tauxecsta - 0.01, 2)
			elseif tauxmeth > 0.0 then
				tauxmeth = round(tauxmeth - 0.01, 2)
			elseif tauxopium > 0.0 then
				tauxopium = round(tauxopium - 0.01, 2)
			elseif tauxhero > 0.0 then
				tauxhero = round(tauxhero - 0.01, 2)
			elseif tauxcoc > 0.0 then
				tauxcoc = round(tauxcoc - 0.01, 2)
			end
			TriggerEvent('item:updatedrug')
			isNow1 = not isNow1
		end
    end
end)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
