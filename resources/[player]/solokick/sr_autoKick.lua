local PlayerCount = 0
local playerlistconnected = {}
local bypassOnlineBanne = {
"steam:11000011ae775bc"
}
RegisterServerEvent('sendSessionPlayerNumber')

AddEventHandler('sendSessionPlayerNumber', function(clientPlayerNumber, name, seconTry, kick)
	serverPlayerNumber = countPlayer()
	--print("server : " ..serverPlayerNumber)
	local seconTry = seconTry
	local kick = kick
	--print("client : "..clientPlayerNumber)
	if(clientPlayerNumber < serverPlayerNumber) then
	
		if(clientPlayerNumber == 1 and serverPlayerNumber > 1) then -- if player are solo
		 
		  TriggerClientEvent('solo:firstTry', source)
		   
		 if seconTry then
		 
		  TriggerClientEvent('solo:seconTry', source)
		 if kick then
		
			local reason = 'Auto-Kick Session solo detecter, SERVER: '.. serverPlayerNumber .. ' / CLIENT:, '  .. clientPlayerNumber -- reason of kick (solo session detected)
			local msg = name .. " KICKED, SERVER SEE: " .. serverPlayerNumber .. " PLAYERS, CLIENT SEE: " .. clientPlayerNumber -- console message (example : client see 1/24 players , server see 24/24 players)
			print('AUTOKICK: ' .. msg.. "\n") -- console title message (AUTOKICK : console message)
			DropPlayer(source, reason) -- kick player
			TriggerClientEvent('chatMessage', -1, 'SERVEUR', { 0, 0x99, 255 },  "^2"..name .. " ^1a été kick : ^2" .. reason) -- In game chat message (example: John Doe (ID) was kicked for Auto-Kick Session solo détectée)
			
		
		end
		end
		else
	--PlayerCount = clientPlayerNumber
	end
	end
	--if serverPlayerNumber < clientPlayerNumber then 
	--PlayerCount = clientPlayerNumber
	--end
	
end)
RegisterServerEvent("pQueue:playerActivated")
AddEventHandler("pQueue:playerActivated", function()
PlayerCount = 0
PlayerCount = PlayerCount + 1

end)

RegisterServerEvent("printdebug")
AddEventHandler("printdebug", function(banned)
print(""..banned)
end)

RegisterServerEvent("bannedtest")
AddEventHandler("bannedtest", function(banned)
if banned == 0 then
	local bypasse = false
	local bannedPlayer = GetPlayerIdentifiers(source)[1] or false
	if bannedPlayer then
		for _, v in pairs(bypassOnlineBanne) do
			if v == bannedPlayer then
				bypasse = true
			else
			bypasse = false
			print(v)
			print(bannedPlayer)
			end
		end
		end
		if bypasse == false then
			print("baaaaaaannnnnneeeeeed Rockstar bye bye poulet ")
			DropPlayer(source, "Vous êtes un cheateur banni rockstar on ne veut pas de ça ici! sinon venez voir un admin")
		end
elseif banned == 3 then
print("this should not happen..")
print("this should not happen..")
print("this should not happen..")
print("this should not happen..")
end
end)


function countPlayer() -- count all players
	Count = 0
	for _, v in pairs(GetPlayers()) do
		Count = Count + 1
	end
	return Count
end