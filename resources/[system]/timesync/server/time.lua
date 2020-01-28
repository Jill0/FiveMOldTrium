time = {h = 9, m = 0, s = 0}

Citizen.CreateThread(function()
	while true do
		Wait(1900)
		time.m = time.m + 1
		if time.m > 59 then
			time.m = 0
			time.h = time.h + 1
			if time.h > 23 then
				time.h = 0
			end
		end
		TriggerClientEvent("ts:timesync", -1, time.h, time.m, time.s)
--		print("event envoyé, h:" .. time.h .. " m:" .. time.m .. " s:" .. time.s)
	end
end)