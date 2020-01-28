 
 copmin = 3 -- nombre de flic min
 AttenteBraq = 3200 -- temps entre 2 braquages (en secondes ) 1800 = 30min
 BoostReward = 2 -- multiplie les gains. Gain = Nb_Flic * BoostReward * reward du lieu
 DistanceSac = 1500 -- distance à laquelle le braqueur perd le sac
 CoutMateriel = 2000 -- prix à payer pour lancer un braquage
 -- STORES :
  -- reward : récompence ( multiplié par le nombre de flic par la suite )
  -- nameofstore : nom affiché sur le point et à l'appel flic
  -- DureeBraquage durée du braquage (en secondes )
  -- Propre : true = argent propre, false = argent sale
 stores = {
	--####SUPERETTES ########
	["superette_senora_freeway"] = {
		position = { ['x'] = 2672.75, ['y'] = 3286.74, ['z'] = 55.24 },
		reward = math.random(2500, 3500),
		nameofstore = "Superette Señora Freeway",
		DureeBraquage = 200,
		Propre = true,
		lastrobbed = 0
	},
	["sandyshores_twentyfoursever"] = {
		position = { ['x'] = 1960.41, ['y'] = 3742.97, ['z'] = 32.34 },
		reward = math.random(2500, 3500),
		nameofstore = "Superette Sandy Shores",
		DureeBraquage = 200,
		Propre = true,
		lastrobbed = 0
	},
	
	["littleseoul_twentyfourseven"] = {
		position = { ['x'] = -709.17, ['y'] = -904.21, ['z'] = 19.21},
		reward = math.random(2500, 3500),
		nameofstore = "Superette Little Seoul",
		DureeBraquage = 180,
		Propre = true,
		lastrobbed = 0
	},
	 ["superette_Paleto"] = {
        position = { ['x'] = 1734.25, ['y'] = 6420.76, ['z'] = 35.04 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette HighWay Paleto",
		DureeBraquage = 300,
		Propre = true,
        lastrobbed = 0
    }, 
	["superette_great_ocean"] = {
        position = { ['x'] = -3244.51, ['y'] = 1001.46, ['z'] = 12.83 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette Great Ocean Highway",
		DureeBraquage = 180,
		Propre = true,
        lastrobbed = 0
    },
	["superette_san_andreas"] = {
        position = { ['x'] = -1219.64, ['y'] = -915.9, ['z'] = 11.33 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette San Andreas Avenue",
		DureeBraquage = 180,
        Propre = true,
        lastrobbed = 0
    },
	["superette_Canyon_drive"] = {
        position = { ['x'] = -1828.46, ['y'] = 798.53, ['z'] = 138.18 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette Banham canyon drive",
		DureeBraquage = 180,
        Propre = true,
        lastrobbed = 0
    },
	["superette_Palomino"] = {
        position = { ['x'] = 2556.91, ['y'] = 380.73, ['z'] = 108.62 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette Palomino Freeway",
		DureeBraquage = 180,
        Propre = true,
        lastrobbed = 0
    },
	["superette_Alongquin_Boulvard_Sandy_Shores"] = {
        position = { ['x'] = 1395.28, ['y'] = 3606.42, ['z'] = 34.98 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette Alongquin Boulvard",
		DureeBraquage = 180,
        Propre = true,
        lastrobbed = 0
    },
	["superette_Route68_Harmony"] = {
        position = { ['x'] = 546.35, ['y'] = 2663.06, ['z'] = 42.16 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette Route 68",
		DureeBraquage = 220,
        Propre = true,
        lastrobbed = 0
    },
	["superette_grand_senora_deser"] = {
        position = { ['x'] = 1168.77, ['y'] = 2717.99, ['z'] = 37.16 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette Grand Señora Desert",
		DureeBraquage = 200,
        Propre = true,
        lastrobbed = 0
    },
	["superette_downtown_vinewood"] = {
        position = { ['x'] = 378.17, ['y'] = 333.09, ['z'] = 103.57 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette DownTown  Vinewood",
		DureeBraquage = 180,
        Propre = true,
        lastrobbed = 0
    },
	["superette_grapeseed"] = {
        position = { ['x'] =1698.03, ['y'] = 4922.62, ['z'] = 42.06 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette Grapeseed Main Street",
		DureeBraquage = 180,
        Propre = true,
        lastrobbed = 0
    },
	["superette_innocence_Boulvard_Elgin_avenue_Strawberry"] = {
        position = { ['x'] = 28.23, ['y'] = -1339.38, ['z'] = 29.5 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette Innocence Boulvard",
		DureeBraquage = 150,
        Propre = true,
        lastrobbed = 0
    },
	["superette_mirror_park"] = {
        position = { ['x'] = 1159.77, ['y'] = -314.03, ['z'] = 69.21 },
        reward = math.random(2500, 3500),
        nameofstore = "Superette Mirror Park Drive West",
		DureeBraquage = 180,
        Propre = true,
        lastrobbed = 0
    },
	-- ####### BANQUES ##############
	["banque__fleeca_centrale"] = {
		position = { ['x'] = 146.36, ['y'] = -1044.77, ['z'] = 29.38 },
		reward = math.random(5000, 7000),
		nameofstore = "Fleeca Centrale",
		DureeBraquage = 90,
		Propre = false,
		lastrobbed = 0
	},
	["banque_fleeca_vinewood"] = {
		position = { ['x'] = 310.8, ['y'] = -282.93, ['z'] = 54.17 },
		reward = math.random(5000, 7000),
		nameofstore = "Fleeca Vinewood",
		DureeBraquage = 150,
		Propre = false,
		lastrobbed = 0
	},
	["banque_paleto"] = {
        position = { ['x'] = -103.94, ['y'] = 6477.62, ['z'] = 31.63 },
        reward = math.random(7000, 9000),
        nameofstore = "Fleeca Blaine County(Paleto)",
		DureeBraquage = 600,
		Propre = false,
        lastrobbed = 0
    }, 
	["banque_principale"] = {
        position = { ['x'] = 254.52, ['y'] = 226.07, ['z'] = 101.88 },
        reward = math.random(15000, 30000),
        nameofstore = "Pacific Standard",
		DureeBraquage = 600,
		Propre = false,
        lastrobbed = 0
    }, 
	["banque_fleeca_burton"] = {
        position = { ['x'] = -354.55, ['y'] = -53.89, ['z'] = 49.05 },
        reward = math.random(5000, 7000),
        nameofstore = "Fleeca Burton",
		DureeBraquage = 180,
		Propre = false,
        lastrobbed = 0
    },
	["banque_fleeca_sandyshore"] = {
        position = { ['x'] = 1176.19, ['y'] = 2711.39, ['z'] = 38.1 },
        reward = math.random(5000, 7000),
        nameofstore = "Fleeca Sandy Shores",
		DureeBraquage = 230,
		Propre = false,
        lastrobbed = 0
    },
	["banque_fleeca_delperro"] = {
        position = { ['x'] = -1212.11, ['y'] = -336.13, ['z'] = 37.79 },
        reward = math.random(5000, 7000),
        nameofstore = "Fleeca Del Perro",
		DureeBraquage = 190,
		Propre = false,
        lastrobbed = 0
    },
	["banque_fleeca_great_ocean"] = {
        position = { ['x'] = -2957.84, ['y'] = 480.81, ['z'] = 15.71 },
        reward = math.random(5000, 7000),
        nameofstore = "Fleeca Great Ocean",
		DureeBraquage = 200,
		Propre = false,
        lastrobbed = 0
    }
	
}