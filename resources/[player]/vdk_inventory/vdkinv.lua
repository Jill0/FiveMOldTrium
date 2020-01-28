ITEMS = {}
-- flag to keep track of whether player died to prevent
-- multiple runs of player dead code
local playerdead = false
local maxCapacity = 100
local handCuffed = false
local WeaponNames = {
    ['WEAPON_KNIFE'] = 'Couteau',
    ['WEAPON_NIGHTSTICK'] = 'Nightstick',
    ['WEAPON_HAMMER'] = 'Marteau',
    ['WEAPON_BAT'] = 'Batte de baseball',
    ['WEAPON_GOLFCLUB'] = 'Club de golf',
    ['WEAPON_CROWBAR'] = 'Barre de fer',
    ['WEAPON_PISTOL'] = 'Pistolet',
    ['WEAPON_COMBATPISTOL'] = 'Pistolet de combat',
    ['WEAPON_APPISTOL'] = 'Pistolet AP',
    ['WEAPON_PISTOL50'] = 'Pistolet .50',
    ['WEAPON_MICROSMG'] = 'Micro SMG',
    ['WEAPON_SMG'] = 'SMG',
    ['WEAPON_SMG_MK2'] = 'Mitraillette',
    ['WEAPON_ASSAULTSMG'] = 'Assault SMG',
    ['WEAPON_ASSAULTRIFLE'] = 'Assault Rifle',
    ['WEAPON_ASSAULTRIFLE_MK2'] = 'Assault Rifle 2',
    ['WEAPON_CARBINERIFLE'] = 'Carbine Rifle',
    ['WEAPON_ADVANCEDRIFLE'] = 'Advanced Rifle',
    ['WEAPON_MG'] = 'MG',
    ['WEAPON_COMBATMG'] = 'Combat MG',
    ['WEAPON_PUMPSHOTGUN'] = 'Pump Shotgun',
    ['WEAPON_SAWNOFFSHOTGUN'] = 'Sawed-Off Shotgun',
    ['WEAPON_ASSAULTSHOTGUN'] = 'Assault Shotgun',
    ['WEAPON_BULLPUPSHOTGUN'] = 'Bullpup Shotgun',
    ['WEAPON_STUNGUN'] = 'Tazer',
    ['WEAPON_SNIPERRIFLE'] = 'Sniper Rifle',
    ['WEAPON_HEAVYSNIPER'] = 'Heavy Sniper',
    ['WEAPON_REMOTESNIPER'] = 'Remote Sniper',
    ['WEAPON_GRENADELAUNCHER'] = 'Grenade Launcher',
    ['WEAPON_GRENADELAUNCHER_SMOKE'] = 'Smoke Grenade Launcher',
    ['WEAPON_RPG'] = 'RPG',
    ['WEAPON_STINGER'] = 'Stinger [Vehicle]',
    ['WEAPON_MINIGUN'] = 'Minigun',
    ['WEAPON_GRENADE'] = 'Grenade',
    ['WEAPON_STICKYBOMB'] = 'Sticky Bomb',
    ['WEAPON_SMOKEGRENADE'] = 'Tear Gas',
    ['WEAPON_BZGAS'] = 'BZ Gas',
    ['WEAPON_MOLOTOV'] = 'Molotov',
    ['WEAPON_FIREEXTINGUISHER'] = 'Fire Extinguisher',
    ['WEAPON_PETROLCAN'] = 'Jerry Can',
    ['WEAPON_BALL'] = 'Ball',
    ['WEAPON_FLARE'] = 'Flare',
    ['WEAPON_RAMMED_BY_CAR'] = 'Rammed by Car',
    ['WEAPON_BOTTLE'] = 'Bottle',
    ['WEAPON_GUSENBERG'] = 'Gusenberg',
    ['WEAPON_SNSPISTOL'] = 'Pétoire',
    ['WEAPON_VINTAGEPISTOL'] = 'Vintage Pistol',
    ['WEAPON_DAGGER'] = 'Antique Cavalry Dagger',
    ['WEAPON_FLAREGUN'] = 'Flare Gun',
    ['WEAPON_HEAVYPISTOL'] = 'Pistolet Lourd',
    ['WEAPON_SPECIALCARBINE'] = 'Special Carbine',
    ['WEAPON_MUSKET'] = 'Musket',
    ['WEAPON_FIREWORK'] = 'Firework Launcher',
    ['WEAPON_MARKSMANRIFLE'] = 'Marksman Rifle',
    ['WEAPON_HEAVYSHOTGUN'] = 'Heavy Shotgun',
    ['WEAPON_PROXMINE'] = 'Proximity Mine',
    ['WEAPON_HOMINGLAUNCHER'] = 'Homing Launcher',
    ['WEAPON_HATCHET'] = 'Hache',
    ['WEAPON_COMBATPDW'] = 'Combat PDW',
    ['WEAPON_KNUCKLE'] = 'Knuckle Duster',
    ['WEAPON_MARKSMANPISTOL'] = 'Marksman Pistol',
    ['WEAPON_MACHETE'] = 'Machete',
    ['WEAPON_MACHINEPISTOL'] = 'Tec 9',
    ['WEAPON_FLASHLIGHT'] = 'Flashlight',
    ['WEAPON_DBSHOTGUN'] = 'Double Barrel Shotgun',
    ['WEAPON_COMPACTRIFLE'] = 'Fusil Compact',
    ['WEAPON_SWITCHBLADE'] = 'Cran d\'arrêt',
    ['WEAPON_REVOLVER'] = 'Revolver',
    ['WEAPON_BARBED_WIRE'] = 'Barbed Wire',
    ['WEAPON_VEHICLE_ROCKET'] = 'Vehicle Rocket',
    ['WEAPON_BULLPUPRIFLE'] = 'Bullpup Rifle',
    ['WEAPON_ASSAULTSNIPER'] = 'Assault Sniper',
    ['WEAPON_RAILGUN'] = 'Railgun',
    ['WEAPON_AUTOSHOTGUN'] = 'Automatic Shotgun',
    ['WEAPON_BATTLEAXE'] = 'Battle Axe',
    ['WEAPON_COMPACTLAUNCHER'] = 'Lance Grenade Compacte',
    ['WEAPON_MINISMG'] = 'Mini SMG',
    ['WEAPON_PIPEBOMB'] = 'Pipebomb',
    ['WEAPON_PUMPSHOTGUN_MK2'] = 'Fusil à pompe',
    ['WEAPON_POOLCUE'] = 'Poolcue',
    ['WEAPON_WRENCH'] = 'Wrench',
    ['WEAPON_PISTOL_MK2'] = 'Pistolet',
    ['WEAPON_VINTAGEPISTOL'] = 'Pistolet Vintage',
    ['WEAPON_DOUBLEACTION'] = 'Revolver doré',
    ['WEAPON_SNOWBALL'] = 'Boule de Neige'
}
-- register events, only needs to be done once

