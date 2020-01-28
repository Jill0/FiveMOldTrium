local blips = {
	{name="Cabinet d'avocats",	id=385, x=110.04, 	y=-752.51,	z=242.15},
	{name="Taxi", 			id=198, x=905.86, 	y=-175.04, 	z=74.07},
	{name="Raffineur", 		id=361, x=1383.86, 	y=-2079.75,	z=51.99},
	{name="Procureur", 		id=387, x=148.51, 	y=-759.3, 	z=242.61},
	{name="Weazel News", 		id=384, x=-600.86,	y=-923.96,	z=23.86},
	{name="Gouvernement", 		id=419, x=-428.93, 	y=1111.05,	z=327.69},
	--{name="Gruppe 6",		id=487, x=-200.63, 	y=-833.93,	z=30.81},
	--{name="Fight Club Los Santos",	id=311, x=-1214.95, y=-1578.52,	z=4.15},
	{name="Fight Club Los Santos",id=311, x=1982.48, 	y=3037.71,	z=47.05},
	
	{name="Tequil-la-la",		id=386, x=-564.41, y=276.67, z=83.13},
	{name="Bahamas Mamas",		id=93,  x=-1388.01,y=-587.45, z=30.31},
	{name="Vanilla Unicorn",	id=121, x=128.57,  y=-1298.34, z=29.23},
	{name="Yellow Jack", 		id=386, x=1990.47, y=3053.37, z=47.21},
	{name="Lost Clubhouse",		id=386, x=981.363, y=-102.65, z=74.84},

    {name="Stock Car Arena",    id=380, x=1137.97, y=108.24,    z=80.74};
	-- {name="Île de Noël",		id=479, x=3248.83, 	y=-140.25,	z=15.66},
	-- {name="Marché de Noël",	id=488, x=389.34, 	y=-356.15,	z=48.02},

	{name="Comissariat", 		id=60,	x=434.9,	y=-981.99,	z=30.7}, --Central
    {name="Comissariat",        id=60,  x=1856.91, y=3689.50, z=34.26}, --Sandy Shore
    {name="Comissariat",        id=60,  x=-449.62, y=6016.36, z=31.71}, --Paleto Bay
	{name="Hopital", 			id=61,	x=295.4,	y=-1449.38, z=29.97}, --Central
    {name="Hopital",            id=61,  x=1828.38, y=3691.88, z=33.22}, --Sandy Shore
    {name="Hopital",            id=61,  x=-248.18, y=6331.25, z=31.43}, --Paleto Bay
	{name="Prison", 			id=285, x=1679.04, 	y=2513.71,  z=45.56},
	{name="Yacht", 				id=455, x=-2045.80, y=-1031.20,	z=11.9},

	{name="Killhouse", 			id=313, x=453.57, 	y=-3081.1,	z=6.07},
	{name="Trim Track", 		id=126, x=94.45, 	y=6800.8,	z=2.17},
    {name="LSTrophy",              id=315, x=1054.13, y=2364.85, z=44.2792}

   -- {name="Micro-pénis de Botiv",	id=465, x=439.76, 	y=5813.64,	z=560.16},
   -- {name="Airport", id=90, x=-1032.690, y=-2728.141, z=13.757},
   -- {name="Airport", id=90, x=1743.6820, y=3286.2510, z=40.087},
   -- -- barbers
   -- {name="Barber", id=71, x=-827.333, y=-190.916, z=37.599},
   -- {name="Barber", id=71, x=130.512, y=-1715.535, z=29.226},
   -- {name="Barber", id=71, x=-1291.472, y=-1117.230, z=6.641},
   -- {name="Barber", id=71, x=1936.451, y=3720.533, z=32.638},
   -- {name="Barber", id=71, x=1200.214, y=-468.822, z=66.268},
   -- {name="Barber", id=71, x=-30.109, y=-141.693, z=57.041},
   -- {name="Barber", id=71, x=-285.238, y=6236.365, z=31.455},
   -- -- Stores
    -- {name="Store", id=52, x=28.463, y=-1353.033, z=29.340},
    -- {name="Store", id=52, x=-54.937, y=-1759.108, z=29.005},
    -- {name="Store", id=52, x=375.858, y=320.097, z=103.433},
    -- {name="Store", id=52, x=1143.813, y=-980.601, z=46.205},
    -- {name="Store", id=52, x=1695.284, y=4932.052, z=42.078},
    -- {name="Store", id=52, x=2686.051, y=3281.089, z=55.241},
    -- {name="Store", id=52, x=1967.648, y=3735.871, z=32.221},
    -- {name="Store", id=52, x=-2977.137, y=390.652, z=15.024},
    -- {name="Store", id=52, x=1160.269, y=-333.137, z=68.783},
    -- {name="Store", id=52, x=-1492.784, y=-386.306, z=39.798},
    -- {name="Store", id=52, x=-1229.355, y=-899.230, z=12.263},
    -- {name="Store", id=52, x=-712.091, y=-923.820, z=19.014},
    -- {name="Store", id=52, x=-1816.544, y=782.072, z=137.600},
    -- {name="Store", id=52, x=1729.689, y=6405.970, z=34.453},
    -- {name="Store", id=52, x=2565.705, y=385.228, z=108.463},
    -- -- Clothing
    -- {name="Clothing", id=73, x=88.291, y=-1391.929, z=29.200},
    -- {name="Clothing", id=73, x=-718.985, y=-158.059, z=36.996},
    -- {name="Clothing", id=73, x=-151.204, y=-306.837, z=38.724},
    -- {name="Clothing", id=73, x=414.646, y=-807.452, z=29.338},
    -- {name="Clothing", id=73, x=-815.193, y=-1083.333, z=11.022},
    -- {name="Clothing", id=73, x=-1208.098, y=-782.020, z=17.163},
    -- {name="Clothing", id=73, x=-1457.954, y=-229.426, z=49.185},
    -- {name="Clothing", id=73, x=-2.777, y=6518.491, z=31.533},
    -- {name="Clothing", id=73, x=1681.586, y=4820.133, z=42.046},
    -- {name="Clothing", id=73, x=130.216, y=-202.940, z=54.505},
    -- {name="Clothing", id=73, x=618.701, y=2740.564, z=41.905},
    -- {name="Clothing", id=73, x=1199.169, y=2694.895, z=37.866},
    -- {name="Clothing", id=73, x=-3164.172, y=1063.927, z=20.674},
    -- {name="Clothing", id=73, x=-1091.373, y=2702.356, z=19.422},
    -- -- ammunationblips
    -- {name="Weapon store", id=110, x=1701.292, y=3750.450, z=34.365},
    -- {name="Weapon store", id=110, x=237.428, y=-43.655, z=69.698},
    -- {name="Weapon store", id=110, x=843.604, y=-1017.784, z=27.546},
    -- {name="Weapon store", id=110, x=-321.524, y=6072.479, z=31.299},
    -- {name="Weapon store", id=110, x=-664.218, y=-950.097, z=21.509},
    -- {name="Weapon store", id=110, x=-1320.983, y=-389.260, z=36.483},
    -- {name="Weapon store", id=110, x=-1109.053, y=2686.300, z=18.775},
    -- {name="Weapon store", id=110, x=2568.379, y=309.629, z=108.461},
    -- {name="Weapon store", id=110, x=-3157.450, y=1079.633, z=20.692},
    -- -- Basic
    -- {name="Comedy Club", id=102, x=377.088, y=-991.869, z=-97.604},
    -- {name="Franklin", id=210, x=7.900, y=548.100, z=175.500},
    -- {name="Franklin", id=210, x=-14.128,	y=-1445.483,	z=30.648},
    -- {name="Michael", id=124, x=-852.400, y=160.000, z=65.600},
    -- {name="Trevor", id=208, x=1985.700, y=3812.200, z=32.200},
    -- {name="Trevor", id=208, x=-1159.034,	y=-1521.180, z=10.633},
    -- {name="FIB", id=106, x=105.455, y=-745.483, z=44.754},
    -- {name="Lifeinvader", id=77, x=-1047.900, y=-233.000, z=39.000},
    -- {name="Cluckin Bell", id=357, x=-72.68752, y=6253.72656, z=31.08991},
    -- {name="Tequil-La La", id=93, x=-565.171, y=276.625, z=83.286},
    -- {name="O'Neil Ranch", id=438, x=2441.200, y=4968.500, z=51.700},
    -- {name="Play Boy Mansion", id=439, x=-1475.234, y=167.088, z=55.841},
    -- {name="Hippy Camp", id=140, x=2476.712, y=3789.645, z=41.226},
    --{name="Chop shop", id=446, x=479.056, y=-1316.825, z=28.203},
	--{name="Chop shop", id=446, x=1008.35, y=-1316.825, z=28.203},
    -- {name="Rebel Radio", id=136, x=736.153, y=2583.143, z=79.634},
    -- {name="Morgue", id=310, x=243.351, y=-1376.014, z=39.534},
    -- {name="Golf", id=109, x=-1336.715, y=59.051, z=55.246 },
    -- {name="Jewelry Store", id=52,  x=-630.400, y=-236.700, z=40.00},
    -- -- Propperty
    -- {name="Casino", id=207, x=925.329, y=46.152, z=80.908 },
    -- {name="Maze Bank Arena", id=135, x=-250.604, y=-2030.000, z=30.000},
    -- {name="Stripbar", id=121, x=134.476, y=-1307.887, z=28.983},
    -- {name="Smoke on the Water", id=140, x=-1171.42, y=-1572.72, z=3.6636},
    -- {name="Weed Farm", id=140, x=2208.777, y=5578.235, z=53.735},
    -- {name="Downtown Cab Co", id=375, x=900.461, y=-181.466, z=73.89},
    -- {name="Theater", id=135, x=293.089, y=180.466, z=104.301},
    -- -- Gangs
    -- {name="Gang", id=437, x=298.68, y=-2010.10, z=20.07},
    -- {name="Gang", id=437, x=86.64, y=-1924.60, z=20.79},
    -- {name="Gang", id=437, x=-183.52, y=-1632.62, z=33.34},
    -- {name="Gang", id=437, x=989.37, y=-1777.56, z=31.32},
    -- {name="Gang", id=437, x=960.24, y=-140.31, z=74.50},
    -- {name="Gang", id=437, x=-1042.29, y=4910.17, z=94.92},
    -- Gas stations
    --{name="Station Essence", id=361, x=49.4187,   y=2778.793,  z=58.043},
    --{name="Station Essence", id=361, x=263.894,   y=2606.463,  z=44.983},
    --{name="Station Essence", id=361, x=1039.958,  y=2671.134,  z=39.550},
    --{name="Station Essence", id=361, x=1207.260,  y=2660.175,  z=37.899},
    --{name="Station Essence", id=361, x=2539.685,  y=2594.192,  z=37.944},
    --{name="Station Essence", id=361, x=2679.858,  y=3263.946,  z=55.240},
    --{name="Station Essence", id=361, x=2005.055,  y=3773.887,  z=32.403},
    --{name="Station Essence", id=361, x=1687.156,  y=4929.392,  z=42.078},
    --{name="Station Essence", id=361, x=1701.314,  y=6416.028,  z=32.763},
    --{name="Station Essence", id=361, x=179.857,   y=6602.839,  z=31.868},
    --{name="Station Essence", id=361, x=-94.4619,  y=6419.594,  z=31.489},
    --{name="Station Essence", id=361, x=-2554.996, y=2334.40,   z=33.078},
    --{name="Station Essence", id=361, x=-1800.375, y=803.661,   z=138.651},
    --{name="Station Essence", id=361, x=-1437.622, y=-276.747,  z=46.207},
    --{name="Station Essence", id=361, x=-2096.243, y=-320.286,  z=13.168},
    --{name="Station Essence", id=361, x=-724.619,  y=-935.1631, z=19.213},
    --{name="Station Essence", id=361, x=-526.019,  y=-1211.003, z=18.184},
    --{name="Station Essence", id=361, x=-70.2148,  y=-1761.792, z=29.534},
    --{name="Station Essence", id=361, x=265.648,   y=-1261.309, z=29.292},
    --{name="Station Essence", id=361, x=819.653,   y=-1028.846, z=26.403},
    --{name="Station Essence", id=361, x=1208.951,  y= -1402.567,z=35.224},
    --{name="Station Essence", id=361, x=1181.381,  y= -330.847, z=69.316},
    --{name="Station Essence", id=361, x=620.843,   y= 269.100,  z=103.089},
    --{name="Station Essence", id=361, x=2581.321,  y=362.039,   z=108.468},
    -- Police Stations
    --{name="Poste de Police", id=60, x=425.130, y=-979.558, z=30.711},
    --{name="Poste de Police", id=60, x=1859.234, y= 3678.742, z=33.690},
    --{name="Poste de Police", id=60, x=-438.862, y=6020.768, z=31.490},
    --{name="Poste de Police", id=60, x=818.221, y=-1289.883, z=26.300},
    
    -- Hospitals
    -- {name="Hospital", id=61, x= 1839.6, y= 3672.93, z= 34.28},
    -- {name="Hospital", id=61, x= -247.76, y= 6331.23, z=32.43},
    -- {name="Hospital", id=61, x= -449.67, y= -340.83, z= 34.50},
    -- {name="Hospital", id=61, x= 357.43, y= -593.36, z= 28.79},
    -- {name="Hospital", id=61, x= 295.83, y= -1446.94, z= 29.97},
    -- {name="Hospital", id=61, x= -676.98, y= 310.68, z= 83.08},

    -- {name="Hospital", id=61, x= -874.64, y= -307.71, z= 39.58},
    -- Vehicle Shop (Simeon)
    -- {name="Simeon", id=120, x=-33.803, y=-1102.322, z=25.422},
    -- -- LS Customs
    -- {name="LS Customs", id=72, x= -362.796, y= -132.400, z= 38.252},
    -- {name="LS Customs", id=72, x= -1140.19, y= -1985.478, z= 12.729},
    -- {name="LS Customs", id=72, x= 716.464, y= -1088.869, z= 21.929},
    -- {name="LS Customs", id=72, x= 1174.81, y= 2649.954, z= 37.371},
    -- {name="LS Customs", id=72, x= 118.485, y= 6619.560, z= 31.802},
    -- -- Lester
    -- {name="Lester", id=77, x=1248.183, y=-1728.104, z=56.000},
    -- {name="Lester", id=77, x=719.000, y=-975.000, y=25.000},
    -- -- Survivals
    -- {name="Survival", id=305, x=2351.331, y=3086.969, z=48.057},
    -- {name="Survival", id=305, x=-1695.803, y=-1139.190, z=13.152},
    -- {name="Survival", id=305, x=1532.52, y=-2138.682, z=77.120},
    -- {name="Survival", id=305, x=-593.724, y=5283.231, z=70.230},
    -- {name="Survival", id=305, x=1891.436, y=3737.409, z=32.513},
    -- {name="Survival", id=305, x=195.572, y=-942.493, z=30.692},
    -- {name="Survival", id=305, x=1488.579, y=3582.804, z=35.345},

    -- {name="Safehouse", id=357, x=-952.35943603516, y= -1077.5021972656, z=2.6772258281708},
    -- {name="Safehouse", id=357, x=-59.124889373779, y= -616.55456542969, z=37.356777191162},
    -- {name="Safehouse", id=357, x=-255.05390930176, y= -943.32885742188, z=31.219989776611},
    -- {name="Safehouse", id=357, x=-771.79888916016, y= 351.59423828125, z=87.998191833496},
    -- {name="Safehouse", id=357, x=-3086.428, y=339.252, z=6.371},
    -- {name="Safehouse", id=357, x=-917.289, y=-450.206, z=39.600},

    -- {name="Race", id=316, x=-1277.629, y=-2030.913, z=1.2823},
    -- {name="Race", id=316, x=2384.969, y=4277.583, z=30.379},
    -- {name="Race", id=316, x=1577.881, y=3836.107, z=30.7717},
  }

Citizen.CreateThread(function()

    for _, item in pairs(blips) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local players = {}

    for i = 0, 68 do
      if NetworkIsPlayerActive(i) then
        table.insert(players, i)
      end
    end

    for k, v in pairs(players) do
      if not GetBlipFromEntity(GetPlayerPed(v)) then
        if GetPlayerPed(v) == GetPlayerPed(-1) then return end
        local blip = AddBlipForEntity(GetPlayerPed(v))
        SetBlipColour(blip, 1)
      end
    end
  end
end)
