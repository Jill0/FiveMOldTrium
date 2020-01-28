
Citizen.CreateThread(function()
    local ped = GetPlayerPed(-1)
    while true do
        if IsControlJustPressed(0, 0xE30CD707) then --[R]
            if(not IsEntityDead(ped) and HasPedGotWeapon(ped, GetHashKey("WEAPON_FISHINGROD"), 0, 0)) then
                if(IsEntityInWater(ped) and not IsPedSwimming(ped) and not IsPedSwimmingUnderWater(ped)) then
                    TaskSwapFishingBait(ped, "p_baitCheese01x", 1)
                end
            end
        end
        Citizen.Wait(1)
    end
end)