RegisterNetEvent("gui:getItems")
RegisterNetEvent("player:receiveItem")
RegisterNetEvent("player:looseItem")
RegisterNetEvent("player:sellItem")
RegisterNetEvent("player:sellItemSale")
RegisterNetEvent("weapon:dropWeapon")

function Chat(t)
    TriggerEvent("chatMessage", 'TRUCKER', {0, 255, 255}, "" .. tostring(t))
end

-- DEBUG
--[[
Citizen.CreateThread(function()
while true do
Citizen.Wait(5000)
TriggerServerEvent("item:getItems")
end
end)
--]]
--

-- handles when a player spawns either from joining or after death
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("item:getItems")
    -- reset player dead flag
    playerdead = false
    TriggerServerEvent("skin_customization:SpawnPlayer")
end)

AddEventHandler("gui:getItems", function(THEITEMS)
    ITEMS = {}
    ITEMS = THEITEMS
end)

AddEventHandler("player:receiveItem", function(item, quantity)
    if(quantity >= 1) then
        quantity = math.floor(quantity)
        if (tryFull(quantity)) then
            item = tonumber(item)
            if (ITEMS[item] == nil) then
                new(item, quantity)
            else
                add({item, quantity})
            end
            ClosePlayerInventory() -- Ferme l'inventaire du joueur
            exports.vdk_truck_inv:CloseVehiclesInventory() -- Ferme l'inventaire du véhicule
        end
    end
end)

