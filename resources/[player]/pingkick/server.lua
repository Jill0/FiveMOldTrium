-- CONFIG --

-- Ping Limit
pingLimit = 600
advert = true
-- CODE --

RegisterServerEvent("checkMyPingBro")
AddEventHandler("checkMyPingBro", function()
	ping = GetPlayerPing(source)
	
	if ping >= pingLimit  and advert == true then
	DropPlayer(source, "Votre ping est trop élevé (Limite: " .. pingLimit .. " Votre ping: " .. ping .. ")")
	elseif ping >= pingLimit  and advert == false then
		advert = true
	elseif ping < pingLimit  and advert == true then	
	advert = false
	end
	
	
	
end)