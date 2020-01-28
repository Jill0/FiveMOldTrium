--[[
Los Santos Customs V1.1 
Credits - MythicalBro
/////License/////
Do not reupload/re release any part of this script without my permission
]]
local colors = {
{name = "Noir", colorindex = 0},{name = "Noir Carbone", colorindex = 147},
{name = "Graphite", colorindex = 1},{name = "Noir Anhracite", colorindex = 11},
{name = "Acier noir", colorindex = 2},{name = "Acier Foncé", colorindex = 3},
{name = "Argent", colorindex = 4},{name = "Acier Bleuté", colorindex = 5},
{name = "Acier Laminé", colorindex = 6},{name = "Acier Ombre", colorindex = 7},
{name = "Pierre D'argent", colorindex = 8},{name = "Acier Nuit", colorindex = 9},
{name = "Cast Iron Silver", colorindex = 10},{name = "Rouge", colorindex = 27},
{name = "Rouge Torino", colorindex = 28},{name = "Formula rouge", colorindex = 29},
{name = "Rouge Lave", colorindex = 150},{name = "Rouge Flamber", colorindex = 30},
{name = "Rouge grâcieux", colorindex = 31},{name = "Rouge Garnet", colorindex = 32},
{name = "Couché de soleil", colorindex = 33},{name = "Rouge Cabernet", colorindex = 34},
{name = "Rouge Vin", colorindex = 143},{name = "Rose Bonbon", colorindex = 35},
{name = "Rose Vif", colorindex = 135},{name = "Rose Pfsiter", colorindex = 137},
{name = "Rose Saumon", colorindex = 136},{name = "Orange Lever De Soleil", colorindex = 36},
{name = "Orange", colorindex = 38},{name = "Orange Vif", colorindex = 138},
{name = "Or", colorindex = 99},{name = "Bronze", colorindex = 90},
{name = "Jaune", colorindex = 88},{name = "Jaune Course", colorindex = 89},
{name = "Jaune Rosée", colorindex = 91},{name = "Vert Foncé", colorindex = 49},
{name = "Vert Courses", colorindex = 50},{name = "Vert Mer", colorindex = 51},
{name = "Vert Olive", colorindex = 52},{name = "Vert Clair", colorindex = 53},
{name = "Vert Essence", colorindex = 54},{name = "Vert Lime", colorindex = 92},
{name = "Blue Nuit", colorindex = 141},
{name = "Blue Galaxie", colorindex = 61},{name = "Bleu Foncé", colorindex = 62},
{name = "Bleu Saxon", colorindex = 63},{name = "Bleu", colorindex = 64},
{name = "Bleu Marin", colorindex = 65},{name = "Bleu Port", colorindex = 66},
{name = "Bleu Diamant", colorindex = 67},{name = "Bleu Surf", colorindex = 68},
{name = "Bleu Nautique", colorindex = 69},{name = "Bleu Course", colorindex = 73},
{name = "Bleu Ultra", colorindex = 70},{name = "Bleu Clair", colorindex = 74},
{name = "Brun Chocolat", colorindex = 96},{name = "Brun Bison", colorindex = 101},
{name = "Brun", colorindex = 95},{name = "Brun Feltzer", colorindex = 94},
{name = "Brun Érable ", colorindex = 97},{name = "Brun Beechwood", colorindex = 103},
{name = "Brun Sienne", colorindex = 104},{name = "Brun Saddle", colorindex = 98},
{name = "Brun Mousse", colorindex = 100},{name = "Brun Woodbeech", colorindex = 102},
{name = "Brun Paille", colorindex = 99},{name = "Brun Sablonneux", colorindex = 105},
{name = "Brun Blanchi", colorindex = 106},{name = "Mauve Schafter", colorindex = 71},
{name = "Violet Spinnaker", colorindex = 72},{name = "Mauve Nuit", colorindex = 142},
{name = "Mauve Brillant", colorindex = 145},{name = "Crème", colorindex = 107},
{name = "Blanc Glace", colorindex = 111},{name = "Gel Blanc", colorindex = 112}}
local metalcolors = {
{name = "Acier Brossé",colorindex = 117},
{name = "Acier Noir Brossé",colorindex = 118},
{name = "Aluminium Brossé",colorindex = 119},
{name = "Or Pur",colorindex = 158},
{name = "Or Brossé",colorindex = 159}
}
local mattecolors = {
{name = "Noir", colorindex = 12},
{name = "Gris", colorindex = 13},
{name = "Gris Clair", colorindex = 14},
{name = "Blanc Glace", colorindex = 131},
{name = "Bleu", colorindex = 83},
{name = "Bleu Foncé", colorindex = 82},
{name = "Bleu Nuit", colorindex = 84},
{name = "Mauve Nuit", colorindex = 149},
{name = "Mauve Schafter", colorindex = 148},
{name = "Rouge", colorindex = 39},
{name = "Rouge Foncé", colorindex = 40},
{name = "Orange", colorindex = 41},
{name = "Jaune", colorindex = 42},
{name = "Vert Lime", colorindex = 55},
{name = "Vert", colorindex = 128},
{name = "Vert Givré", colorindex = 151},
{name = "Vert Feuillage", colorindex = 155},
{name = "Olive", colorindex = 152},
{name = "Terre Foncé", colorindex = 153},
{name = "Désert ", colorindex = 154}
}



