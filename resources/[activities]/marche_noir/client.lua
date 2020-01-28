local isMafieu = false
local options = {
    x = 0.5,
    y = 0.1635,
    width = 0.435,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "~s~Marché noir",
    menu_subtitle = "Categories",
    color_r = 192,
    color_g = 57,
    color_b = 43
}

AddEventHandler("playerSpawned", function()
  TriggerServerEvent("magasin_composants:checkIsMafieu")
end)

RegisterNetEvent('magasin_composants:receiveIsMafieu')
AddEventHandler('magasin_composants:receiveIsMafieu', function(result)
  Citizen.Trace('isMafieu')
  if(result == "0") then
    isMafieu = false
  else
    isMafieu = true
  end
end)

RegisterNetEvent("mp:firstspawn")
AddEventHandler("mp:firstspawn",function()
	Main() -- Menu to draw
    Menu.hidden = not Menu.hidden -- Hide/Show the menu
    Menu.renderGUI(options) -- Draw menu on each tick if Menu.hidden = false
end)

function changemodel(model)
	
	local modelhashed = GetHashKey(model)

	RequestModel(modelhashed)
	while not HasModelLoaded(modelhashed) do 
	    RequestModel(modelhashed)
	    Citizen.Wait(0)
	end

	SetPlayerModel(PlayerId(), modelhashed)
	local a = "" -- nil doesnt work
	SetPedRandomComponentVariation(GetPlayerPed(-1), true)
	SetModelAsNoLongerNeeded(modelhashed)
end

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function Main()
    options.menu_subtitle = "Composants"
    ClearMenu()
    Menu.addButton("Chambre ← ~o~$1", "Chambre", nil)
end

------------------------------
--FONCTIONS
-------------------------------
local magasin_composants = {
	{ ['x'] = 1188.4837646484, ['y'] = 2637.7631835938, ['z'] = 38.441177368164 }
}

--Citizen.CreateThread(function()
--	for k,v in ipairs(magasin_composants)do
--		local blip = AddBlipForCoord(v.x, v.y, v.z)
--		SetBlipSprite(blip, 52)
--		SetBlipScale(blip, 0.8)
--		SetBlipAsShortRange(blip, true)
--		BeginTextCommandSetBlipName("STRING")
--		AddTextComponentString("Magasin de composants pour arme à feu")
--		EndTextCommandSetBlipName(blip)
--	end
--end)

RegisterNetEvent("magasin_composants:Chambre")
AddEventHandler("magasin_composants:Chambre", function()
		TriggerEvent("player:receiveItem", 38, 1)
		print("ss")
	    Menu.hidden = false  
end)

function Chambre()
   	TriggerServerEvent("magasin_composants:Chambres")
    Menu.hidden = false
end


-------------------------
---INVENTAIRE
-------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Press F2 to open menu
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in ipairs(magasin_composants) do
			
				if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 20.0)then
					DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 192, 57, 43, 43, 0,0, 0,0)
					if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 2.0)then
						DisplayHelpText("Appuyer sur ~INPUT_VEH_EXIT~ pour ~r~ouvrir le menu.")
						if IsControlJustPressed(1, 23) then
	                        Main()
	                        Menu.hidden = not Menu.hidden
					    end
	                  Menu.renderGUI(options)
	                end
	            end
        	
		end
	end
end)
