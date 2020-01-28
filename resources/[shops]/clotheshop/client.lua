
local options = {
    x = 0.15,
    y = 0.15,
    width = 0.25,
    height = 0.035,
    scale = 0.2,
    font = 0,
    menu_title = "Magasin de vêtements",
    menu_subtitle = "Categories",
    color_r = 50,
    color_g = 0,
    color_b = 10
}

local Categories = {
    {['id'] = 3, ['name'] = "Gants et Corps"},
	{['id'] = 4, ['name'] = "Bas"},
    {['id'] = 6, ['name'] = "Pieds"},
    {['id'] = 7, ['name'] = "Cou"},
    {['id'] = 8, ['name'] = "Dessous"},
    {['id'] = 11, ['name'] = "Hauts"}
	--{['id'] = 5, ['name'] = "Parachutes, sacs"},
	--{['id'] = 10, ['name'] = "Stickers"}
}

local emplacement = {
    {name="Magasin de vêtements", id=73, x=1691.0, y=4828.21, z=42.06},
    {name="Magasin de vêtements", id=73, x=122.478, y=-211.57, z=54.55},
    {name="Magasin de vêtements", id=73, x=-710.16, y=-153.26, z=37.41},
    {name="Magasin de vêtements", id=73, x=-826.906, y=-1078.45, z=11.33},
    {name="Magasin de vêtements", id=73, x=-1197.32, y=-779.681, z=17.33},
    {name="Magasin de vêtements", id=73, x=7.98274, y=6517.87, z=31.88},
    {name="Magasin de vêtements", id=73, x=423.592, y=-799.904, z=29.50},
    {name="Magasin de vêtements", id=73, x=1190.44, y=2708.27, z=38.23}
}

local AllClothes = {}
local MyClothes = {}
local MyModels = {}
local inclothemenu = {}
local inmodelsmenu = {}
local MyModelsOk = false
local AllClothesOk = false
local MyClothesOk = false
local MyModelMenu = {}

RegisterNetEvent("clotheshop:giveListOfClothes")
AddEventHandler("clotheshop:giveListOfClothes", function(allcloth)
    AllClothes = allcloth
    AllClothesOk = true
end)

RegisterNetEvent("clotheshop:giveListOfMyClothes")
AddEventHandler("clotheshop:giveListOfMyClothes", function(mycloth)
    MyClothes = mycloth
    MyClothesOk = true
end)

RegisterNetEvent("clotheshop:giveListOfMyModels")
AddEventHandler("clotheshop:giveListOfMyModels", function(mymods)
    MyModels = mymods
    MyModelsOk = true
end)

------------------------------------------------------------
-------------------------- Spawn ---------------------------
------------------------------------------------------------
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("clotheshop:getModelMenu")
end)

RegisterNetEvent("clotheshop:giveModelMenu")
AddEventHandler("clotheshop:giveModelMenu", function(modelmenu)
    MyModelMenu = modelmenu
    clothesSelector(modelmenu)
end)

RegisterNetEvent("clotheshop:spawnafterjob")
AddEventHandler("clotheshop:spawnafterjob", function()
    clothesSelector(MyModelMenu, true)
end)
------------------------------------------------------------
------------------------------------------------------------

------------------------------------------------------------
---------------------- Menu principal ----------------------
------------------------------------------------------------
local principal = "Main"
function Main()
	inclothemenu = {}
    inmodelsmenu = {}
    options.menu_title = "Magasin de vêtements"
    options.menu_subtitle = "Accueil"
    ClearMenu()
    clothesSelector(MyModelMenu)
    Menu.selection = 1
    Menu.addButton("Acheter des vêtements", "BuyClothesCategories", nil)
    Menu.addButton("Composer/Editer une tenue", "MakeModelvestiaire", nil)
    Menu.addButton("Choisir une tenue", "ChangeModelVestiaire", nil)
    principal = "Main"
end

RegisterNetEvent("clotheshop:menuAppart")
AddEventHandler("clotheshop:menuAppart", function()
    if Menu.hidden == true then
        MainAppart()
        Menu.hidden = false
        FreezeEntityPosition(GetPlayerPed(-1), true)
    else
        closeGui()
    end
end)

function MainAppart()
	inclothemenu = {}
    inmodelsmenu = {}
    options.menu_title = "Mes vêtements"
    options.menu_subtitle = "Accueil"
    ClearMenu()
    clothesSelector(MyModelMenu)
    Menu.selection = 1
    Menu.addButton("Composer/Editer une tenue", "MakeModelvestiaire", nil)
    Menu.addButton("Choisir une tenue", "ChangeModelVestiaire", nil)
    principal = "MainAppart"