LSC_Config = {}
LSC_Config.prices = {}

--------Prices---------
LSC_Config.prices = {

------Window tint------
	windowtint = {
		{ name = "Noir Pur", tint = 1, price = 1000},
		{ name = "Fumée Noir", tint = 2, price = 1000},
		{ name = "Fumée Clair", tint = 3, price = 1000},
		{ name = "Limo", tint = 4, price = 1000},
		{ name = "Green", tint = 5, price = 1000},
	},

-------Respray--------
----Primary color---
	--Chrome 
	chrome = {
		colors = {
			{name = "Chrome", colorindex = 120}
		},
		price = 1000
	},
	--Classic 
	classic = {
		colors = colors,
		price = 200
	},
	--Matte 
	matte = {
		colors = mattecolors,
		price = 500
	},
	--Metallic 
	metallic = {
		colors = colors,
		price = 300
	},
	--Metals 
	metal = {
		colors = metalcolors,
		price = 300
	},

----Secondary color---
	--Chrome 
	chrome2 = {
		colors = {
			{name = "Chrome", colorindex = 120}
		},
		price = 1000
	},
	--Classic 
	classic2 = {
		colors = colors,
		price = 200
	},
	--Matte 
	matte2 = {
		colors = mattecolors,
		price = 500
	},
	--Metallic 
	metallic2 = {
		colors = colors,
		price = 300
	},
	--Metals 
	metal2 = {
		colors = metalcolors,
		price = 300
	},

------Neon layout------
	neonlayout = {
		{name = "Avant, Arrière et Côtés", price = 5000},
	},
	--Neon color
	neoncolor = {
		{ name = "Blanc", neon = {255,255,255}, price = 1000},
		{ name = "Bleu", neon = {0,0,255}, price = 1000},
		{ name = "Bleu Électrique ", neon = {0,150,255}, price = 1000},
		{ name = "Vert Menthe", neon = {50,255,155}, price = 1000},
		{ name = "Vert Lime", neon = {0,255,0}, price = 1000},
		{ name = "Jaune", neon = {255,255,0}, price = 1000},
		{ name = "Or", neon = {204,204,0}, price = 1000},
		{ name = "Orange", neon = {255,128,0}, price = 1000},
		{ name = "Rouge", neon = {255,0,0}, price = 1000},
		{ name = "Rose", neon = {255,102,255}, price = 1000},
		{ name = "Rose Vif",neon = {255,0,255}, price = 1000},
		{ name = "Mauve", neon = {153,0,153}, price = 1000},
		{ name = "Brun", neon = {139,69,19}, price = 1000},
	},
	
--------Plates---------
	plates = {
		{ name = "Bleu Sur Blanc 1", plateindex = 0, price = 200},
		{ name = "Bleu Sur Blanc 2", plateindex = 3, price = 200},
		{ name = "Bleu Sur Blanc 3", plateindex = 4, price = 200},
		{ name = "Jaune Sur Bleu", plateindex = 2, price = 300},
		{ name = "Jaune Sur Noir", plateindex = 1, price = 600},
	},
	
--------Wheels--------
----Wheel accessories----
	wheelaccessories = {
		{ name = "Stock Tires", price = 1000},
		{ name = "Custom Tires", price = 1250},
		{ name = "Pneu Pare-Balles", price = 5000},
		{ name = "Fumée De Pneu Blanche",smokecolor = {254,254,254}, price = 3000},
		{ name = "Fumée De Pneu Noir", smokecolor = {1,1,1}, price = 3000},
		{ name = "Fumée De Pneu Bleu", smokecolor = {0,150,255}, price = 3000},
		{ name = "Fumée De Pneu Jaune", smokecolor = {255,255,50}, price = 3000},
		{ name = "Fumée De Pneu Orange", smokecolor = {255,153,51}, price = 3000},
		{ name = "Fumée De Pneu Rouge", smokecolor = {255,10,10}, price = 3000},
		{ name = "Fumée De Pneu Verte", smokecolor = {10,255,10}, price = 3000},
		{ name = "Fumée De Pneu Mauve", smokecolor = {153,10,153}, price = 3000},
		{ name = "Fumée De Pneu Rose", smokecolor = {255,102,178}, price = 3000},
		{ name = "Fumée De Pneu Grise",smokecolor = {128,128,128}, price = 3000},
	},

----Wheel color----
	wheelcolor = {
		colors = colors,
		price = 1000,
	},

----Front wheel (Bikes)----
	frontwheel = {
		{name = "Stock", wtype = 6, mod = -1, price = 1000},
		{name = "Speedway", wtype = 6, mod = 0, price = 1000},
		{name = "Streetspecial", wtype = 6, mod = 1, price = 1000},
		{name = "Racer", wtype = 6, mod = 2, price = 1000},
		{name = "Trackstar", wtype = 6, mod = 3, price = 1000},
		{name = "Overlord", wtype = 6, mod = 4, price = 1000},
		{name = "Trident", wtype = 6, mod = 5, price = 1000},
		{name = "Triplethreat", wtype = 6, mod = 6, price = 1000},
		{name = "Stilleto", wtype = 6, mod = 7, price = 1000},
		{name = "Wires", wtype = 6, mod = 8, price = 1000},
		{name = "Bobber", wtype = 6, mod = 9, price = 1000},
		{name = "Solidus", wtype = 6, mod = 10, price = 1000},
		{name = "Iceshield", wtype = 6, mod = 11, price = 1000},
		{name = "Loops", wtype = 6, mod = 12, price = 1000},
	},

----Back wheel (Bikes)-----
	backwheel = {
		{name = "Stock", wtype = 6, mod = -1, price = 1000},
		{name = "Speedway", wtype = 6, mod = 0, price = 1000},
		{name = "Streetspecial", wtype = 6, mod = 1, price = 1000},
		{name = "Racer", wtype = 6, mod = 2, price = 1000},
		{name = "Trackstar", wtype = 6, mod = 3, price = 1000},
		{name = "Overlord", wtype = 6, mod = 4, price = 1000},
		{name = "Trident", wtype = 6, mod = 5, price = 1000},
		{name = "Triplethreat", wtype = 6, mod = 6, price = 1000},
		{name = "Stilleto", wtype = 6, mod = 7, price = 1000},
		{name = "Wires", wtype = 6, mod = 8, price = 1000},
		{name = "Bobber", wtype = 6, mod = 9, price = 1000},
		{name = "Solidus", wtype = 6, mod = 10, price = 1000},
		{name = "Iceshield", wtype = 6, mod = 11, price = 1000},
		{name = "Loops", wtype = 6, mod = 12, price = 1000},
	},

----Sport wheels-----
	sportwheels = {
		{name = "Stock", wtype = 0, mod = -1, price = 1000},
		{name = "Inferno", wtype = 0, mod = 0, price = 1000},
		{name = "Deepfive", wtype = 0, mod = 1, price = 1000},
		{name = "Lozspeed", wtype = 0, mod = 2, price = 1000},
		{name = "Diamondcut", wtype = 0, mod = 3, price = 1000},
		{name = "Chrono", wtype = 0, mod = 4, price = 1000},
		{name = "Feroccirr", wtype = 0, mod = 5, price = 1000},
		{name = "Fiftynine", wtype = 0, mod = 6, price = 1000},
		{name = "Mercie", wtype = 0, mod = 7, price = 1000},
		{name = "Syntheticz", wtype = 0, mod = 8, price = 1000},
		{name = "Organictyped", wtype = 0, mod = 9, price = 1000},
		{name = "Endov1", wtype = 0, mod = 10, price = 1000},
		{name = "Duper7", wtype = 0, mod = 11, price = 1000},
		{name = "Uzer", wtype = 0, mod = 12, price = 1000},
		{name = "Groundride", wtype = 0, mod = 13, price = 1000},
		{name = "Spacer", wtype = 0, mod = 14, price = 1000},
		{name = "Venum", wtype = 0, mod = 15, price = 1000},
		{name = "Cosmo", wtype = 0, mod = 16, price = 1000},
		{name = "Dashvip", wtype = 0, mod = 17, price = 1000},
		{name = "Icekid", wtype = 0, mod = 18, price = 1000},
		{name = "Ruffeld", wtype = 0, mod = 19, price = 1000},
		{name = "Wangenmaster", wtype = 0, mod = 20, price = 1000},
		{name = "Superfive", wtype = 0, mod = 21, price = 1000},
		{name = "Endov2", wtype = 0, mod = 22, price = 1000},
		{name = "Slitsix", wtype = 0, mod = 23, price = 1000},
	},
-----Suv wheels------
	suvwheels = {
		{name = "Stock", wtype = 3, mod = -1, price = 1000},
		{name = "Vip", wtype = 3, mod = 0, price = 1000},
		{name = "Benefactor", wtype = 3, mod = 1, price = 1000},
		{name = "Cosmo", wtype = 3, mod = 2, price = 1000},
		{name = "Bippu", wtype = 3, mod = 3, price = 1000},
		{name = "Royalsix", wtype = 3, mod = 4, price = 1000},
		{name = "Fagorme", wtype = 3, mod = 5, price = 1000},
		{name = "Deluxe", wtype = 3, mod = 6, price = 1000},
		{name = "Icedout", wtype = 3, mod = 7, price = 1000},
		{name = "Cognscenti", wtype = 3, mod = 8, price = 1000},
		{name = "Lozspeedten", wtype = 3, mod = 9, price = 1000},
		{name = "Supernova", wtype = 3, mod = 10, price = 1000},
		{name = "Obeyrs", wtype = 3, mod = 11, price = 1000},
		{name = "Lozspeedballer", wtype = 3, mod = 12, price = 1000},
		{name = "Extra vaganzo", wtype = 3, mod = 13, price = 1000},
		{name = "Splitsix", wtype = 3, mod = 14, price = 1000},
		{name = "Empowered", wtype = 3, mod = 15, price = 1000},
		{name = "Sunrise", wtype = 3, mod = 16, price = 1000},
		{name = "Dashvip", wtype = 3, mod = 17, price = 1000},
		{name = "Cutter", wtype = 3, mod = 18, price = 1000},
	},
-----Offroad wheels-----
	offroadwheels = {
		{name = "Stock", wtype = 4, mod = -1, price = 1000},
		{name = "Raider", wtype = 4, mod = 0, price = 1000},
		{name = "Mudslinger", wtype = 4, modtype = 23, wtype = 4, mod = 1, price = 1000},
		{name = "Nevis", wtype = 4, mod = 2, price = 1000},
		{name = "Cairngorm", wtype = 4, mod = 3, price = 1000},
		{name = "Amazon", wtype = 4, mod = 4, price = 1000},
		{name = "Challenger", wtype = 4, mod = 5, price = 1000},
		{name = "Dunebasher", wtype = 4, mod = 6, price = 1000},
		{name = "Fivestar", wtype = 4, mod = 7, price = 1000},
		{name = "Rockcrawler", wtype = 4, mod = 8, price = 1000},
		{name = "Milspecsteelie", wtype = 4, mod = 9, price = 1000},
	},
-----Tuner wheels------
	tunerwheels = {
		{name = "Stock", wtype = 5, mod = -1, price = 1000},
		{name = "Cosmo", wtype = 5, mod = 0, price = 1000},
		{name = "Supermesh", wtype = 5, mod = 1, price = 1000},
		{name = "Outsider", wtype = 5, mod = 2, price = 1000},
		{name = "Rollas", wtype = 5, mod = 3, price = 1000},
		{name = "Driffmeister", wtype = 5, mod = 4, price = 1000},
		{name = "Slicer", wtype = 5, mod = 5, price = 1000},
		{name = "Elquatro", wtype = 5, mod = 6, price = 1000},
		{name = "Dubbed", wtype = 5, mod = 7, price = 1000},
		{name = "Fivestar", wtype = 5, mod = 8, price = 1000},
		{name = "Slideways", wtype = 5, mod = 9, price = 1000},
		{name = "Apex", wtype = 5, mod = 10, price = 1000},
		{name = "Stancedeg", wtype = 5, mod = 11, price = 1000},
		{name = "Countersteer", wtype = 5, mod = 12, price = 1000},
		{name = "Endov1", wtype = 5, mod = 13, price = 1000},
		{name = "Endov2dish", wtype = 5, mod = 14, price = 1000},
		{name = "Guppez", wtype = 5, mod = 15, price = 1000},
		{name = "Chokadori", wtype = 5, mod = 16, price = 1000},
		{name = "Chicane", wtype = 5, mod = 17, price = 1000},
		{name = "Saisoku", wtype = 5, mod = 18, price = 1000},
		{name = "Dishedeight", wtype = 5, mod = 19, price = 1000},
		{name = "Fujiwara", wtype = 5, mod = 20, price = 1000},
		{name = "Zokusha", wtype = 5, mod = 21, price = 1000},
		{name = "Battlevill", wtype = 5, mod = 22, price = 1000},
		{name = "Rallymaster", wtype = 5, mod = 23, price = 1000},
	},
-----Highend wheels------
	highendwheels = {
		{name = "Stock", wtype = 7, mod = -1, price = 1000},
		{name = "Shadow", wtype = 7, mod = 0, price = 1000},
		{name = "Hyper", wtype = 7, mod = 1, price = 1000},
		{name = "Blade", wtype = 7, mod = 2, price = 1000},
		{name = "Diamond", wtype = 7, mod = 3, price = 1000},
		{name = "Supagee", wtype = 7, mod = 4, price = 1000},
		{name = "Chromaticz", wtype = 7, mod = 5, price = 1000},
		{name = "Merciechlip", wtype = 7, mod = 6, price = 1000},
		{name = "Obeyrs", wtype = 7, mod = 7, price = 1000},
		{name = "Gtchrome", wtype = 7, mod = 8, price = 1000},
		{name = "Cheetahr", wtype = 7, mod = 9, price = 1000},
		{name = "Solar", wtype = 7, mod = 10, price = 1000},
		{name = "Splitten", wtype = 7, mod = 11, price = 1000},
		{name = "Dashvip", wtype = 7, mod = 12, price = 1000},
		{name = "Lozspeedten", wtype = 7, mod = 13, price = 1000},
		{name = "Carboninferno", wtype = 7, mod = 14, price = 1000},
		{name = "Carbonshadow", wtype = 7, mod = 15, price = 1000},
		{name = "Carbonz", wtype = 7, mod = 16, price = 1000},
		{name = "Carbonsolar", wtype = 7, mod = 17, price = 1000},
		{name = "Carboncheetahr", wtype = 7, mod = 18, price = 1000},
		{name = "Carbonsracer", wtype = 7, mod = 19, price = 1000},
	},
-----Lowrider wheels------
	lowriderwheels = {
		{name = "Stock", wtype = 2, mod = -1, price = 1000},
		{name = "Flare", wtype = 2, mod = 0, price = 1000},
		{name = "Wired", wtype = 2, mod = 1, price = 1000},
		{name = "Triplegolds", wtype = 2, mod = 2, price = 1000},
		{name = "Bigworm", wtype = 2, mod = 3, price = 1000},
		{name = "Sevenfives", wtype = 2, mod = 4, price = 1000},
		{name = "Splitsix", wtype = 2, mod = 5, price = 1000},
		{name = "Freshmesh", wtype = 2, mod = 6, price = 1000},
		{name = "Leadsled", wtype = 2, mod = 7, price = 1000},
		{name = "Turbine", wtype = 2, mod = 8, price = 1000},
		{name = "Superfin", wtype = 2, mod = 9, price = 1000},
		{name = "Classicrod", wtype = 2, mod = 10, price = 1000},
		{name = "Dollar", wtype = 2, mod = 11, price = 1000},
		{name = "Dukes", wtype = 2, mod = 12, price = 1000},
		{name = "Lowfive", wtype = 2, mod = 13, price = 1000},
		{name = "Gooch", wtype = 2, mod = 14, price = 1000},
	},
-----Muscle wheels-----
	musclewheels = {
		{name = "Stock", wtype = 1, mod = -1, price = 1000},
		{name = "Classicfive", wtype = 1, mod = 0, price = 1000},
		{name = "Dukes", wtype = 1, mod = 1, price = 1000},
		{name = "Musclefreak", wtype = 1, mod = 2, price = 1000},
		{name = "Kracka", wtype = 1, mod = 3, price = 1000},
		{name = "Azrea", wtype = 1, mod = 4, price = 1000},
		{name = "Mecha", wtype = 1, mod = 5, price = 1000},
		{name = "Blacktop", wtype = 1, mod = 6, price = 1000},
		{name = "Dragspl", wtype = 1, mod = 7, price = 1000},
		{name = "Revolver", wtype = 1, mod = 8, price = 1000},
		{name = "Classicrod", wtype = 1, mod = 9, price = 1000},
		{name = "Spooner", wtype = 1, mod = 10, price = 1000},
		{name = "Fivestar", wtype = 1, mod = 11, price = 1000},
		{name = "Oldschool", wtype = 1, mod = 12, price = 1000},
		{name = "Eljefe", wtype = 1, mod = 13, price = 1000},
		{name = "Dodman", wtype = 1, mod = 14, price = 1000},
		{name = "Sixgun", wtype = 1, mod = 15, price = 1000},
		{name = "Mercenary", wtype = 1, mod = 16, price = 1000},
	},
	
---------Trim color--------
	trim = {
		colors = colors,
		price = 1000
	},
	
----------Mods-----------
	mods = {
	
----------Liveries--------
	[48] = {
		startprice = 15000,
		increaseby = 2500
	},
	
----------Windows--------
	[46] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Tank--------
	[45] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Trim--------
	[44] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Aerials--------
	[43] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Arch cover--------
	[42] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Struts--------
	[41] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Air filter--------
	[40] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Engine block--------
	[39] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Hydraulics--------
	[38] = {
		startprice = 15000,
		increaseby = 2500
	},
	
----------Trunk--------
	[37] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Speakers--------
	[36] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Plaques--------
	[35] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Shift leavers--------
	[34] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Steeringwheel--------
	[33] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Seats--------
	[32] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Door speaker--------
	[31] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Dial--------
	[30] = {
		startprice = 5000,
		increaseby = 1250
	},
----------Dashboard--------
	[29] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Ornaments--------
	[28] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Trim--------
	[27] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Vanity plates--------
	[26] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Plate holder--------
	[25] = {
		startprice = 5000,
		increaseby = 1250
	},
	
---------Headlights---------
	[22] = {
		{name = "Phares d'origines", mod = 0, price = 0},
		{name = "Phares Xénons", mod = 1, price = 1625},
	},
	
----------Turbo---------
	[18] = {
		{ name = "None", mod = 0, price = 0},
		{ name = "Turbo", mod = 1, price = 15000},
	},
	
-----------Armor-------------
	[16] = {
		{name = "Armure 20%",modtype = 16, mod = 0, price = 2500},
		{name = "Armure 40%",modtype = 16, mod = 1, price = 5000},
		--{name = "Armure 60%",modtype = 16, mod = 2, price = 7500},
		--{name = "Armure 80%",modtype = 16, mod = 3, price = 10000},
		--{name = "Armure 100%",modtype = 16, mod = 4, price = 12500},
	},

---------Suspension-----------
	[15] = {
		{name = "Suspension Abaissé",mod = 0, price = 1000},
		{name = "Suspension de Rue",mod = 1, price = 2000},
		{name = "Suspension de Sport",mod = 2, price = 3500},
		{name = "Suspension de Compétition",mod = 3, price = 4000},
	},

-----------Horn----------
	[14] = {
		{name = "Klaxon de Camion", mod = 0, price = 1625},
		{name = "Klaxon de Police", mod = 1, price = 4062},
		{name = "Klaxon de Clown", mod = 2, price = 6500},
		{name = "Klaxon Musical 1", mod = 3, price = 11375},
		{name = "Klaxon Musical 2", mod = 4, price = 11375},
		{name = "Klaxon Musical 3", mod = 5, price = 11375},
		{name = "Klaxon Musical 4", mod = 6, price = 11375},
		{name = "Klaxon Musical 5", mod = 7, price = 11375},
		{name = "Klaxon Sadtrombone", mod = 8, price = 11375},
		{name = "Klaxon Classique 1", mod = 9, price = 11375},
		{name = "Klaxon Classique 2", mod = 10, price = 11375},
		{name = "Klaxon Classique 3", mod = 11, price = 11375},
		{name = "Klaxon Classique 4", mod = 12, price = 11375},
		{name = "Klaxon Classique 5", mod = 13, price = 11375},
		{name = "Klaxon Classique 6", mod = 14, price = 11375},
		{name = "Klaxon Classique 7", mod = 15, price = 11375},
		{name = "Klaxon Scaledo", mod = 16, price = 11375},
		{name = "Klaxon Scalere", mod = 17, price = 11375},
		{name = "Klaxon Scalemi", mod = 18, price = 11375},
		{name = "Klaxon Scalefa", mod = 19, price = 11375},
		{name = "Klaxon Scalesol", mod = 20, price = 11375},
		{name = "Klaxon Scalela", mod = 21, price = 11375},
		{name = "Klaxon Scaleti", mod = 22, price = 11375},
		{name = "Klaxon Scaledo High", mod = 23, price = 11375},
		{name = "Klaxon Jazz 1", mod = 25, price = 11375},
		{name = "Klaxon Jazz 2", mod = 26, price = 11375},
		{name = "Klaxon Jazz 3", mod = 27, price = 11375},
		{name = "Klaxon Jazzloop", mod = 28, price = 11375},
		{name = "Klaxon Starspangban 1", mod = 29, price = 11375},
		{name = "Klaxon Starspangban 2", mod = 30, price = 11375},
		{name = "Klaxon Starspangban 3", mod = 31, price = 11375},
		{name = "Klaxon Starspangban 4", mod = 32, price = 11375},
		{name = "Klaxon Classicalloop 1", mod = 33, price = 11375},
		{name = "Klaxon Classicalloop 2", mod = 34, price = 11375},
		{name = "Klaxon Classicalloop 3", mod = 35, price = 11375},
	},

----------Transmission---------
	[13] = {
		{name = "Transmission de Rue", mod = 0, price = 10000},
		{name = "Transmission de Sport", mod = 1, price = 12500},
		{name = "Transmission de Course", mod = 2, price = 15000},
	},
	
-----------Brakes-------------
	[12] = {
		{name = "Freins de Rue", mod = 0, price = 6500},
		{name = "Freins de Sport", mod = 1, price = 8775},
		{name = "Freins de Course", mod = 2, price = 11375},
	},
	
------------Engine----------
	[11] = {
		{name = "Reprog. Moteur, Niveau 2", mod = 0, price = 4500},
		{name = "Reprog. Moteur, Niveau 3", mod = 1, price = 8000},
		{name = "Reprog. Moteur, Niveau 4", mod = 2, price = 10500},
	},
	
-------------Roof----------
	[10] = {
		startprice = 1250,
		increaseby = 400
	},
	
------------Fenders---------
	[8] = {
		startprice = 1500,
		increaseby = 400
	},
	
------------Hood----------
	[7] = {
		startprice = 1500,
		increaseby = 400
	},
	
----------Grille----------
	[6] = {
		startprice = 1250,
		increaseby = 400
	},
	
----------Roll cage----------
	[5] = {
		startprice = 1250,
		increaseby = 400
	},
	
----------Exhaust----------
	[4] = {
		startprice = 1000,
		increaseby = 400
	},
	
----------Skirts----------
	[3] = {
		startprice = 1250,
		increaseby = 400
	},
	
-----------Rear bumpers----------
	[2] = {
		startprice = 2500,
		increaseby = 500
	},
	
----------Front bumpers----------
	[1] = {
		startprice = 2500,
		increaseby = 500
	},
	
----------Spoiler----------
	[0] = {
		startprice = 2500,
		increaseby = 400
	},
	}
	
}

