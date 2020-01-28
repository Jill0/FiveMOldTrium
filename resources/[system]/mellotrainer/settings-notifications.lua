-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
-- DO NOT TOUCHY, CONTACT Michael G/TheStonedTurtle if anything is broken.
local adminStatus = nil
local selfDeathMessage = "~o~Vous ~s~êtes mort."
local deathSuicideMessage = "~o~Vous avez ~s~commis un suicide."

-- Hold dead players to prevent multiple messages.
local deadPlayers = {}

RegisterNUICallback("notifications", function(data, cb)
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

	if(action=="players")then
		featurePlayerNotifications = state
		drawNotification("Notifications joueur: "..text)

	elseif(action=="death")then
		featureDeathNotifications = state
		drawNotification("Notifiations décès: "..text)
	end

	if(cb)then cb("ok") end
end)

RegisterNetEvent( 'mellotrainer:playerJoined' )
AddEventHandler( 'mellotrainer:playerJoined', function( ID )
	local id = tonumber( ID )
	if ( featurePlayerNotifications and id ~= PlayerId() and adminStatus == true) then
		local name = GetPlayerName( id )
		drawNotification( "~g~<C>"..name.."</C> ~s~a rejoint." )
	end
end )

RegisterNetEvent( 'mellotrainer:playerLeft' )
AddEventHandler( 'mellotrainer:playerLeft', function( name )
	if ( featurePlayerNotifications and adminStatus == true) then
		drawNotification( "~r~<C>" .. name .. "</C> ~s~a quitté." )
	end
end )

