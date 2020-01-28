--[[Register]]--

RegisterNetEvent('FinishMoneyCheckForVeh')
RegisterNetEvent('vehshop:spawnVehicle')



--[[Local/Global]]--

local vehshop = {
	identifier = nil,
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
	menu = {
		x = 0.9,
		y = 0.08,
		width = 0.2,
		height = 0.04,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.4,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Vehicles", description = ""},
				{name = "Motorcycles", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {
				{name = "Compacts", description = ''},
				{name = "Coupes", description = ''},
				{name = "Sedans", description = ''},
				{name = "Sports", description = ''},
				{name = "Sports Classics", description = ''},
				{name = "Super", description = ''},
				{name = "Muscle", description = ''},
				{name = "Off-Road", description = ''},
				{name = "SUVs", description = ''},
				{name = "Vans", description = ''},
				--{name = "Cycles", description = ''},
			}
		},
		["compacts"] = {
			title = "compacts",
			name = "compacts",
			buttons = {
				{name = "Blista", costs = 16500, description = {}, model = "blista", vMax="72.43", accel="57.5", frein= "20" },
				{name = "Brioso R/A", costs = 20000, description = {}, model = "brioso", vMax="72.43", accel="72.5", frein= "20"},
				{name = "Dilettante", costs = 2000, description = {}, model = "Dilettante", vMax="69.75", accel="25", frein= "20"},
				{name = "Issi", costs = 15000, description = {}, model = "issi2", vMax="72.43", accel="57.5", frein= "20"},
				{name = "Panto", costs = 20000, description = {}, model = "panto", vMax="70.82", accel="67.5", frein= "20"},
				{name = "Prairie", costs = 12500, description = {}, model = "prairie", vMax="72.43", accel="55", frein= "20"},
				{name = "Rhapsody", costs = 15000, description = {}, model = "rhapsody", vMax="71.36", accel="57.5", frein= "20"},
			}
		},
		["coupes"] = {
			title = "coupes",
			name = "coupes",
			buttons = {
				{name = "Ruiner", costs = 50000, description = {}, model = "ruiner", vMax="77.8", accel="65", frein= "20"},
				{name = "Cognoscenti Cabrio", costs = 60000, description = {}, model = "cogcabrio", vMax="77.8", accel="65", frein= "20"},
				{name = "Exemplar", costs = 80000, description = {}, model = "exemplar", vMax="77.8", accel="65", frein= "30"},
				{name = "F620", costs = 68000, description = {}, model = "f620", vMax="77.8", accel="60", frein= "30"},
				{name = "Felon", costs = 63000, description = {}, model = "felon", vMax="77.8", accel="60", frein= "30"},
				{name = "Felon GT", costs = 65000, description = {}, model = "felon2", vMax="77.8", accel="60", frein= "30"},
				{name = "Jackal", costs = 45000, description = {}, model = "jackal", vMax="76.46", accel="55", frein= "30"},
				{name = "Oracle", costs = 65000, description = {}, model = "oracle", vMax="80.48", accel="67.5", frein= "30"},
				{name = "Oracle XS", costs = 40000, description = {}, model = "oracle2", vMax="80.48", accel="65", frein= "30"},
				{name = "Sentinel XS", costs = 42000, description = {}, model = "sentinel", vMax="76.19", accel="52.5", frein= "30"},
				{name = "Sentinel", costs = 40000, description = {}, model = "sentinel2", vMax="76.19", accel="52.5", frein= "30"},
				{name = "Windsor", costs = 250000, description = {}, model = "windsor", vMax="77.8", accel="65", frein= "20"},
				{name = "Windsor Drop", costs = 280000, description = {}, model = "windsor2", vMax="80.48", accel="69.75", frein= "23.33"},
				{name = "Zion", costs = 35000, description = {}, model = "zion", vMax="77.8", accel="55", frein= "30"},
				{name = "Zion Cabrio", costs = 37500, description = {}, model = "zion2", vMax="77.8", accel="55", frein= "30"},
			}
		},
		["sports"] = {
			title = "sports",
			name = "sports",
			buttons = {
				{name = "9F", costs = 250000, description = {}, model = "ninef", vMax="83.17", accel="82.5", frein= "33.33"},
				{name = "9F Cabrio", costs = 280000, description = {}, model = "ninef2", vMax="83.17", accel="82.5", frein= "33.33"},
				{name = "Alpha", costs = 400000, description = {}, model = "alpha", vMax="83.17", accel="85", frein= "33.33"},
				{name = "Banshee", costs = 350000, description = {}, model = "banshee", vMax="79.41", accel="85", frein= "33.33"},
				{name = "Bestia GTS", costs = 320000, description = {}, model = "bestiagts", vMax="83.17", accel="80", frein= "33.33"},
				{name = "Blista Compact", costs = 45000, description = {}, model = "blista", vMax="70.82", accel="57.5", frein= "18.33"},
				{name = "Buffalo", costs = 95000, description = {}, model = "buffalo", vMax="77.8", accel="67.5", frein= "30"},
				{name = "Buffalo S", costs = 105000, description = {}, model = "buffalo2", vMax="77.8", accel="72.5", frein= "30"},
				{name = "Carbonizzare", costs = 350000, description = {}, model = "carbonizzare", vMax="84.78", accel="87.5", frein= "26.67"},
				{name = "Comet", costs = 320000, description = {}, model = "comet2", vMax="81.56", accel="85", frein= "26.67"},
				{name = "Comet Rétro", costs = 450000, description = {}, model = "comet3", vMax="80.56", accel="85", frein= "27"},
				{name = "Coquette", costs = 180000, description = {}, model = "coquette", vMax="81.56", accel="82.5", frein= "26.67"},
				{name = "Drift Tampa", costs = 550000, description = {}, model = "tampa2", vMax="80.48", accel="82.5", frein= "16.67"},
				{name = "Feltzer", costs = 405000, description = {}, model = "feltzer2", vMax="82.09", accel="85", frein= "26.67"},
				{name = "Furore GT", costs = 310000, description = {}, model = "furoregt", vMax="81.56", accel="83.75", frein= "26.67"},
				{name = "Fusilade", costs = 90000, description = {}, model = "fusilade", vMax="79.95", accel="80", frein= "30"},
				{name = "Jester", costs = 350000, description = {}, model = "jester", vMax="84.78", accel="75", frein= "31.67"},
				{name = "Jester(Racecar)", costs = 400000, description = {}, model = "jester2", vMax="84.78", accel="77.5", frein= "31.67"},
				{name = "Kuruma", costs = 175000, description = {}, model = "kuruma", vMax="78.87", accel="77.5", frein= "16.67"},
				{name = "Lynx", costs = 330000, description = {}, model = "lynx", vMax="84.24", accel="78.75", frein= "33.33"},
				{name = "Massacro", costs = 350000, description = {}, model = "massacro", vMax="82.09", accel="90.25", frein= "30"},
				{name = "Massacro(Racecar)", costs = 400000, description = {}, model = "massacro2", vMax="83.81", accel="91", frein= "30"},
				{name = "Elegy", costs = 105000, description = {}, model = "elegy2", vMax="81.56", accel="82.5", frein= "16.67"},
				{name = "Elegy Rétro", costs = 325000, description = {}, model = "elegy", vMax="79.41", accel="42.5", frein= "33.33"},
				{name = "Khamelion", costs = 400000, description = {}, model = "khamelion", vMax="75.12", accel="37.5", frein= "30"},
				{name = "Futo", costs = 68000, description = {}, model = "futo", vMax="72.43", accel="72.5", frein= "16.67"},
				{name = "Omnis", costs = 310000, description = {}, model = "omnis", vMax="81.56", accel="76.25", frein= "33.33"},
				{name = "Penumbra", costs = 55000, description = {}, model = "penumbra", vMax="75.12", accel="55", frein= "26.67"},
				{name = "Rapid GT", costs = 380000, description = {}, model = "rapidgt", vMax="81.56", accel="90", frein= "33.33"},
				{name = "Rapid GT Convertible", costs = 390000, description = {}, model = "rapidgt2", vMax="81.56", accel="90", frein= "33.33"},
				{name = "Schafter V12", costs = 200000, description = {}, model = "schafter3", vMax="80.48", accel="75", frein= "31.67"},
				{name = "Sultan", costs = 125000, description = {}, model = "sultan", vMax="77.8", accel="65", frein= "13.33"},
			    {name = "Surano", costs = 375000, description = {}, model = "surano", vMax="83.17", accel="85", frein= "33.33"},
				{name = "Seven-70", costs = 550000, description = {}, model = "seven70", vMax="85.31", accel="83.75", frein= "33.33"},
				{name = "Tropos", costs = 300000, description = {}, model = "tropos", vMax="81.56", accel="56.25", frein= "23.33"},
				{name = "Verkierer", costs = 320000, description = {}, model = "verlierer2", vMax="80.48", accel="83.75", frein= "33.33"},
				{name = "Specter", costs = 340000, description = {}, model = "specter", vMax="80.48", accel="83.75", frein= "33.33"},
				{name = "Specter 2.0", costs = 380000, description = {}, model = "specter2", vMax="80.48", accel="83.75", frein= "33.33"},
			}
		},
		["sportsclassics"] = {
			title = "sports classics",
			name = "sportsclassics",
			buttons = {
				{name = "Penetrator", costs = 300000, description = {}, model = "penetrator", vMax="81.02", accel="80", frein= "20"},
				{name = "Casco", costs = 300000, description = {}, model = "casco", vMax="81.02", accel="80", frein= "20"},
				{name = "Coquette Classic", costs = 280007, description = {}, model = "coquette2", vMax="81.02", accel="85", frein= "16.67"},
				--{name = "JB 700", costs = 1500000, description = {}, model = "jb700", vMax="80.48", accel="65", frein= "20"},
				{name = "Pigalle", costs = 100000, description = {}, model = "pigalle", vMax="79.95", accel="66.25", frein= "28.33"},
				{name = "Stinger", costs = 200000, description = {}, model = "stinger", vMax="77.8", accel="65", frein= "20"},
				{name = "Stinger GT", costs = 230000, description = {}, model = "stingergt", vMax="77.8", accel="65", frein= "20"},
				{name = "Stirling GT", costs = 250000, description = {}, model = "feltzer3", vMax="74.04", accel="75", frein= "26.67"},
				{name = "Z-Type", costs = 1200250, description = {}, model = "ztype", vMax="75.12", accel="55", frein= "13.33"},
			    {name = "Infernus classique", costs = 423600, description = {}, model = "infernus2", vMax="80.21", accel="82.5", frein= "16.67"},
				{name = "Manana", costs = 95000, description = {}, model = "manana", vMax="69.75", accel="40", frein= "8.33"},
				{name = "Peyote", costs = 113000, description = {}, model = "peyote", vMax="69.75", accel="40", frein= "8.33"},
				{name = "Mamba", costs = 375000, description = {}, model = "mamba", vMax="79.41", accel="85", frein= "16.67"},
				{name = "Monroe", costs = 230000, description = {}, model = "monroe", vMax="80.48", accel="70", frein= "22"},
				{name = "Roosevelt", costs = 999999, description = {}, model = "btype3", vMax="67.07", accel="67.5", frein= "18.3"},
			}
		},
		["super"] = {
			title = "super",
			name = "super",
			buttons = {
				{name = "811", costs = 1900000, description = {}, model = "pfister811", vMax="85.47", accel="89", frein= "37.3"}, 	
				{name = "Ruston", costs = 2000000, model = "ruston", vMax="85.47", accel="89", frein= "37.3"},
				{name = "Adder", costs = 1400000, description = {}, model = "adder", vMax="85.85", accel="80", frein= "33.33"},
				{name = "Banshee 900R", costs = 499000, description = {}, model = "banshee2", vMax="80.48", accel="86.88", frein= "33.33"},
				{name = "Bullet", costs = 570000, description = {}, model = "bullet", vMax="81.56", accel="82.5", frein= "26.67"},
				{name = "Cheetah", costs = 900000, description = {}, model = "cheetah", vMax="82.09", accel="80", frein= "26.67"},
				{name = "Entity XF", costs = 1200000, description = {}, model = "entityxf", vMax="83.17", accel="82.5", frein= "30"},
				{name = "ETR1", costs = 2400000, description = {}, model = "sheava", vMax="85.04", accel="82.5", frein= "38.33"},
				{name = "FMJ", costs = 2900000, description = {}, model = "fmj", vMax="84.99", accel="91.38", frein= "36.67"},
				{name = "Infernus", costs = 500000, description = {}, model = "infernus", vMax="80.48", accel="85", frein= "16.67"},
				{name = "Osiris", costs = 1700000, description = {}, model = "osiris", vMax="85.31", accel="88.5", frein= "33.33"},
				{name = "RE-7B", costs = 4500000, description = {}, model = "le7b", vMax="86.38", accel="92.75", frein= "36.67"},
				{name = "Nero", costs = 1800000, description = {}, model = "nero", vMax="85.85", accel="84.38", frein= "33.33"},
				{name = "Nero 2.0", costs = 2800000, description = {}, model = "nero2", vMax="85.85", accel="84.38", frein= "33.33"},
				{name = "Reaper", costs = 2500000, description = {}, model = "reaper", vMax="85.31", accel="91.25", frein= "36.67"},
				{name = "Sultan RS", costs = 499000, description = {}, model = "sultanrs", vMax="79.41", accel="82.5", frein= "33.33"},
				{name = "T20", costs = 1750000, description = {}, model = "t20", vMax="85.31", accel="88.5", frein= "33.33"},
				{name = "Turismo R", costs = 2600000, description = {}, model = "turismor", vMax="83.17", accel="88.25", frein= "40"},
				{name = "Tyrus", costs = 3400000, description = {}, model = "tyrus", vMax="86.38", accel="92.75", frein= "40"},
				{name = "Tempesta", costs = 1100000, description = {}, model = "tempesta", vMax="84.24", accel="90", frein= "33.33"},
				{name = "Vacca", costs = 700000, description = {}, model = "vacca", vMax="81.56", accel="75", frein= "33.33"},
				{name = "Voltic", costs = 1200000, description = {}, model = "voltic", vMax="77.8", accel="90", frein= "33.33"},
				{name = "X80 Proto", costs = 7500000, description = {}, model = "prototipo", vMax="85.31", accel="93.75", frein= "36.67"},
				{name = "Zentorno", costs = 2000000, description = {}, model = "zentorno", vMax="85.31", accel="88.75", frein= "33.33"},
				{name = "Itali GTB", costs = 1500000, description = {}, model = "italigtb", vMax="85.31", accel="84.14", frein= "37"},
				{name = "Itali GTB 2.0", costs = 1900000, description = {}, model = "italigtb2", vMax="85.31", accel="84.14", frein= "37"},
				{name = "GP1", costs = 1300000, description = {}, model = "gp1", vMax="86.12", accel="92.5", frein= "40"},
			}
		},
		["muscle"] = {
			title = "muscle",
			name = "muscle",
			buttons = {
				{name = "Blade", costs = 135000, description = {}, model = "blade", vMax="77.8", accel="81", frein= "26.67"},
				{name = "Buccaneer", costs = 142000, description = {}, model = "buccaneer", vMax="78.34", accel="70", frein= "26.67"},
				{name = "Chino", costs = 154750, description = {}, model = "chino", vMax="75.12", accel="70", frein= "26.67"},
				{name = "Coquette BlackFin", costs = 265000, description = {}, model = "coquette3", vMax="81.02", accel="85", frein= "16.67"},
				{name = "Dominator", costs = 172000, description = {}, model = "dominator", vMax="77.8", accel="72.5", frein= "26.67"},
				{name = "Dukes", costs = 196900, description = {}, model = "dukes", vMax="77.26", accel="80", frein= "26.67"},
				{name = "Gauntlet", costs = 137500, description = {}, model = "gauntlet", vMax="77.8", accel="75", frein= "30"},
				{name = "Hotknife", costs = 210000, description = {}, model = "hotknife", vMax="75.12", accel="75", frein= "14.33"},
				{name = "Faction", costs = 73000, description = {}, model = "faction", vMax="75.12", accel="70", frein= "26.67"},
				{name = "Nightshade", costs = 154000, description = {}, model = "nightshade", vMax="77.8", accel="62.5", frein= "20"},
				{name = "Picador", costs = 42000, description = {}, model = "picador", vMax="72.43", accel="55", frein= "26.67"},
				{name = "Sabre Turbo", costs = 95000, description = {}, model = "sabregt", vMax="75.12", accel="70", frein= "26.67"},
				{name = "Tampa", costs = 145000, description = {}, model = "tampa", vMax="75.12", accel="67.5", frein= "26.67"},
				{name = "Tornado Rusty", costs = 14000, description = {}, model = "tornado3", vMax="75.12", accel="67.5", frein= "26.67"},
				{name = "Tornado2", costs = 50000, description = {}, model = "tornado2", vMax="75.12", accel="67.5", frein= "26.67"},
				{name = "Virgo", costs = 60000, description = {}, model = "virgo", vMax="75.12", accel="70", frein= "26.67"},
				{name = "Vigero", costs = 65000, description = {}, model = "vigero", vMax="75.12", accel="72.5", frein= "26.67"},
			}
		},
		["offroad"] = {
			title = "off-road",
			name = "off-road",
			buttons = {
				{name = "Bifta", costs = 72000, description = {}, model = "bifta", vMax="72.97", accel="65", frein= "23.33"},
				{name = "Blazer", costs = 10000, description = {}, model = "blazer", vMax="67.07", accel="62.5", frein= "33.33"},
				{name = "Brawler", costs = 120000, description = {}, model = "brawler", vMax="72.43", accel="62.5", frein= "20.67"},
				{name = "Mesa v3", costs = 150000, description = {}, model = "mesa3", vMax="72.43", accel="62.5", frein= "20.67"},
				{name = "Bubsta 6x6", costs = 240000, description = {}, model = "dubsta3", vMax="73.51", accel="70", frein= "20"},
				{name = "Dune Buggy", costs = 37000, description = {}, model = "dune", vMax="72.43", accel="62.5", frein= "21"},
				{name = "Rebel", costs = 33500, description = {}, model = "rebel2", vMax="69.75", accel="50", frein= "20"},
				{name = "Sandking XL", costs = 69000, description = {}, model = "sandking", vMax="69.75", accel="50", frein= "20"},
				{name = "Sandking", costs = 54000, description = {}, model = "sandking2", vMax="69.75", accel="50", frein= "20"},
				{name = "Contender", costs = 260000, description = {}, model = "contender", vMax="69.75", accel="50", frein= "20"},
				--{name = "The Liberator", costs = 6000000, description = {}, model = "monster", vMax="59.02", accel="100", frein= "21.67"},
				{name = "Trophy Truck", costs = 537000, description = {}, model = "trophytruck", vMax="75.12", accel="84.75", frein= "10"},
				{name = "Trophy Truck Dune", costs = 600000, description = {}, model = "trophytruck2", vMax="75.12", accel="84.75", frein= "10"},
				{name = "Motoneige", costs = 5000, description = {}, model = "snowmob", vMax="80.01", accel="84.75", frein= "30.01"},
			}
		},
		["suvs"] = {
			title = "suvs",
			name = "suvs",
			buttons = {
				{name = "Baller", costs = 49000, description = {}, model = "baller", vMax="72.43", accel="67.5", frein= "20"},
				{name = "Cavalcade", costs = 51000, description = {}, model = "cavalcade", vMax="68.14", accel="50", frein= "20"},
				{name = "Granger", costs = 54000, description = {}, model = "granger", vMax="75.12", accel="47.5", frein= "26.67"},
				{name = "Huntley S", costs = 84900, description = {}, model = "huntley", vMax="72.97", accel="66.25", frein= "18.33"},
				{name = "Landstalker", costs = 44000, description = {}, model = "landstalker", vMax="72.43", accel="45", frein= "26.67"},
				{name = "Radius", costs = 47000, description = {}, model = "radi", vMax="75.12", accel="50", frein= "26.67"},
				{name = "Rocoto", costs = 43000, description = {}, model = "rocoto", vMax="74.58", accel="47.5", frein= "8.33"},
				{name = "Seminole", costs = 35000, description = {}, model = "seminole", vMax="69.75", accel="45", frein= "26.67"},
				{name = "XLS", costs = 58000, description = {}, model = "xls", vMax="70.82", accel="65", frein= "19.33"},
			}
		},
		["vans"] = {
			title = "vans",
			name = "vans",
			buttons = {
				{name = "Bison", costs = 59000, description = {}, model = "bison", vMax="69.75", accel="50", frein= "20"},
				{name = "Bobcat XL", costs = 45000, description = {}, model = "bobcatxl", vMax="69.75", accel="45", frein= "26.67"},
				{name = "Gang Burrito", costs = 64000, description = {}, model = "gburrito", vMax="69.75", accel="40", frein= "20"},
				{name = "Journey", costs = 100000, description = {}, model = "journey", vMax="53.66", accel="32.5", frein= "8.33"},
				{name = "Minivan", costs = 32500, description = {}, model = "minivan", vMax="67.07", accel="37.5", frein= "13.33"},
				{name = "Paradise", costs = 29500, description = {}, model = "paradise", vMax="69.75", accel="42.5", frein= "13.33"},
				{name = "Rumpo", costs = 28500, description = {}, model = "rumpo", vMax="69.75", accel="45", frein= "10"},
				{name = "Surfer", costs = 37500, description = {}, model = "surfer", vMax="53.66", accel="25", frein= "10"},
				{name = "Youga", costs = 40500, description = {}, model = "youga", vMax="64.39", accel="35", frein= "10"},
			}
		},
		["sedans"] = {
			title = "sedans",
			name = "sedans",
			buttons = {
				{name = "Asea", costs = 11500, description = {}, model = "asea", vMax="77.8", accel="50", frein= "13.33"},
				{name = "Asterope", costs = 17000, description = {}, model = "asterope", vMax="77.8", accel="50", frein= "30"},
				{name = "Fugitive", costs = 20000, description = {}, model = "fugitive", vMax="77.8", accel="50", frein= "30"},
				{name = "Glendale", costs = 15000, description = {}, model = "glendale", vMax="78.87", accel="58.75", frein= "21.67"},
				{name = "Ingot", costs = 12000, description = {}, model = "ingot", vMax="67.07", accel="35", frein= "20"},
				{name = "Intruder", costs = 16500, description = {}, model = "intruder", vMax="77.8", accel="50", frein= "30"},
				{name = "Premier", costs = 9000, description = {}, model = "premier", vMax="77.8", accel="50", frein= "20"},
				{name = "Primo", costs = 11000, description = {}, model = "primo", vMax="75.12", accel="50", frein= "30"},
				{name = "Primo Custom", costs = 12000, description = {}, model = "primo2", vMax="75.12", accel="50", frein= "30"},
				--{name = "Primo Custom", costs = 12500, description = {}, model = "primo2", vMax="75.12", accel="50", frein= "30"},
				{name = "Regina", costs = 10000, description = {}, model = "regina", vMax="64.39", accel="35", frein= "20"},
				{name = "Schafter", costs = 135000, description = {}, model = "schafter2", vMax="77.8", accel="50", frein= "30"},
				{name = "Schafter LWB", costs = 135000, description = {}, model = "schafter4", vMax="76.19", accel="50", frein= "28.33"},
				{name = "Stanier", costs = 14500, description = {}, model = "stanier", vMax="75.12", accel="50", frein= "30"},
				{name = "Stratum", costs = 12000, description = {}, model = "stratum", vMax="72.43", accel="52.5", frein= "20"},
				{name = "Stretch", costs = 300000, description = {}, model = "stretch", vMax="72.43", accel="42.5", frein= "26.67"},
				{name = "Super Diamond", costs = 70000, description = {}, model = "superd", vMax="77.8", accel="65", frein= "20"},
				{name = "Surge", costs = 20000, description = {}, model = "surge", vMax="75.12", accel="25", frein= "20"},
				{name = "Tailgater", costs = 25000, description = {}, model = "tailgater", vMax="77.8", accel="50", frein= "30"},
				{name = "Warrener", costs = 20000, description = {}, model = "warrener", vMax="75.12", accel="61.25", frein= "31.67"},
				{name = "Washington", costs = 15750, description = {}, model = "washington", vMax="75.12", accel="50", frein= "30"},
				{name = "Cognoscenti", costs = 77500, description = {}, model = "cognoscenti", vMax="77.8", accel="66.25", frein= "19"},
			}
		},
		["motorcycles"] = {
			title = "MOTORCYCLES",
			name = "motorcycles",
			buttons = {
				{name = "FCR", costs = 50000, description = {}, model = "fcr", vMax="77.8", accel="100", frein= "40"},
				{name = "FCR2", costs = 55000, description = {}, model = "fcr2", vMax="77.8", accel="100", frein= "40"},
				{name = "Akuma", costs = 50000, description = {}, model = "AKUMA", vMax="77.8", accel="100", frein= "40"},
				{name = "Bagger", costs = 10000, description = {}, model = "bagger", vMax="69.75", accel="52.5", frein= "40"},
				{name = "Bati 801", costs = 45000, description = {}, model = "bati", vMax="80.48", accel="75", frein= "46.67"},
				{name = "Bati 801RR", costs = 48000, description = {}, model = "bati2", vMax="80.48", accel="75", frein= "46.67"},
				{name = "BF400", costs = 30000, description = {}, model = "bf400", vMax="77.8", accel="72.5", frein= "36.67"},
				{name = "Carbon RS", costs = 65000, description = {}, model = "carbonrs", vMax="77.8", accel="75", frein= "43.33"},
				{name = "Cliffhanger", costs = 65000, description = {}, model = "cliffhanger", vMax="79.14", accel="79.5", frein= "36.67"},
				{name = "Daemon", costs = 15000, description = {}, model = "daemon", vMax="72.43", accel="65", frein= "20"},
				{name = "Daemon Custom", costs = 18000, description = {}, model = "daemon2", vMax="72.43", accel="65", frein= "20"},
				{name = "Wolfsbane", costs = 16000, description = {}, model = "wolfsbane", vMax="69.75", accel="63.75", frein= "40"},
				{name = "Double T", costs = 40000, description = {}, model = "double", vMax="78.87", accel="77.5", frein= "46.67"},
				{name = "Enduro", costs = 14000, description = {}, model = "enduro", vMax="63.85", accel="72.5", frein= "36.67"},
				{name = "Faggio", costs = 10, description = {}, model = "faggio2", vMax="48.29", accel="25", frein= "13.33"},
				{name = "Gargoyle", costs = 75000, description = {}, model = "gargoyle", vMax="78.87", accel="78.13", frein= "36.67"},
				{name = "Hakuchou", costs = 47000, description = {}, model = "hakuchou", vMax="81.56", accel="78.75", frein= "46.67"},
				{name = "Hexer", costs = 20000, description = {}, model = "hexer", vMax="72.43", accel="65", frein= "33.33"},
				{name = "Innovation", costs = 110000, description = {}, model = "innovation", vMax="72.43", accel="80", frein= "33.33"},
				{name = "Lectro", costs = 570000, description = {}, model = "lectro", vMax="75.12", accel="70", frein= "40"},
				{name = "Nemesis", costs = 8000, description = {}, model = "nemesis", vMax="75.12", accel="75", frein= "40"},
				{name = "Nightblade", costs = 50000, description = {}, model = "nightblade", vMax="75.12", accel="75", frein= "40"},
				{name = "Diabolus", costs = 60500, description = {}, model = "diablous", vMax="76.46", accel="78", frein= "40"},
				{name = "Diabolus 2.0", costs = 100000, description = {}, model = "diablous2", vMax="76.46", accel="78", frein= "40"},
				{name = "Esskey", costs = 49000, description = {}, model = "esskey", vMax="77.8", accel="73.75", frein= "40"},
				{name = "manchez", costs = 40000, description = {}, model = "manchez", vMax="77.8", accel="73.75", frein= "40"},
				{name = "PCJ-600", costs = 12000, description = {}, model = "pcj", vMax="69.75", accel="65", frein= "43.33"},
				{name = "Ruffian", costs = 30000, description = {}, model = "ruffian", vMax="75.12", accel="85", frein= "36.67"},
				{name = "Sanchez", costs = 27000, description = {}, model = "sanchez", vMax="63.31", accel="70", frein= "36.67"},
				{name = "Sovereign", costs = 43500, description = {}, model = "sovereign", vMax="72.43", accel="67.5", frein= "36.67"},
				{name = "Thrust", costs = 89000, description = {}, model = "thrust", vMax="81.56", accel="66.25", frein= "50"},
				{name = "Vader", costs = 5000, description = {}, model = "vader", vMax="75.12", accel="67.5", frein= "36.67"},
				{name = "Zombie Bobber", costs = 16000, description = {}, model = "zombiea", vMax="73.51", accel="72.5", frein= "26.67"},
				{name = "Zombie Chopper", costs = 16000, description = {}, model = "zombieb", vMax="73.51", accel="72.5", frein= "26.67"},
				{name = "Vindicator", costs = 42000, description = {}, model = "vindicator", vMax="81.56", accel="66.25", frein= "50"},
			}
		},
	}
}

