--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 24/05/2017
-- Time: 02:37
-- To change this template use File | Settings | File Templates.
--
wearingHat = false
wearingGlasses = false
wearingPercing = false
wearingMask = false

RegisterNetEvent("accessories_switcher:WearHat")
AddEventHandler("accessories_switcher:WearHat", function(item)
    SetPedPropIndex(GetPlayerPed(-1), 0, item.prop_id,item.prop_txt, 0)
end)

RegisterNetEvent("accessories_switcher:toggleHat")
AddEventHandler("accessories_switcher:toggleHat", function()
    if wearingHat then
        wearingHat = false
        ClearPedProp(GetPlayerPed(-1),0)
    else
        wearingHat = true
        TriggerServerEvent("accessories_switcher:server_wearHat")
    end
end)

RegisterNetEvent("accessories_switcher:WearPercing")
AddEventHandler("accessories_switcher:WearPercing", function(item)
    SetPedPropIndex(GetPlayerPed(-1), 2, item.percing,item.percing_txt, 0)
end)

RegisterNetEvent("accessories_switcher:togglePercing")
AddEventHandler("accessories_switcher:togglePercing", function()
    if wearingPercing then
        wearingPercing = false
        ClearPedProp(GetPlayerPed(-1),1)
    else
        wearingPercing = true
        TriggerServerEvent("accessories_switcher:server_wearGlasses")
    end
end)

RegisterNetEvent("accessories_switcher:WearGlasses")
AddEventHandler("accessories_switcher:WearGlasses", function(item)
    SetPedPropIndex(GetPlayerPed(-1), 1, item.prop_id,item.prop_txt, 0)
end)

RegisterNetEvent("accessories_switcher:toggleGlasses")
AddEventHandler("accessories_switcher:toggleGlasses", function()
    if wearingGlasses then
        wearingGlasses = false
        ClearPedProp(GetPlayerPed(-1),1)
    else
        wearingGlasses = true
        TriggerServerEvent("accessories_switcher:server_wearGlasses")
    end
end)

RegisterNetEvent("accessories_switcher:WearMask")
AddEventHandler("accessories_switcher:WearMask", function(item)
--    print(item.prop_id .. " " ..item.prop_txt)
    SetPedComponentVariation(GetPlayerPed(-1), 1, item.prop_id,item.prop_txt, 0)
end)

RegisterNetEvent("accessories_switcher:toggleMasks")
AddEventHandler("accessories_switcher:toggleMasks", function()
    if wearingMask then
        wearingMask = false
		SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0)
    else
        wearingMask = true
        TriggerServerEvent("accessories_switcher:server_wearMask")
    end
end)
