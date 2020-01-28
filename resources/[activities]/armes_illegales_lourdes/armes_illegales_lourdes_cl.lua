local posVentes = {
	{ x = -2166.36, y = 5197.02, z = 16.38 },
	{ x = 575.28, y = -3121.3, z = 18.27},
}
local isMafieu = false


RegisterNetEvent('armes_illegales_lourdes:receiveIsMafieu')
RegisterNetEvent("armes_illegales_lourdes:selection")


AddEventHandler("playerSpawned", function()
  TriggerServerEvent("armes_illegales_lourdes:checkIsMafieu")
end)

AddEventHandler('armes_illegales_lourdes:receiveIsMafieu', function(result)
  if(result == 1) then
	isMafieu = true
  else
	isMafieu = false
  end
end)

AddEventHandler("armes_illegales_lourdes:selection", function(data)
	local item = data.itemid
	local price = data.price
	if (exports.vdk_inventory:notFull() == true) then
		TriggerServerEvent('armes_illegales_lourdes:testprix',item,price)
	else
		Chat("INVENTAIRE PLEIN")
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in ipairs(posVentes) do
			if (isMafieu == true) then
				if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 20.0)then
					DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
					if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 1.0)then
						DisplayHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir/fermer l'atelier de fabrication")
						if(IsControlJustReleased(1, 51))then
							Menu.initMenu()
							Menu.isOpen = not Menu.isOpen
						end
						if Menu.isOpen then
							Menu.draw()
							Menu.keyControl()
						end
					end
				end
			end
		end
	end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function Chat(t)
	TriggerEvent("chatMessage", 'Atelier de fabrication', { 0, 255, 255}, "" .. tostring(t))
end