-- Settings
local depositAtATM = false -- Allows the player to deposit at an ATM rather than only in banks (Default: false)
local giveCashAnywhere = false -- Allows the player to give CASH to another player, no matter how far away they are. (Default: false)
local withdrawAnywhere = false -- Allows the player to withdraw cash from bank account anywhere (Default: false)
local depositAnywhere = false -- Allows the player to deposit cash into bank account anywhere (Default: false)
local displayBankBlips = true -- Toggles Bank Blips on the map (Default: true)
local displayAtmBlips = false -- Toggles ATM blips on the map (Default: false) // THIS IS UGLY. SOME ICONS OVERLAP BECAUSE SOME PLACES HAVE MULTIPLE ATM MACHINES. NOT RECOMMENDED
local enableBankingGui = true -- Enables the banking GUI (Default: true) // MAY HAVE SOME ISSUES
local idbank = 0
local charbank = {}
charbank.icon = "CHAR_BANK_MAZE"
charbank.titre = "Maze Bank"
-- ATMS - bank = (0 -> maze / 1 -> fleeca / 2 -> bankofliberty)
local atms = {
	{name = "ATM", x = 310.73, y = -1452.64, z = 29.69, bank = 2},
	{name = "ATM", x = -37.78, y = -1114.99, z = 26.43, bank = 0},
    {name = "ATM", x = -621.01, y = -114.46, z = 39.6, bank = 1},
    {name = "ATM", x = -619.99, y = -113.6, z = 39.6, bank = 1},
    {name = "ATM", x = -386.82, y = 6046.05, z = 31.5017, bank = 2},
    {name = "ATM", x = -283.028, y = 6226.02, z = 31.187, bank = 2},
    {name = "ATM", x = -132.922, y = 6366.54, z = 31.101, bank = 2},
    {name = "ATM", x = -97.3, y = 6455.44, z = 31.784, bank = 2},
    {name = "ATM", x = -95.55, y = 6457.15, z = 31.784, bank = 2},
    {name = "ATM", x = 155.9, y = 6642.85, z = 31.784, bank = 2},
    {name = "ATM", x = 174.147, y = 6637.95, z = 31.784, bank = 2},
    {name = "ATM", x = 1701.21, y = 6426.56, z = 32.730, bank = 2},
    {name = "ATM", x = 1735.23, y = 6410.51, z = 35.164, bank = 2},
    {name = "ATM", x = 1702.96, y = 4933.52, z = 42.051, bank = 2},
    {name = "ATM", x = 1968.13, y = 3743.59, z = 32.272, bank = 2},
    {name = "ATM", x = 1822.7, y = 3683.1, z = 34.244, bank = 2},
    {name = "ATM", x = 1171.99, y = 2702.56, z = 38.027, bank = 2},
    {name = "ATM", x = 540.0420, y = 2671.007, z = 42.177, bank = 0}, --
    {name = "ATM", x = 2564.52, y = 2584.74, z = 38.016, bank = 2},
    {name = "ATM", x = 2558.75, y = 350.99, z = 108.050, bank = 2},
    {name = "ATM", x = 2558.5, y = 389.49, z = 108.660, bank = 2},
    {name = "ATM", x = 1077.75, y = -776.455, z = 58.218, bank = 2},
    {name = "ATM", x = 1138.26, y = -468.908, z = 66.789, bank = 2},
    {name = "ATM", x = 1166.98, y = -456.086, z = 66.7, bank = 2},
    {name = "ATM", x = 1153.884, y = -326.540, z = 69.245, bank = 2},
    {name = "ATM", x = 380.743, y = 323.391, z = 103.270, bank = 2},
    {name = "ATM", x = 237.438, y = 217.842, z = 106.840, bank = 2},
    {name = "ATM", x = 236.68, y = 219.331, z = 106.840, bank = 2},
    {name = "ATM", x = 238.146, y = 216.274, z = 106.840, bank = 2},
    {name = "ATM", x = 265.153, y = 212.011, z = 106.780, bank = 2},
    {name = "ATM", x = 265.603, y = 213.49, z = 106.780, bank = 2},
    {name = "ATM", x = 264.519, y = 210.408, z = 106.780, bank = 2},
    {name = "ATM", x = 285.2029, y = 143.5690, z = 104.970, bank = 2},
    {name = "ATM", x = 158.622, y = 234.201, z = 106.450, bank = 2},
    {name = "ATM", x = -164.568, y = 233.5066, z = 94.919, bank = 0},
    {name = "ATM", x = -1827.28, y = 784.872, z = 138.020, bank = 2},
    {name = "ATM", x = -1409.39, y = -99.2603, z = 52.473, bank = 2},
    {name = "ATM", x = -1205.35, y = -325.579, z = 37.870, bank = 1},
    {name = "ATM", x = -2072.41, y = -316.959, z = 13.345, bank = 2},
    {name = "ATM", x = -2975.01, y = 380.096, z = 14.992, bank = 0},
    {name = "ATM", x = -2957.89, y = 487.493, z = 15.486, bank = 0},
    {name = "ATM", x = -3043.96, y = 594.566, z = 7.595, bank = 0},
    {name = "ATM", x = -3144.36, y = 1127.56, z = 20.868, bank = 2},
    {name = "ATM", x = -3241.17, y = 997.588, z = 12.500, bank = 0},
    {name = "ATM", x = -3240.58, y = 1008.55, z = 12.877, bank = 2},
    {name = "ATM", x = -1305.40, y = -706.240, z = 25.352, bank = 2},
    {name = "ATM", x = -538.225, y = -854.423, z = 29.234, bank = 0},
    {name = "ATM", x = -710.09, y = -818.901, z = 23.768, bank = 2},
    {name = "ATM", x = -712.909, y = -818.944, z = 23.768, bank = 2},
    {name = "ATM", x = -717.614, y = -915.880, z = 19.268, bank = 2},
    {name = "ATM", x = -526.566, y = -1222.90, z = 18.434, bank = 0},
    {name = "ATM", x = -256.233, y = -716.00, z = 33.444, bank = 0},
    {name = "ATM", x = -258.876, y = -723.408, z = 33.444, bank = 0},
    {name = "ATM", x = -203.548, y = -861.588, z = 30.205, bank = 0},
    {name = "ATM", x = 111.203, y = -775.318, z = 31.427, bank = 0},
    {name = "ATM", x = 114.421, y = -776.394, z = 31.427, bank = 0},
    {name = "ATM", x = 112.9290, y = -818.710, z = 31.386, bank = 0},
    {name = "ATM", x = 119.9000, y = -883.826, z = 31.191, bank = 0},
    {name = "ATM", x = 146.88, y = -1035.45, z = 29.366, bank = 1},
    {name = "ATM", x = -846.304, y = -340.402, z = 38.687, bank = 2},
    {name = "ATM", x = -56.8093, y = -1751.94, z = 29.452, bank = 2},
    {name = "ATM", x = -261.992, y = -2012.32, z = 30.121, bank = 2},
    {name = "ATM", x = -273.073, y = -2024.57, z = 30.197, bank = 2},
    {name = "ATM", x = 24.589, y = -946.056, z = 29.357, bank = 2},
    {name = "ATM", x = -254.112, y = -692.483, z = 33.616, bank = 0},
    {name = "ATM", x = -1570.54, y = -546.989, z = 34.955, bank = 2},
    {name = "ATM", x = -1415.909, y = -211.825, z = 46.500, bank = 2},
    {name = "ATM", x = -1430.112, y = -211.014, z = 46.500, bank = 2},
    {name = "ATM", x = 33.1755, y = -1348.25, z = 29.497, bank = 2},
    {name = "ATM", x = 129.216, y = -1292.347, z = 29.269, bank = 2},
    {name = "ATM", x = 287.645, y = -1282.646, z = 29.659, bank = 2},
    {name = "ATM", x = 289.012, y = -1256.545, z = 29.440, bank = 2},
    {name = "ATM", x = 295.74, y = -896.109, z = 29.217, bank = 2},
    {name = "ATM", x = 296.485, y = -894.200, z = 29.217, bank = 2},
    {name = "ATM", x = 1686.84, y = 4815.81, z = 42.0084, bank = 2},
    {name = "ATM", x = -302.408, y = -829.945, z = 32.417, bank = 0},
    {name = "ATM", x = 5.134, y = -919.949, z = 29.557, bank = 2},
    {name = "ATM", x = -30.2699, y = -723.675, z = 44.2279, bank = 0},
    {name = "ATM", x = -28.0239, y = -724.524, z = 44.2282, bank = 0},
    {name = "ATM", x = 527.353, y = -160.682, z = 57.09, bank = 2},
    {name = "ATM", x = -867.265, y = -187.044, z = 37.8433, bank = 0},
{name = "ATM", x = -231.94, y = -1299.56, z = 31.29, bank = 1}}
-- Banks - bank = (0 -> maze / 1 -> fleeca / 2 -> bankofliberty)
local banks = {
    {name = "Banque", x = 150.266, y = -1040.203, z = 29.374, bank = 1},
    {name = "Banque", x = -1212.980, y = -330.841, z = 37.787, bank = 1},
    {name = "Banque", x = -2962.55, y = 482.884, z = 15.703, bank = 1},
    {name = "Banque", x = -112.202, y = 6469.295, z = 31.626, bank = 0},
    {name = "Banque", x = 313.426, y = -278.808, z = 54.170, bank = 1},
    {name = "Banque", x = -351.044, y = -49.9558, z = 49.042, bank = 1},
    {name = "Banque", x = 242.335, y = 225.118, z = 106.286, bank = 2},
    {name = "Banque", x = 247.538, y = 223.275, z = 106.286, bank = 2},
    {name = "Banque", x = 252.649, y = 221.402, z = 106.286, bank = 2},
{name = "Banque", x = 1175.89, y = 2706.87, z = 38.626, bank = 1}}
-- Display Map Blips
Citizen.CreateThread(function()
    if (displayBankBlips == true) then
        for _, item in pairs(banks) do
            item.blip = AddBlipForCoord(item.x, item.y, item.z)
            SetBlipSprite(item.blip, 108)
            SetBlipAsShortRange(item.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(item.name)
            EndTextCommandSetBlipName(item.blip)
        end
    end
    if (displayAtmBlips == true) then
        for _, item in pairs(atms) do
            item.blip = AddBlipForCoord(item.x, item.y, item.z)
            SetBlipSprite(item.blip, 277)
            SetBlipAsShortRange(item.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(item.name)
            EndTextCommandSetBlipName(item.blip)
        end
    end
end)
-- NUI Variables
local bankOpen = false
local atmOpen = false
function LoadInterfaceATM()
    Citizen.CreateThread(function()
        function Initialize(scaleform)
            local scaleform = RequestScaleformMovie(scaleform)
            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(0)
            end
            PushScaleformMovieFunction(scaleform, "enterPINanim")
            PopScaleformMovieFunctionVoid()
            PushScaleformMovieFunction(scaleform, "DISPLAY_BALANCE")
            PushScaleformMovieFunctionParameterString("Vous êtes connecté à votre Banque...")
            PushScaleformMovieFunctionParameterString("ATM v145.122.232")
            PopScaleformMovieFunctionVoid()
            --PushScaleformMovieFunctionParameterString("")
            --PushScaleformMovieFunctionParameterInt(0)
            return scaleform
        end
        scaleform = Initialize("ATM")
        while bankOpen or OpeningATM do
            Citizen.Wait(0)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
        end
        SetScaleformMovieAsNoLongerNeeded(scaleform)
    end)
end
-- Open Gui and Focus NUI
function openGui(isAtm)
    if isAtm then
        TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_ATM", 0, false)
        Citizen.Wait(4000)
        OpeningATM = true
        LoadInterfaceATM()
        Citizen.Wait(3500)
    end
    SetNuiFocus(true)
    SendNUIMessage({openBank = true, isatm = isAtm, bank = idbank, CharBank = charbank})
    OpeningATM = false
end
-- Close Gui and disable NUI
function closeGui()
    SetNuiFocus(false)
    SendNUIMessage({openBank = false})
    bankOpen = false
    atmOpen = false
    ClearPedTasks(GetPlayerPed(-1))
end
function showHelpNotification(str)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(str)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end
-- If GUI setting turned on, listen for INPUT_CONTEXT keypress
if enableBankingGui then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            local isAtm = IsNearATM()
            if(IsNearBank() or isAtm == true) then
                if bankOpen == false and atmOpen == false then
                    if isAtm then
                        showHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder au ~b~distributeur")
                    else
                        showHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à la ~b~banque")
                    end
                end
                if IsControlJustPressed(1, 51) then -- IF INPUT_CONTEXT Is pressed
                    if idbank == 0 then
                        charbank.icon = "CHAR_BANK_MAZE"
                        charbank.titre = "Maze Bank"
                    elseif idbank == 1 then
                        charbank.icon = "CHAR_BANK_FLEECA"
                        charbank.titre = "Fleeca Bank"
                    elseif idbank == 2 then
                        charbank.icon = "CHAR_BANK_BOL"
                        charbank.titre = "Bank Of Liberty"
                    end
                    if (IsInVehicle()) then
                        TriggerEvent("ft_libs:AdvancedNotification", source, {
                            icon = charbank.icon,
                            title = charbank.titre,
                            text = "~r~Vous ne pouvez pas gérer votre argent en voiture",
                        })
                    else
                        if bankOpen then
                            closeGui()
                            bankOpen = false
                        else
                            openGui(isAtm)
                            bankOpen = true
                        end
                    end
                end
            else
                if(atmOpen or bankOpen) then
                    closeGui()
                end
                atmOpen = false
                bankOpen = false
            end
        end
    end)
end
-- Disable controls while GUI open
Citizen.CreateThread(function()
    while true do
        if bankOpen or atmOpen then
            local ply = GetPlayerPed(-1)
            local active = true
            DisableControlAction(0, 1, active) -- LookLeftRight
            DisableControlAction(0, 2, active) -- LookUpDown
            DisableControlAction(0, 24, active) -- Attack
            DisablePlayerFiring(ply, true) -- Disable weapon firing
            DisableControlAction(0, 142, active) -- MeleeAttackAlternate
            DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
            if IsDisabledControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({type = "click"})
            end
        end
        Citizen.Wait(1)
    end
end)
-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
    closeGui()
    cb('ok')
end)
RegisterNUICallback('balance', function(data, cb)
    SendNUIMessage({openSection = "balance"})
    cb('ok')
end)
RegisterNUICallback('withdraw', function(data, cb)
    SendNUIMessage({openSection = "withdraw"})
    cb('ok')
end)
RegisterNUICallback('deposit', function(data, cb)
    SendNUIMessage({openSection = "deposit"})
    cb('ok')
end)
RegisterNUICallback('transfer', function(data, cb)
    SendNUIMessage({openSection = "transfer"})
    cb('ok')
end)
RegisterNUICallback('quickCash', function(data, cb)
    TriggerEvent('bank:withdraw', 100)
    cb('ok')
end)
RegisterNUICallback('withdrawSubmit', function(data, cb)
    TriggerEvent('bank:withdraw', data.amount)
    cb('ok')
end)
RegisterNUICallback('depositSubmit', function(data, cb)
    TriggerEvent('bank:deposit', data.amount)
    cb('ok')
end)
RegisterNUICallback('transferSubmit', function(data, cb)
    TriggerServerEvent("bank:transfer", tonumber(data.numcompte), tonumber(data.amount), charbank)
    cb('ok')
end)
-- Check if player is near an atm
function IsNearATM()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for _, item in pairs(atms) do
        local distance = GetDistanceBetweenCoords(item.x, item.y, item.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if(distance <= 1.5) then
            idbank = item.bank
            return true
        end
    end
end
-- Check if player is in a vehicle
function IsInVehicle()
    local ply = GetPlayerPed(-1)
    if IsPedSittingInAnyVehicle(ply) then
        return true
    else
        return false
    end
end
-- Check if player is near a bank
function IsNearBank()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for _, item in pairs(banks) do
        local distance = GetDistanceBetweenCoords(item.x, item.y, item.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if(distance <= 3) then
            idbank = item.bank
            return true
        end
    end
end
-- Process deposit if conditions met
RegisterNetEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    if (IsInVehicle()) then
        TriggerEvent("ft_libs:AdvancedNotification", source, {
            icon = charbank.icon,
            title = charbank.titre,
            text = "~r~Vous ne pouvez pas utiliser un ATM en voiture",
        })
    else
        TriggerServerEvent("bank:deposit", tonumber(amount), charbank)
    end
end)
-- Process withdraw if conditions met
RegisterNetEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    TriggerServerEvent("bank:withdraw", tonumber(amount), charbank)
end)
-- Process give cash if conditions met
RegisterNetEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
    player, distance = GetClosestPlayer()
    if((distance ~= -1 and distance < 3) or giveCashAnywhere == true) and (IsPedInAnyVehicle(GetPlayerPed(-1), true) == false) and (not IsEntityDead(GetPlayerPed(-1))) then
        DisplayOnscreenKeyboard(1, "Quantité :", "", "", "", "", "", 8)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(1);
        end
        if (GetOnscreenKeyboardResult()) then
            local res = 1
            res = tonumber(GetOnscreenKeyboardResult())
            if res ~= nil then
                if res < 0 then
                    res = res - res
                end
                local player2 = GetPlayerServerId(player)
                TriggerServerEvent("bank:givecash", player2, tonumber(res))
                local ped = GetPlayerPed(-1)
                if ped then
                    TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false)
                    Citizen.Wait(1500)
                    ClearPedTasks(GetPlayerPed(-1))
                end
            end
        end
    else
        TriggerEvent('chatMessage', "", {255, 0, 0}, "^1Pas de joueur proche")
    end