end
------------------------------------------------------------
------------------------------------------------------------

------------------------------------------------------------
---------------------- Achat vêtements ---------------------
------------------------------------------------------------
function BuyClothesCategories()
	inclothemenu = {}
    inmodelsmenu = {}
    options.menu_subtitle = "Acheter des vêtements"
    ClearMenu()
    clothesSelector(MyModelMenu)
    Menu.selection = 1
    Menu.previous = "Main"
    for i,c in pairs(Categories) do
        local name = Categories[Menu.buttonCount+1].name
        Menu.addButton(name, "BuyClothesDrawable", {Categories[Menu.buttonCount+1].id, name})
    end
end

function BuyClothesDrawable(args, selec)
    if not AllClothesOk then
        TriggerServerEvent("clotheshop:getListOfClothes")
    end
    if not MyClothesOk then
        TriggerServerEvent("clotheshop:getListOfMyClothes")
    end
    inmodelsmenu = {}
    inclothemenu = {}
	options.menu_subtitle = "Acheter des vêtements"
    ClearMenu()
    Menu.previous = "BuyClothesCategories"
    while not AllClothesOk do
        Wait(10)
    end
    while not MyClothesOk do
        Wait(10)
    end
    for k, v in pairs(AllClothes) do
        if v.categorie == args[1] and GetHashKey(v.model) == GetEntityModel(GetPlayerPed(-1)) then
            for i, c in pairs(MyClothes) do
                if v.categorie == c.categorie and v.prop_id == c.prop_id and v.prop_txt == c.prop_txt then
                    v.price = "~g~Acheté"
                end
            end
            if v.price == "~g~Acheté" then
                Menu.addButton(args[2] .. " n°" .. k .. "      " .. v.price, "DejaNotif", nil)
            else
        	   Menu.addButton(args[2] .. " n°" .. k .. "      ~r~" .. v.price .."$", "BuyClothe", v)
            end
            table.insert(inclothemenu, {['component_id']=v.categorie, ['prop_id']=v.prop_id, ['prop_txt']=v.prop_txt})
        end
    end
    if selec then
        Menu.selection = selec[1]
        curplagemin = selec[2]
        curplagemax = selec[3]
    else
        Menu.selection = 1
    end
end

function BuyClothe(item)
    TriggerServerEvent("clotheshop:buyclothe", item)
end

function DejaNotif()
    Notif("~r~Vous avez déjà cet article")
end

RegisterNetEvent("clotheshop:buyclotheaccepted")
AddEventHandler('clotheshop:buyclotheaccepted', function(item)
    --Accepté
    table.insert(MyClothes, item)
    local catname = ""
    for k, v in pairs(Categories) do
        if v.id == item.categorie then
            catname = v.name
        end
    end
    local args = {item.categorie, catname}
    local selec = {Menu.selection, curplagemin, curplagemax}
    BuyClothesDrawable(args, selec)
end)
------------------------------------------------------------
------------------------------------------------------------

------------------------------------------------------------
------------------- Composer une tenue ---------------------
------------------------------------------------------------
function MakeModelvestiaire()
    inclothemenu = {}
    inmodelsmenu = {}
    options.menu_subtitle = "Composer/Editer une tenue"
    ClearMenu()
    clothesSelector(MyModelMenu)
    Menu.selection = 1
    Menu.previous = principal
    Menu.addButton("Nouvelle tenue", "NewClothes", nil)
    Menu.addButton("Supprimer une tenue", "DeleteClothes", nil)
end

function NewClothes()
    inclothemenu = {}
    inmodelsmenu = {}
    options.menu_subtitle = "Nouvelle tenue"
    ClearMenu()
    clothesSelector(MyModelMenu)
    Menu.selection = 1
    Menu.previous = "MakeModelvestiaire"
    for i,c in pairs(Categories) do
        local name = Categories[Menu.buttonCount+1].name
        Menu.addButton(name, "NewClothesDrawable", {Categories[Menu.buttonCount+1].id, name})
    end
    Menu.addButton("~g~Enregistrer cette tenue", "SaveModel", nil)
end

