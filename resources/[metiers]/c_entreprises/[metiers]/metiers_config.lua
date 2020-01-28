-- loop-ignore : le script ignore totalement ce métier
-- pole-emploi : ce métier n'apparaît pas dans pôle emploi
-- metier_prive : metier prive ou publique
-- for_all : visible par tous
-- id = id du blips
-- CircleDiameter : le diamètre du cercle
-- CircleBounce : Le cercle rebondi sur place si 1
-- distActivate : La distance à laquelle le script s'active
-- distDraw : La distance à laquelle le cercle est visible
-- giveItem : L'objet donné sur le point
-- requireItem : L'objet requis sur le point
-- minprice : le prix de vente mini par unité
-- maxprice : le prix de vente maxi par unité
-- fonction : Obligatoire pour Garage et Entreprise, facultatif pour les autres.


--############### BÛCHERON ###############
-- local bucheron = {metier = "Bûcheron", 
    -- nom = "La Bûcherie", 
    -- jobid = 7, 
    -- loop_ignore = false, 
    -- pole_ignore = false, 
    -- metier_prive = false, 
    -- check_service = 'isInServiceBucheronBool', 
    -- coffre = {}, 
    -- garage = {id = 18, nom = "Garage", fonction = 'GetVehicleBucheron', x = -790.644, y = 5400.225, z = 33.425, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    -- entreprise = {id = 17, nom = "Prise de Service", fonction = 'GetServiceBucheron', x = -839.800, y = 5401.216, z = 34.005, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    -- recolte = {[1] = {id = 19, nom = "Découpe du bois", fonction = nil, forcecar = true, forcepedincar = true, x = -471.076, y = 5580.450, z = 70.162, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 19, maxQuantity = 8, distActivate = 10, distDraw = 30}}, 
    -- traitement = {[1] = {id = 20, nom = "Fabrication des planches", fonction = nil, forcecar = true, forcepedincar = true, x = -508.064, y = 5267.702, z = 79.610, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 19, giveItem = 20, maxQuantity = 8, distActivate = 10, distDraw = 30}}, 
    -- vente = {[1] = {id = 21, nom = "Vente de des planches", fonction = nil, forcecar = true, forcepedincar = true, x = 1199.263, y = -1345.268, z = 34.404, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 20, minprice = 33, maxprice = 40, distActivate = 10, distDraw = 30}}, 
-- vehicules = {[1] = {nom = "Camion de DéDé", model = 'Phantom', vehid = 1}}}
-- ############# WATER AND POWER #########
local water = {metier = "Traiteur d'eau", 
    nom = "Water and Power", 
    jobid = 7, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = false, 
    for_all = false,
    check_service = 'isInServiceWaterBool', 
    coffre = {}, 
    garage = {id = 18, nom = "1.Garage", fonction = 'GetVehicleWater', x = 741.92, y = 132.32, z = 79.3, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 17, nom = "2.Prise de Service", fonction = 'GetServiceWater', x = 734.41, y = 133.78, z = 80.0, CircleDiameter = 2.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {[1] = {id = 19, nom = "3.Récolte d'eau non traité", fonction = nil, forcecar = true, forcepedincar = true, x = 1909.26, y = 575.65, z = 175.32, CircleDiameter = 30.0, CircleBounce = 0, giveItem = 147, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    traitement = {[1] = {id = 20, nom = "4.Traitement de l'eau", fonction = nil, forcecar = true, forcepedincar = true, x = 354.0, y = -2645.8, z = 5.26, CircleDiameter = 30.0, CircleBounce = 0, requireItem = 147, giveItem = 148, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    vente = {[1] = {id = 21, nom = "5.Vente des bouteilles d'eau", fonction = nil, forcecar = true, forcepedincar = true, x = 468.0, y = 3569.98, z = 32.74, CircleDiameter = 30.0, CircleBounce = 0, requireItem = 148, minprice = 24, maxprice = 34, distActivate = 10, distDraw = 30}}, 
vehicules = {[1] = {nom = "Camion", model = 'boxville', vehid = 1}}}
--########################################

--############### VIGNERON ###############
local vigneron = {metier = "Vigneron", 
    nom = "Le Bouchon", 
    jobid = 13, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = true,
    for_all = false,
    check_service = 'isInServiceVigneronBool', 
    coffre = {x = -1893.512, y = 2075.651, z = 139.997, CircleDiameter = 3.0, CircleBounce = 1, distActivate = 3, distDraw = 30}, 
    garage = {id = 318, nom = "Garage", fonction = 'GetVehicleVigneron', x = -1901.316, y = 2026.555, z = 140.000, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 366, nom = "Prise de Service", fonction = 'GetServiceVigneron', x = -1886.461, y = 2049.232, z = 140.179, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {[1] = {id = 85, nom = "1.Récolte du Raisin", fonction = nil, forcecar = true, forcepedincar = true, x = -1829.171, y = 2213.837, z = 86.303, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 26, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    traitement = {[1] = {id = 93, nom = "2.Mise en Bouteille", fonction = nil, forcecar = true, forcepedincar = true, x = 496.167, y = -1970.300, z = 23.799, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 26, giveItem = 27, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    vente = {[1] = {id = 500, nom = "3.Vente des Bouteilles", fonction = nil, forcecar = true, forcepedincar = true, x = -1524.525, y = 90.259, z = 55.501, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 27, minprice = 50, maxprice = 60, distActivate = 10, distDraw = 30}}, 
vehicules = {[1] = {nom = "Pickup", model = 'sadler', vehid = 1}}}
--########################################

--############### BRASSEUR ###############
local brasseur = {metier = "Brasseur", 
    nom = "Les 3 Bibines", 
    jobid = 12, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = true, 
    for_all = false,
    check_service = 'isInServiceBrasseurBool', 
    coffre = {x = 2445.577, y = 4983.623, z = 45.809, CircleDiameter = 3.0, CircleBounce = 1, distActivate = 3, distDraw = 30}, 
    garage = {id = 318, nom = "Garage", fonction = 'GetVehicleBrasseur', x = 2442.192, y = 5011.770, z = 46.009, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 366, nom = "Prise de Service", fonction = 'GetServiceBrasseur', x = 2480.028, y = 4953.197, z = 44.309, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {[1] = {id = 67, nom = "1.Récolte de l'Orge", fonction = nil, forcecar = true, forcepedincar = true, x = 2413.522, y = 4991.765, z = 45.502, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 24, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    traitement = {[1] = {id = 467, nom = "2.Fabrication de la Bière", fonction = nil, forcecar = true, forcepedincar = true, x = 837.185, y = -1938.010, z = 27.776, CircleDiameter = 20.0, CircleBounce = 0, requireItem = 24, giveItem = 25, maxQuantity = 30, distActivate = 20, distDraw = 30},
				  [2] = {id = 467, nom = "Fabrication du cidre", fonction = nil, forcecar = true, forcepedincar = true, x = 842.46, y = -1987.54, z = 29.3, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 149, giveItem = 164, maxQuantity = 30, distActivate = 10, distDraw = 30}},
    vente = {[1] = {id = 500, nom = "3.Vente de la Bière", fonction = nil, forcecar = true, forcepedincar = true, x = 141.320, y = -1277.928, z = 28.109, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 25, minprice = 45, maxprice = 55, distActivate = 10, distDraw = 30},
			 [2] = {id = 500, nom = "Vente du Cidre", fonction = nil, forcecar = true, forcepedincar = true, x = -559.98, y = 301.62, z = 83.16, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 164, minprice = 45, maxprice = 55, distActivate = 10, distDraw = 30}},	
vehicules = {[1] = {nom = "Camion à Bibines", model = 'pounder', vehid = 1}}}
--########################################

--############### LIVREUR ###############
local livreur = {metier = "Livreur", 
    nom = "PostOP", 
    jobid = 14, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = true, 
    for_all = false,
    check_service = 'isInServiceLivreurBool', 
    coffre = {x = -456.74, y = -2750.63, z = 5.0, CircleDiameter = 3.0, CircleBounce = 1, distActivate = 3, distDraw = 30}, 
    garage = {id = 318, nom = "Garage", fonction = 'GetVehicleLivreur', x = -409.75, y = -2795.61, z = 5.0, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 366, nom = "Prise de Service", fonction = 'GetServiceLivreur', x = -422.120, y = -2787.520, z = 5.0, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {[1] = {id = 514, nom = "1.Chargement de la cargaison", fonction = 'SpawnCargaisonLivreur', forcecar = true, forcepedincar = true, x = -413.39, y = -2697.21, z = 5.00, CircleDiameter = 3.0, CircleBounce = 0, giveItem = 0, maxQuantity = 0, distActivate = 10, distDraw = 30}}, 
    traitement = {}, 
    vente = {[1] = {id = 500, nom = "2.Dépôt de la cargaison", fonction = 'VenteCargaisonLivreur', forcecar = true, forcepedincar = false, x = 1738.72, y = 3283.57, z = 39.90, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 0, minprice = 1600, maxprice = 2000, distActivate = 10, distDraw = 30}}, 
vehicules = {[1] = {nom = "Véhicule de fonction", model = 'flatbed', vehid = 1}, [2] = {nom = "Fenwick", model = 'forklift', vehid = 2}}}
--########################################

--############### FERMIER ###############
local fermier = {metier = "Fermier", 
    nom = "La P'tite Mie", 
    jobid = 6, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = true, 
    for_all = false,
    check_service = 'isInServiceFermierBool', 
    coffre = {x = 2258.313, y = 5165.692, z = 58.111, CircleDiameter = 3.0, CircleBounce = 1, distActivate = 3, distDraw = 30}, 
    garage = {id = 318, nom = "Garage", fonction = 'GetVehicleFermier', x = 2229.083, y = 5167.491, z = 58.007, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 366, nom = "Prise de Service", fonction = 'GetServiceFermier', x = 2242.869, y = 5154.286, z = 57.087, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {[1] = {id = 85, nom = "1.Récolte du Blé", fonction = nil, forcecar = true, forcepedincar = true, x = 2150.973, y = 5164.509, z = 53.091, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 10, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    traitement = {[1] = {id = 436, nom = "2.Fabrication du Pain", fonction = nil, forcecar = true, forcepedincar = true, x = 2903.000, y = 4382.175, z = 49.552, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 10, giveItem = 5, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    vente = {[1] = {id = 500, nom = "3.Vente du Pain", fonction = nil, forcecar = true, forcepedincar = true, x = -1292.270, y = -1398.797, z = 3.586, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 5, minprice = 41, maxprice = 51, distActivate = 10, distDraw = 30}}, 
vehicules = {[1] = {nom = "Camion Benson", model = 'benson', vehid = 1}}}
--########################################

--############### MINEUR ###############
local mineur = {metier = "Mineur", 
    nom = "La Carrière", 
    jobid = 9, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = false, 
    for_all = false,
    check_service = 'isInServiceMineurBool', 
    coffre = {}, 
    garage = {id = 18, nom = "Garage", fonction = 'GetVehicleMineur', x = 981.393, y = -1919.801, z = 30.320, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 17, nom = "Prise de Service", fonction = 'GetServiceMineur', x = 966.258, y = -1933.027, z = 30.327, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {[1] = {id = 19, nom = "Mine de Fer", fonction = nil, forcecar = true, forcepedincar = true, x = 2678.576, y = 2870.152, z = 35.753, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 1, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    traitement = {[1] = {id = 20, nom = "La Fonderie", fonction = nil, forcecar = true, forcepedincar = true, x = 1075.501, y = -1949.545, z = 30.204, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 1, giveItem = 2, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    vente = {[1] = {id = 21, nom = "Vente du Métal", fonction = nil, forcecar = true, forcepedincar = true, x = -463.215, y = -1714.076, z = 17.654, CircleDiameter = 15.0, CircleBounce = 0, requireItem = 2, minprice = 16, maxprice = 36, distActivate = 15, distDraw = 30}}, 
vehicules = {[1] = {nom = "Camion Mineur n°1", model = 'tiptruck', vehid = 1}, [2] = {nom = "Camion Mineur n°2", model = 'tiptruck2', vehid = 2}, [3] = {nom = "Camion Mineur n°3", model = 'rubble', vehid = 3}}}
--########################################

--############### Prisonnier ###############
local prisonnier = {metier = "Prisonnier", 
    nom = "Prison", 
    jobid = 28, 
    loop_ignore = false, 
    pole_ignore = true, 
    metier_prive = false, 
    for_all = true,
    check_service = 'isInServicePrisonnierBool', 
    coffre = {}, 
    garage = {id = 477, nom = "Garage", fonction = 'GetVehiclePrisonnier', x = 1850.19, y = 2547.01, z = 45.17, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 366, nom = "Entrée/Sortie Prison", fonction = 'SetPrisonnier', x =1828.93 , y = 2603.18, z = 45.39, CircleDiameter = 1.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {[1] = {id = 427, nom = "Mine", fonction = nil, forcecar = true, forcepedincar = true, x = 2948.91, y = 2799.76, z = 40.68, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 1, maxQuantity = 30, distActivate = 10, distDraw = 30}, 
			   [2] = {id = 427, nom = "Ramassage des ordures", fonction = nil, forcecar = false, forcepedincar = true, x = 1717.58, y = 2503.25, z = 45.56, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 168, maxQuantity = 30, distActivate = 10, distDraw = 30}},
    traitement = {[1] = {id = 478, nom = "Mixage", fonction = nil, forcecar = true, forcepedincar = true, x = 1861.3, y = 2712.86, z = 45.42, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 1, giveItem = 2, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    vente = {[1] = {id = 569, nom = "Stockage", fonction = nil, forcecar = true, forcepedincar = true, x = 1636.09, y = 2598.64, z = 45.06, CircleDiameter = 15.0, CircleBounce = 0, requireItem = 2, minprice = 65, maxprice = 75, distActivate = 15, distDraw = 30},
			 [2] = {id = 478, nom = "Stockage des ordures", fonction = nil, forcecar = false, forcepedincar = true, x = 1628.96, y = 2494.33, z = 45.56, CircleDiameter = 15.0, CircleBounce = 0, requireItem = 168, minprice = 20, maxprice = 30, distActivate = 15, distDraw = 30}},
vehicules = {[1] = {nom = "Camion 1", model = 'mixer', vehid = 1}}}
--########################################

--############### Arboriculteur ###############
local arboriculteur = {metier = "Arboriculteur",
 nom = "Jus-Dit-Cieux",
 jobid = 21, 
 loop_ignore = false,
 pole_ignore = false,
 metier_prive = true,
 for_all = false,
check_service = 'isInServiceArboriculteurBool',
 coffre = {x = 2589.42, y = 4676.1, z = 34.08, CircleDiameter = 3.0, CircleBounce = 1, distActivate = 3, distDraw = 30},
 garage = {id = 474, nom = "Garage", fonction = 'GetVehicleArboriculteur', x = 2553.39, y = 4670.01, z = 33.95, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30},
 entreprise = {id = 366, nom = "Prise de Service", fonction = 'GetServiceArboriculteur', x = 2570.8, y = 4667.98, z = 34.08, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30},
 recolte = {[1] = {id = 478, nom = "Récolte de pommes", fonction = nil, forcecar = true, forcepedincar = true, x =2386.71, y = 4703.5, z = 33.99, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 149, maxQuantity = 30, distActivate = 10, distDraw = 30},
			[2] = {id = 478, nom = "Récolte d'oranges", fonction = nil, forcecar = true, forcepedincar = true, x =2413.38, y = 4677.38, z = 33.84, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 163, maxQuantity = 30, distActivate = 10, distDraw = 30}},
 traitement = {[1] = {id = 93, nom = "Mise en bouteille Pomme", fonction = nil, forcecar = true, forcepedincar = true, x = 1932.61, y = 4640.22, z = 40.44, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 149, giveItem = 150, maxQuantity = 30, distActivate = 10, distDraw = 30},
			   [2] = {id = 93, nom = "Mise en bouteille Orange", fonction = nil, forcecar = true, forcepedincar = true, x = 1961.38, y = 4641.55, z = 40.44, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 163, giveItem = 108, maxQuantity = 30, distActivate = 10, distDraw = 30}},
 vente = {[1] = {id = 434, nom = "Vente du Jus de Pomme", fonction = nil, forcecar = true, forcepedincar = true, x = 82.57, y = -210.19, z = 54.49, CircleDiameter = 15.0, CircleBounce = 0, requireItem = 150, minprice = 37, maxprice = 47, distActivate = 15, distDraw = 30},
		  [2] = {id = 434, nom = "Vente du Jus d'Orange", fonction = nil, forcecar = true, forcepedincar = true, x = 28.56, y = -1311.66, z = 29.25, CircleDiameter = 15.0, CircleBounce = 0, requireItem = 108, minprice = 37, maxprice = 47, distActivate = 15, distDraw = 30}},
 vehicules = {[1] = {nom = "Camion Fruitier", model = 'mule3', vehid = 1}}}
--########################################

--############### Glacier ###############
local glacier = {metier = "Glacier",
 nom = "Good'Lickin",
 jobid = 27, 
 loop_ignore = false,
 pole_ignore = false,
 metier_prive = true,
 for_all = false,
check_service = 'isInServiceGlacierBool',
 coffre = {x = 406.05, y = 6525.15, z = 27.75, CircleDiameter = 3.0, CircleBounce = 1, distActivate = 3, distDraw = 30},
 garage = {id = 318, nom = "Garage", fonction = 'GetVehicleGlacier', x = 405.53, y = 6494.32, z = 27.70, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30},
 entreprise = {id = 366, nom = "Prise de Service", fonction = 'GetServiceGlacier', x = 417.15, y = 6520.54, z = 27.23, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30},
 recolte = {[1] = {id = 478, nom = "Récolte de Fraises", fonction = nil, forcecar = true, forcepedincar = true, x = 265.35, y = 6490.88, z = 30.6, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 152, maxQuantity = 30, distActivate = 10, distDraw = 30},
			[2] = {id = 478, nom = "Récolte de Myrtilles", fonction = nil, forcecar = true, forcepedincar = true, x = 346.71, y = 6493.74, z = 28.72, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 154, maxQuantity = 30, distActivate = 10, distDraw = 30},
			[3] = {id = 478, nom = "Récolte de Bananes", fonction = nil, forcecar = true, forcepedincar = true, x = 257.49, y = 6522.51, z = 30.84, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 151, maxQuantity = 30, distActivate = 10, distDraw = 30},
			[4] = {id = 478, nom = "Récolte de Pêches", fonction = nil, forcecar = true, forcepedincar = true, x = 351.68, y = 6524.25, z = 28.58, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 153, maxQuantity = 30, distActivate = 10, distDraw = 30}},
			
 traitement = {[1] = {id = 604, nom = "Sorbets Fraises", fonction = nil, forcecar = true, forcepedincar = true, x = 906.51, y = -1736.74, z = 30.56, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 152, giveItem = 155, maxQuantity = 30, distActivate = 5, distDraw = 30},
			   [2] = {id = 604, nom = "Sorbets Myrtilles", fonction = nil, forcecar = true, forcepedincar = true, x = 869.76, y = -1681.86, z = 30.2, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 154, giveItem = 158, maxQuantity = 30, distActivate =5, distDraw = 30},
			   [3] = {id = 604, nom = "Sorbets Bananes", fonction = nil, forcecar = true, forcepedincar = true, x = 864.55, y = -1725.35, z = 29.67, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 151, giveItem = 156, maxQuantity = 30, distActivate = 5, distDraw = 30},
			   [4] = {id = 604, nom = "Sorbets Pêches", fonction = nil, forcecar = true, forcepedincar = true, x = 864.57, y = -1703.63, z = 29.59, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 153, giveItem = 157, maxQuantity = 30, distActivate = 5, distDraw = 30},
			   
			   [5] = {id = 604, nom = "Smoothies Fraises", fonction = nil, forcecar = true, forcepedincar = true, x = 899.2, y = -1735.42, z = 30.4, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 152, giveItem = 159, maxQuantity = 30, distActivate = 5, distDraw = 30},
			   [6] = {id = 604, nom = "Smoothies Myrtilles", fonction = nil, forcecar = true, forcepedincar = true, x = 915.09, y = -1738.73, z = 30.66, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 154, giveItem = 161, maxQuantity = 30, distActivate =5, distDraw = 30},
			   [7] = {id = 604, nom = "Smoothies Bananes", fonction = nil, forcecar = true, forcepedincar = true, x = 961.46, y = -1694.4, z = 30.46, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 151, giveItem = 160, maxQuantity = 30, distActivate = 5, distDraw = 30},
			   [8] = {id = 604, nom = "Smoothies Pêches", fonction = nil, forcecar = true, forcepedincar = true, x = 959.57, y = -1715.64, z = 30.49, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 153, giveItem = 162, maxQuantity = 30, distActivate = 5, distDraw = 30}},
 
 vente = {[1] = {id = 500, nom = "Vente Sorbets Fraises", fonction = nil, forcecar = true, forcepedincar = true, x = 106.88, y = -1812.1, z = 26.52, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 155, minprice = 49, maxprice = 59, distActivate = 5, distDraw = 30},
          [2] = {id = 500, nom = "Vente Sorbets Myrtilles", fonction = nil, forcecar = true, forcepedincar = true, x = 95.34, y = -1826.03, z = 26.08, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 158, minprice = 49, maxprice = 59, distActivate = 5, distDraw = 30},
          [3] = {id = 500, nom = "Vente Sorbets Bananes", fonction = nil, forcecar = true, forcepedincar = true, x = 89.35, y = -1843.76, z = 25.17, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 156, minprice = 49, maxprice = 59, distActivate = 5, distDraw = 30},
          [4] = {id = 500, nom = "Vente Sorbets Pêches", fonction = nil, forcecar = true, forcepedincar = true, x = 68.03, y = -1824.43, z = 25.2, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 157, minprice = 49, maxprice = 59, distActivate = 5, distDraw = 30},
		  
   		  [5] = {id = 500, nom = "Vente Smoothies Fraises", fonction = nil, forcecar = true, forcepedincar = true, x = 30.42, y = -1767.15, z = 29.33, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 159, minprice = 49, maxprice = 59, distActivate = 5, distDraw = 30},
          [6] = {id = 500, nom = "Vente Smoothies Myrtilles", fonction = nil, forcecar = true, forcepedincar = true, x = 50.48, y = -1744.2, z = 29.3, CircleDiameter = .0, CircleBounce = 0, requireItem = 161, minprice = 49, maxprice = 59, distActivate = 5, distDraw = 30},
          [7] = {id = 500, nom = "Vente Smoothies Bananes", fonction = nil, forcecar = true, forcepedincar = true, x = 66.62, y = -1721.92, z = 29.31, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 160, minprice = 49, maxprice = 59, distActivate = 5, distDraw = 30},
          [8] = {id = 500, nom = "Vente Smoothies Pêches", fonction = nil, forcecar = true, forcepedincar = true, x = 93.16, y = -1741.73, z = 29.31, CircleDiameter = 5.0, CircleBounce = 0, requireItem = 162, minprice = 49, maxprice = 59, distActivate = 5, distDraw = 30}}, 
 vehicules = {[1] = {nom = "Camion", model = 'mule', vehid = 1}}}
--########################################

--############### PECHEUR ###############
local pecheur = {metier = "Pêcheur", 
    nom = "Dov'Fish", 
    jobid = 10, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = true, 
    for_all = false,
    check_service = 'isInServicePecheurBool', 
    coffre = {x = 3817.605, y = 4482.550, z = 4.992, CircleDiameter = 3.0, CircleBounce = 1, distActivate = 3, distDraw = 30}, 
    garage = {id = 318, nom = "Garage", fonction = 'GetVehiclePecheur', x = 3827.914, y = 4466.706, z = 1.991, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    entreprise = {id = 366, nom = "Prise de Service", fonction = 'GetServicePecheur', x = 3804.072, y = 4476.629, z = 4.992, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {[1] = {id = 68, nom = "1.Zone de Pêche", fonction = nil, forcecar = true, forcepedincar = false, x = 3780.315, y = 4845.537, z = 0.468, CircleDiameter = 60.0, CircleBounce = 0, giveItem = 21, maxQuantity = 30, distActivate = 60, distDraw = 100}}, 
    traitement = {[1] = {id = 467, nom = "2.Préparation du Poisson", fonction = nil, forcecar = true, forcepedincar = true, x = 970.746, y = -1623.371, z = 29.110, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 21, giveItem = 22, maxQuantity = 30, distActivate = 10, distDraw = 30}}, 
    vente = {[1] = {id = 500, nom = "3.Vente des Filets", fonction = nil, forcecar = true, forcepedincar = true, x = -1053.807, y = -1398.759, z = 4.425, CircleDiameter = 15.0, CircleBounce = 0, requireItem = 22, minprice = 56, maxprice = 66, distActivate = 15, distDraw = 30}}, 
vehicules = {[1] = {nom = "Le petit bâteau", model = 'tug', vehid = 1}, [2] = {nom = "Camionette", model = 'benson', vehid = 2}}}
--########################################

--############### RAFFINEUR ###############
local raffineur = {metier = "Raffineur", 
    nom = "Fuel & Explosions", 
    jobid = 20, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = true, 
    for_all = false,
    check_service = 'isInServiceRaffineurBool', 
    coffre = {x = 1413.870, y = -2042.442, z = 50.998, CircleDiameter = 3.0, CircleBounce = 1, distActivate = 3, distDraw = 30}, 
    garage = {id = 318, nom = "Garage", fonction = 'GetVehicleRaffineur', x = 1358.479, y = -2078.598, z = 50.99, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 366, nom = "Prise de Service", fonction = 'GetServiceRaffineur', id = 17, x = 1383.03, y = -2078.81, z = 50.99, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {[1] = {id = 415, nom = "1.Récolte du Pétrole", fonction = nil, forcecar = true, forcepedincar = true, x = 1370.961, y = -1860.891, z = 55.98, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 43, maxQuantity = 8, distActivate = 10, distDraw = 30}}, 
    traitement = {[1] = {id = 467, nom = "2.La Raffinerie", fonction = nil, forcecar = true, forcepedincar = true, x = 479.02, y = -2146.73, z = 4.91, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 43, giveItem = 44, maxQuantity = 8, distActivate = 10, distDraw = 30}}, 
    vente = {[1] = {id = 500, nom = "3.Vente de des planches", fonction = nil, forcecar = true, forcepedincar = true, x = -2536.184, y = 2344.321, z = 32.06, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 44, minprice = 74, maxprice = 84, distActivate = 10, distDraw = 30}}, 
vehicules = {[1] = {nom = "Camion de Bernard", model = 'Phantom', vehid = 1}}}
--########################################

--############### CONCESSIONNAIRE ###############
local concessionnaire = {metier = "Concessionnaire", 
    nom = "Loca'Nation", 
    jobid = 25, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = true,
    for_all = false, 
    check_service = 'isInServiceConcessionnaireBool', 
    coffre = {x = -31.589, y = -1106.970, z = 25.422, CircleDiameter = 1.0, CircleBounce = 1, distActivate = 2, distDraw = 30}, 
    garage = {id = 500, nom = "Menu Concessionnaire", fonction = 'CheckForOpeningConcessMenu', x = -31.773, y = -1113.521, z = 25.422, CircleDiameter = 2.0, CircleBounce = 0, distActivate = 2, distDraw = 30}, 
    entreprise = {id = 524, nom = "Zone de rangement de véhicules", fonction = 'SupprimerVehiculeConcessionnaire', id = 17, x = -9.52, y = -1089.89, z = 25.67, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {}, 
    traitement = {}, 
    vente = {}, 
vehicules = {}}
--########################################

--############### AVOCAT ###############
local avocat = {metier = "Avocat", 
    nom = "Chicote & Justice", 
    jobid = 22, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = true, 
    for_all = false,
    check_service = 'isInServiceAvocatBool', 
    coffre = {x = 122.19, y = -738.18, z = 241.15, CircleDiameter = 1.0, CircleBounce = 1, distActivate = 2, distDraw = 30},
    garage = {id = 225, nom = "Garage", fonction = 'GetVehicleAvocat', x = -3.68, y = -668.09, z = 31.33, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 498, nom = "Prise de Service", fonction = 'GetServiceAvocat', id = 17, x = 107.84, y = -750.45, z = 241.15, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {}, 
    traitement = {}, 
    vente = {}, 
vehicules = {[1] = {nom = "Voiture Avocat", model = 'washington', vehid = 1}}}
--########################################

--############### GOUVERNEMENT ###############
local gouvernement = {metier = "Gouvernement", 
    nom = "Gouvernement", 
    jobid = 23, 
    loop_ignore = false, 
    pole_ignore = true, 
    metier_prive = true, 
    for_all = false,
    check_service = 'isInServiceGouvernementBool', 
    coffre = {x = -1555.790, y = -575.123, z = 107.537, CircleDiameter = 1.0, CircleBounce = 1, distActivate = 2, distDraw = 30}, 
    garage = {}, 
    entreprise = {}, 
    recolte = {}, 
    traitement = {}, 
    vente = {}, 
vehicules = {}}
--########################################

--############### PROCUREUR ###############
local procureur = {metier = "Procureur", 
    nom = "Procureur", 
    jobid = 24, 
    loop_ignore = false, 
    pole_ignore = true, 
    metier_prive = true, 
    for_all = false,
    check_service = 'isInServiceProcureurBool', 
    coffre = {}, 
    garage = {id = 225, nom = "Garage", fonction = 'GetVehicleProcureur', x = -3.712, y = -670.003, z = 31.338, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    entreprise = {id = 498, nom = "Prise de Service", fonction = 'GetServiceProcureur', x = 10.095, y = -668.158, z = 32.449, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    recolte = {}, 
    traitement = {}, 
    vente = {}, 
vehicules = {[1] = {nom = "Voiture Procureur", model = 'cog55', vehid = 1}}}
--########################################

--############### MECANICIEN ###############
local mecanicien = {metier = "Mécanicien", 
    nom = "Benny's", 
    jobid = 16, 
    loop_ignore = false, 
    metier_prive = true, 
    pole_ignore = false, 
    for_all = false,
    check_service = 'isInServiceMecanicienBool', 
    coffre = {x = -206.773, y = -1341.549, z = 33.894, CircleDiameter = 1.0, CircleBounce = 1, distActivate = 2, distDraw = 30}, 
    garage = {}, 
    entreprise = {}, 
    recolte = {}, 
    traitement = {}, 
    vente = {}, 
vehicules = {}}
--########################################

--############### LSES ###############
local lses = {metier = "LSES", 
    nom = "LSES", 
    jobid = 15, 
    loop_ignore = false, 
    metier_prive = true, 
    pole_ignore = true, 
    for_all = false,
    check_service = 'isInServiceLsesBool', 
    coffre = {x = 229.894, y = -1369.412, z = 38.534, CircleDiameter = 1.0, CircleBounce = 1, distActivate = 2, distDraw = 30}, 
    garage = {}, 
    entreprise = {}, 
    recolte = {}, 
    traitement = {}, 
    vente = {}, 
vehicules = {}}
--########################################

--############### LSPD ###############
local lspd = {metier = "LSPD", 
    nom = "LSPD", 
    jobid = 2, 
    loop_ignore = false, 
    pole_ignore = true, 
    metier_prive = true,
    for_all = false, 
    check_service = 'isInServiceLspdBool', 
    coffre = {x = 452.736, y = -973.624, z = 29.689, CircleDiameter = 1.0, CircleBounce = 1, distActivate = 2, distDraw = 30}, 
    garage = {}, 
    entreprise = {}, 
    recolte = {}, 
    traitement = {}, 
    vente = {}, 
vehicules = {}}
--########################################


--############### TAXI ###############
local taxi = {metier = "Taxi", 
    nom = "Cab'n'Co", 
    jobid = 17, 
    loop_ignore = false, 
    pole_ignore = false, 
    metier_prive = true, 
    for_all = false,
    check_service = 'isInServiceTaxiBool', 
    coffre = {x = 882.722, y = -159.996, z = 76.110, CircleDiameter = 1.0, CircleBounce = 1, distActivate = 2, distDraw = 30}, 
    garage = {}, 
    entreprise = {}, 
    recolte = {}, 
    traitement = {}, 
    vente = {}, 
vehicules = {}}
--########################################

entreprises = {
    [1] = fermier, 
    [2] = water, 
    [3] = brasseur, 
    [4] = vigneron, 
    [5] = livreur, 
    [6] = mineur, 
    [7] = arboriculteur, 
    [8] = pecheur, 
    [9] = raffineur, 
    [10] = concessionnaire, 
    [11] = avocat, 
    [12] = gouvernement, 
    [13] = procureur, 
    [14] = mecanicien, 
    [15] = lses, 
    [16] = lspd, 
    [17] = taxi,
	[18] = glacier,
	[19] = prisonnier
}

pole_emploi = {
    [1] = {nom = "Recherche d'Emploi", id = 407, x = -266.94, y = -960.744, z = 30.0231}, 
[2] = {nom = "Recherche d'Emploi", id = 407, x = -253.952, y = 6148.22, z = 30.4242}}

options = {
    x = 0.1, 
    y = 0.2, 
    width = 0.2, 
    height = 0.04, 
    scale = 0.4, 
    font = 0, 
    menu_title = "Entreprise", 
    menu_subtitle = "Gestion", 
    color_r = 30, 
    color_g = 144, 
    color_b = 255, 
}

--[[local coffres = {
  {nom='Coffre LSES', x=229.89440917969, y=-1369.412109375, z=39.534370422363, jobid=15}, -- LSES
  {nom='Coffre LSPD',x=452.73648071289, y=-973.62426757813, z=29.689603805542, jobid=2}, -- LSPD
  {nom='Coffre Benny\'S',x=-206.77369689941, y=-1341.5491943359, z=33.894374847412, jobid=16}, -- MECANICIEN
  {nom='Coffre Raffineurs',x=1413.8708496094, y=-2042.4427490234, z=50.998550415039, jobid=20}, -- RAFFINEUR
  {nom='Coffre Pêcheurs',x=3817.6057128906, y=4482.5502929688, z=4.9926853179932 , jobid=10}, -- PECHEUR
  {nom='Coffre Fermiers',x=2258.3134765625, y=5165.6923828125, z=58.111709594727 , jobid=6}, -- FERMIER
  {nom='Coffre Vignerons',x=-1893.5125732422, y=2075.6511230469, z=139.99772644043 , jobid=13}, -- VIGNERON
  {nom='Coffre Orpailleurs',x=707.40289306641, y=-966.55505371094, z=29.412853240967, jobid=21}, -- ORPAILLEUR
  {nom='Coffre Journaliste',x=-1055.21484375, y=-230.88966369629, z=43.021030426025, jobid=19}, -- JOURNALISTE
  {nom='Coffre Loca\'Luxe',x=-31.58943939209, y=-1106.9705810547, z=25.422351837158, jobid=25}, -- LOCALUXE
  {nom='Coffre Brasseur',x=2445.5776367188, y=4983.6235351563, z=45.809768676758, jobid=12}, -- BRASSEUR
  {nom='Coffre Gouvernement',x=-1555.7905273438, y=-575.12353515625, z=107.53789520264, jobid=23}, -- GOUVERNEMENT
  {nom='Coffre Taxi',x=882.72222900391, y=-159.99606323242, z=77.110229492188, jobid=17}, -- TAXI
}
]]--
--############### ORPAILLEUR ###############
-- local orpailleur = {metier = "Orpailleur", 
    -- nom = "Le Diamantaire", 
    -- jobid = 21, 
    -- loop_ignore = false, 
    -- pole_ignore = false, 
    -- metier_prive = true, 
    -- check_service = 'isInServiceOrpailleurBool', 
    -- coffre = {x = 1075.4, y = -2328.81, z = 30.29, CircleDiameter = 3.0, CircleBounce = 1, distActivate = 3, distDraw = 30}, 
    -- garage = {id = 318, nom = "Garage", fonction = 'GetVehicleOrpailleur', x = 1110.039, y = -2290.100, z = 29.376, CircleDiameter = 5.0, CircleBounce = 0, distActivate = 5, distDraw = 30}, 
    -- entreprise = {id = 366, nom = "Prise de Service", fonction = 'GetServiceOrpailleur', x = 1084.820, y = -2289.270, z = 29.231, CircleDiameter = 3.0, CircleBounce = 0, distActivate = 3, distDraw = 30}, 
    -- recolte = {[1] = {id = 17, nom = "Mine d'Or", fonction = nil, forcecar = true, forcepedincar = true, x = -596.781, y = 2091.123, z = 130.412, CircleDiameter = 10.0, CircleBounce = 0, giveItem = 3, maxQuantity = 10, distActivate = 10, distDraw = 30}}, 
    -- traitement = {[1] = {id = 18, nom = "La Fonderie", fonction = nil, forcecar = true, forcepedincar = true, x = 1102.256, y = -2241.587, z = 29.210, CircleDiameter = 10.0, CircleBounce = 0, requireItem = 3, giveItem = 9, maxQuantity = 10, distActivate = 10, distDraw = 30}}, 
    -- vente = {[1] = {id = 19, nom = "Vente de l'Or", fonction = nil, forcecar = true, forcepedincar = true, x = -623.765, y = -227.916, z = 37.057, CircleDiameter = 15.0, CircleBounce = 0, requireItem = 9, minprice = 150, maxprice = 158, distActivate = 15, distDraw = 30}}, 
-- vehicules = {[1] = {nom = "Camion Orpailleur n°1", model = 'bison', vehid = 1}, [2] = {nom = "Camion Orpailleur n°2", model = 'bison2', vehid = 2}, [3] = {nom = "Camion Orpailleur n°3", model = 'bison3', vehid = 3}}}
--########################################