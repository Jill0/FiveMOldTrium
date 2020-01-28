-- AFFICHAGE DU TEXTE --
function drawTxt(txt, scale, xpos, ypos)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, scale)
  SetTextDropshadow(1, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextEntry("STRING")
  AddTextComponentString(txt)
	DrawText(xpos, ypos)
end

CreateThread(function()
	local open = true
  while true do
    Citizen.Wait(10)
		if IsControlJustPressed(1, 10) then -- PAGEUP - INPUT_SCRIPTED_FLY_ZUP
			if open == true then
				open = false
				print("fermé")
			elseif open == false then
				open = true
				print("ouvert")
			end
		end

		if open == true then
			-- VARIABLES --
	    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
	    local roundx = tonumber(string.format("%.2f", x))
	    local roundy = tonumber(string.format("%.2f", y))
	    local roundz = tonumber(string.format("%.2f", z))
			local heading = GetEntityHeading(GetPlayerPed(-1))
	    local roundh = tonumber(string.format("%.2f", heading))
			local speed = GetEntitySpeed(PlayerPedId())
			local health = GetEntityHealth(PlayerPedId())
	    local rounds = tonumber(string.format("%.2f", speed))
			local veheng = GetVehicleEngineHealth(GetVehiclePedIsUsing(PlayerPedId()))
	    local vehbody = GetVehicleBodyHealth(GetVehiclePedIsUsing(PlayerPedId()))
			local logs = "actifs"

			-- DEFINITION AFFICHAGE --
			local size = 0.5
			local x = 0.01
			local y = 0.0
			local line = 0.03

			-- AFFICHAGE --
			drawTxt("~s~PageUP pour ouvrir/fermer", 0.2, x, y)
			y = y + 0.01 -- DECALAGE DU PAGEUP
			drawTxt("~r~SERVER TEST", size, x, y)
			drawTxt("~r~X:~s~ "..roundx, size, x, y + line)
			drawTxt("~r~Y:~s~ "..roundy, size, x, y + line * 2)
			drawTxt("~r~Z:~s~ "..roundz, size, x, y + line * 3)
			drawTxt("~r~H:~s~ "..roundh, size, x, y + line * 4)
			drawTxt("~r~Speed: ~s~"..rounds, size, x, y + line * 5)
			drawTxt("~r~Player HP: ~s~"..health,  size, x, y + line * 6)
			drawTxt("~r~Logs: ~s~"..logs, size, x, y + line * 7)

			-- SI DANS UN VEHICULE --
		  if IsPedInAnyVehicle(PlayerPedId(), 1) then
				local vehenground = tonumber(string.format("%.2f", veheng))
	      local vehbodround = tonumber(string.format("%.2f", vehbody))
		  	drawTxt("~r~Engine HP: ~s~"..vehenground, size, x, y + line * 8)
		  	drawTxt("~r~Bodycar HP: ~s~"..vehbodround, size, x, y + line * 9)
	    end
	  end
	end
end)