function NewClothesDrawable(args, selec)
    if not MyClothesOk then
        TriggerServerEvent("clotheshop:getListOfMyClothes")
    end
    if not AllClothesOk then
        TriggerServerEvent("clotheshop:getListOfClothes")
    end
    inclothemenu = {}
    inmodelsmenu = {}
    options.menu_subtitle = "Nouvelle tenue - " .. args[2]
    ClearMenu()
    Menu.previous = "NewClothes"
    while not MyClothesOk do
        Wait(10)
    end
    while not AllClothesOk do
        Wait(10)
    end
    local etat2 = ""
    if args[1] == 6 then
        if MyModelMenu.shoe == 34 and MyModelMenu.shoe_txt == 0 then
            etat2 = "    ~g~Installé"
        end
        Menu.addButton("~r~Aucun"..etat2, "AddClothe", {{['categorie'] = args[1], ['prop_id'] = 34, ['prop_txt'] = 0}, args})
        table.insert(inclothemenu, {['component_id']=args[1], ['prop_id']=34, ['prop_txt']=0})
    elseif args[1] == 7 then
        if MyModelMenu.pend == 0 and MyModelMenu.pend_txt == 0 then
            etat2 = "    ~g~Installé"
        end
        Menu.addButton("~r~Aucun"..etat2, "AddClothe", {{['categorie'] = args[1], ['prop_id'] = 0, ['prop_txt'] = 0}, args})
        table.insert(inclothemenu, {['component_id']=args[1], ['prop_id']=0, ['prop_txt']=0})
    elseif args[1] == 8 then
        if MyModelMenu.undershirt == 15 and MyModelMenu.undershirt_txt == 0 then
            etat2 = "    ~g~Installé"
        end
        Menu.addButton("~r~Aucun"..etat2, "AddClothe", {{['categorie'] = args[1], ['prop_id'] = 15, ['prop_txt'] = 0}, args})
        table.insert(inclothemenu, {['component_id']=args[1], ['prop_id']=15, ['prop_txt']=0})
    elseif args[1] == 11 then
        if MyModelMenu.shirt == 15 and MyModelMenu.shirt_txt == 0 then
            etat2 = "    ~g~Installé"
        end
        Menu.addButton("~r~Aucun"..etat2, "AddClothe", {{['categorie'] = args[1], ['prop_id'] = 15, ['prop_txt'] = 0}, args})
        table.insert(inclothemenu, {['component_id']=args[1], ['prop_id']=15, ['prop_txt']=0})
    end
    for k, v in pairs(AllClothes) do
        if args[1] == v.categorie and (GetHashKey(v.model) == GetEntityModel(GetPlayerPed(-1)) or v.model == nil) then
            for i, c in pairs(MyClothes) do
                if v.categorie == c.categorie and v.prop_id == c.prop_id and v.prop_txt == c.prop_txt then
                    local etat = ""
                    if c.categorie == 3 then
                        if c.prop_id == MyModelMenu.hand and c.prop_txt == MyModelMenu.hand_txt then
                            etat = "    ~g~Installé"
                        end
                    elseif c.categorie == 4 then
                        if c.prop_id == MyModelMenu.pants and c.prop_txt == MyModelMenu.pants_txt then
                            etat = "    ~g~Installé"
                        end
                    elseif c.categorie == 6 then
                        if c.prop_id == MyModelMenu.shoe and c.prop_txt == MyModelMenu.shoe_txt then
                            etat = "    ~g~Installé"
                        end
                    elseif c.categorie == 7 then
                        if c.prop_id == MyModelMenu.pend and c.prop_txt == MyModelMenu.pend_txt then
                            etat = "    ~g~Installé"
                        end
                    elseif c.categorie == 8 then
                        if c.prop_id == MyModelMenu.undershirt and c.prop_txt == MyModelMenu.undershirt_txt then
                            etat = "    ~g~Installé"
                        end
                    elseif c.categorie == 11 then
                        if c.prop_id == MyModelMenu.shirt and c.prop_txt == MyModelMenu.shirt_txt then
                            etat = "    ~g~Installé"
                        end
                    end
                    Menu.addButton(args[2] .. " n°" .. k .. etat, "AddClothe", {c, args})
                    table.insert(inclothemenu, {['component_id']=v.categorie, ['prop_id']=v.prop_id, ['prop_txt']=v.prop_txt})
                end
            end
        end
    end
    if selec then
        Menu.selection = selec[1]
        curplagemin = selec[2]
        curplagemax = selec[3]
    else
        Menu.selection = 1
    end
end

