Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if NetworkIsSessionStarted() then
			TriggerServerEvent("Queue:playerActivated")
			return
		end
	end
end)