local holdingup = false
local store = ""
local secondsRemaining = 0
local incircle = false
local posLastBraquage = {}
-- ###BLIPS POUR TEST #####
-- Citizen.CreateThread(function() -- blips ( à supprimer après les tests)
	-- for k,v in pairs(stores)do
		-- local ve = v.position

		-- local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		-- SetBlipSprite(blip, 437)
		-- SetBlipScale(blip, 0.8)
		-- SetBlipAsShortRange(blip, true)
		-- BeginTextCommandSetBlipName("STRING")
		-- AddTextComponentString("Braquage")
		-- EndTextCommandSetBlipName(blip)
	-- end
-- end)
-- #############################




RegisterNetEvent('braquages:currentlyrobbing') -- remise à la valeur max du décompteur de temps
AddEventHandler('braquages:currentlyrobbing', function(robb)

	holdingup = true
	store = robb
	secondsRemaining = stores[robb].DureeBraquage
end)

RegisterNetEvent('braquages:toofarlocal') -- message quitter la zone
AddEventHandler('braquages:toofarlocal', function(robb)
	holdingup = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Braquage annulé, Vous vous êtes trop éloigné du coffre ! Partez à plus de "..DistanceSac.. "pour passer incognito ! ")
	
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('braquages:notifycop2')
AddEventHandler('braquages:notifycop2', function(text,state,robb)

	if exports["c_services"]:getIsInService() then -- uniquement pour la LSPD
		if state == true then  -- Blips si début
			if robb ~= nil then 
				POLICE_currentBlip = AddBlipForCoord(stores[robb].position.x, stores[robb].position.y, stores[robb].position.z)
				SetBlipSprite(POLICE_currentBlip, 58)
				SetBlipColour(POLICE_currentBlip, 5)
			end
		else 				-- remove si annulé
			RemoveBlip(POLICE_currentBlip)
		end 
		SetNotificationTextEntry('STRING')
		AddTextComponentString(text)
		DrawNotification(false, false)
		
	end
end)


RegisterNetEvent('braquages:robberycomplete') -- fin du braquage, message argent
AddEventHandler('braquages:robberycomplete', function(robb)
	holdingup = false
	TriggerEvent('chatMessage', 'COFFRE', {0,255, 0}, "Bravo ! Vous avez dérobé: "..robb.."$ ! Partez à plus de "..DistanceSac.. " pour passer incognito !") 
	store = ""
	secondsRemaining = 0	
	incircle = false
	SetPedComponentVariation(GetPlayerPed(-1), 5, 45, 0, 2) --ajout du sac
end)

Citizen.CreateThread(function() -- décompteur de temps
	while true do
		if holdingup then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end
		Citizen.Wait(1)
		end
end)




Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		if posLastBraquage ~=nil then
			if (GetDistanceBetweenCoords(pos, posLastBraquage.x, posLastBraquage.y, posLastBraquage.z,true) > DistanceSac) then
				SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 2) -- retrait du sac
			end
		end
		for k,v in pairs(stores)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if not holdingup then
					DrawMarker(29, v.position.x, v.position.y, v.position.z , 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555,0, 0,255, 1, 0, 0,0)
					
					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0) then
						if (incircle == false) then
							DisplayHelpText("~INPUT_CONTEXT~ pour cambrioler ~b~" .. v.nameofstore .. " !~w~ Cela vous coutera ~r~"..CoutMateriel.."~w~ $ de matériel.")
						end
						incircle = true
						if(IsControlJustReleased(1, 51))then
						 if exports["c_services"]:getIsInService() == true then -- impossible pour les flics
							 TriggerEvent('chatMessage', "BRAQUAGE", {255, 0, 0}, "Vous êtes policier ! Vous ne pouvez pas cambrioler !");
							 else
				
								TriggerServerEvent('braquages:stestcop',k,GetNbBraqueurs())
							 end
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end
		
		-- #### BRAQUAGE EN COURS #####
		if holdingup then
			drawTxt(0.9, 1.44, 1.0,1.0,0.4, "Cambriolage : ~r~" .. secondsRemaining .. "~w~ secondes restantes", 255, 255, 255, 255)
			SetPedComponentVariation(GetPlayerPed(-1), 5, 44, 0, 2) --ajout du sac
			local pos2 = stores[store].position
			local posLastBraquage = pos2
			DrawMarker(1, pos2.x, pos2.y, pos2.z -0.5, 0, 0, 0, 0, 0, 0, 12.0, 12.0, 0.2, 1555, 0, 0,255, 1, 0, 0,0) 

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 6.5)then
				TriggerServerEvent('braquages:toofar', store,stores[store].nameofstore)
				
			end
		end
		Citizen.Wait(1)
	end
end)




function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
function Chat(t)
	TriggerEvent("chatMessage", 'BRAQUAGE', { 0, 255, 255}, "" .. tostring(t))
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
function GetNbBraqueurs()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
	local NbBraqueurs = 1
    for index, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            if( distance < 10) then
                NbBraqueurs= NbBraqueurs + 1
               
            end
        end
    end
    return NbBraqueurs
end