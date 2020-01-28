
local AllClothes = {}

MySQL.ready(function ()
    MySQL.Async.fetchAll("SELECT * FROM clothes", {}, function(result)
    	AllClothes = result
    end)
end)

RegisterServerEvent("clotheshop:getListOfMyModels")
AddEventHandler("clotheshop:getListOfMyModels", function()
	local _source = source
	local user = exports["essentialmode"]:getPlayerFromId(_source)
	MySQL.Async.fetchAll("SELECT * FROM modelvestiaire WHERE identifier = @identifier", {['@identifier'] = user.identifier}, function(result)
		TriggerClientEvent("clotheshop:giveListOfMyModels", _source, result)
	end)
end)

RegisterServerEvent("clotheshop:getListOfClothes")
AddEventHandler("clotheshop:getListOfClothes", function()
	local _source = source
	if not (#AllClothes > 0) then
		MySQL.Async.fetchAll("SELECT * FROM clothes", {}, function(result)
    		AllClothes = result
    		TriggerClientEvent("clotheshop:giveListOfClothes", _source, AllClothes)
    	end)
	else
		TriggerClientEvent("clotheshop:giveListOfClothes", _source, AllClothes)
	end
end)

RegisterServerEvent("clotheshop:getListOfMyClothes")
AddEventHandler("clotheshop:getListOfMyClothes", function()
	local _source = source
	local user = exports["essentialmode"]:getPlayerFromId(_source)
	MySQL.Async.fetchAll("SELECT * FROM clothes_users WHERE identifier=@identifier", {['@identifier']=user.identifier}, function(result)
		TriggerClientEvent("clotheshop:giveListOfMyClothes", _source, result)
	end)
end)

RegisterServerEvent("clotheshop:getModelMenu")
AddEventHandler("clotheshop:getModelMenu", function()
	local _source = source
	local user = exports["essentialmode"]:getPlayerFromId(_source)
	MySQL.Async.fetchAll("SELECT identifier, shirt, shirt_txt, hand, hand_txt, shoe, shoe_txt, pants, pants_txt, undershirt, undershirt_txt, pend, pend_txt FROM modelmenu WHERE identifier=@identifier", {['@identifier']=user.identifier}, function(result)
		TriggerClientEvent("clotheshop:giveModelMenu", _source, result[1])
	end)
end)

RegisterServerEvent("clotheshop:buyclothe")
AddEventHandler("clotheshop:buyclothe", function(item)
	local _source = source
	local user = exports["essentialmode"]:getPlayerFromId(_source)
	if user.money >= item.price then
		user.func.removeMoney(item.price)
		MySQL.Async.execute("INSERT INTO clothes_users (identifier, categorie, prop_id, prop_txt) VALUES (@identifier, @categorie, @prop_id, @prop_txt)", {['identifier'] = user.identifier, ['categorie'] = item.categorie, ['prop_id'] = item.prop_id, ['prop_txt'] = item.prop_txt})
		TriggerClientEvent("clotheshop:buyclotheaccepted", _source, item)
	else
		TriggerClientEvent("clotheshop:notif", _source, "~r~Vous n'avez pas assez d'argent")
	end
end)

RegisterServerEvent("clotheshop:changeModel")
AddEventHandler("clotheshop:changeModel", function(item)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	MySQL.Async.execute("UPDATE modelmenu SET hand=@hand, hand_txt=@hand_txt, pants=@pants, pants_txt=@pants_txt, shoe=@shoe, shoe_txt=@shoe_txt, pend=@pend, pend_txt=@pend_txt, undershirt=@undershirt, undershirt_txt=@undershirt_txt, shirt=@shirt, shirt_txt=@shirt_txt WHERE identifier=@identifier", {['hand'] = item.hand, ['hand_txt'] = item.hand_txt, ['pants'] = item.pants, ['pants_txt'] = item.pants_txt, ['shoe'] = item.shoe, ['shoe_txt'] = item.shoe_txt, ['pend'] = item.pend, ['pend_txt'] = item.pend_txt, ['undershirt'] = item.undershirt, ['undershirt_txt'] = item.undershirt_txt, ['shirt'] = item.shirt, ['shirt_txt'] = item.shirt_txt, ['identifier'] = user.identifier})
end)

RegisterServerEvent("clotheshop:AddTenue")
AddEventHandler("clotheshop:AddTenue", function(titre, item)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	MySQL.Async.execute("INSERT INTO modelvestiaire (identifier, model, hand, hand_txt, pants, pants_txt, shoe, shoe_txt, pend, pend_txt, undershirt, undershirt_txt, shirt, shirt_txt) VALUES (@identifier, @model, @hand, @hand_txt, @pants, @pants_txt, @shoe, @shoe_txt, @pend, @pend_txt, @undershirt, @undershirt_txt, @shirt, @shirt_txt)", {['hand'] = item.hand, ['hand_txt'] = item.hand_txt, ['pants'] = item.pants, ['pants_txt'] = item.pants_txt, ['shoe'] = item.shoe, ['shoe_txt'] = item.shoe_txt, ['pend'] = item.pend, ['pend_txt'] = item.pend_txt, ['undershirt'] = item.undershirt, ['undershirt_txt'] = item.undershirt_txt, ['shirt'] = item.shirt, ['shirt_txt'] = item.shirt_txt, ['identifier'] = user.identifier, ['model'] = titre})
end)

RegisterServerEvent("clotheshop:delmodel")
AddEventHandler("clotheshop:delmodel", function(item)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	MySQL.Async.execute("DELETE FROM modelvestiaire WHERE model=@model AND identifier=@identifier AND shirt=@shirt AND shirt_txt=@shirt_txt AND hand=@hand AND hand_txt=@hand_txt AND shoe=@shoe AND shoe_txt=@shoe_txt AND pants=@pants AND pants_txt=@pants_txt AND undershirt=@undershirt AND undershirt_txt=@undershirt_txt AND pend=@pend AND pend_txt=@pend_txt", {['model']=item.model, ['identifier']=user.identifier, ['hand'] = item.hand, ['hand_txt'] = item.hand_txt, ['pants'] = item.pants, ['pants_txt'] = item.pants_txt, ['shoe'] = item.shoe, ['shoe_txt'] = item.shoe_txt, ['pend'] = item.pend, ['pend_txt'] = item.pend_txt, ['undershirt'] = item.undershirt, ['undershirt_txt'] = item.undershirt_txt, ['shirt'] = item.shirt, ['shirt_txt'] = item.shirt_txt})
end)
