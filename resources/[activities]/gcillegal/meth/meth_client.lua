--=============================================================================
-- #Author: Jonathan D @ Gannon
--=============================================================================

--=============================================================================
--  Config
--=============================================================================
local myPed = GetPlayerPed(-1)
local myPos = GetEntityCoords(myPed)
local currentVehicle = 0 
local isGoodVehcile = false
local currentCharge = 0
local nbPolice = 0

DecorRegister('illegal_chargeMeth', 3)

local Meth = {}
Meth.coords = {
    produitChimique = { x = 1538.17, y = 6337.2, z = 23.57 },
    --produitChimique = { x = 2459.34 , y = 3449.22 , z = 49.84},
    tranformeToMeth = { x = 848.52, y = 2827.87, z = 57.02 },
    venteMeth = { x = -685.65, y =  5794.46 , z =  17.33},
}
Meth.vehicle = GetHashKey('journey')
Meth.vehicle2 = GetHashKey('surfer')
Meth.vehicle3 = GetHashKey('surfer2')
Meth.vehicle4 = GetHashKey('camper')
Meth.objectId = 11
Meth.prixVente = 90
Meth.Text = {
    NeedVehicle = '~b~Methylamine\n~g~Un labo mobile à la breaking bad, tu connais ?',
    BadVehicle = '~o~ Ce véhicule ne va pas faire l\'affaire, trouve autre chose',
    ChargementVehicle = '~b~ Chargement du véhicule',
    ChargementFullVehicle = '~g~ Le véhicule est plein\n~r~ Mettez vous en route, trouve le bon endroit',
    TransformToMeth = '~b~Fabrication de meth',
    CreateMeth = '~o~ +1 Meth',
    VenteEnCours = '~b~Vente de meth',
    VenteMeth = '~o~ + ' .. Meth.prixVente .. ' $',
}

Meth.lastVehcile = 0
Meth.lastDommageVehcile = 0
--restart gcillegal
Meth.recolte = function(currentVehicle, isGoodVehcile)
    if currentVehicle == 0 then
        showMessageInformation(Meth.Text.NeedVehicle)
        return
    end
    if isGoodVehcile == false then
        showMessageInformation(Meth.Text.BadVehicle)
    else
        -- SetVehicleExclusiveDriver(vehicle, true) 41062318F23ED854 
        --Citizen.InvokeNative(0x41062318F23ED854,currentVehicle, true)
        if currentCharge >= 10000 then
            showMessageInformation(Meth.Text.ChargementFullVehicle)
            currentCharge = 10000
        else
            currentCharge = math.min(10000, currentCharge + 8) --(3m30, def: 2 =9min)
            DecorSetInt(currentVehicle,'illegal_chargeMeth', currentCharge)
            showMessageInformation(Meth.Text.ChargementVehicle)
        end
    end
end

Meth.tranformeToMeth = function(vehicle)
    if currentCharge > 0 then
        currentCharge = DecorGetInt(vehicle,'illegal_chargeMeth')
        currentCharge = math.max(0,currentCharge - 100) -- def 100
        DecorSetInt(vehicle,'illegal_chargeMeth', currentCharge)

        RequestNamedPtfxAsset("core")
        SetPtfxAssetNextCall("core")
        local effet = StartParticleFxLoopedOnEntity("exp_grd_grenade_smoke", myPed,
            0.0,-2.0,5.0,
            0.0,0.0,0.0,
            3.0,
            1,1,1)
        
        showMessageInformation(Meth.Text.TransformToMeth, 8000)
        Citizen.Wait(2000) --def 8000
        StopParticleFxLooped(effet, 0)
        TriggerEvent("player:receiveItem", Meth.objectId , 1)
    end
end


Meth.venteMeth = function ()
    local totalItem = exports.vdk_inventory:getQuantity(Meth.objectId)
    if totalItem == 0 then
        return
    end
    showMessageInformation(Meth.Text.VenteEnCours, 8000)
    Citizen.Wait(1000) --def 8000
	-- local pourcentage = 1
	-- for i=0,nbPolice,1 do
	-- pourcentage = pourcentage * 1.2
	-- end
    TriggerEvent("player:sellItemSale", Meth.objectId, math.floor(Meth.prixVente*(1.2^nbPolice)))
    showMessageInformation(Meth.Text.VenteMeth, 8000)
    Citizen.Wait(1500) --def 2000
end

Meth.checkPoint = function(currentVehicle, isGoodVehcile)
    local dist = GetDistanceBetweenCoords(myPos.x, myPos.y, myPos.z, Meth.coords.produitChimique.x, Meth.coords.produitChimique.y, Meth.coords.produitChimique.z, true)
    if dist < 10.0 then
        Meth.recolte(currentVehicle, isGoodVehcile)
        return
    end
    dist = GetDistanceBetweenCoords(myPos.x, myPos.y, myPos.z, Meth.coords.venteMeth.x, Meth.coords.venteMeth.y, Meth.coords.venteMeth.z, true)
    if dist < 10.0 then
        Meth.venteMeth()
        return
    end
    
    if isGoodVehcile then
        dist = GetDistanceBetweenCoords(myPos.x, myPos.y, myPos.z, Meth.coords.tranformeToMeth.x, Meth.coords.tranformeToMeth.y, Meth.coords.tranformeToMeth.z, true)
        if dist < 10.0 then
            Meth.tranformeToMeth(currentVehicle)
        end
    end
end

