local CruiseControl = 0
local originalspeed = 110.0

Citizen.CreateThread( function()
    while true do 
        Citizen.Wait(1)   
        local ped = GetPlayerPed(-1)
        local inVehicle = IsPedSittingInAnyVehicle(ped)
        if ped and inVehicle then
              local vehicle = GetVehiclePedIsIn(ped, false)
              local speed = GetEntitySpeed(vehicle)
            -- debug
            --originalspeed = Citizen.InvokeNative(0x53AF99BAA671CA47, Citizen.PointerValueFloatInitialized(vehicle))
            --drawNotification("Max SPEED :" .. originalspeed)
            --
            if IsControlJustPressed(1, 20) then
                if (GetPedInVehicleSeat(vehicle, -1) == ped) then
                    if(math.floor(speed*3.6) > 49) then
                        if CruiseControl == 0 then
                            speedLimit = speed  
                            SetEntityMaxSpeed(vehicle, speedLimit)
    						drawNotification("Limiteur ~g~Activé :~n~~s~Vitesse max : ".. math.floor(speedLimit*3.6).."kmh")
    						Citizen.Wait(1000)
    				        DisplayHelpText("Ajuster votre vitesse avec ~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_DOWN~")
    						PlaySound(-1, "COLLECTED", "HUD_AWARDS", 0, 0, 1)
                            CruiseControl = 1
                        else
                            drawNotification("Limiteur ~r~Désactivé")   
                            originalspeed = Citizen.InvokeNative(0x53AF99BAA671CA47, Citizen.PointerValueFloatInitialized(vehicle))
                            SetEntityMaxSpeed(vehicle, originalspeed)					
                            CruiseControl = 0
                        end
                    else
                        drawNotification('Vous ne pouvez pas activer le Limiteur à moins de 50 km/h')
                        originalspeed = Citizen.InvokeNative(0x53AF99BAA671CA47, Citizen.PointerValueFloatInitialized(vehicle))
                        SetEntityMaxSpeed(vehicle, originalspeed)
                        CruiseControl = 0
                    end
                else
				    drawNotification("Action disponible uniquement en voiture")						
                end
            elseif IsControlJustPressed(1, 27) then
                if CruiseControl == 1 and (math.floor(speedLimit*3.6) > 49) then
                    speedLimit = speedLimit + 1
                    SetEntityMaxSpeed(vehicle, speedLimit)
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					DisplayHelpText("Vitesse Maximale ".. math.floor(speedLimit*3.6).. "kmh")
                end
            elseif IsControlJustPressed(1, 173) then
                if CruiseControl == 1  and (math.floor(speedLimit*3.6) > 49) then
                    speedLimit = speedLimit - 1
					if speedLimit < 0 then speedLimit = 0 end
                    SetEntityMaxSpeed(vehicle, speedLimit)
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)	
					DisplayHelpText("Vitesse Maximale ".. math.floor(speedLimit*3.6).. "kmh")
                end
            end
        end
    end
end)

function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end