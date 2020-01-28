
-- Change Weather Type
function changeWeatherType(type, time)
	ClearWeatherTypePersist() -- Ensure no persistant weather
	SetWeatherTypeOverTime(type, time)
end

-- Update players wind
function updateWind(toggle,heading,speed)
	if(toggle) then
		SetWind(1.0)
		SetWindSpeed(speed)
		SetWindDirection(heading)
	else
		SetWind(0.0)
		SetWindSpeed(0.0)
	end
end

-- Sync weather with server settings.
RegisterNetEvent('smartweather:updateWeather')
AddEventHandler('smartweather:updateWeather', function(data, time)
	if not time then
		time = 240.0
	end
	changeWeatherType(data["weatherString"], time)
	updateWind(data["windEnabled"],data["windHeading"],data["windSpeed"])
end)

-- Sync on player connect
AddEventHandler('playerSpawned', function()	
	TriggerServerEvent('smartweather:syncWeather')
end)