local fakecar = {model = '', car = nil}
local vehshop_locations = {{entering = {-54.04,-1090.28,25.42}, inside = {-46.56327,-1097.382,25.99875, 120.1953}, outside = {-31.849,-1090.648,25.998,322.345}}}
local vehshop_blips ={}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local vehicle_price = 0
local backlock = false
local firstspawn = 0



--[[Functions]]--

function LocalPed()
	return GetPlayerPed(-1)
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function IsPlayerInRangeOfVehshop()
	return inrangeofvehshop
end

function ShowVehshopBlips(bool)
	if bool and #vehshop_blips == 0 then
		for station,pos in pairs(vehshop_locations) do
			local loc = pos
			pos = pos.entering
			local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
			-- 60 58 137
			SetBlipSprite(blip, 326)
			SetBlipColour(blip, 3)
			SetBlipScale(blip, 1.0)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Concessionnaire')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(vehshop_blips, {blip = blip, pos = loc})
		end
		Citizen.CreateThread(function()
			while #vehshop_blips > 0 do
				Citizen.Wait(0)
				local inrange = false
				for i,b in ipairs(vehshop_blips) do
					DrawMarker(1,b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],0,0,0,0,0,0,1.001,1.0001,0.5001,0,155,255,200,0,0,0,0)
					if vehshop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and  GetDistanceBetweenCoords(b.pos.entering[1],b.pos.entering[2],b.pos.entering[3],GetEntityCoords(LocalPed())) < 5 then
						ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour accéder~n~au ~b~catalogue de voiture', 1000)
						currentlocation = b
						inrange = true
					end
				end
				inrangeofvehshop = inrange
			end
		end)
	elseif bool == false and #vehshop_blips > 0 then
		for i,b in ipairs(vehshop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		vehshop_blips = {}
	end
end

function f(n)
	return n + 0.0001
end

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreator()
	boughtcar = false
	local ped = LocalPed()
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	vehshop.currentmenu = "main"
	vehshop.opened = true
	vehshop.selectedbutton = 0
end

RegisterNetEvent("vehshop:f_GetIdentifier")
AddEventHandler("vehshop:f_GetIdentifier", function(identifier)
	vehshop.identifier = identifier
end)

function CloseCreator(name, veh, price)
	Citizen.CreateThread(function()
		Wait(1000)
		local ped = LocalPed()
		if not boughtcar then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
		else
			local name = name
			local vehicle = veh
			local price = price
			local veh = GetVehiclePedIsUsing(ped)
			local model = GetEntityModel(veh)
			local colors = table.pack(GetVehicleColours(veh))
			local extra_colors = table.pack(GetVehicleExtraColours(veh))
			SetVehicleModKit(veh,0)
			local mods = {}
			for i = 0,24 do
				mods[i] = GetVehicleMod(veh,i)
			end
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
			local pos = currentlocation.pos.outside

			FreezeEntityPosition(ped,false)
			RequestModel(model)
			while not HasModelLoaded(model) do
				Citizen.Wait(0)
			end
			personalvehicle = CreateVehicle(model,pos[1],pos[2],pos[3],pos[4],true,false)
			--SetModelAsNoLongerNeeded(model)
			for i,mod in pairs(mods) do
				SetVehicleModKit(personalvehicle,0)
				SetVehicleMod(personalvehicle,i,mod)
			end
			SetVehicleOnGroundProperly(personalvehicle)

			--plaque perso
			--DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "Plaque", "", "", "", 8)
			--while (UpdateOnscreenKeyboard() == 0) do
			--	DisableAllControlActions(0);
			--	Wait(0);
		--	end
			--if (GetOnscreenKeyboardResult()) then
			--	result = tostring(GetOnscreenKeyboardResult())
			--	--Chat(result)
				--plate 
		--	end
			
					
			
			
			-- local plate = GetVehicleNumberPlateText(personalvehicle)
			--result = tostring(result)
			--local plate=string.upper(result)
			--SetVehicleNumberPlateText(personalvehicle, plate)
			

			--local plate = vehshop.identifier
			--SetVehicleNumberPlateText(personalvehicle, plate)
			local plate = GetVehicleNumberPlateText(personalvehicle)
			SetVehicleHasBeenOwnedByPlayer(personalvehicle,true)
			local id = NetworkGetNetworkIdFromEntity(personalvehicle)
			SetNetworkIdCanMigrate(id, true)
			--Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
			SetVehicleColours(personalvehicle,colors[1],colors[2])
			SetVehicleExtraColours(personalvehicle,extra_colors[1],extra_colors[2])
			TaskWarpPedIntoVehicle(GetPlayerPed(-1),personalvehicle,-1)
			SetEntityVisible(ped,true)
			local primarycolor = colors[1]
			local secondarycolor = colors[2]
			local pearlescentcolor = extra_colors[1]
			local wheelcolor = extra_colors[2]
			TriggerServerEvent('BuyForVeh', name, vehicle, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
			TriggerServerEvent("garages:CheckGarageForVeh")
			--TriggerServerEvent("garages:storeallvehicles2")
		end
		vehshop.opened = false
		vehshop.menu.from = 1
		vehshop.menu.to = 10
	end)
end

function drawMenuButton(button,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end

function drawMenuRight(txt,x,y,selected)
	local menu = vehshop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 - 0.03, y - menu.height/2 + 0.0028)
end

function drawMenuTitle(txt,x,y)
	local menu = vehshop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DoesPlayerHaveVehicle(model,button,y,selected)
		local t = false
		--TODO:check if player own car
		if t then
			drawMenuRight("OWNED",vehshop.menu.x,y,selected)
		else
			drawMenuRight(button.costs.."$",vehshop.menu.x,y,selected)
		end
end

function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function ButtonSelected(button)
	local ped = GetPlayerPed(-1)
	local this = vehshop.currentmenu
	local btn = button.name
	if this == "main" then
		if btn == "Vehicles" then
			OpenMenu('vehicles')
		elseif btn == "Motorcycles" then
			OpenMenu('motorcycles')
		end
	elseif this == "vehicles" then
		if btn == "Sports" then
			OpenMenu('sports')
		elseif btn == "Sedans" then
			OpenMenu('sedans')
		elseif btn == "Compacts" then
			OpenMenu('compacts')
		elseif btn == "Coupes" then
			OpenMenu('coupes')
		elseif btn == "Sports Classics" then
			OpenMenu("sportsclassics")
		elseif btn == "Super" then
			OpenMenu('super')
		elseif btn == "Muscle" then
			OpenMenu('muscle')
		elseif btn == "Off-Road" then
			OpenMenu('offroad')
		elseif btn == "SUVs" then
			OpenMenu('suvs')
		elseif btn == "Vans" then
			OpenMenu('vans')
		end
	elseif this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "super" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" or this == "cycles" or this == "motorcycles" then
		--TriggerServerEvent('CheckMoneyForVeh',button.name, button.model, button.costs)
	end
end

function OpenMenu(menu)
	fakecar = {model = '', car = nil}
	vehshop.lastmenu = vehshop.currentmenu
	if menu == "vehicles" then
		vehshop.lastmenu = "main"
	elseif menu == "bikes"  then
		vehshop.lastmenu = "main"
	elseif menu == 'race_create_objects' then
		vehshop.lastmenu = "main"
	elseif menu == "race_create_objects_spawn" then
		vehshop.lastmenu = "race_create_objects"
	end
	vehshop.menu.from = 1
	vehshop.menu.to = 10
	vehshop.selectedbutton = 0
	vehshop.currentmenu = menu
end

function Back()
	if backlock then
		return
	end
	backlock = true
	if vehshop.currentmenu == "main" then
		CloseCreator()
	elseif vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
		if DoesEntityExist(fakecar.car) then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
		end
		fakecar = {model = '', car = nil}
		OpenMenu(vehshop.lastmenu)
	else
		OpenMenu(vehshop.lastmenu)
	end
end

--[[Citizen]]--

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1,51) and IsPlayerInRangeOfVehshop() then
			if vehshop.opened then
				CloseCreator()
			else
				TriggerServerEvent("vehshop:GetIdentifier")
				OpenCreator()
			end
		end
		if vehshop.opened then
			local ped = LocalPed()
			local menu = vehshop.menu[vehshop.currentmenu]
			drawTxt(vehshop.title,1,1,vehshop.menu.x,vehshop.menu.y,1.0, 255,255,255,255)
			drawMenuTitle(menu.title, vehshop.menu.x,vehshop.menu.y + 0.08)
			drawTxt(vehshop.selectedbutton.."/"..tablelength(menu.buttons),0,0,vehshop.menu.x + vehshop.menu.width/2 - 0.0385,vehshop.menu.y + 0.067,0.4, 255,255,255,255)
			local y = vehshop.menu.y + 0.12
			buttoncount = tablelength(menu.buttons)
			local selected = false

			for i,button in pairs(menu.buttons) do
				if i >= vehshop.menu.from and i <= vehshop.menu.to then

					if i == vehshop.selectedbutton then
						selected = true
					else
						selected = false
					end
					drawMenuButton(button,vehshop.menu.x,y,selected)
					if button.costs ~= nil then
						if vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
							DoesPlayerHaveVehicle(button.model,button,y,selected)
						else
						drawMenuRight(button.costs.."$",vehshop.menu.x,y,selected)
						end
					end
					y = y + 0.04
					if vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
						if selected then
							if fakecar.model ~= button.model then
								if DoesEntityExist(fakecar.car) then
									Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
								end
								local pos = currentlocation.pos.inside
								local hash = GetHashKey(button.model)
								RequestModel(hash)
								while not HasModelLoaded(hash) do
									Citizen.Wait(0)
									drawTxt("~b~Loading...",0,1,0.5,0.5,1.5,255,255,255,255)

								end
								local veh = CreateVehicle(hash,pos[1],pos[2],pos[3],pos[4],false,false)
								while not DoesEntityExist(veh) do
									Citizen.Wait(0)
									drawTxt("~b~Loading...",0,1,0.5,0.5,1.5,255,255,255,255)
								end
								FreezeEntityPosition(veh,true)
								SetEntityInvincible(veh,true)
								SetVehicleDoorsLocked(veh,4)
								--SetEntityCollision(veh,false,false)
								TaskWarpPedIntoVehicle(LocalPed(),veh,-1)
								for i = 0,24 do
									SetVehicleModKit(veh,0)
									RemoveVehicleMod(veh,i)
								end
								fakecar = { model = button.model, car = veh}
							end
						end
					end
					if selected and IsControlJustPressed(1,51) then
						ButtonSelected(button)
					end
				end
			end
		end
		if vehshop.opened then
			if IsControlJustPressed(1,202) then
				Back()
			end
			if IsControlJustReleased(1,202) then
				backlock = false
			end
			if IsControlJustPressed(1,188) then
				if vehshop.selectedbutton > 1 then
					vehshop.selectedbutton = vehshop.selectedbutton -1
					if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
						vehshop.menu.from = vehshop.menu.from -1
						vehshop.menu.to = vehshop.menu.to - 1
					end
				end
			end
			if IsControlJustPressed(1,187)then
				if vehshop.selectedbutton < buttoncount then
					vehshop.selectedbutton = vehshop.selectedbutton +1
					if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
						vehshop.menu.to = vehshop.menu.to + 1
						vehshop.menu.from = vehshop.menu.from + 1
					end
				end
			end
		end

	end
