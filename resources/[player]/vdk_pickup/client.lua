local pickups_activated = {}

RegisterNetEvent("vdk_pickup:addpickupclient")
AddEventHandler("vdk_pickup:addpickupclient", function(playerx, playery, playerz, item, idtab, qty)
    local object12 = CreatePickup(GetHashKey("PICKUP_MONEY_PAPER_BAG"), playerx, playery + 3, playerz - 0.5, 8, 0, false)
    table.insert(pickups_activated, {['pickup'] = object12, ['item'] = item, ['id'] = idtab, ['qty'] = qty})
end)

RegisterNetEvent("vdk_pickup:rempickupclient")
AddEventHandler("vdk_pickup:rempickupclient", function(idtab)
    local index = nil
    for k, v in ipairs(pickups_activated) do
        if v.id == idtab then
            table.remove(pickups_activated, k)
            RemovePickup(v.pickup)
            break
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    TriggerServerEvent('vdk_pickup:recuperationpickups')
    while true do
        Citizen.Wait(1)
        if #pickups_activated > 0 then
            for k, v in ipairs(pickups_activated) do
                if DoesPickupExist(v.pickup) then
                    if HasPickupBeenCollected(v.pickup) then
                    	local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                        TriggerServerEvent("vdk_pickup:rempickup", v.id)
                        if (exports.vdk_inventory:tryFull(v.qty) == true) then
                        	TriggerEvent('player:receiveItem', v.item.item_id, v.qty)
                            TriggerServerEvent("item:RamasseMsg", v.item.libelle, v.qty)
                            exports.vdk_inventory:ClosePlayerInventory() -- Ferme l'inventaire du joueur
                            exports.vdk_truck_inv:CloseVehiclesInventory() -- Ferme l'inventaire du véhicule
                            TriggerEvent("ft_libs:AdvancedNotification", {
                               icon = "CHAR_MP_STRIPCLUB_PR",
                               title = "iTrium",
                                text = "Ramassé : ~g~".. v.qty .." ~b~" .. v.item.libelle
                            })
                        else
                            TriggerServerEvent('vdk_pickup:addpickup', playerx, playery + 0.50, playerz, v.item, v.qty)
                            TriggerEvent("ft_libs:AdvancedNotification", {
                                icon = "CHAR_MP_STRIPCLUB_PR",
                                title = "iTrium",
                                text = "Vous avez trop d'objets sur vous !"
                            })
                        end
                    else
                        local pickupcoord = GetPickupCoords(v.pickup)
                        DrawText3D(pickupcoord['x'], pickupcoord['y'], pickupcoord['z'], v.qty .. "x " .. v.item.libelle)
                    end
                end
            end
        end
    end
end)


function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    if dist <= 8.0 then
        local scale = (1 / dist) * 2
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = scale * fov
        if onScreen then
            SetTextScale(0.0 * scale, 0.4 * scale)
            SetTextFont(0)
            SetTextProportional(1)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(2, 0, 0, 0, 150)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            SetTextCentre(1)
            AddTextComponentString(text)
            DrawText(_x, _y)
        end
    end
end
