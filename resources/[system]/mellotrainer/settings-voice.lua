-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.


-- Update voice feature variables
function updateVoiceDistanceVariables(distance)
	featureVPTooClose = false
	featureVPVeryClose = false
	featureVPClose = false
	featureVPNearby = false
	featureVPDistant = false
	featureVPFar = false
	featureVPVeryFar = false
	featureVPAllPlayers = false
	if(distance == 0)then
		featureVPAllPlayers = true;
	elseif(distance == 5)then
		featureVPTooClose = true
	elseif(distance == 25)then
		featureVPVeryClose = true
	elseif(distance == 75)then
		featureVPClose = true
	elseif(distance == 200)then
		featureVPNearby = true
	elseif(distance == 500)then
		featureVPDistant = true
	elseif(distance == 2500)then
		featureVPFar = true
	elseif(distance == 8000)then
		featureVPVeryFar = true
	end
end



RegisterNUICallback("voiceopts", function(data, cb)
	local playerPed = GetPlayerPed(-1)
	local action = data.action
	local state = data.newstate
	local request = data.data[3]
	local text,text2

	if(state) then
		text = "~g~ON"
		text2 = "~r~OFF"
	else
		text = "~r~OFF"
		text2 = "~g~ON"
	end

	if(action=="channel")then
		if(request == "0" or request == 0)then
			NetworkClearVoiceChannel()
			drawNotification("Voice Channel reset")
		else
			NetworkSetVoiceChannel(tonumber(request))
			drawNotification("Now In Voice Channel: "..request)
		end
	elseif(action=="distance")then
		local distance = tonumber(request) + 0.00

		NetworkSetTalkerProximity(distance)
		updateVoiceDistanceVariables(distance)
		if(distance > 0)then
			drawNotification("Voice Proximity: "..distance.." meters")
		else
			drawNotification("Voice Proximity: All Players")
		end
	elseif(action=="voicetoggle")then
		featureVoiceChat = state
		NetworkSetVoiceActive(state)		
		drawNotification("Voice Chat: "..text)


	elseif(action=="showtoggle")then
		featureShowVoiceChatSpeaker = state
		if(not state)then
			SendNUIMessage({hidevoice=true})
		end
		drawNotification("Voice Speakers Overlay: "..text)

	end

	if(cb)then cb("ok") end
end)