end)

AddEventHandler('FinishMoneyCheckForVeh', function(name, vehicle, price)
	local name = name
	local vehicle = vehicle
	local price = price
	boughtcar = true
	CloseCreator(name, vehicle, price)
end)

AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	--326 car blip 227 225
	ShowVehshopBlips(true)
	firstspawn = 1
end
end)

AddEventHandler('vehshop:spawnVehicle', function(v)
	local car = GetHashKey(v)
	local playerPed = GetPlayerPed(-1)
	if playerPed and playerPed ~= -1 then
		RequestModel(car)
		while not HasModelLoaded(car) do
				Citizen.Wait(0)
		end
		local playerCoords = GetEntityCoords(playerPed)
		veh = CreateVehicle(car, playerCoords, 0.0, true, false)
		TaskWarpPedIntoVehicle(playerPed, veh, -1)
		SetEntityInvincible(veh, true)
	end
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		RemoveIpl('v_carshowroom')
		RemoveIpl('shutter_open')
		RemoveIpl('shutter_closed')
		RemoveIpl('shr_int')
		RemoveIpl('csr_inMission')
		RequestIpl('v_carshowroom')
		RequestIpl('shr_int')
		RequestIpl('shutter_closed')
		firstspawn = 1
	end
end)

function ShowInfo(text, state)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, state, 0, -1)
end