function AddClothe(args)
    if args[1].categorie == 3 then
        MyModelMenu.hand = args[1].prop_id
        MyModelMenu.hand_txt = args[1].prop_txt
    elseif args[1].categorie == 4 then
        MyModelMenu.pants = args[1].prop_id
        MyModelMenu.pants_txt = args[1].prop_txt
    elseif args[1].categorie == 6 then
        MyModelMenu.shoe = args[1].prop_id
        MyModelMenu.shoe_txt = args[1].prop_txt
    elseif args[1].categorie == 7 then
        MyModelMenu.pend = args[1].prop_id
        MyModelMenu.pend_txt = args[1].prop_txt
    elseif args[1].categorie == 8 then
        MyModelMenu.undershirt = args[1].prop_id
        MyModelMenu.undershirt_txt = args[1].prop_txt
    elseif args[1].categorie == 11 then
        MyModelMenu.shirt = args[1].prop_id
        MyModelMenu.shirt_txt = args[1].prop_txt
    end
    TriggerServerEvent("clotheshop:changeModel", MyModelMenu)
    NewClothesDrawable(args[2], {Menu.selection, curplagemin, curplagemax})
end

function SaveModel()
    local res = ""
    AddTextEntry('FMMC_KEY_TIP1', "Nom de la tenue :    (non enregistré si vide)")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 20)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(1)
    end
    res = GetOnscreenKeyboardResult()
    if res ~= "" then
        TriggerServerEvent("clotheshop:AddTenue", res, MyModelMenu)
        local MyTenueToInsert = {}
        MyTenueToInsert.hand = MyModelMenu.hand
        MyTenueToInsert.hand_txt = MyModelMenu.hand_txt
        MyTenueToInsert.pants = MyModelMenu.pants
        MyTenueToInsert.pants_txt = MyModelMenu.pants_txt
        MyTenueToInsert.shoe = MyModelMenu.shoe
        MyTenueToInsert.shoe_txt = MyModelMenu.shoe_txt
        MyTenueToInsert.pend = MyModelMenu.pend
        MyTenueToInsert.pend_txt = MyModelMenu.pend_txt
        MyTenueToInsert.undershirt = MyModelMenu.undershirt
        MyTenueToInsert.undershirt_txt = MyModelMenu.undershirt_txt
        MyTenueToInsert.shirt = MyModelMenu.shirt
        MyTenueToInsert.shirt_txt = MyModelMenu.shirt_txt
        MyTenueToInsert.model = res
        table.insert(MyModels, MyTenueToInsert)
    end
end

function DeleteClothes()
    if not MyModelsOk then
        TriggerServerEvent("clotheshop:getListOfMyModels")
    end
    inmodelsmenu = {}
    inmodelmenu = {}
    options.menu_subtitle = "Supprimer une tenue"
    ClearMenu()
    Menu.selection = 1
    Menu.previous = "MakeModelvestiaire"
    while not MyModelsOk do
        Wait(10)
    end
    for k, v in pairs(MyModels) do
        local etat = ""
        if v.hand == MyModelMenu.hand and v.hand_txt == MyModelMenu.hand_txt and v.pants == MyModelMenu.pants and v.pants_txt == MyModelMenu.pants_txt and v.shoe == MyModelMenu.shoe and v.shoe_txt == MyModelMenu.shoe_txt and v.pend == MyModelMenu.pend and v.pend_txt == MyModelMenu.pend_txt and v.undershirt == MyModelMenu.undershirt and v.undershirt_txt == MyModelMenu.undershirt_txt and v.shirt == MyModelMenu.shirt and v.shirt_txt == MyModelMenu.shirt_txt then
            etat = "    ~g~Installé"
        end
        Menu.addButton(v.model..etat, "ConfirmDeleteModel", v)
        table.insert(inmodelsmenu, v)
    end
end

function ConfirmDeleteModel(tenue)
    inmodelsmenu = {}
    inmodelmenu = {}
    options.menu_subtitle = "Supprimer cette tenue ?"
    ClearMenu()
    Menu.selection = 1
    Menu.previous = "DeleteClothes"
    Menu.addButton("Supprimer la tenue \"" .. tenue.model .. "\" ?", nil)
    Menu.addButton("Oui", "delmodel", tenue)
    Menu.addButton("Non", "DeleteClothes", nil)
end

function delmodel(tenue)
    TriggerServerEvent("clotheshop:delmodel", tenue)
    for k, v in pairs(MyModels) do
        if v == tenue then
            table.remove(MyModels, k)
            break
        end
    end
    DeleteClothes()