AddEventHandler("player:looseItem", function(item, quantity)
    item = tonumber(item)
    local quantity = math.floor(quantity)
    if (ITEMS[item].quantity >= quantity) then
        delete({item, quantity})
    end
    ClosePlayerInventory() -- Ferme l'inventaire du joueur
    exports.vdk_truck_inv:CloseVehiclesInventory() -- Ferme l'inventaire du véhicule
end)

AddEventHandler("player:sellItem", function(item, price)
    item = tonumber(item)
    local quantity = math.floor(ITEMS[item].quantity)
    if (quantity >= 1) then
        sell({item, price})
    end
    ClosePlayerInventory() -- Ferme l'inventaire du joueur
    exports.vdk_truck_inv:CloseVehiclesInventory() -- Ferme l'inventaire du véhicule
end)

AddEventHandler("player:sellItemSale", function(item, price)
    item = tonumber(item)
    local quantity = math.floor(ITEMS[item].quantity)
    if (quantity >= 1) then
        sellsale({item, price})
    end
    ClosePlayerInventory() -- Ferme l'inventaire du joueur
    exports.vdk_truck_inv:CloseVehiclesInventory() -- Ferme l'inventaire du véhicule
end)

function ClosePlayerInventory()
    if(not Menu.hidden) then
        Menu.hidden = true
    end
end

function sell(arg)
    local itemId = tonumber(arg[1])
    local price = arg[2]
    local item = ITEMS[itemId]
    item.quantity = math.floor(item.quantity - 1)
    TriggerServerEvent("item:sell", itemId, item.quantity, price)
    --    InventoryMenu()
end

function sellsale(arg)
    local itemId = tonumber(arg[1])
    local price = arg[2]
    local item = ITEMS[itemId]
    item.quantity = math.floor(item.quantity - 1)
    TriggerServerEvent("item:sellsale", itemId, item.quantity, price)
    --    InventoryMenu()
end

function delete(arg)
    local itemId = tonumber(arg[1])
    local qty = arg[2]
    local item = ITEMS[itemId]
    item.quantity = item.quantity - qty
    TriggerServerEvent("item:updateQuantity", item.quantity, itemId)
end

function jeter(arg)
    DisplayOnscreenKeyboard(1, "Quantité :", "", "", "", "", "", 3)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end
    if (GetOnscreenKeyboardResult()) then
        local itemId = tonumber(arg[1])
        local item = ITEMS[itemId]
        local res = 1
        res = tonumber(GetOnscreenKeyboardResult())
        if (type(res) == "number") and (res ~= nil) and (math.floor(res) ~= 0) then
            if (math.floor(res) > 0) and (math.floor(res) == res) then
                if (item.quantity - res >= 0 and res >= 1) then
                    local playerx, playery, playerz = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                    TriggerEvent("player:looseItem", itemId, res)
                    --print("item name"..item.libelle..)
                    --print("quantity"..res..)
                    TriggerServerEvent("item:JetMsg", item.libelle, res)
                    TriggerServerEvent("vdk_pickup:addpickup", playerx, playery, playerz, item, res)
                    local ped = GetPlayerPed(-1)
                    if ped then
                        TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false)
                        Citizen.Wait(1000)
                        ClearPedTasks(GetPlayerPed(-1))
                    end
                    Menu.hidden = not Menu.hidden
                    ClearMenu()
                end
            end
        end
    end
end