end)
-- Process give cash if conditions met
RegisterNetEvent('bank:givetaxecash')
AddEventHandler('bank:givetaxecash', function(toPlayer, amount)
    player, distance = GetClosestPlayer()
    if((distance ~= -1 and distance < 3) or giveCashAnywhere == true) and (IsPedInAnyVehicle(GetPlayerPed(-1), true) == false) and (not IsEntityDead(GetPlayerPed(-1))) then
        DisplayOnscreenKeyboard(1, "Montant :", "", "", "", "", "", 8)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(1);
        end
        if (GetOnscreenKeyboardResult()) then
            local res = 1
            res = tonumber(GetOnscreenKeyboardResult())
            if res ~= nil then
                if res < 0 then
                    res = res - res
                end
                local player2 = GetPlayerServerId(player)
                --TriggerServerEvent("bank:givecash", player2, tonumber(res))
                TriggerServerEvent('entreprises:selltaxe', player2, tonumber(res))
                local ped = GetPlayerPed(-1)
                if ped then
                    TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false)
                    Citizen.Wait(1500)
                    ClearPedTasks(GetPlayerPed(-1))
                end
            end
        end
    else
        TriggerEvent('chatMessage', "", {255, 0, 0}, "^1Pas de joueur proche")
    end
end)
RegisterNetEvent('bank:givedirty')
AddEventHandler('bank:givedirty', function(toPlayer, amount)
    player, distance = GetClosestPlayer()
    if((distance ~= -1 and distance < 3) or giveCashAnywhere == true) and (IsPedInAnyVehicle(GetPlayerPed(-1), true) == false) then
        DisplayOnscreenKeyboard(1, "Quantité :", "", "", "", "", "", 8)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Wait(1);
        end
        if (GetOnscreenKeyboardResult()) then
            local res = 1
            res = tonumber(GetOnscreenKeyboardResult())
            if res ~= nil then
                if res < 0 then
                    res = res - res
                end
                local player2 = GetPlayerServerId(player)
                TriggerServerEvent("bank:givedirty", player2, tonumber(res))
                local ped = GetPlayerPed(-1)
                if ped then
                    TaskStartScenarioInPlace(ped, "PROP_HUMAN_PARKING_METER", 0, false)
                    Citizen.Wait(1500)
                    ClearPedTasks(GetPlayerPed(-1))
                end
            end
        end
    else
        TriggerEvent('chatMessage', "", {255, 0, 0}, "^1Pas de joueur proche")
    end
end)
-- Send NUI message to update bank balance
RegisterNetEvent('banking:updateBalance')
AddEventHandler('banking:updateBalance', function(balance)
    local id = PlayerId()
    local playerName = GetPlayerName(id)
    SendNUIMessage({
        updateBalance = true,
        balance = balance,
        player = playerName
    })
    TriggerServerEvent('gcPhone:BankUpdate')
end)
RegisterNetEvent('banking:initnumcompte')
AddEventHandler('banking:initnumcompte', function(numCompte)
    SendNUIMessage({
        numcompte = numCompte
    })
end)
-- Send NUI Message to display add balance popup
RegisterNetEvent("banking:addBalance")
AddEventHandler("banking:addBalance", function(amount)
    SendNUIMessage({
        addBalance = true,
        amount = amount
    })
end)
-- Send NUI Message to display remove balance popup
RegisterNetEvent("banking:removeBalance")
AddEventHandler("banking:removeBalance", function(amount)
    SendNUIMessage({
        removeBalance = true,
        amount = amount
    })
end)
function GetPlayers()
    local players = {}
    for i = 0, 68 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end
function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for index, value in ipairs(players) do
        local target = GetPlayerPed(value)
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
