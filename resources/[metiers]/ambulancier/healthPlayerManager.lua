--[[
################################################################
- Creator: Jyben
- Edition: Charli62128
- Date: 30/04/2017
- Url: https://github.com/Jyben/emergency
- Licence: Apache 2.0
################################################################
--]]
local isDeadForSpawn = false
local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
function Chat(t)
    TriggerEvent("chatMessage", 'AMBU', {0, 255, 255}, "" .. tostring(t))
end
local isDead = false
local isKO = false
local CountDownStarted = false
local CountDown = 900
local isDeadForSpawn = false
local demarchehaschanged = false
--[[
################################
            THREADS
################################
--]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local playerPed = GetPlayerPed(-1)
        local playerID = PlayerId()
        local currentPos = GetEntityCoords(playerPed, true)
        local previousPos
        isDead = IsEntityDead(playerPed)
        
        if isKO and previousPos ~= currentPos then
            isKO = false
        end
        if (GetEntityHealth(playerPed) < 120 and not isDead and not isKO) then
            if (IsPedInMeleeCombat(playerPed)) then
                SetPlayerKO(playerID, playerPed)
            end
        end
        previousPos = currentPos
        
        local PlayerHeal = GetEntityHealth(playerPed)
        if (PlayerHeal < 170 and not isDead) then
            demarchetype = "move_m@fire"
            if(PlayerHeal < 160 and PlayerHeal > 145) then
                demarchetype = "move_injured_generic"
            elseif(PlayerHeal < 145 and PlayerHeal > 130) then
                demarchetype = "move_heist_lester"
            elseif(PlayerHeal < 130) then
                demarchetype = "move_lester_CaneUp"
            end
            demarchehaschanged = true
            RequestAnimSet(demarchetype)
            while not HasAnimSetLoaded(demarchetype) do
                Wait(10)
            end
            SetPedMovementClipset(playerPed, demarchetype, 1.0)
        else
            if(demarchehaschanged) then
                demarchehaschanged = false
                ResetPedMovementClipset(playerPed, 1.0)
            end
        end
        
        if(IsConversationPedDead(playerPed)) then
            SendNotification("[Attention] Il est interdit de parler ici et sur Discord pendant un coma !")
            SendNotification("Il est interdit de réapparaitre à l'hôpital si des Ambulanciers sont présents en ville.")
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsEntityDead(PlayerPedId())then
            StartScreenEffect("DeathFailOut", 0, 0)
            ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
            if not isDeadForSpawn then
                isDeadForSpawn = true
                StartDeadCountDown()
                TriggerServerEvent("ambulancier:setDead", 1)
            end
            local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
            if HasScaleformMovieLoaded(scaleform) then
                Citizen.Wait(0)
                PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                PushScaleformMovieFunctionParameterString("~r~Vous êtes dans le coma")
                PushScaleformMovieFunctionParameterString("En cas d'abus utilisez la commande ~b~/report")
                PopScaleformMovieFunctionVoid()
                Citizen.Wait(500)
                while IsEntityDead(PlayerPedId()) do
                    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                    Citizen.Wait(0)
                end
                StopScreenEffect("DeathFailOut")
            end
        end
    end
end)

function StartDeadCountDown()
    Citizen.CreateThread(function()
        if not CountDownStarted then
            CountDownStarted = true
            Citizen.Wait(10000)
            local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
            while (CountDown > 0) do
                local CurrentAmbuService = GetAmbulancierInServiceManager()
                if(CurrentAmbuService < 1) then
                    if(CountDown > 300) then
                        PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                        PushScaleformMovieFunctionParameterString("~b~ Aucun Ambulancier en service")
                        PushScaleformMovieFunctionParameterString("~w~le temps d'attente est donc ~g~réduit ~w~à ~g~5 ~w~minutes ~w~!")
                        PopScaleformMovieFunctionVoid()
                        Citizen.Wait(5000)
                        CountDown = 300
                    end
                end
                if(CountDown < 60) then
                    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                    PushScaleformMovieFunctionParameterString("~w~Retour hôpital autorisé dans ~g~" .. CountDown .. " ~w~secondes")
                    PushScaleformMovieFunctionParameterString("Vous ne vous rappelez de rien !")
                    PopScaleformMovieFunctionVoid()
                else
                    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                    PushScaleformMovieFunctionParameterString("~w~Retour hôpital autorisé dans ~r~" .. math.ceil(CountDown / 60) .. " ~w~minutes")
                    PushScaleformMovieFunctionParameterString("Vous commencez à oublier tout ce qui vient de se passer...")
                    PopScaleformMovieFunctionVoid()
                end
                Citizen.Wait(1000)
                CountDown = CountDown - 1
            end
            Citizen.Wait(1000)
            PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
            PushScaleformMovieFunctionParameterString("~w~Retour hôpital ~g~autorisé ~w~!")
            PopScaleformMovieFunctionVoid()
            CountDown = 0
            CountDownStarted = false
        end
    end)
end
function GetCurrentCountDown()
    return CountDown
end
function ResetCountDown()
    CountDown = 900
