AddEventHandler('onClientMapStart', function()
	CreateThread(function()
		TriggerEvent("helper:openHelp") -- OUVRIR A LA CONNEXION
	end)
end)

RegisterNetEvent("helper:openHelp")
AddEventHandler("helper:openHelp", function()
	local display = true
	openHelper(true)
	while display do -- TANT QUE LE HELPER EST OUVERT
		Wait(10)
	exports.ft_libs:HelpPromt(TXT.CONTROLS)
		exports.ft_libs:Notification(TXT.QUESTIONS)
		if (IsControlJustPressed(1, KEY.E) or IsControlJustPressed(1, KEY.ENTER) or IsControlJustPressed(1, KEY.ESC)) then -- E / ENTER / ESC POUR FERMER
		 	display = false -- FERMER
			openHelper(false)
			exports.ft_libs:HelpPromt(TXT.PUSHTOTALK)
		elseif (IsControlJustPressed(1, KEY.RIGHT)) then -- → PAGE SUIVANTE
			nextSlide()
		elseif (IsControlJustPressed(1, KEY.LEFT)) then -- ← PAGE PRECEDENTE
			previousSlide()
		end
	end
end)

CreateThread(function() -- OUVRIR AVEC F7
	while true do
		Wait(10)
		if IsControlJustPressed(1, KEY.F7) then
			TriggerEvent("helper:openHelp")
		end
	end
end)

-- NUI --
function openHelper(value)
	SendNUIMessage({openHelper = value})
end

function nextSlide()
	SendNUIMessage({nextSlide = true})
end

function previousSlide()
	SendNUIMessage({previousSlide = true})
end