end
------------------------------------------------------------
------------------------------------------------------------

------------------------------------------------------------
------------------- choisir une tenue ---------------------
------------------------------------------------------------
function ChangeModelVestiaire(selec)
    if not MyModelsOk then
        TriggerServerEvent("clotheshop:getListOfMyModels")
    end
    inmodelsmenu = {}
    inmodelmenu = {}
    options.menu_subtitle = "Choisir une tenue"
    ClearMenu()
    Menu.previous = principal
    while not MyModelsOk do
        Wait(10)
    end
    for k, v in pairs(MyModels) do
        local etat = ""
        if v.hand == MyModelMenu.hand and v.hand_txt == MyModelMenu.hand_txt and v.pants == MyModelMenu.pants and v.pants_txt == MyModelMenu.pants_txt and v.shoe == MyModelMenu.shoe and v.shoe_txt == MyModelMenu.shoe_txt and v.pend == MyModelMenu.pend and v.pend_txt == MyModelMenu.pend_txt and v.undershirt == MyModelMenu.undershirt and v.undershirt_txt == MyModelMenu.undershirt_txt and v.shirt == MyModelMenu.shirt and v.shirt_txt == MyModelMenu.shirt_txt then
            etat = "    ~g~Installé"
        end
        Menu.addButton(v.model..etat, "ChangeModel", v)
        table.insert(inmodelsmenu, v)
    end
    if selec then
        Menu.selection = selec[1]
        curplagemin = selec[2]
        curplagemax = selec[3]
    else
        Menu.selection = 1
    end
end

function ChangeModel(item)
    MyModelMenu.hand = item.hand
    MyModelMenu.hand_txt = item.hand_txt
    MyModelMenu.pants = item.pants
    MyModelMenu.pants_txt = item.pants_txt
    MyModelMenu.shoe = item.shoe
    MyModelMenu.shoe_txt = item.shoe_txt
    MyModelMenu.pend = item.pend
    MyModelMenu.pend_txt = item.pend_txt
    MyModelMenu.undershirt = item.undershirt
    MyModelMenu.undershirt_txt = item.undershirt_txt
    MyModelMenu.shirt = item.shirt
    MyModelMenu.shirt_txt = item.shirt_txt
    TriggerServerEvent("clotheshop:changeModel", item)
    ChangeModelVestiaire({Menu.selection, curplagemin, curplagemax})
end
------------------------------------------------------------
------------------------------------------------------------

------------------------------------------------------------
---------------   Installation des tenues ------------------
------------------------------------------------------------
local _tenue = {['hand'] = 0, ['hand_txt'] = 0, ['pants'] = 0, ['pants_txt'] = 0, ['shoe'] = 0, ['shoe_txt'] = 0, ['pend'] = 0, ['pend_txt'] = 21, ['undershirt'] = 0, ['undershirt_txt'] = 0, ['shirt'] = 0, ['shirt_txt'] = 0}

function clotheSelector(component_id, prop_id, prop_txt)
    local good = false
    if component_id == 3 then
        if _tenue.hand ~= prop_id or _tenue.hand_txt ~= prop_txt then
            _tenue.hand = prop_id
            _tenue.hand_txt = prop_txt
            good = true
        end
    elseif component_id == 4 then
        if _tenue.pants ~= prop_id or _tenue.pants_txt ~= prop_txt then
            _tenue.pants = prop_id
            _tenue.pants_txt = prop_txt
            good = true
        end
    elseif component_id == 6 then
        if _tenue.shoe ~= prop_id or _tenue.shoe_txt ~= prop_txt then
            _tenue.shoe = prop_id
            _tenue.shoe_txt = prop_txt
            good = true
        end
    elseif component_id == 7 then
        if _tenue.pend ~= prop_id or _tenue.pend_txt ~= prop_txt then
            _tenue.pend = prop_id
            _tenue.pend_txt = prop_txt
            good = true
        end
    elseif component_id == 8 then
        if _tenue.undershirt ~= prop_id or _tenue.undershirt_txt ~= prop_txt then
            _tenue.undershirt = prop_id
            _tenue.undershirt_txt = prop_txt
            good = true
        end
    elseif component_id == 11 then
        if _tenue.shirt ~= prop_id or _tenue.shirt_txt ~= prop_txt then
            _tenue.shirt = prop_id
            _tenue.shirt_txt = prop_txt
            good = true
        end
    end
    if good then
        SetPedComponentVariation(GetPlayerPed(-1), component_id, prop_id, prop_txt, 0)
    end
