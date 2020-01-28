
local Player          = nil
local CruisedSpeed    = 0
local CruisedSpeedKm  = 0

Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(1)
    if IsControlJustPressed(1, 303) and IsDriver() then
      Player = GetPlayerPed(-1)
      TriggerCruiseControl()
    end
  end
end)

function TriggerCruiseControl ()
  if CruisedSpeed == 0 and IsDriving() then
    if GetVehiculeSpeed() > 0 and GetPedInVehicleSeat(GetVehicle(),-1) then
      CruisedSpeed = GetVehiculeSpeed()
      CruisedSpeedKm = TransformToKm(CruisedSpeed)
      local Current_Vehicle = GetVehicle()
      if(CruisedSpeedKm > 49) then
	      ShowNotif('Régul. ~g~activé ~s~:' .. CruisedSpeedKm .. ' km/h')

	      Citizen.CreateThread(function ()
	        while CruisedSpeed > 0 and IsInVehicle() == Player do
	          Wait(0)
	          if not IsTurningOrHandBraking() and GetVehiculeSpeed() < (CruisedSpeed - 1.5) then
	            CruisedSpeed = 0
	            ShowNotif('Régul. ~r~désactivé')
	            Wait(2000)
	            break
	          end

	          if not IsTurningOrHandBraking() and IsVehicleOnAllWheels(Current_Vehicle) then
	          	if(GetVehicleCurrentGear(Current_Vehicle) ~= nil and GetVehicleCurrentGear(Current_Vehicle) > 0) and not GetVehicleHandbrake(Current_Vehicle) then
	          		if((GetVehiculeSpeed() < CruisedSpeed) and (CruisedSpeedKm > 49)) then
	            		SetVehicleForwardSpeed(Current_Vehicle, CruisedSpeed)
	            	end
	            else
	            	CruisedSpeed = 0
	            	ShowNotif('Régul. ~r~désactivé par sécurité')
	            	Wait(2000)
	            	break
	        	end
	          end

	          if IsControlJustPressed(1, 303) then
	            CruisedSpeed = GetVehiculeSpeed()
	            CruisedSpeedKm = TransformToKm(CruisedSpeed)
	            ShowNotif('Régul. ~g~modifié ~s~: ' .. CruisedSpeedKm .. ' km/h')
	          end

	          if IsControlJustPressed(2, 72) or GetVehicleHandbrake(Current_Vehicle) then
	            CruisedSpeed = 0
	            ShowNotif('Régul. ~r~désactivé')
	            Wait(2000)
	            break
	          end
	        end
	      end)
	  else
	  	CruisedSpeed = 0
	  	ShowNotif('Vous ne pouvez pas activer le régulateur à moins de 50 km/h')
	  end
    end
  end
end

function IsTurningOrHandBraking ()
  return IsControlPressed(2, 76) or IsControlPressed(2, 63) or IsControlPressed(2, 64)
end

function IsDriving ()
  return IsPedInAnyVehicle(Player, false)
end

function GetVehicle ()
  return GetVehiclePedIsIn(Player, false)
end

function IsInVehicle ()
  return GetPedInVehicleSeat(GetVehicle(), -1)
end

function IsDriver ()
  return GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1)
end

function GetVehiculeSpeed ()
  return GetEntitySpeed(GetVehicle())
end

function TransformToKm (speed)
  return math.floor(speed * 3.6 + 0.5)
end

function ShowNotif(text)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(text)
  DrawNotification(true, false)
end