------Model Blacklist--------
--Does'nt allow specific vehicles to be upgraded
LSC_Config.ModelBlacklist = {
	"police",
}

--Sets if garage will be locked if someone is inside it already
LSC_Config.lock = false

--Enable/disable old entering way
LSC_Config.oldenter = false

--Menu settings
LSC_Config.menu = {

-------Controls--------
	controls = {
		menu_up = 27,
		menu_down = 173,
		menu_left = 174,
		menu_right = 175,
		menu_select = 201,
		menu_back = 177
	},

-------Menu position-----
	--Possible positions:
	--Left
	--Right
	--Custom position, example: position = {x = 0.2, y = 0.2}
	position = "left",

-------Menu theme--------
	--Possible themes: light, darkred, bluish, greenish
	--Custom example:
	--[[theme = {
		text_color = { r = 255,g = 255, b = 255, a = 255},
		bg_color = { r = 0,g = 0, b = 0, a = 155},
		--Colors when button is selected
		stext_color = { r = 0,g = 0, b = 0, a = 255},
		sbg_color = { r = 255,g = 255, b = 0, a = 200},
	},]]
	theme = "light",
	
--------Max buttons------
	--Default: 10
	maxbuttons = 10,

-------Size---------
	--[[
	Default:
	width = 0.24
	height = 0.36
	]]
	width = 0.24,
	height = 0.36

}