end

function clothesSelector(tenue, force)
    if tenue.hand ~= _tenue.hand or tenue.hand_txt ~= _tenue.hand_txt or tenue.pants ~= _tenue.pants or tenue.pants_txt ~= _tenue.pants_txt or tenue.shoe ~= _tenue.shoe or tenue.shoe_txt ~= _tenue.shoe_txt or tenue.pend ~= _tenue.pend or tenue.pend_txt ~= _tenue.pend_txt or tenue.undershirt ~= _tenue.undershirt or tenue.undershirt_txt ~= _tenue.undershirt_txt or tenue.shirt ~= _tenue.shirt or tenue.shirt_txt ~= _tenue.shirt_txt or force then
        local ped = GetPlayerPed(-1)
        SetPedComponentVariation(ped, 3, tenue.hand, tenue.hand_txt, 0)
        SetPedComponentVariation(ped, 4, tenue.pants, tenue.pants_txt, 0)
        SetPedComponentVariation(ped, 6, tenue.shoe, tenue.shoe_txt, 0)
        SetPedComponentVariation(ped, 7, tenue.pend, tenue.pend_txt, 0)
        SetPedComponentVariation(ped, 8, tenue.undershirt, tenue.undershirt_txt, 0)
        SetPedComponentVariation(ped, 11, tenue.shirt, tenue.shirt_txt, 0)
        _tenue.hand = tenue.hand
        _tenue.hand_txt = tenue.hand_txt
        _tenue.pants = tenue.pants
        _tenue.pants_txt = tenue.pants_txt
        _tenue.shoe = tenue.shoe
        _tenue.shoe_txt = tenue.shoe_txt
        _tenue.pend = tenue.pend
        _tenue.pend_txt = tenue.pend_txt
        _tenue.undershirt = tenue.undershirt
        _tenue.undershirt_txt = tenue.undershirt_txt
        _tenue.shirt = tenue.shirt
        _tenue.shirt_txt = tenue.shirt_txt
    end
end
------------------------------------------------------------
------------------------------------------------------------

Citizen.CreateThread(function()
	for _, item in pairs(emplacement) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(item.blip, item.colour)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
	while true do
        Citizen.Wait(0)
        if isNearShop() then
            if Menu.hidden == true then
                SetTextComponentFormat("STRING")
                AddTextComponentString("Appuyez sur la touche ~INPUT_CONTEXT~ pour ouvrir le magasin de ~b~vêtements.")
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end
            if IsControlJustPressed(1, 51) then
                if Menu.hidden == true then
                    Menu.hidden = false
                    Main()
                    FreezeEntityPosition(GetPlayerPed(-1), true)
                else
                    closeGui()
                end
            end
        end
		if #inclothemenu > 0 then
        	if Menu.selection > 0 then
            	clotheSelector(inclothemenu[Menu.selection].component_id, inclothemenu[Menu.selection].prop_id, inclothemenu[Menu.selection].prop_txt)
        	end
		end
        if #inmodelsmenu > 0 then
            if Menu.selection > 0 then
                clothesSelector(inmodelsmenu[Menu.selection])
            end
        end
		if Menu.hidden == false then
            Menu.renderGUI(options)
            DisableControlAction(0, 24, active) -- Attack
            DisablePlayerFiring(GetPlayerPed(-1), true) -- Disable weapon firing
            DisableControlAction(0, 142, active) -- MeleeAttackAlternate
            DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
        end
	end
end)

function isNearShop()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for _, item in pairs(emplacement) do
        local distance = GetDistanceBetweenCoords(item.x, item.y, item.z,  plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if distance <= 15.0 then
        	DrawMarker(1, item.x, item.y, item.z - 1, 0, 0, 0, 0, 0, 0, 2.0001, 2.0001, 0.5001, 1555, 0, 0,165, 0, 0, 0,0)
        end
        if(distance <= 2.0) then
            return true
        end
    end
end

function closeGui()
    inclothemenu = {}
    inmodelsmenu = {}
    Menu.hidden = true
    FreezeEntityPosition(GetPlayerPed(-1), false)
    clothesSelector(MyModelMenu)
end

function Notif(txt)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(txt)
    DrawNotification(false, false)
end

RegisterNetEvent("clotheshop:notif")
AddEventHandler("clotheshop:notif", function(txt)
    Notif(txt)
end)