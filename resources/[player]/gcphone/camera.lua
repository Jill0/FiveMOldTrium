local phoneId = 0 -- [0] = "Michael's", [1] = "Trevor's", [2] = "Franklin's", [4] = "Prologue"
local phone = false
local frontCam = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if phone == true then
			if IsControlJustPressed(1, 177) and phone == true then -- CLOSE PHONE
				DestroyMobilePhone()
				exports["Players"]:setStatusHUD(false)
				phone = false
				CellCamActivate(false, false)
			end
			if IsControlJustPressed(1, 27) then -- CHANGE CAMERA MODE
				frontCam = not frontCam
				CellFrontCamActivate(frontCam)
			end
		end
	end
end)

function camStatus()
	return phone
end

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

RegisterNetEvent('camera:selfie')
AddEventHandler('camera:selfie',
function()
	CreateMobilePhone(phoneId)
	CellCamActivate(true, true)
	phone = true
	frontCam = true
	CellFrontCamActivate(frontCam)
	exports["Players"]:setStatusHUD(true)
end)

RegisterNetEvent('camera:photo')
AddEventHandler('camera:photo',
function()
    CreateMobilePhone(phoneId)
	CellCamActivate(true, true)
	phone = true
	frontCam = false
	CellFrontCamActivate(frontCam)
	exports["Players"]:setStatusHUD(true)
end)