-- Better Death Messages
function killActionFromWeaponHash(weaponHash)
	if (weaponHash ~= nil)then
		if (weaponHash == GetHashKey("WEAPON_RUN_OVER_BY_CAR") or weaponHash == GetHashKey("WEAPON_RAMMED_BY_CAR")) then
			return "aplatis";
		end
		if (weaponHash == GetHashKey("WEAPON_CROWBAR") or weaponHash == GetHashKey("WEAPON_BAT") or weaponHash == GetHashKey("WEAPON_HAMMER") or weaponHash == GetHashKey("WEAPON_GOLFCLUB") or weaponHash == GetHashKey("WEAPON_NIGHTSTICK") or weaponHash == GetHashKey("WEAPON_KNUCKLE")) then
			return "battu";
		end
		if (weaponHash == GetHashKey("WEAPON_DAGGER") or weaponHash == GetHashKey("WEAPON_KNIFE")) then
			return "poignardé";
		end
		if (weaponHash == GetHashKey("WEAPON_SNSPISTOL") or weaponHash == GetHashKey("WEAPON_HEAVYPISTOL") or weaponHash == GetHashKey("WEAPON_VINTAGEPISTOL") or weaponHash == GetHashKey("WEAPON_PISTOL") or weaponHash == GetHashKey("WEAPON_APPISTOL") or weaponHash == GetHashKey("WEAPON_COMBATPISTOL") or weaponHash == GetHashKey("WEAPON_SNSPISTOL")) then
			return "troué";
		end
		if (weaponHash == GetHashKey("WEAPON_GRENADELAUNCHER") or weaponHash == GetHashKey("WEAPON_HOMINGLAUNCHER") or weaponHash == GetHashKey("WEAPON_STICKYBOMB") or weaponHash == GetHashKey("WEAPON_PROXMINE") or weaponHash == GetHashKey("WEAPON_RPG") or weaponHash == GetHashKey("WEAPON_EXPLOSION") or weaponHash == GetHashKey("VEHICLE_WEAPON_TANK")) then
			return "bombardé";
		end
		if (weaponHash == GetHashKey("WEAPON_MICROSMG") or weaponHash == GetHashKey("WEAPON_SMG") or weaponHash == GetHashKey("WEAPON_ASSAULTSMG") or weaponHash == GetHashKey("WEAPON_MG") or weaponHash == GetHashKey("WEAPON_COMBATMG") or weaponHash == GetHashKey("WEAPON_COMBATPDW") or weaponHash == GetHashKey("WEAPON_MINIGUN")) then
			return "pulvérisé";
		end
		if (weaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") or weaponHash == GetHashKey("WEAPON_CARBINERIFLE") or weaponHash == GetHashKey("WEAPON_ADVANCEDRIFLE") or weaponHash == GetHashKey("WEAPON_BULLPUPRIFLE") or weaponHash == GetHashKey("WEAPON_SPECIALCARBINE") or weaponHash == GetHashKey("WEAPON_GUSENBERG")) then
			return "vidé";
		end
		if (weaponHash == GetHashKey("WEAPON_MARKSMANRIFLE") or weaponHash == GetHashKey("WEAPON_SNIPERRIFLE") or weaponHash == GetHashKey("WEAPON_HEAVYSNIPER") or weaponHash == GetHashKey("WEAPON_ASSAULTSNIPER") or weaponHash == GetHashKey("WEAPON_REMOTESNIPER")) then
			return "canardé";
		end
		if (weaponHash == GetHashKey("WEAPON_BULLPUPSHOTGUN") or weaponHash == GetHashKey("WEAPON_ASSAULTSHOTGUN") or weaponHash == GetHashKey("WEAPON_PUMPSHOTGUN") or weaponHash == GetHashKey("WEAPON_HEAVYSHOTGUN") or weaponHash == GetHashKey("WEAPON_SAWNOFFSHOTGUN")) then
			return "explosé";
		end
		if (weaponHash == GetHashKey("WEAPON_HATCHET") or weaponHash == GetHashKey("WEAPON_MACHETE")) then
			return "éviscéré";
		end
		if (weaponHash == GetHashKey("WEAPON_MOLOTOV")) then
			return "incendié";
		end
		return "assassiné";
	end
	return "assassiné";
end

-- Other Player died
function handlePlayerDeathMessage( pedID, currentPed )
	local me = PlayerId()
	local entity, weaponHash = NetworkGetEntityKillerOfPlayer( pedID )
	local name = GetPlayerName( pedID )

	local msg = "~o~<C>" .. name .. "</C> ~s~est mort."

	if ( IsPedAPlayer( entity ) ) then
		local killer = NetworkGetPlayerIndexFromPed( entity )
		local kname = GetPlayerName( killer )

		if ( kname == name ) then
			msg = "~o~<C>" .. name .. "</C> ~s~a commis un suicide."
		elseif ( kname == GetPlayerName( me ) )then
			msg = "~o~<C>You</C> ~s~" .. killActionFromWeaponHash( weaponHash ) .. " ~o~<C>" .. name .. "</C>~s~."
		else
			msg = "~y~<C>" .. kname .. "</C> ~s~" .. killActionFromWeaponHash( weaponHash ) .. " ~o~<C>" .. name .. "</C>~s~."
		end
	end

	drawNotification( msg )
end


-- Check for death messages
function checkForDeaths()
    local me = PlayerId()

    for i = 0, maxPlayers, 1 do
        if ( NetworkIsPlayerConnected( i ) ) then
        	local currentPed = GetPlayerPed( i )

        	if ( DoesEntityExist( currentPed ) and IsEntityDead( currentPed ) and adminStatus == true) then 

        		if(deadPlayers[i] == nil)then
	       			handlePlayerDeathMessage( i, currentPed )
	       			deadPlayers[i] = true
	       		end
	       	else
				deadPlayers[i] = nil	       		
			end
		end
	end
end

-- Admin only trainer?
RegisterNetEvent("mellotrainer:receveurtusaurapasadmin242")
AddEventHandler("mellotrainer:receveurtusaurapasadmin242", function(status)
	adminStatus = status
end)

-- Get their admin status once they load in game.
AddEventHandler('onClientMapStart', function()
	TriggerServerEvent("mellotrainer:getAdminStatus")
end)



-- Requests admin status 10 seconds after script restart. 
-- If player is joining this should fire via onClientMapStart.
Citizen.CreateThread(function()
	Wait(10000)
	if(adminStatus == nil)then
		TriggerServerEvent("mellotrainer:getAdminStatus")
	end
end)