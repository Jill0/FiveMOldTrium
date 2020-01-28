-- CONFIG
useKPH = true -- use kph or mph
inputGroup, ControlIndex = 0, 137 --default toggle for kph/mph is caps lock
local compteurx = 0 -- 0 Par defaud
local compteury = 0 -- 0 Par defaud
-- CONFIG END

colorfuelr, colorfuelg, colorfuelb = 255, 255, 255
curBackground, rpmScale, curAlpha, curJaugeAlpha, curHeliPlane = "compteur", 242,0,0,0 -- ignore this stuff
RPM, showBlinker= 0, false -- ignore this too

function math.round(num, numDecimalPlaces)
	return string.format("%.0f", num)
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local statusHUD = exports["Players"]:getStatusHUD()
		if not statusHUD then
			speedTable = {}
			local veh = GetVehiclePedIsUsing(PlayerPedId())
			----------------- Affichage helico/avion/train/velo ---------------
			if (IsPedInAnyHeli(GetPlayerPed(-1),true) or IsPedInAnyPlane(GetPlayerPed(-1),true) or IsPedInAnyBoat(GetPlayerPed(-1),true) or IsThisModelABicycle(GetEntityModel(veh)) or IsPedInAnyTrain(GetPlayerPed(-1),true)) and (GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 or GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) and IsVehicleEngineOn(veh) then
				local PlateVeh = GetVehicleNumberPlateText(veh)
				drawTxt(1.423, 1.20, 1.0,1.0,0.55, "~w~" .. PlateVeh, 255, 255, 255, 255)
				if curHeliPlane >= 255 then
					curHeliPlane = 255
					if IsThisModelABicycle(GetEntityModel(veh)) or IsPedInAnyTrain(GetPlayerPed(-1),true) then
						curJaugeAlpha = 0
					else
						curJaugeAlpha = 255
					end
				else
					curHeliPlane = curHeliPlane+5
				end
				if IsControlJustPressed(inputGroup, ControlIndex) and not IsThisModelABicycle(GetEntityModel(veh)) then
					useKPH = not useKPH
				end
				if IsThisModelABicycle(GetEntityModel(veh)) then
					useKPH = true
				end
				------------- Affichage voitures/motos ---------------------
			elseif (IsPedInAnyVehicle(GetPlayerPed(-1),true) and GetSeatPedIsTryingToEnter(GetPlayerPed(-1)) == -1 or GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1)) and IsVehicleEngineOn(veh) then
				local PlateVeh = GetVehicleNumberPlateText(veh)
				drawTxt(1.3875, 1.333, 1.0,1.0,0.38, "~w~" .. PlateVeh, 255, 255, 255, 255)
				if curAlpha >= 200 then
					curAlpha = 200
				else
					curAlpha = curAlpha+5
				end
				if IsControlJustPressed(inputGroup, ControlIndex) then
					useKPH = not useKPH
				end
			elseif not IsPedInAnyVehicle(GetPlayerPed(-1),false) then
				if curHeliPlane <= 0 then
					curHeliPlane = 0
					curJaugeAlpha = 0
				else
					curHeliPlane = curHeliPlane-5
					curJaugeAlpha = curJaugeAlpha-5
				end
				if curAlpha <= 0 then
					curAlpha = 0
				else
					curAlpha = curAlpha-5
				end
				blinkerleft,blinkerright = false,false
			end
			--------------------------------------------------
			if not HasStreamedTextureDictLoaded("monspeedmeter") then
				RequestStreamedTextureDict("monspeedmeter", true)
				while not HasStreamedTextureDictLoaded("monspeedmeter") do
					Wait(1)
				end
			else
				DrawSprite("monspeedmeter", curBackground, 0.905+compteurx,0.805+compteury,0.15,0.25, 0.0, 255, 255, 255, curAlpha)
				DrawSprite("monspeedmeter", "heli_background", 0.900+compteurx,0.805+compteury,0.17,0.13, 0.0, 255, 255, 255, curHeliPlane)
				if DoesEntityExist(veh) then
					RPM = GetVehicleCurrentRpm(veh)
					if RPM > 0.99 and GetVehicleFuelLevel(veh) ~= 0.0 then
						RPM = RPM*100
						RPM = RPM+math.random(-2,2)
						RPM = RPM/100
					end
					if not GetIsVehicleEngineRunning(veh) then RPM = 0.0 end -- fix for R*'s Engine RPM fuckery
					_,lightson,highbeams = GetVehicleLightsState(veh)
					if lightson == 1 or highbeams == 1 then
						 curBackground = "compteur" --	At night
						if highbeams == 1 then
							showHighBeams,showLowBeams = true,false
						elseif lightson == 1 and highbeams == 0 then
							showHighBeams,showLowBeams = false,true
						end
					else
						curBackground = "compteur"
						showHighBeams,showLowBeams = false,false
					end

					if showHighBeams then
						DrawSprite("monspeedmeter", "flights", 0.896+compteurx,0.877+compteury,0.014,0.015,0, 0, 50, 240, curAlpha)
					else
						DrawSprite("monspeedmeter", "flights", 0.896+compteurx,0.877+compteury,0.014,0.015,0, 55, 55, 55, curAlpha)
					end
					if showLowBeams then
						DrawSprite("monspeedmeter", "lights", 0.88+compteurx,0.877+compteury,0.014,0.015,0, 0, 255, 0, curAlpha)
					else
						DrawSprite("monspeedmeter", "lights", 0.88+compteurx,0.877+compteury,0.014,0.015,0, 55, 55, 55, curAlpha)
					end
					-------------------------------------------------------------------
					overwriteChecks = false -- debug value to display all icons
					----------------------------Blinkers-------------------------------
					-------------------------------------------------------------------
					blinkerstate = GetVehicleIndicatorLights(veh) -- owo whats this
					if blinkerstate == 0 or not IsVehicleEngineOn(veh) then
						blinkerleft,blinkerright = false,false
					elseif blinkerstate == 1 and IsVehicleEngineOn(veh) then
						blinkerleft,blinkerright = true,false
					elseif blinkerstate == 2 and IsVehicleEngineOn(veh) then
						blinkerleft,blinkerright = false,true
					elseif blinkerstate == 3 and IsVehicleEngineOn(veh) then
						blinkerleft,blinkerright = true,true
					end
					if overwriteChecks then
						showBlinker,blinkerleft,blinkerright = true, true, true
					end
					if blinkerleft and showBlinker then
						DrawSprite("monspeedmeter", "blinker", 0.870+compteurx,0.85+compteury,0.022,0.03,180.0, 124,252,0, curAlpha)
					else
						DrawSprite("monspeedmeter", "blinker", 0.870+compteurx,0.85+compteury,0.022,0.03,180.0, 55,55,55, curAlpha)
					end
					if blinkerright and showBlinker then
						DrawSprite("monspeedmeter", "blinker", 0.940+compteurx,0.85+compteury,0.022,0.03,0.0, 124,252,0, curAlpha)
					else
						DrawSprite("monspeedmeter", "blinker", 0.940+compteurx,0.85+compteury,0.022,0.03,0.0, 55,55,55, curAlpha)
					end
					--------------------------------------------------------------------
					-------------------- Engine, Oil, Fuel, lights ---------------------
					--------------------------------------------------------------------
					engineHealth = GetVehicleEngineHealth(veh)
					if engineHealth <= 800 and engineHealth > 500 then
						showDamageYellow,showDamageRed, showDamageGrey = true, false, false
						OilLevel = 1
					elseif engineHealth <= 500 then
						showDamageYellow,showDamageRed, showDamageGrey = false, true, false
						if engineHealth <= 200 then
							OilLevel = 0
						end
					else
						showDamageYellow,showDamageRed, showDamageGrey = false, false, true
						OilLevel = 1
					end
					local logof = "fuel"
					getelec = exports.es_AdvancedFuel:getelec()
					if getelec['es'] then
						MaxFuelLevel = 0.142
						FuelLevel = getelec['es']
					else
						MaxFuelLevel = 0
						FuelLevel = 0
					end
					if getelec['el'] then
						logof = "elec"
					else
						logof = "fuel"
					end
					if FuelLevel <= MaxFuelLevel*0.2 and FuelLevel > MaxFuelLevel*0.11 then
						showLowFuelYellow,showLowFuelRed = true,false
					elseif FuelLevel <= MaxFuelLevel*0.11 then
						showLowFuelYellow,showLowFuelRed = false,true
					else
						showLowFuelYellow,showLowFuelRed = false,false
					end
					if OilLevel <= 0.5 then
						showLowOil = true
					else
						showLowOil = false
					end
					if overwriteChecks then
						showDamageRed,showLowFuelRed,showLowOil = true, true, true
					end
					if MaxFuelLevel ~= 0 then
						colorfuel2r, colorfuel2g, colorfuel2b = 55, 55, 55
						colorfuelr, colorfuelg, colorfuelb = 255, 255, 255
						if showLowFuelYellow then
							colorlogor, colorlogog, colorlogob = 255, 191, 0
						elseif showLowFuelRed then
							colorlogor, colorlogog, colorlogob = 255, 0, 0
						else
							if curHeliPlane == 255 then
								colorlogor, colorlogog, colorlogob = 255, 255, 255
							else
								colorlogor, colorlogog, colorlogob = 55, 55, 55
							end
						end
						DrawSprite("monspeedmeter", logof, 0.986+compteurx,0.865+compteury,0.012,0.022,0, colorlogor, colorlogog, colorlogob, curJaugeAlpha)
						DrawSprite("monspeedmeter", logof, 0.954+compteurx,0.862+compteury,0.01,0.017,0, colorlogor, colorlogog, colorlogob, curAlpha)

						if FuelLevel >= MaxFuelLevel*0.99 then
							DrawSprite("monspeedmeter", "full", 0.986+compteurx,0.725+compteury,0.012,0.022,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "full", 0.959+compteurx,0.754+compteury,0.006,0.011,0, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "full", 0.986+compteurx,0.725+compteury,0.012,0.022,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "full", 0.959+compteurx,0.754+compteury,0.006,0.011,0, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
						if FuelLevel >= MaxFuelLevel*0.11 then
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.846+compteury,0.005,0.010,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.962+compteurx,0.845+compteury,0.01,0.007, 10.0, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.846+compteury,0.005,0.010,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.962+compteurx,0.845+compteury,0.01,0.007, 10.0, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
						if FuelLevel >= MaxFuelLevel*0.2 then
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.833+compteury,0.005,0.010,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.964+compteurx,0.835+compteury,0.01,0.007, 7.5, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.833+compteury,0.005,0.010,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.964+compteurx,0.835+compteury,0.01,0.007, 7.5, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
						if FuelLevel >= MaxFuelLevel*0.3 then
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.820+compteury,0.005,0.010,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9655+compteurx,0.825+compteury,0.01,0.007, 5.0, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.820+compteury,0.005,0.010,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9655+compteurx,0.825+compteury,0.01,0.007, 5.0, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
						if FuelLevel >= MaxFuelLevel*0.4 then
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.807+compteury,0.005,0.010,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9662+compteurx,0.815+compteury,0.01,0.007, 2.5, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.807+compteury,0.005,0.010,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9662+compteurx,0.815+compteury,0.01,0.007, 2.5, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
						if FuelLevel >= MaxFuelLevel*0.5 then
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.794+compteury,0.005,0.010,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9665+compteurx,0.805+compteury,0.01,0.007, 0.0, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.794+compteury,0.005,0.010,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9665+compteurx,0.805+compteury,0.01,0.007, 0.0, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
						if FuelLevel >= MaxFuelLevel*0.6 then
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.781+compteury,0.005,0.010,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9662+compteurx,0.795+compteury,0.01,0.007, -2.5, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.781+compteury,0.005,0.010,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9662+compteurx,0.795+compteury,0.01,0.007, -2.5, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
						if FuelLevel >= MaxFuelLevel*0.7 then
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.768+compteury,0.005,0.010,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9655+compteurx,0.785+compteury,0.01,0.007, -5.0, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.768+compteury,0.005,0.010,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.9655+compteurx,0.785+compteury,0.01,0.007, -5.0, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
						if FuelLevel >= MaxFuelLevel*0.8 then
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.755+compteury,0.005,0.010,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.964+compteurx,0.775+compteury,0.01,0.007, -7.5, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.755+compteury,0.005,0.010,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.964+compteurx,0.775+compteury,0.01,0.007, -7.5, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
						if FuelLevel >= MaxFuelLevel*0.9 then
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.742+compteury,0.005,0.010,0, colorfuelr, colorfuelg, colorfuelb, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.962+compteurx,0.765+compteury,0.01,0.007, -10.0, colorfuelr, colorfuelg, colorfuelb, curAlpha)
						else
							DrawSprite("monspeedmeter", "fuelbar", 0.986+compteurx,0.742+compteury,0.005,0.010,0, colorfuel2r, colorfuel2g, colorfuel2b, curJaugeAlpha)
							DrawSprite("monspeedmeter", "barre", 0.962+compteurx,0.765+compteury,0.01,0.007, -10.0, colorfuel2r, colorfuel2g, colorfuel2b, curAlpha)
						end
					end

					if IsPedInAnyHeli(GetPlayerPed(-1),true) or IsPedInAnyPlane(GetPlayerPed(-1),true) or IsPedInAnyBoat(GetPlayerPed(-1),true) then
						if showDamageYellow then
							DrawSprite("monspeedmeter", "engine", 0.920+compteurx,0.850+compteury,0.020,0.025,0, 255, 191, 0, curHeliPlane)
						elseif showDamageRed then
							DrawSprite("monspeedmeter", "engine", 0.920+compteurx,0.850+compteury,0.020,0.025,0, 255, 0, 0, curHeliPlane)
						end
						if showLowOil then
							DrawSprite("monspeedmeter", "oil", 0.895+compteurx,0.850+compteury,0.020,0.025,0, 255, 0, 0, curHeliPlane)
						end
					else
						if showDamageYellow then
							DrawSprite("monspeedmeter", "engine", 0.94+compteurx,0.877+compteury,0.015,0.017,0, 255, 191, 0, curAlpha)
						elseif showDamageRed then
							DrawSprite("monspeedmeter", "engine", 0.94+compteurx,0.877+compteury,0.015,0.017,0, 255, 0, 0, curAlpha)
						elseif showDamageGrey then
							DrawSprite("monspeedmeter", "engine", 0.94+compteurx,0.877+compteury,0.015,0.017,0, 55, 55, 55, curAlpha)
						end
						if showLowOil then
							DrawSprite("monspeedmeter", "oil", 0.923+compteurx,0.877+compteury,0.015,0.018,0, 255, 0, 0, curAlpha)
						else
							DrawSprite("monspeedmeter", "oil", 0.923+compteurx,0.877+compteury,0.015,0.018,0, 55, 55, 55, curAlpha)
						end
					end

					--------------------------------------------------------------------

					if (GetVehicleClass(veh) >= 0 and GetVehicleClass(veh) < 13 or GetVehicleClass(veh) >= 17) or (IsPedInAnyPlane(GetPlayerPed(-1),true) or IsPedInAnyBoat(GetPlayerPed(-1),true) or IsThisModelABicycle(GetEntityModel(veh)) or IsPedInAnyHeli(GetPlayerPed(-1),true)) then
						if useKPH then
							speed = GetEntitySpeed(veh)* 3.6
						else
							speed = GetEntitySpeed(veh)*2.236936
						end
						gear = GetVehicleCurrentGear(veh)+1
					else
						curAlpha = 0
					end
				else
					RPM = 0
				end

				if not gear or (RPM==0 and speed==0) then gear = 1 end

				if gear == 1 and RPM ~= 0 and speed ~= 0 then gear = 0 end

				DrawSprite("monspeedmeter", "gear_"..gear, 0.9055+compteurx,0.735+compteury,0.015,0.030, 0.0, 255, 255, 255, curAlpha)

						if not speed then speed = "0.0" end
						speed = math.round(speed)
						speed = tostring(speed)
						for i = 1, string.len(speed) do
							speedTable[i] = speed:sub(i, i)
						end
				if string.len(speed) == 1 then
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[1], 0.919+compteurx,0.795+compteury,0.020,0.050, 0.0, 255, 255, 255, curAlpha)
				elseif string.len(speed) == 2 then
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[1], 0.900+compteurx,0.795+compteury,0.020,0.050, 0.0, 255, 255, 255, curAlpha)
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[2], 0.919+compteurx,0.795+compteury,0.020,0.050, 0.0, 255, 255, 255, curAlpha)
				elseif string.len(speed) == 3 then
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[1], 0.881+compteurx,0.795+compteury,0.020,0.050, 0.0, 255, 255, 255, curAlpha)
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[2], 0.900+compteurx,0.795+compteury,0.020,0.050, 0.0, 255, 255, 255, curAlpha)
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[3], 0.919+compteurx,0.795+compteury,0.020,0.050, 0.0, 255, 255, 255, curAlpha)
				elseif string.len(speed) >= 4 then
					DrawSprite("monspeedmeter", "speed_digits_9", 0.881+compteurx,0.795+compteury,0.020,0.050, 0.0, 255, 255, 255, curAlpha)
					DrawSprite("monspeedmeter", "speed_digits_9", 0.900+compteurx,0.795+compteury,0.020,0.050, 0.0, 255, 255, 255, curAlpha)
					DrawSprite("monspeedmeter", "speed_digits_9", 0.919+compteurx,0.795+compteury,0.020,0.050, 0.0, 255, 255, 255, curAlpha)
				end

				if useKPH then
					DrawSprite("monspeedmeter", "kmh", 0.94+compteurx,0.815+compteury,0.015,0.015, 0.0, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "mph", 0.94+compteurx,0.815+compteury,0.015,0.015, 0.0, 255, 255, 255, curAlpha)
				end

				----------------------------------- compte tours ------------------------------
				if RPM > 0.09 then
					DrawSprite("monspeedmeter", "barre", 0.8605+compteurx,0.875+compteury,0.01,0.007, -18.0, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.860+compteurx,0.875+compteury,0.01,0.007, -17.5, 55, 55, 55, curAlpha)
				end
				if RPM > 0.12 then
					DrawSprite("monspeedmeter", "barre", 0.856+compteurx,0.865+compteury,0.01,0.007, -15.0, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.856+compteurx,0.865+compteury,0.01,0.007, -15.0, 55, 55, 55, curAlpha)
				end
				if RPM > 0.16 then
					DrawSprite("monspeedmeter", "barre", 0.852+compteurx,0.855+compteury,0.01,0.007, -12.5, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.852+compteurx,0.855+compteury,0.01,0.007, -12.5, 55, 55, 55, curAlpha)
				end
				if RPM > 0.29 then
					DrawSprite("monspeedmeter", "barre", 0.849+compteurx,0.845+compteury,0.01,0.007, -10.0, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.849+compteurx,0.845+compteury,0.01,0.007, -10.0, 55, 55, 55, curAlpha)
				end
				if RPM > 0.40 then
					DrawSprite("monspeedmeter", "barre", 0.847+compteurx,0.835+compteury,0.01,0.007, -7.5, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.847+compteurx,0.835+compteury,0.01,0.007, -7.5, 55, 55, 55, curAlpha)
				end
				if RPM > 0.50 then
					DrawSprite("monspeedmeter", "barre", 0.8455+compteurx,0.825+compteury,0.01,0.007, -5.0, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.8455+compteurx,0.825+compteury,0.01,0.007, -5.0, 55, 55, 55, curAlpha)
				end
				if RPM > 0.60 then
					DrawSprite("monspeedmeter", "barre", 0.8448+compteurx,0.815+compteury,0.01,0.007, -2.5, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.8448+compteurx,0.815+compteury,0.01,0.007, -2.5, 55, 55, 55, curAlpha)
				end
				if RPM > 0.70 then
					DrawSprite("monspeedmeter", "barre", 0.8445+compteurx,0.805+compteury,0.01,0.007, 0.0, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.8445+compteurx,0.805+compteury,0.01,0.007, 0.0, 55, 55, 55, curAlpha)
				end
				if RPM > 0.79 then
					DrawSprite("monspeedmeter", "barre", 0.8448+compteurx,0.795+compteury,0.01,0.007, 2.5, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.8448+compteurx,0.795+compteury,0.01,0.007, 2.5, 55, 55, 55, curAlpha)
				end
				if RPM > 0.84 then
					DrawSprite("monspeedmeter", "barre", 0.8455+compteurx,0.785+compteury,0.01,0.007, 5.0, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.8455+compteurx,0.785+compteury,0.01,0.007, 5.0, 55, 55, 55, curAlpha)
				end
				if RPM > 0.87 then
					DrawSprite("monspeedmeter", "barre", 0.847+compteurx,0.775+compteury,0.01,0.007, 7.5, 255, 255, 255, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.847+compteurx,0.775+compteury,0.01,0.007, 7.5, 55, 55, 55, curAlpha)
				end
				if RPM > 0.90 then
					DrawSprite("monspeedmeter", "barre", 0.849+compteurx,0.765+compteury,0.01,0.007, 10.0, 255, 245, 0, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.849+compteurx,0.765+compteury,0.01,0.007, 10.0, 55, 45, 0, curAlpha)
				end
				if RPM > 0.92 then
					DrawSprite("monspeedmeter", "barre", 0.852+compteurx,0.755+compteury,0.01,0.007, 12.5, 255, 245, 0, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.852+compteurx,0.755+compteury,0.01,0.007, 12.5, 55, 45, 0, curAlpha)
				end
				if RPM > 0.94 then
					DrawSprite("monspeedmeter", "barre", 0.8552+compteurx,0.745+compteury,0.01,0.007, 15.0, 255, 245, 0, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.8552+compteurx,0.745+compteury,0.01,0.007, 15.0, 55, 45, 0, curAlpha)
				end
				if RPM > 0.96 then
					DrawSprite("monspeedmeter", "barre", 0.8596+compteurx,0.736+compteury,0.01,0.007, 19.5, 255, 245, 0, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.8596+compteurx,0.736+compteury,0.01,0.007, 19.5, 55, 45, 0, curAlpha)
				end
				if RPM > 0.98 then
					DrawSprite("monspeedmeter", "barre", 0.8647+compteurx,0.727+compteury,0.01,0.007, 23.0, 255, 0, 0, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.8647+compteurx,0.727+compteury,0.01,0.007, 23.0, 55, 0, 0, curAlpha)
				end
				if RPM > 1.0 then
					DrawSprite("monspeedmeter", "barre", 0.87+compteurx,0.7185+compteury,0.01,0.007, 28.5, 255, 0, 0, curAlpha)
				else
					DrawSprite("monspeedmeter", "barre", 0.87+compteurx,0.7185+compteury,0.01,0.007, 28.5, 55, 0, 0, curAlpha)
				end

				-------------------------------------------- Compteur Velo, bateau, helico --------------------------------------------------------------
				if string.len(speed) == 1 then
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[1], 0.962+compteurx,0.786+compteury,0.025,0.06, 0.0, 255, 255, 255, curHeliPlane)
				elseif string.len(speed) == 2 then
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[1], 0.938+compteurx,0.786+compteury,0.025,0.06, 0.0, 255, 255, 255, curHeliPlane)
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[2], 0.962+compteurx,0.786+compteury,0.025,0.06, 0.0, 255, 255, 255, curHeliPlane)
				elseif string.len(speed) == 3 then
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[1], 0.918+compteurx,0.786+compteury,0.025,0.06, 0.0, 255, 255, 255, curHeliPlane)
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[2], 0.938+compteurx,0.786+compteury,0.025,0.06, 0.0, 255, 255, 255, curHeliPlane)
					DrawSprite("monspeedmeter", "speed_digits_"..speedTable[3], 0.962+compteurx,0.786+compteury,0.025,0.06, 0.0, 255, 255, 255, curHeliPlane)
				elseif string.len(speed) >= 4 then
					DrawSprite("monspeedmeter", "speed_digits_9", 0.918+compteurx,0.786+compteury,0.025,0.06, 0.0, 255, 255, 255, curHeliPlane)
					DrawSprite("monspeedmeter", "speed_digits_9", 0.938+compteurx,0.786+compteury,0.025,0.06, 0.0, 255, 255, 255, curHeliPlane)
					DrawSprite("monspeedmeter", "speed_digits_9", 0.962+compteurx,0.786+compteury,0.025,0.06, 0.0, 255, 255, 255, curHeliPlane)
				end
				if useKPH then
					DrawSprite("monspeedmeter", "kmh", 0.962+compteurx,0.847+compteury,0.025,0.025, 0.0, 255, 255, 255, curHeliPlane)
				else
					DrawSprite("monspeedmeter", "mph", 0.962+compteurx,0.847+compteury,0.025,0.025, 0.0, 255, 255, 255, curHeliPlane)
				end
				-----------------------------------------------------------------------------------------------------------------------------------------
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if (blinkerleft or blinkerright) and curAlpha ~= 0 then
			showBlinker = true
			TriggerEvent("LIFE_CL:Sound:PlayOnOne","chime",0.7,true)
			Citizen.Wait(500)
			showBlinker = false
			TriggerEvent("LIFE_CL:Sound:StopOnOne")
			Citizen.Wait(500)
		end
	end
end)
