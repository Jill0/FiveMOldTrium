
local lastrobbed = 0 -- temps depuis le dernier braquage
local robbers = {}




RegisterServerEvent('braquages:rob') -- braquage
AddEventHandler('braquages:rob', function(robb,nbPolice,source,NbBraqueurs)
local user = exports["essentialmode"]:getPlayerFromId(source)
	if nbPolice >= copmin then
		if stores[robb] then
			local store = stores[robb]
			
			if (os.time() - lastrobbed) < AttenteBraq and lastrobbed ~= 0 then
				
				TriggerClientEvent('chatMessage', source, 'BRAQUAGE', {255, 0, 0}, "Un braquage a eu lieu récemment, les enseignes ont protégé leur argent.")
				return
			end
			user.func.removeMoney(CoutMateriel)
			sendBraquage(user,store.nameofstore,NbBraqueurs,true)
			TriggerClientEvent('braquages:notifycop2',-1, "~r~BRAQUAGE EN COURS:~w~ " .. store.nameofstore .. "!~b~ "..NbBraqueurs.." suspect(s) !", true,robb) -- préviens les flics
			TriggerClientEvent('chatMessage', source, 'BRAQUAGE', {255, 0, 0}, "Vous avez commencé un braquage à ^2" .. store.nameofstore .. "^0, ne vous éloignez pas du magasin !")
			TriggerClientEvent('chatMessage', source, 'ALARME', {255, 0, 0}, "La LSPD a été averti !")
			TriggerClientEvent('chatMessage', source, 'BRAQUAGE', {255, 0, 0}, "^1"..store.DureeBraquage.."^0 secondes ("..(store.DureeBraquage/60).."minutes) avant l'ouverture !")
			TriggerClientEvent('braquages:currentlyrobbing', source, robb)
			lastrobbed = os.time()
			robbers[source] = robb
			SetTimeout((store.DureeBraquage*1000), function() -- prends des ms et non des secondes
				if(robbers[source])then
					nbPolice=getPoliceInService()
					local gain = BoostReward*nbPolice*store.reward
					TriggerClientEvent('braquages:robberycomplete', source,gain)
					TriggerClientEvent('braquages:notifycop2',-1, "~r~BRAQUAGE:~w~ Le braqueur s'est enfui avec ~r~"..gain.." ~w~$ ... ",false,nil)
					TriggerEvent('es:getPlayerFromId', source, function(target) 
						if(target)then
							
							sendEndBraquage(user,store.nameofstore,gain)
							if store.Propre == true then -- Banque = sale sinon propre
								user.func.addMoney(gain)
							else
								user.func.addDirty_Money(gain)
							end 
						end
					end)
				end
			end)		
		end
	else
		TriggerClientEvent('chatMessage', source, 'BRAQUAGE', {255, 0, 0}, "Pas assez de policiers en ville")
	end
end)


RegisterServerEvent('braquages:toofar') -- si le braqueur quitte la zone
AddEventHandler('braquages:toofar', function(robb,storename)
local user = exports["essentialmode"]:getPlayerFromId(source)
	if(robbers[source])then
	    lastrobbed = lastrobbed - AttenteBraq/2
		TriggerClientEvent('braquages:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('police:cancelCall', -1)
		sendBraquage(user,storename,0,false)
		TriggerClientEvent('braquages:notifycop2',-1, "~r~BRAQUAGE ANNULE:~w~ " .. storename .. ".",false,nil)
	end
end)


RegisterServerEvent('braquages:stestcop') -- récupère le nombre de flic en service
AddEventHandler('braquages:stestcop', function(k,NbBraqueurs)

	local lspd= getPoliceInService() 
	if lspd ==nil then
		lspd =0
	end
	TriggerEvent('braquages:rob',k,lspd,source,NbBraqueurs)
	
	
end)

function getPoliceInService()
	 local nbPolicier = 0
    nbPolicier = exports["c_services"]:POLICE_getNbPerosnnelActive()
    return nbPolicier
end
--### TOOLS ####
function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end


function sendBraquage(user,lieu,NbBraqueurs,state)
	if state==true then
		TriggerEvent('discord:braquage', "INFORMATION :gun:: **" .. user.nom .. " ".. user.prenom ..  "** braque **"..lieu.."**."..NbBraqueurs.." Braqueurs potentiels.")
	else
		TriggerEvent('discord:braquage', "INFORMATION :runner: : **" .. user.nom .. " ".. user.prenom ..  "** a fui **"..lieu.."**.")
	end
end
function sendEndBraquage(user,lieu,gains)
	TriggerEvent('discord:braquage', "INFORMATION :money_with_wings: : **" .. user.nom .. " ".. user.prenom ..  "** a dérobé **"..gains.."** $ à "..lieu)
end