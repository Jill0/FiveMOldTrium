
RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(killer,reason)
	if killer == "**Invalid**" then --Can't figure out what's generating invalid, it's late. If you figure it out, let me know. I just handle it as a string for now.
		reason = 2
	end
	if reason == 0 then
		 --TriggerClientEvent('showNotification', source,"~o~".. source.."~w~ est mort dans a un accident. ")
	elseif reason == 1 then
		TriggerClientEvent('showNotification', source,"~o~".. killer .. "~w~ vous a tué")
	else
		 --TriggerClientEvent('showNotification', source,"~o~".. killer.."~w~ es mort.")
	end
end)