function add(arg)
    local itemId = tonumber(arg[1])
    local qty = arg[2]
    local item = ITEMS[itemId]
    item.quantity = math.floor(item.quantity + qty)
    TriggerServerEvent("item:updateQuantity", item.quantity, itemId)
    
    --Test
    if (itemId == 19 and item.quantity > 8 or itemId == 20 and item.quantity > 8) then
        TriggerServerEvent("item:updateQuantity", 8, itemId)
    end
    --    InventoryMenu()
end

function new(item, quantity)
    TriggerServerEvent("item:setItem", item, quantity)
    TriggerServerEvent("item:getItems")
end

function getQuantity(itemId)
    if ITEMS[tonumber(itemId)] ~= nil then
        return ITEMS[tonumber(itemId)].quantity
    end
    return 0
end

function getPods()
    local pods = 0
    for _, v in pairs(ITEMS) do
        pods = pods + v.quantity
    end
    return pods
end

function notFull()
    local pods = 0
    for _, v in pairs(ITEMS) do
        pods = pods + v.quantity
    end
    if (pods < (maxCapacity)) then return true end
end

function tryFull(quantity)
    local pods = 0
    for _, v in pairs(ITEMS) do
        pods = pods + v.quantity
    end
    if ((pods + quantity) < (maxCapacity)) then return true end
end

function InventoryMenu()
    ped = GetPlayerPed(-1)
    ClearMenu()
    -- Menu Armes
    local count_ws = 0
    for k, v in pairs(WeaponNames) do
        if HasPedGotWeapon(GetPlayerPed(-1), GetHashKey(k), false) then
            count_ws = count_ws + 1
            if(count_ws == 1) then
                Menu.addButton("-------- Armes équipées ---------", "InventoryMenu", nil)
            end
            Menu.addButton(WeaponNames[tostring(k)], "ArmeMenu", k)
        end
    end
    if(count_ws > 0) then
        Menu.addButton("---------- Objets ----------", "InventoryMenu", nil)
    end
    --
    for ind, value in pairs(ITEMS) do
        if (value.quantity > 0) then
            Menu.addButton(tostring(value.libelle) .. " : " .. tostring(value.quantity), "ItemMenu", ind)
        end
    end
    MenuTitle = "Objets: " .. (getPods() or 0) .. "/" .. maxCapacity .. " et " .. count_ws .. " Armes"
end

function ArmeMenu(armeID)
    ClearMenu()
    MenuTitle = "Armes :"
    --Menu.addButton("Donner", "give_ws", armeID)
    Menu.addButton("Ne plus équiper", "jeter_ws", armeID)
end

AddEventHandler("weapon:dropWeapon", function(weapon_model, has_weapon)
    if(has_weapon) then
        RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey(weapon_model))
        TriggerEvent('chatMessage', 'INFO', {255, 0, 0}, "L'arme est retirée !")
    else
        TriggerEvent('chatMessage', 'INFO', {255, 0, 0}, "Vous ne possédez pas cette arme !")
    end
end)

function jeter_ws(armeID)
    if notFull() then
        TriggerEvent("jeter_ws", armeID)
    else
        TriggerEvent('chatMessage', 'INFO', {255, 0, 0}, "Inventaire plein !")
        Menu.hidden = not Menu.hidden
    end
end

RegisterNetEvent('jeter_ws')
AddEventHandler('jeter_ws', function(armeID)
    --
    local demonter_encours = true
    local step_monter = 1
    local delai_demontage = 15
    while demonter_encours do
        if not Menu.hidden then
            ClearMenu()
            MenuTitle = "Armes :"
            if not IsPedUsingScenario(ped, "PROP_HUMAN_PARKING_METER") then
                TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false)
            end
            local step_equal = (delai_demontage - step_monter) - 1
            if (step_equal == 0) then
                Menu.addButton("Démontage terminé !", "closemenu")
                Wait(500)
                ClearPedTasks(GetPlayerPed(-1))
                TriggerServerEvent("weapon:controlWeapon", armeID)
                Menu.hidden = not Menu.hidden
                demonter_encours = not demonter_encours
            else
                Menu.addButton("Démontage en cours |" .. string.rep("=", step_monter) .. ">" .. string.rep("_", step_equal) .. "|", "closemenu")
                step_monter = step_monter + 1
                Wait(1000)
                ClearMenu()
            end
        else
            ClearPedTasks(GetPlayerPed(-1))
            demonter_encours = not demonter_encours
            ClearMenu()
        end
    end