end
--[[
################################
            EVENTS
################################
--]]
-- Triggered when player died by environment
AddEventHandler('baseevents:onPlayerDied',
    function(playerId, reasonID)
        TriggerEvent('es_em:playerInComa')
        --TriggerServerEvent("ambulancier:setDead",1)
        SendNotification('Vous êtes dans le coma !')
    end
)
-- Triggered when player died by an another player
AddEventHandler('baseevents:onPlayerKilled',
    function(playerId, playerKill, reasonID)
        TriggerEvent('es_em:playerInComa')
        --TriggerServerEvent("ambulancier:setDead",1)
        SendNotification('Vous êtes dans le coma !')
    end
)
function Resurrect()
    local playerPed = GetPlayerPed(-1)
    ResurrectPed(playerPed)
    SetEntityHealth(playerPed, GetPedMaxHealth(playerPed) / 2)
    ClearPedTasksImmediately(playerPed)
    TriggerServerEvent("ambulancier:setDead", 0)
    isDeadForSpawn = false
    notif('Vous avez été réanimé')
    ResetCountDown()
    -- Si le joueur est sous l'eau
    Citizen.CreateThread(function()
        Citizen.Wait(2000)
        if(IsEntityInWater(playerPed) or IsPedSwimmingUnderWater(playerPed) or IsPedSwimming(playerPed)) then
            SetPedComponentVariation(playerPed, 8, 123, 2)
        end
    end)
end
RegisterNetEvent('ambulancier:rescue')
AddEventHandler('ambulancier:rescue', function()
    TriggerServerEvent("ambulancier:needs")
    Resurrect()
    TriggerServerEvent("skin:reloadSkin")
end)
RegisterNetEvent("ambulancier:forceRespawn")
AddEventHandler("ambulancier:forceRespawn",
    function()
        --TriggerServerEvent("ambulancier:resetInventory")
        --RemoveAllPedWeapons(GetPlayerPed(-1), true)
        --Chat("ICI")
        DoScreenFadeOut(1)
        SetEntityInvincible(GetPlayerPed(-1), true)
        NetworkResurrectLocalPlayer(ambulancier_sortie.x, ambulancier_sortie.y, ambulancier_sortie.z, ambulancier_sortie.h, true, true, false)
        --TaskStartScenarioInPlace(GetPlayerPed(-1), 'WORLD_HUMAN_SUNBATHE_BACK', 0, false)
        SetPedToRagdoll(GetPlayerPed(-1), 15000, 15000, 0, 0, 0, 0)
        SendNotification('Vous vous reveillez en vous agitant brusquement... mais vous avez tout oublié !')
        StartScreenEffect("HeistTripSkipFade", 30000, false)
        TriggerEvent("gc:CantStopEm")
        Citizen.Wait(2000)
        DoScreenFadeIn(10000)
        Citizen.Wait(10000)
        SetPedToRagdoll(GetPlayerPed(-1), 6000, 6000, 0, 0, 0, 0)
        --ClearPedTasks(GetPlayerPed(-1))
        SendNotification('Vous reprenez votre esprit... petit à petit...')
        TriggerServerEvent("item:reset")
        TriggerServerEvent("item:getItems")
        TriggerServerEvent("skin:reloadSkin")
        TriggerEvent("police:finishService")
        RemoveAllPedWeapons(GetPlayerPed(-1), true)
        TriggerServerEvent("police:checkIsCop")
        TriggerServerEvent("weaponshop:RemoveWeaponsToPlayer")
        SetPedIsDrunk(GetPlayerPed(-1), true)
        --ShakeGameplayCam("DRUNK_SHAKE", 1.0)
        SetPedConfigFlag(GetPlayerPed(-1), 100, true)
        SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        Citizen.Wait(10000)
        SetEntityInvincible(GetPlayerPed(-1), false)
        TriggerEvent("gc:CanStopEm")
        ResetScenarioTypesEnabled()
        ResetPedMovementClipset(GetPlayerPed(-1), 0)
        SetPedIsDrunk(GetPlayerPed(-1), false)
        SetPedToRagdoll(GetPlayerPed(-1), 6000, 6000, 0, 0, 0, 0)
        StopScreenEffect()
        TriggerServerEvent("ambulancier:setDead", 0)
        isDeadForSpawn = false
        ResetCountDown()
        --TriggerEvent('spwanManager:forceRespawn')
        TriggerServerEvent('antitroll:RetourHopitalDetected', GetPlayerName(PlayerId()))
    end)
    --[[
################################
        BUSINESS METHODS
################################
--]]
    function SetPlayerKO(playerID, playerPed)
        isKO = true
        SendNotification('Vous êtes KO !')
        SetPedToRagdoll(playerPed, 6000, 6000, 0, 0, 0, 0)
    end
    function SendNotification(message)
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, false)
    end
    --[[
################################
        USEFUL METHODS
################################
--]]
    function GetStringReason(reasonID)
        local reasonString = 'Tuer'
        if reasonID == 0 or reasonID == 56 or reasonID == 1 or reasonID == 2 then
            reasonIDString = 'Molester'
        elseif reasonID == 3 then
            reasonIDString = 'Poignarder'
        elseif reasonID == 4 or reasonID == 6 or reasonID == 18 or reasonID == 51 then
            reasonIDString = 'Exploser'
        elseif reasonID == 5 or reasonID == 19 then
            reasonIDString = 'Bruler'
        elseif reasonID == 7 or reasonID == 9 then
            reasonIDString = 'Coup de crosse'
        elseif reasonID == 10 or reasonID == 11 then
            reasonIDString = 'Par Balle'
        elseif reasonID == 12 or reasonID == 13 or reasonID == 52 then
            reasonIDString = 'Par Balle'
        elseif reasonID == 14 or reasonID == 15 or reasonID == 20 then
            reasonIDString = 'Par Balle'
        elseif reasonID == 16 or reasonID == 17 then
            reasonIDString = 'Par Balle'
        elseif reasonID == 49 or reasonID == 50 then
            reasonString = 'Ecraser'
        end
        return reasonString
    end
    
