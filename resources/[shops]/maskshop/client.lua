
local options = {
    x = 0.15,
    y = 0.15,
    width = 0.25,
    height = 0.035,
    scale = 0.2,
    font = 0,
    menu_title = "Magasin de masques",
    menu_subtitle = "Categories",
    color_r = 50,
    color_g = 0,
    color_b = 10
}

local MaskStores = {
    { x = -1336.18, y = -1277.77, z = 3.78128, markerWidth = 2.0001, activationDist = 2.5 }
}

RegisterNetEvent("maskshop:notifs")
AddEventHandler("maskshop:notifs", function(msg)
    notifs(msg)
end)
function notifs(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString( msg )
    DrawNotification(false, false)
end

local MASKS_LIST = {}
local DRESSING_MASKS_LIST = {}

RegisterNetEvent('maskshop:setMasksList')
AddEventHandler('maskshop:setMasksList', function(list)
    MASKS_LIST = {}
    MASKS_LIST = list
end)

RegisterNetEvent('maskshop:setDressingMasksList')
AddEventHandler('maskshop:setDressingMasksList', function(list)
    DRESSING_MASKS_LIST = {}
    for k,mask in ipairs(list) do
        DRESSING_MASKS_LIST[k] = mask
    end
end)

---------------------------------------------------- FUNCTIONS ---------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- Check if player is near a bank
function isNearShop()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for _, item in pairs(MaskStores) do
        local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if(distance <= item.activationDist ) then
            return true
        end
    end
end

function setMapMarker(stores, blipIcon, blipColor, blipName)
    for k,v in ipairs(stores)do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, blipIcon)
        SetBlipColour(blip, blipColor)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipName)
        EndTextCommandSetBlipName(blip)
    end
end

------------------------------------------------------- NUI ------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
local inmaskmenu = nil

function Main()
    options.menu_title = "Magasin de masques"
    options.menu_subtitle = "Accueil"
    ClearMenu()
    Menu.selection = 1
    inmaskmenu = nil
    Menu.addButton("Acheter un masque", "BuyMasks", nil)
    Menu.addButton("Changer de masque", "ChangeMask", nil)
end

function BuyMasks()
    options.menu_subtitle = "Acheter un masque"
    ClearMenu()
    Menu.previous = "Main"
    inmaskmenu = MASKS_LIST
    for i,c in pairs(MASKS_LIST) do
        local name = "Masque n°" .. MASKS_LIST[Menu.buttonCount+1].id
        if MASKS_LIST[Menu.buttonCount+1].item_name ~= nil then
            name = MASKS_LIST[Menu.buttonCount+1].item_name
        end
        Menu.addButton(name .. " - " .. comma_value(MASKS_LIST[Menu.buttonCount+1].price) .. "$", "buyamask", MASKS_LIST[Menu.buttonCount+1])
    end
end

function ChangeMask()
    options.menu_subtitle = "Changer de masque"
    ClearMenu()
    Menu.previous = "Main"
    if #DRESSING_MASKS_LIST > 0 then
        inmaskmenu = DRESSING_MASKS_LIST
        for i,c in pairs(DRESSING_MASKS_LIST) do
            local name = "Masque n°" .. DRESSING_MASKS_LIST[Menu.buttonCount+1].id
            if DRESSING_MASKS_LIST[Menu.buttonCount+1].item_name ~= nil then
                name = DRESSING_MASKS_LIST[Menu.buttonCount+1].item_name
            end
            Menu.addButton(name, "changeamask", {prop_id = DRESSING_MASKS_LIST[Menu.buttonCount+1].prop_id, prop_txt = DRESSING_MASKS_LIST[Menu.buttonCount+1].prop_txt})
        end
    end
end

-- Close Gui
function closeGui()
    SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0)
    inmaskmenu = nil
    Menu.hidden=true
    FreezeEntityPosition(GetPlayerPed(-1), false)
end

function buyamask(mask)
    TriggerServerEvent('maskshop:buyProp',{price = mask.price, category = mask.category, item_id = mask.prop_id, txt = mask.prop_txt})
    closeGui()
end

function changeamask(prop)
    TriggerServerEvent('maskshop:wearMaskProp', prop.prop_id, prop.prop_txt)
    closeGui()
end

function masksSelector(maskID, maskVariation)
  SetPedComponentVariation(GetPlayerPed(-1), 1, maskID, maskVariation, 0)
end

function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

------------------------------------------------------ THREAD ----------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    setMapMarker(MaskStores, 362, 21, "Magasin de masques")
    while true do
        Citizen.Wait(0)
        if isNearShop() then
            SetTextComponentFormat("STRING")
            AddTextComponentString("Appuyez sur la touche ~INPUT_CONTEXT~ pour ouvrir le magasin.")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustPressed(1, 51) then
                TriggerServerEvent('maskshop:getModelAndList')
                if Menu.hidden == true then
                    Menu.hidden = false
                    Main()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                else
                    closeGui()
                end
            end
        end
        if inmaskmenu then
            if Menu.selection > 0 then
                local propid = inmaskmenu[Menu.selection].prop_id
                local proptxt = inmaskmenu[Menu.selection].prop_txt
                masksSelector(propid, proptxt)
            end
        end
        if Menu.hidden == false then
            Menu.renderGUI(options)
            DisableControlAction(0, 24, active) -- Attack
            DisablePlayerFiring( GetPlayerPed(-1), true) -- Disable weapon firing
            DisableControlAction(0, 142, active) -- MeleeAttackAlternate
            DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
        end

    end
end)