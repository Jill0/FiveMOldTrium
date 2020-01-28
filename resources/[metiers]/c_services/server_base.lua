--=============================================================================
--  Jonathan D @ Gannon
--============================================================================
local nbAmbulancier = 0
local nbPolicier = 0

function getTime()
    return os.time() - 2 * 60 * 60 + math.floor(0)
end

-- export
function AddEmergencyConnected(jobid)
	if(jobid == 2) then
		nbPolicier = nbPolicier + 1
		--print("[AJOUT] 1 Policier AJOUTE")
		elseif(jobid == 15) then
			nbAmbulancier = nbAmbulancier + 1
			--print("[AJOUT] 1 Ambulancier AJOUTE")
		end
end

function RemoveEmergencyConnected(jobid)
	if(jobid == 2 and nbPolicier > 0) then
		nbPolicier = nbPolicier - 1
		--print("[SUPPRESSION] 1 Policier SUPPRIME")
		elseif(jobid == 15 and nbAmbulancier > 0) then
			nbAmbulancier = nbAmbulancier - 1
			--print("[SUPPRESSION] 1 Ambulancier SUPPRIME")
		end
end

function GetAmbuConnected()
	return nbAmbulancier
end

function GetPoliceConnected()
	return nbPolicier
end