Meth.CheckDomamgeVehcile = function(vehicle)
    local cDmg = GetEntityHealth(vehicle)
    local deltaDmg =  Meth.lastDommageVehcile - cDmg
    if deltaDmg ~= 0 then
        Citizen.Trace('dmg !')
        currentCharge = math.max(currentCharge - deltaDmg * 100, 0)
        DecorSetInt(vehicle, 'illegal_chargeMeth', currentCharge)
        if currentCharge == 0 then
            showMessageInformation('~r~Vous avez perdu tout votre chargement', 15000)
        end
    end
    Meth.lastDommageVehcile = cDmg
end

Meth.showChargement = function()
    DrawRect(0.065, 0.04, 0.1, 0.033, 0,0,0,225)
    SetTextFont(6)
    SetTextScale(0.0,0.5)
    SetTextCentre(false)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString('~r~Methylamine: ~b~' .. (currentCharge/100) .. ' %')
    DrawText(0.020, 0.04 - 0.017)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if(nbPolice > 2) then
            myPed = GetPlayerPed(-1)
            myPos = GetEntityCoords(myPed)
            currentVehicle = GetVehiclePedIsIn(myPed, false)
            if currentVehicle ~= 0 then
				if (IsVehicleModel(currentVehicle, Meth.vehicle) or IsVehicleModel(currentVehicle, Meth.vehicle2) or IsVehicleModel(currentVehicle, Meth.vehicle3) or IsVehicleModel(currentVehicle, Meth.vehicle4)) then
					isGoodVehcile = true 
				else
					isGoodVehcile = false 
				end
            else
                isGoodVehcile = false
            end
            Meth.checkPoint(currentVehicle, isGoodVehcile)  
            if isGoodVehcile  then 
                if Meth.lastVehcile == 0 then
                    currentCharge = DecorGetInt(currentVehicle, 'illegal_chargeMeth')
                    Meth.lastVehcile = currentVehicle
                    Meth.lastDommageVehcile = GetEntityHealth(currentVehicle)
                end
                if currentCharge ~= 0 then
                    Meth.CheckDomamgeVehcile(currentVehicle)
                end
            elseif Meth.lastVehcile ~= 0 then 
                Citizen.Trace('currentCharge set 0')
                DecorSetInt(Meth.lastVehcile, 'illegal_chargeMeth', currentCharge)
                currentCharge = 0
                Meth.lastVehcile = 0
                Meth.lastDommageVehcile = 0
                Meth.PedInGoodVehicle = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentCharge ~= 0 then
            Meth.showChargement()
        end
    end
end)

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		TriggerServerEvent('illegal:stestcop')
	end
end)]]--
	
AddEventHandler("illegal:illegalsetcop", function(nbPolicier)
	nbPolice = nbPolicier
	--print("POLICIERS METH : " ..nbPolicier)
end)

--=============================================================================
--  Debug
--=============================================================================
--restart gcillegal
-- local currentVehicle = GetVehiclePedIsIn(myPed, 0)
-- DecorSetInt('illegal_chargeMeth', 0)
--CreateVehicle(Meth.vehicle, myPos.x, myPos.y + 2.0, myPos.z, 0.0, true, false)
--SetEntityCoords(myPed, Meth.coords.produitChimique.x, Meth.coords.produitChimique.y, Meth.coords.produitChimique.z)
--SetEntityCoords(myPed, Meth.coords.tranformeToMeth.x, Meth.coords.tranformeToMeth.y, Meth.coords.tranformeToMeth.z)
--SetEntityCoords(myPed, Meth.coords.venteMeth.x, Meth.coords.venteMeth.y, Meth.coords.venteMeth.z)

-- Citizen.Trace('pos ' .. myPos.x .. ' ' .. myPos.y .. ' ' .. myPos.z)

-- --local effet = "ent_amb_fbi_smoke_door_med"
-- -- local effet = 'scr_rcbarry2'
-- -- -- Citizen.CreateThread(function()
-- -- --     while true do
-- -- --         Citizen.Wait(0)
-- --         RequestNamedPtfxAsset(effet)
-- --         SetPtfxAssetNextCall(effet)
-- -- StartParticleFxNonLoopedOnEntity(effet, GetPlayerPed(-1), 
-- -- 0.0, 0.0, -0.5,  
-- -- 0.0, 0.0, 0.0, 
-- -- 1.0, 0, 0, 0)

-- -- local ef = "exp_grd_grenade_smoke"

-- -- -- local myPed = GetPlayerPed(-1)
-- -- -- local myPos = GetEntityCoords(myPed)
-- -- START_PARTICLE_FX_NON_LOOPED_ON_ENTITY = 0x0D53A3B8DA0809D2
-- local gg = GetVehiclePedIsIn(myPed, false)
-- currentCharge = 10000
-- DecorSetInt(gg, 'illegal_chargeMeth', currentCharge)

-- Citizen.CreateThread(function()

--         RequestNamedPtfxAsset("core")
--         SetPtfxAssetNextCall("core")
--         --exp_grd_grenade_smoke
--         local gg = GetVehiclePedIsIn(myPed, false)
--         local effet = StartParticleFxLoopedOnEntity("exp_grd_grenade_smoke", gg,
--         0.0,-2.0,2.0,
--         0.0,0.0,0.0,
--         3.0,
--         1,1,1)
--         Citizen.Wait(8000)
--         StopParticleFxLooped(effet,0)

-- end)

--SetParticleFxLoopedColour(effet, 0.0, 0.0, 0.0, 0)
--SetParticleFxLoopedScale(effet, 3.0)
--     end

-- end)