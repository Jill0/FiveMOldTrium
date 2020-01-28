checkRate = 5000

Citizen.CreateThread(function()
	while true do
		Wait(checkRate)

		TriggerServerEvent("checkMyPingBro")
	end
end)