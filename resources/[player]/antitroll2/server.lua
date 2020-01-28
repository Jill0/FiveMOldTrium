RegisterServerEvent("baseevents:onPlayerKilled")
AddEventHandler('baseevents:onPlayerKilled', function(killedBy, data)
	local victim = source
    local weaponHash = data.weaponhash
    -- local weapon = getWeaponName(weaponHash)
	TriggerEvent("ft_libs:PrintTable", data)
end)

RegisterServerEvent("baseevents:onPlayerDied")
AddEventHandler('baseevents:onPlayerDied', function(killedBy, pos)
	local victim = source
    TriggerEvent("ft_libs:PrintTable", source)
    TriggerEvent("ft_libs:PrintTable", killedBy)
    TriggerEvent("ft_libs:PrintTable", pos)
end)