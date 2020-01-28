---------------------------
------CHOSE SQL MODE-------
---------------------------
--Async   -----------------
--MySQL   -----------------
--Couchdb ----------------- (soon)
---------------------------
local mode = "Async"

local visite = {
    [1] = {["price"] = 2000000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [2] = {["price"] = 100000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [3] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [4] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [5] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [6] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [7] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [8] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [9] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [10] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [11] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [12] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [13] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [14] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [15] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [16] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [17] = {["price"] = 700000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [18] = {["price"] = 1000000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [19] = {["price"] = 1000000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [20] = {["price"] = 1000000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [21] = {["price"] = 1000000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [22] = {["price"] = 1000000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [23] = {["price"] = 1100000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
    [24] = {["price"] = 1100000, ["visiteurs"] = {["name"] = nil, ["id"] = nil}},
}

local lang = 'fr'
local txt = {
    ['fr'] = {
        ['welcome'] = 'Bienvenue dans votre appartement!',
        ['nocash'] = 'Vous n\'avez pas assez d\'argent!',
        ['estVendu'] = 'Appartement vendus!',
        ['deposit'] = 'Vous avez depose ',
        ['withdraw'] = 'Vous avez retire ',
        ['curency'] = '$'
    },
    
    ['en'] = {
        ['welcome'] = 'Welcome to home!',
        ['nocash'] = 'You d\'ont have enough cash!',
        ['estVendu'] = 'Apartment sold!',
        ['depositcash'] = 'You deposited ',
        ['withdraw'] = 'You withdrew ',
        ['curency'] = '$'
    }}
    
    -- LES BOJETS
    
    RegisterServerEvent("appart:getListPlayerInventory") -- Etape 1 de la dépose : On récupère l'inventaire du joueur
    AddEventHandler("appart:getListPlayerInventory", function(appart)
        --local user = exports["essentialmode"]:getPlayerFromId(source)
        --MySQL.Async.fetchAll('SELECT DISTINCT stockage.quantity, stockage.item_id, items.value, items.libelle, items.type, items.weapon_model FROM stockage JOIN items ON stockage.item_id = items.id WHERE stockage.type = "player_pocket" AND stockage.identifier = @identifier', {['@identifier'] = user.identifier}, function (result)
        --if(result) then
        --TriggerClientEvent("appart:menuDeposerObjet", user.source, result, appart)
        --end
        --end)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        local player_inventory = exports["vdk_inventory"]:GetPlayerStockage(user.identifier)
        TriggerClientEvent("appart:menuDeposerObjet", user.source, player_inventory, appart)
    end)
    
    RegisterServerEvent("appart:srvDeposerObjet") -- Etape 2 du retrait
    AddEventHandler("appart:srvDeposerObjet", function(quantite, objet_id, appart)
        TriggerClientEvent("player:looseItem", source, objet_id, quantite)
        MySQL.Async.fetchAll('SELECT id FROM stockage WHERE type = "apartment_chest" AND item_id = @item_id and identifier = @identifier', {['@item_id'] = objet_id, ['@identifier'] = appart}, function (result)
            if(result[1]) then
                MySQL.Async.execute('UPDATE stockage SET quantity = quantity + @quantite WHERE type = "apartment_chest" AND identifier = @identifier AND item_id = @item_id', {['@quantite'] = quantite, ['@item_id'] = objet_id, ['@identifier'] = appart})
            else
                MySQL.Async.execute('INSERT INTO stockage (`identifier`, `item_id`, `quantity`, `type`) VALUES (@identifier, @item_id, @quantite, "apartment_chest")', {['@quantite'] = quantite, ['@item_id'] = objet_id, ['@identifier'] = appart})
            end
        end)
    end)
    --
    RegisterServerEvent("appart:getListAppartInventory") -- Etape 1 du retrait : On liste les objets de l'appartement
    AddEventHandler("appart:getListAppartInventory", function(appart)
        local result = MySQL.Sync.fetchAll('SELECT stockage.quantity, stockage.item_id, items.libelle FROM stockage JOIN items ON stockage.item_id = items.id WHERE stockage.type = "apartment_chest" AND stockage.identifier = @identifier', {['@identifier'] = appart})
        if(result) then
            TriggerClientEvent("appart:menuRetirerObjet", source, result, appart)
        end
    end)
    
    RegisterServerEvent("appart:srvRetirerObjet") -- Etape 2 du retrait
    AddEventHandler("appart:srvRetirerObjet", function(quantite, objet_id, appart)
        TriggerClientEvent("player:receiveItem", source, objet_id, quantite)
        MySQL.Async.fetchAll('SELECT id FROM stockage WHERE type = "apartment_chest" AND item_id = @item_id and identifier = @identifier', {['@item_id'] = objet_id, ['@identifier'] = appart}, function (result)
            if(result[1]) then
                MySQL.Async.execute('UPDATE stockage SET quantity = quantity - @quantite WHERE type = "apartment_chest" AND identifier = @identifier AND item_id = @item_id', {['@quantite'] = quantite, ['@item_id'] = objet_id, ['@identifier'] = appart})
            end
        end)
    end)
    
    -- FIN DES OBJETS
    
    RegisterServerEvent("apart:Initialisation")
    AddEventHandler('apart:Initialisation', function()
        local user = exports["essentialmode"]:getPlayerFromId(source)
        MySQL.Async.fetchAll("SELECT identifier,name FROM user_appartement", {['@nom'] = "1"}, function (result)
            if (result) then
                count = 0
                for _ in pairs(result) do
                    count = count + 1
                    if (result[count].identifier == user.identifier) then
                        TriggerClientEvent('apart:BlipsAppart', user.source, result[count].name, 1)
                    else
                        TriggerClientEvent('apart:BlipsAppart', user.source, result[count].name, 2)
                    end
                end
            end
        end)
    end)
    local isBuy = 0
    
    RegisterServerEvent("apart:getAppart")
    AddEventHandler('apart:getAppart', function(name)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        if(user) then
            local player = user.identifier
            local name = name
            if (mode == "Async") then
                MySQL.Async.fetchScalar("SELECT identifier FROM user_appartement WHERE name = @nom", {['@nom'] = tostring(name)}, function (result)
                    if (result) then
                        if (result == player) then
                            TriggerClientEvent('apart:isMine', user.source)
                        else
                            TriggerClientEvent('apart:isBuy', user.source)
                        end
                    else
                        TriggerClientEvent('apart:isNotBuy', user.source)
                    end
                end)
            elseif mode == "MySQL" then
                local executed_query = MySQL:executeQuery("SELECT identifier FROM user_appartement WHERE name = '@nom'", {['@nom'] = tostring(name)})
                local result = MySQL:getResults(executed_query, {'identifier'})
                if (result) then
                    count = 0
                    for _ in pairs(result) do
                        count = count + 1
                    end
                    if count > 0 then
                        if (result[1].identifier == player) then
                            TriggerClientEvent('apart:isMine', user.source)
                        else
                            TriggerClientEvent('apart:isBuy', user.source)
                        end
                    else
                        TriggerClientEvent('apart:isNotBuy', user.source)
                    end
                end
            end
        else
            TriggerEvent("es:bug")
        end
    end)
    
    RegisterServerEvent("apart:addInter")
    AddEventHandler('apart:addInter', function(id, interiorx, interiory, interiorz)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        visite[id].visiteurs.name = user.func.getLastName() .. " " .. user.func.getName()
        visite[id].visiteurs.id = user.source
        TriggerClientEvent('apart:SonnerInterieur', -1, interiorx, interiory, interiorz)
    end)
    
    RegisterServerEvent("apart:getInter")
    AddEventHandler('apart:getInter', function()
        TriggerClientEvent('apart:setInter', source, visite)
    end)
    
    RegisterServerEvent("apart:TeleportVisiteur")
    AddEventHandler('apart:TeleportVisiteur', function(player, interior)
        local target = exports["essentialmode"]:getPlayerFromId(player)
        TriggerClientEvent('apart:teleportUser', target.source)
        visite[interior].visiteurs.name = nil
        visite[interior].visiteurs.id = nil
    end)
    
    RegisterServerEvent("apart:buyAppart")
    AddEventHandler('apart:buyAppart', function(id, name, price)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        if(visite[id].price ~= price) then
            TriggerEvent('discord:antiCheat', "@everyone REPORT : " .. user.nom .. " " .. user.prenom .. " (ID : " .. user.source .. ") a acheté l'appartement " .. name .. " pour " .. price .. "$ au lieu de " .. visite[id].price .. "$")
        end
        if(user) then
            local player = user.identifier
            local name = name
            local price = price
            if (tonumber(user.money) >= tonumber(price)) then
                user.func.removeMoney((price))
                if (mode == "Async") then
                    MySQL.Async.execute("INSERT INTO user_appartement (`identifier`, `name`, `price`) VALUES (@username, @name, @price)", {['@username'] = player, ['@name'] = name, ['@price'] = price})
                elseif mode == "MySQL" then
                    local executed_query2 = MySQL:executeQuery("INSERT INTO user_appartement (`identifier`, `name`, `price`) VALUES ('@username', '@name', '@price')", {['@username'] = player, ['@name'] = name, ['@price'] = price})
                end
                
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_SIMEON",
                    title = "Stephane",
                    text = txt[lang]['welcome'],
                })
                
                TriggerClientEvent('apart:isMine', user.source)
            else
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_SIMEON",
                    title = "Stephane",
                    text = txt[lang]['nocash'],
                })
            end
        else
            TriggerEvent("es:bug")
        end
    end)
    
    -- ARGENT PROPRE
    RegisterServerEvent("apart:getCash")
    AddEventHandler('apart:getCash', function(name)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        local player = user.identifier
        local name = name
        if (mode == "Async") then
            MySQL.Async.fetchAll("SELECT dirtymoney,money FROM user_appartement WHERE name = @nom", {['@nom'] = tostring(name)}, function (result)
                if (result) then
                    money = result[1].money
                    dirtymoney = result[1].dirtymoney
                    TriggerClientEvent('apart:getCash', user.source, money, dirtymoney)
                end
            end)
        elseif mode == "MySQL" then
            local executed_query = MySQL:executeQuery("SELECT dirtymoney,money FROM user_appartement WHERE name = @nom", {['@nom'] = tostring(name)})
            local result = MySQL:getResults(executed_query, {'identifier'})
            if (result) then
                money = result[1].money
                dirtymoney = result[1].dirtymoney
                TriggerClientEvent('apart:getCash', user.source, money, dirtymoney)
            end
        end
    end)
    
    RegisterServerEvent("apart:depositcash")
    AddEventHandler('apart:depositcash', function(cash, apart)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        local player = user.identifier
        local money = 0
        if (tonumber(user.money) >= tonumber(cash) and tonumber(cash) > 0) then
            if mode == "Async" then
                MySQL.Async.fetchAll("SELECT money FROM user_appartement WHERE name = @nom", {['@nom'] = apart}, function (result)
                    if (result) then
                        money = result[1].money
                        user.func.removeMoney(tonumber(cash))
                        local newmoney = money + cash
                        MySQL.Async.execute("UPDATE user_appartement SET `money`=@cash WHERE name = @nom", {['@cash'] = newmoney, ['@nom'] = apart}, function(data)
                        end)
                    end
                end)
            elseif mode == "MySQL" then
                local executed_query = MySQL:executeQuery("SELECT money FROM user_appartement WHERE name = @nom", {['@nom'] = apart})
                local result = MySQL:getResults(executed_query, {'money'})
                if (result) then
                    money = result[1].money
                    user.func.removeMoney(tonumber(cash))
                    local newmoney = money + cash
                    MySQL:executeQuery("UPDATE user_appartement SET `money`=@cash WHERE name = @nom", {['@cash'] = newmoney, ['@nom'] = apart})
                end
            end
            
            TriggerClientEvent('apart:getCash', user.source, money, dirtymoney)
        else
            print('pas argent')
        end
    end)
    
    RegisterServerEvent("apart:depositdirtycash")
    AddEventHandler('apart:depositdirtycash', function(cash, apart)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        local money = 0
        if (tonumber(user.dirty_money) >= tonumber(cash) and tonumber(cash) > 0) then
            if mode == "Async" then
                MySQL.Async.fetchAll("SELECT dirtymoney FROM user_appartement WHERE name = @nom", {['@nom'] = apart}, function (result)
                    if (result) then
                        money = result[1].dirtymoney
                        user.func.removeDirty_Money(tonumber(cash))
                        local newmoney = money + cash
                        MySQL.Async.execute("UPDATE user_appartement SET `dirtymoney`=@cash WHERE name = @nom", {['@cash'] = newmoney, ['@nom'] = apart}, function(data)
                        end)
                    end
                end)
            elseif mode == "MySQL" then
                local executed_query = MySQL:executeQuery("SELECT dirtymoney FROM user_appartement WHERE name = @nom", {['@nom'] = apart})
                local result = MySQL:getResults(executed_query, {'dirtymoney'})
                if (result) then
                    money = result[1].dirtymoney
                    user.func.removeDirtyMoney(tonumber(cash))
                    local newmoney = money + cash
                    MySQL:executeQuery("UPDATE user_appartement SET `dirtymoney`=@cash WHERE name = @nom", {['@cash'] = newmoney, ['@nom'] = apart})
                end
            end
            
            TriggerClientEvent('apart:getCash', source, money, dirtymoney)
        else
            print('pas argent')
        end
    end)
    
    -- ARGENT SALE
    RegisterServerEvent("apart:takedirtycash")
    AddEventHandler('apart:takedirtycash', function(cash, apart)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        local money = 0
        if mode == "Async" then
            MySQL.Async.fetchAll("SELECT dirtymoney FROM user_appartement WHERE name = @nom", {['@nom'] = apart}, function (result)
                if (result) then
                    money = result[1].dirtymoney
                    print('test : ' ..money)
                    if (tonumber(cash) <= tonumber(money) and tonumber(cash) > 0) then
                        user.func.addDirty_Money(tonumber(cash))
                        local newmoney = money - cash
                        MySQL.Async.execute("UPDATE user_appartement SET `dirtymoney`=@cash WHERE name = @nom", {['@cash'] = newmoney, ['@nom'] = apart}, function(data)
                        end)
                    else
                        print('pas argent')
                    end
                end
            end)
        elseif mode == "MySQL" then
            local executed_query = MySQL:executeQuery("SELECT dirtymoney FROM user_appartement WHERE name = @nom", {['@nom'] = apart})
            local result = MySQL:getResults(executed_query, {'dirtymoney'})
            if (result) then
                money = result[1].money
                if (tonumber(cash) <= tonumber(money) and tonumber(cash) > 0) then
                    user.func.addDirty_Money(tonumber(cash))
                    local newmoney = money - cash
                    MySQL:executeQuery("UPDATE user_appartement SET `dirtymoney`=@cash WHERE name = @nom", {['@cash'] = newmoney, ['@nom'] = apart})
                else
                    print('pas argent')
                end
            end
        end
        
        TriggerClientEvent('apart:getCash', user.source, money, dirtymoney)
    end)
    
    RegisterServerEvent("apart:takecash")
    AddEventHandler('apart:takecash', function(cash, apart)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        local money = 0
        if mode == "Async" then
            MySQL.Async.fetchAll("SELECT money FROM user_appartement WHERE name = @nom", {['@nom'] = apart}, function (result)
                if (result) then
                    money = result[1].money
                    if (tonumber(cash) <= tonumber(money) and tonumber(cash) > 0) then
                        user.func.addMoney(tonumber(cash))
                        local newmoney = money - cash
                        MySQL.Async.execute("UPDATE user_appartement SET `money`=@cash WHERE name = @nom", {['@cash'] = newmoney, ['@nom'] = apart}, function(data)
                        end)
                    else
                        print('pas argent')
                    end
                end
            end)
        elseif mode == "MySQL" then
            local executed_query = MySQL:executeQuery("SELECT money FROM user_appartement WHERE name = @nom", {['@nom'] = apart})
            local result = MySQL:getResults(executed_query, {'money'})
            if (result) then
                money = result[1].money
                if (tonumber(cash) <= tonumber(money) and tonumber(cash) > 0) then
                    user.addMoney(tonumber(cash))
                    local newmoney = money - cash
                    MySQL:executeQuery("UPDATE user_appartement SET `money`=@cash WHERE name = @nom", {['@cash'] = newmoney, ['@nom'] = apart})
                else
                    print('pas argent')
                end
            end
        end
        
        TriggerClientEvent('apart:getCash', user.source, money, dirtymoney)
    end)
    
    RegisterServerEvent("apart:sellAppart")
    AddEventHandler('apart:sellAppart', function(name, price)
        local user = exports["essentialmode"]:getPlayerFromId(source)
        if(user) then
            local player = user.identifier
            local name = name
            local price = price / 2
            user.func.addMoney((price))
            if (mode == "Async") then
                MySQL.Async.execute("DELETE from user_appartement WHERE identifier = @username AND name = @name",
                {['@username'] = player, ['@name'] = name})
            elseif mode == "MySQL" then
                local executed_query3 = MySQL:executeQuery("DELETE from user_appartement WHERE identifier = '@username' AND name = '@name'",
                {['@username'] = player, ['@name'] = name})
            end
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_SIMEON",
                title = "Stephane",
                text = txt[lang]['estVendu'],
            })
            TriggerClientEvent('apart:isNotBuy', user.source)
        else
            TriggerEvent("es:bug")
        end
    end)
    
    function getPlayerID(source)
        local identifiers = GetPlayerIdentifiers(source)
        local player = getIdentifiant(identifiers)
        return player
    end
    
    function getIdentifiant(id)
        for _, v in ipairs(id) do
            return v
        end
    end
    