end)

function ItemMenu(itemId)
    ClearMenu()
    --local destroy = {itemId , 1}
    MenuTitle = "Details:"
    Menu.addButton("Utiliser", "use", itemId)
    Menu.addButton("Donner", "give", itemId)
    Menu.addButton("Jeter", "jeter", {itemId, 1})
end

function give(item)
    player, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) and (IsPedInAnyVehicle(GetPlayerPed(-1), true) == false) then
        DisplayOnscreenKeyboard(1, "Quantité :", "", "", "", "", "", 3)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0)
            Wait(0)
        end
        if (GetOnscreenKeyboardResult()) then
            local res = 1
            res = tonumber(GetOnscreenKeyboardResult())
            if (type(res) == "number") and (res ~= nil) and (math.floor(res) ~= 0) then
                if (math.floor(res) > 0) and (math.floor(res) == res) then
                    if (ITEMS[item].quantity - res >= 0 and res >= 1) then
                        TriggerServerEvent("player:giveItem", item, ITEMS[item].libelle, res, GetPlayerServerId(player))
                        TriggerServerEvent("item:TradeMsg", ITEMS[item].libelle, res, GetPlayerServerId(player))
                        local ped = GetPlayerPed(-1)
                        if ped then
                            TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false)
                            Citizen.Wait(1500)
                            ClearPedTasks(GetPlayerPed(-1))
                        end
                        Menu.hidden = not Menu.hidden
                    else
                        TriggerEvent("ft_libs:AdvancedNotification", {
                            icon = "CHAR_MP_STRIPCLUB_PR",
                            title = "iTrium",
                            text = "Non, ça ne marche pas comme ça..."
                        })
                    end
                else
                    TriggerEvent("ft_libs:AdvancedNotification", {
                        icon = "CHAR_MP_STRIPCLUB_PR",
                        title = "iTrium",
                        text = "Merci d'éviter les chiffres/nombres à virgule ou inférieurs à 0 !"
                    })
                end
            end
        end
    else
        TriggerEvent("ft_libs:AdvancedNotification", {
            icon = "CHAR_MP_STRIPCLUB_PR",
            title = "iTrium",
            text = "Pas de joueur proche ou dans un vehicule"
        })
        Menu.hidden = not Menu.hidden
    end
end

function use(item)
    if (ITEMS[item].quantity >= 0) then
        if ITEMS[item].type == 0 then --Nourriture/Boisson
            TriggerServerEvent("player:useItem", item, ITEMS[item].libelle, 1)
            Menu.hidden = true
        elseif ITEMS[item].type == 1 then --Armes
            TriggerEvent("monter_ws", item)
        elseif ITEMS[item].type == 3 then --Menottes
            VDK_Cuffed()
            Menu.hidden = true
        elseif ITEMS[item].type == 4 then --Repair Kit
            RepairVehicle()
            Menu.hidden = true
        elseif ITEMS[item].type == 5 then --Jumelles
            TriggerEvent("jumelles:Active")
            Menu.hidden = true
        end
    end
end

RegisterNetEvent('monter_ws')
AddEventHandler('monter_ws', function(item)
    local monter_encours = true
    local step_monter = 1
    local delai_montage = 15
    while monter_encours do
        if not Menu.hidden then
            ClearMenu()
            MenuTitle = "Armes :"
            if not IsPedUsingScenario(ped, "PROP_HUMAN_PARKING_METER") then
                TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false)
            end
            local step_equal = (delai_montage - step_monter) - 1
            if (step_equal == 0) then
                Menu.addButton("Montage terminé !", "closemenu")
                Wait(500)
                ClearPedTasks(GetPlayerPed(-1))
                TriggerServerEvent("weapon:hasWeapon", ITEMS[item])
                Menu.hidden = not Menu.hidden
                monter_encours = not monter_encours
            else
                Menu.addButton("Montage en cours |" .. string.rep("=", step_monter) .. ">" .. string.rep("_", step_equal) .. "|", "closemenu")
                step_monter = step_monter + 1
                Wait(1000)
                ClearMenu()
            end
        else
            ClearPedTasks(GetPlayerPed(-1))
            monter_encours = not monter_encours
            ClearMenu()
        end
    end
