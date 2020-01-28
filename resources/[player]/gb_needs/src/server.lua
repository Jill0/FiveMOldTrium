--
-- @Project: Trium
-- @License: No License
--

local malusfood = 1
local bonusfood = 100
local maluswater = 1
local bonuswater = 100
local malusneeds = 100
local bonusneeds = 1

-- CHECK NEEDS
function checkneeds(source)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	return tonumber(user.food),tonumber(user.water),tonumber(user.needs)
end

-- Update BDD
function updateMe(user)
	user.set({
		food = user.food,
		water = user.water,
		needs = user.needs,
	})
	MySQL.Async.execute('UPDATE users SET `food`=@foodvalue, `water`=@watervalue, `needs`=@needsvalue WHERE identifier = @identifier',
		{['@foodvalue'] = user.food, ['@watervalue'] = user.water, ['@needsvalue'] = user.needs, ['@identifier'] = user.identifier})
end

-- UPDATE NEEDS
function updateneeds(source, calories, waterdrops, wc)
	local user = exports["essentialmode"]:getPlayerFromId(source)
  user.food = user.food - calories
  user.water = user.water - waterdrops
  user.needs = user.needs + wc
	updateMe(user)
	return user
end

-- CUSTOM UPDATE NEEDS
function customupdateneeds(source, calories, waterdrops, wc)

	local user = exports["essentialmode"]:getPlayerFromId(source)
  user.food = user.food + calories
  if (tonumber(user.food) >= tonumber(bonusfood)) then
  	user.food = bonusfood
  elseif(tonumber(user.food) <= 0) then
  	user.food = 0
  end

  user.water = user.water + waterdrops
  if (tonumber(user.water) >= tonumber(bonuswater)) then
  	user.water = bonuswater
  elseif(tonumber(user.water) <= 0) then
  	user.water = 0
  end

  user.needs = user.needs - wc
  if (tonumber(user.needs) >= tonumber(malusneeds)) then
  	user.needs = malusneeds
  elseif (tonumber(user.needs) <= 0) then
  	user.needs = 0
  end

	updateMe(user)
	return user

end

-- SET NEEDS
function setneeds(source, food, water, needs)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	user.food = food
	user.water = water
	user.needs = needs
	updateMe(user)
end

-- NEEDS
function removeneeds(source, wc)
	local user = exports["essentialmode"]:getPlayerFromId(source)
  user.needs = user.needs - wc
  if (tonumber(user.needs) >= tonumber(malusneeds)) then
  	user.needs = malusneeds
  elseif (tonumber(user.needs) <= 0) then
  	user.needs = 0
  end
	updateMe(user)
	return user
end

RegisterServerEvent('gabs:removeneeds')
AddEventHandler('gabs:removeneeds', function(source, wc)
	local user = exports["essentialmode"]:getPlayerFromId(source)
  if (tonumber(user.needs) >= 1) then
  	user = removeneeds(source, wc)
    TriggerClientEvent("gabs:setneeds", user.source, user.needs)
    TriggerClientEvent("gabs:pee", user.source)
  else
  	TriggerClientEvent('chatMessage', user.source, 'NEWS', {0, 0, 200}, "Vous n'avez aucun besoin")
  end
end)

--SET DEFAULT NEEDS
RegisterServerEvent('gabs:setdefaultneeds')
AddEventHandler('gabs:setdefaultneeds', function()
  setneeds(source, tonumber(bonusfood), tonumber(bonuswater), 0)
  TriggerClientEvent("gabs:setfood", source, tonumber(bonusfood))
  TriggerClientEvent("gabs:setwater", source, tonumber(bonuswater))
  TriggerClientEvent("gabs:setneeds", source, 0)
end)

--ADD CUSTOM NEEDS
RegisterServerEvent('gabs:addcustomneeds')
AddEventHandler('gabs:addcustomneeds', function(source, calories, waterdrops, wc)
  local user = customupdateneeds(source, calories, waterdrops, wc)
  if (waterdrops > 0) then
  	TriggerClientEvent("gabs:drink", user.source)
  end
  if (calories > 0) then
  	TriggerClientEvent("gabs:eat", user.source)
  end
  TriggerClientEvent("gabs:setfood", user.source, user.food)
  TriggerClientEvent("gabs:setwater", user.source, user.water)
  TriggerClientEvent("gabs:setneeds", user.source, user.needs)
end)

-- START NEEDS
AddEventHandler('es:playerLoaded', function(source)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if user.food ~= nil and user.water ~= nil and user.needs ~= nil then
		TriggerClientEvent("gabs:setfood", user.source, user.food)
		TriggerClientEvent("gabs:setwater", user.source, user.water)
		TriggerClientEvent("gabs:setneeds", user.source, user.needs)
	else
		TriggerClientEvent("gabs:setfood", user.source, 100)
		TriggerClientEvent("gabs:setwater", user.source, 100)
		TriggerClientEvent("gabs:setneeds", user.source, 0)
	end
end)

RegisterServerEvent("gabs:updateMe")
AddEventHandler("gabs:updateMe", function ()
	local user = exports["essentialmode"]:getPlayerFromId(source)
  if(tonumber(user.food) >= 1) and (tonumber(user.water) >= 1) and (tonumber(user.needs) < tonumber(malusneeds)) then
  	user = updateneeds(source, malusfood, maluswater, bonusneeds)
    TriggerClientEvent("gabs:setfood", source, user.food)
    TriggerClientEvent("gabs:setwater", source, user.water)
    TriggerClientEvent("gabs:setneeds", source, user.needs)
    if (tonumber(user.food) <= 0) or (tonumber(user.water) <= 0) or (tonumber(user.needs) >= 100) then
    	TriggerClientEvent('gabs:needskill', source, user.food, user.water, user.needs)
    end
  else
  	TriggerClientEvent('gabs:needskill', source, user.food, user.water, user.needs)
  end
end)