end)

function closemenu()
    Menu.hidden = true
end

function RepairVehicle()
    Citizen.CreateThread(function()
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        veh = GetClosestVehicle(plyCoords["x"], plyCoords["y"], plyCoords["z"], 3.001, 0, 70)
        if(DoesEntityExist(veh)) then
            if(GetVehicleEngineHealth(veh) > 0) then
                --ClearPedTasksImmediately(GetPlayerPed(-1))
                --TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_VEHICLE_MECHANIC", 0, true)
                TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_player", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                Citizen.Wait(20000)
                EngineEndommaged = GetVehicleEngineHealth(veh)
                EngineHealth = EngineEndommaged + 400
                SetVehicleEngineHealth(veh, EngineHealth)
                --SetVehicleFixed(veh, 1)
                --SetVehicleDeformationFixed(veh, 1)
                SetVehicleUndriveable(veh, 1)
                ClearPedTasksImmediately(GetPlayerPed(-1))
                TriggerEvent('chatMessage', 'REPARATION', {255, 0, 0}, "Votre véhicule est réparé. Vous pouvez rouler !")
                TriggerEvent("player:looseItem", 107, 1)
            else
                TriggerEvent('chatMessage', 'REPARATION', {255, 0, 0}, "Le véhicule est trop endommagé !")
            end
        else
            TriggerEvent('chatMessage', 'REPARATION', {255, 0, 0}, "Aucun véhicule proche!")
        end
    end)
end

Citizen.CreateThread(function()
    -- Load the bouncer animation (testing)
    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Wait(1)
    end
end)

function VDK_Cuffed()
    t, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:mettremenottesnouvchangementcasse", GetPlayerServerId(t))
    else
        TriggerEvent('chatMessage', 'GOUVERNMENT', {255, 0, 0}, "Pas de joueur proche!")
    end
end

RegisterNetEvent('item:getArrestedetouicchiant')
AddEventHandler('item:getArrestedetouicchiant', function()
    handCuffed = not handCuffed
    if (handCuffed) then
        TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Vous avez été menotté.")
        SetPedComponentVariation(GetPlayerPed(-1), 7, 41, 0, 0)
        TriggerEvent('gcPhone:handCuffed', true)
    else
        TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Liberté ! Adieu merveilleuses menottes ...")
        SetPedComponentVariation(GetPlayerPed(-1), 7, 0, 0, 0)
        TriggerEvent('gcPhone:handCuffed', false)
    end
end)

RegisterNetEvent("item:handCuffed")
AddEventHandler("item:handCuffed", function(bool)
    handCuffed = bool
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if ((IsControlJustPressed(1, 311)) and (handCuffed == false) and (not IsEntityDead(PlayerPedId(-1)))) then
            Citizen.Wait(250)
            InventoryMenu() -- Menu to draw
            Menu.hidden = not Menu.hidden -- Hide/Show the menu
        end
        Menu.renderGUI() -- Draw menu on each tick if Menu.hidden = false
        -- if IsEntityDead(PlayerPedId()) then
        -- PlayerIsDead()
        -- -- prevent the death check from overloading the server
        -- playerdead = true
        -- end
    end
end)

-- function PlayerIsDead()
-- -- do not run if already ran
-- if playerdead then
-- return
-- end
-- TriggerServerEvent("item:reset")
-- end

----------------------------------------------------------------

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    
    for index, value in ipairs(players) do
        local target = GetPlayerPed(value)
        --Chat(target.." TARGET")
        --Chat(ply.. " PLY")
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
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

