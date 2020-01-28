
--[[Register]]--
RegisterServerEvent('garages:CheckForSpawnVeh')
RegisterServerEvent('garages:CheckForVeh')
RegisterServerEvent('garages:SetVehOut')
RegisterServerEvent('garages:SetVehIn')
RegisterServerEvent('garages:PutVehInGarages')
RegisterServerEvent('garages:CheckGarageForVeh')
RegisterServerEvent('garages:CheckGarageForHeliBoat')
RegisterServerEvent('garages:CheckForSelVeh')
RegisterServerEvent('garages:SelVeh')
RegisterServerEvent('garages:putinfo')
RegisterServerEvent('garages:storeallvehicles2')


--[[Local/Global]]--
local vehicles = {}
local mods ={}
local neoncolor = {}
local neon = 0
local xenon =0
local colors = {}
local colorsExtra = {}
local colorsmoke = {}
local windowtint = 0
local wheeltype = 0
local smoke = 0
local pneu = 0
local pneum = 0
local plac = 0
local turbo = 0
local health = 1000


--[[Events]]--
AddEventHandler('garages:storeallvehicles2', function(identifiers)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    MySQL.Sync.execute('UPDATE user_vehicle SET vehicle_state =@state WHERE identifier=@owner AND vehicle_state = "Sorti"', {['@owner'] = player, ['@state'] = "Rentré"})
  end)
end)

AddEventHandler('garages:CheckForSpawnVeh', function(veh_id)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if(user) then
      local veh_id = veh_id
      local player = user.identifier
      local result = MySQL.Sync.fetchAll('SELECT * FROM user_vehicle WHERE identifier = @username AND ID = @ID',{['@username'] = player, ['@ID'] = veh_id})
      if(result)then
        for k,v in ipairs(result)do
          vehicle = v.vehicle_model
          plate = v.vehicle_plate
          state = v.vehicle_state
          primarycolor = v.vehicle_colorprimary
          secondarycolor = v.vehicle_colorsecondary
          pearlescentcolor = v.vehicle_pearlescentcolor
          wheelcolor = v.vehicle_wheelcolor
      		mods = v.mods
          neoncolor = v.neoncolor
          neon = v.neon
          xenon = v.xenon
          colorsmoke = v.colorsmoke
  		    windowtint = v.windowtint
          wheeltype = v.wheeltype
          smoke = v.smoke
          pneu = v.pneu
  		    pneum = v.pneum
  		    plac = v.plac
  		    turbo = v.turbo
  		    health = v.health
          local vehicle = vehicle
          local plate = plate
          local state = state
          local primarycolor = primarycolor
          local secondarycolor = secondarycolor
          local pearlescentcolor = pearlescentcolor
          local wheelcolor = wheelcolor
  	      local mods = mods
  	      local neoncolor = neoncolor
  	      local neon = neon
  	      local xenon = xenon
          local colorsmoke = json.decode(colorsmoke)
          local windowtint = windowtint
          local wheeltype = wheeltype
          local smoke = smoke
          local pneu = pneu
          local pneum = pneum
          local plac = plac
          local turbo = turbo
          local health = health
        end
      end
      TriggerClientEvent('garages:SpawnVehicle', user.source, vehicle, veh_id, plate, primarycolor , secondarycolor, pearlescentcolor, wheelcolor, mods, neoncolor, neon, xenon, colorsmoke, windowtint, wheeltype, smoke , pneu , pneum, plac, turbo, health)
  	else
  		TriggerEvent("es:bug")
  	end
  end)
end)

AddEventHandler('garages:CheckForVeh', function(vehid)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if(user) then
      local vehid = vehid
      local state = "Sorti"
      local player = user.identifier
      local result = MySQL.Sync.fetchAll('SELECT * FROM user_vehicle WHERE identifier = @username AND vehicle_state =@state AND ID =@id',{['@username'] = player, ['@state'] = state, ['@id'] = vehid})
      if(result)then
        for k,v in ipairs(result)do
          idtest = tonumber(v.ID)
          vehicle = v.vehicle_model
          plate = v.vehicle_plate
  		    modeltype = v.veh_type
          local idtest = idtest
          local vehicle = vehicle
          local plate = plate
          local modeltype = modeltype
        end
      end
      TriggerClientEvent('garages:StoreVehicle', user.source, idtest, vehicle, plate, modeltype)
  	else
  		TriggerEvent("es:bug")
    end
  end)
end)

AddEventHandler('garages:SetVehOut', function( vehid, plate, car)
  TriggerEvent('es:getPlayerFromId', source, function(user)
  if(user) then
    local player = user.identifier
    local vehid = vehid
    local state = "Sorti"
    local plate = plate
    MySQL.Sync.execute('UPDATE user_vehicle SET vehicle_state=@state WHERE identifier = @username AND vehicle_plate = @plate  AND ID = @id',
      { ['@id'] = vehid ,['@username'] = player,  ['@state'] = state, ['@plate'] = plate})
	  else
		TriggerEvent("es:bug")
		end
  end)
end)

AddEventHandler('garages:SetVehIn', function( vehid, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if(user) then
      local player = user.identifier
      local vehid = vehid
      local primarycolor = primarycolor
      local colorextra = secondarycolor
      local pearlescentcolor = pearlescentcolor
      local wheelcolor = wheelcolor
      local plate = plate
      local state = "Rentré"
      MySQL.Sync.execute('UPDATE user_vehicle SET vehicle_state=@state, vehicle_colorprimary=@primarycolor , vehicle_colorsecondary=@colorextra , vehicle_pearlescentcolor=@pearlescentcolor , vehicle_wheelcolor=@wheelcolor WHERE identifier = @username AND vehicle_plate = @plate  AND ID = @id',
        { ['@id'] = vehid ,['@username'] = player,  ['@state'] = state, ['@primarycolor'] = primarycolor, ['@colorextra'] = colorextra ,['@pearlescentcolor'] = pearlescentcolor,  ['@wheelcolor'] = wheelcolor, ['@plate'] = plate})
    else
  		TriggerEvent("es:bug")
		end
  end)
end)

AddEventHandler('garages:putinfo', function( vehid, mods, neoncolor, neon, xenon, colsmo, windowtint, wheeltype, smoke, pneu, pneum, plac, turbo, health)
	local vehid = vehid
	local mods = json.encode(mods)
	local  neoncolor = json.encode(neoncolor)
	local  neon = neon
	local  xenon = xenon
	local  colorsmoke = json.encode(colsmo)
	local  windowtint = windowtint
	local  wheeltype = wheeltype
	local  smoke = smoke
	local  pneu = pneu
	local  pneum = pneum
	local plac = plac
	local turbo = turbo
	local health = health
	local  state = "Rentré"
  MySQL.Sync.execute('UPDATE user_vehicle SET mods = @mods, neoncolor = @neoncolor, neon = @neon,  colorsmoke = @colorsmoke, windowtint =@windowtint, wheeltype =@wheeltype, smoke = @smoke, pneu =@pneu, pneum =@aze, xenon=@xenon, plac = @plac, turbo = @turbo, health = @health WHERE  ID = @id',
    { ['@id'] = vehid , ['@mods'] = mods, ['@neoncolor'] = neoncolor , ['@neon'] = neon, ['@xenon'] = xenon, ['@colorsmoke'] = colorsmoke , ['@windowtint'] = windowtint, ['@wheeltype'] = wheeltype, ['@smoke'] = smoke, ['@pneu'] = pneu, ['@aze'] = pneum, ['@plac'] = plac, ['@turbo'] = turbo, ['@health'] = health })
end)

AddEventHandler('garages:PutVehInGarages', function(vehicle)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if(user) then
      local player = user.identifier
      local state ="Rentré"

      local result = MySQL.Sync.execute('SELECT identifier FROM user_vehicle WHERE identifier = @username',{['@username'] = player})


      if(result)then
        for k,v in ipairs(result)do
          joueur = v.identifier
          local joueur = joueur
         end
      end

      if joueur ~= nil then
        MySQL.Sync.execute('UPDATE user_vehicle SET `vehicle_state`=@state WHERE identifier = @username', {['@username'] = player, ['@state'] = state})
      end
  	else
  		TriggerEvent("es:bug")
		end
  end)
end)

-- Voiture
AddEventHandler('garages:CheckGarageForVeh', function()
  vehicles = {}
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if(user) then
      local player = user.identifier
      local result = MySQL.Sync.fetchAll('SELECT ID,vehicle_model,vehicle_name,vehicle_state,vehicle_plate FROM user_vehicle WHERE identifier = @username AND veh_type = 1',{['@username'] = player})

      if (result) then
        for _, v in ipairs(result) do
          t = { ["id"] = v.ID, ["vehicle_model"] = v.vehicle_model, ["vehicle_name"] = v.vehicle_name, ["vehicle_state"] = v.vehicle_state, ["vehicle_plate"] = v.vehicle_plate}
          vehicles[tonumber(v.ID)] = t
        end
          TriggerClientEvent('garages:getVehicles', user.source, vehicles)
      end
  	else
  		TriggerEvent("es:bug")
		end
  end)
end)

-- Helico>Bateau
AddEventHandler('garages:CheckGarageForHeliBoat', function()
  vehicles = {}
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if(user) then
      local player = user.identifier
      local result = MySQL.Sync.fetchAll('SELECT ID,vehicle_model,vehicle_name,vehicle_state,vehicle_plate FROM user_vehicle WHERE identifier = @username AND veh_type = 2',{['@username'] = player})

      if (result) then
          for _, v in ipairs(result) do
  				t = { ["id"] = v.ID, ["vehicle_model"] = v.vehicle_model, ["vehicle_name"] = v.vehicle_name, ["vehicle_state"] = v.vehicle_state, ["vehicle_plate"] = v.vehicle_plate}
  				vehicles[tonumber(v.ID)] = t
          end
           TriggerClientEvent('garages:getVehicles', user.source, vehicles)
      end
  	else
  		TriggerEvent("es:bug")
		end
  end)
end)

AddEventHandler('garages:CheckForSelVeh', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if(user) then
      local state = "Sorti"
      local player = user.identifier
      local result = MySQL.Sync.fetchAll('SELECT * FROM user_vehicle WHERE identifier = @username AND vehicle_state =@state',{['@username'] = player, ['@vehicle'] = vehicle, ['@state'] = state})
      if(result) then
      	TriggerClientEvent('garages:SelVehicle', user.source, result)
      end
  	else
  		TriggerEvent("es:bug")
		end
  end)
end)


AddEventHandler('garages:SelVeh', function(vehid, plate)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if(user) then
      local player = user.identifier
      local plate = plate
  	local vehid = vehid
      local result = MySQL.Sync.fetchAll('SELECT vehicle_price FROM user_vehicle WHERE identifier = @username AND vehicle_plate =@plate  AND ID = @id',{['@id'] = vehid ,['@username'] = player, ['@plate'] = plate})
      if(result)then
        for k,v in ipairs(result)do
          price = v.vehicle_price
        local price = price / 2
        user.func.addMoney((price))
        end
      end
      MySQL.Sync.execute('DELETE from user_vehicle WHERE identifier = @username AND vehicle_plate = @plate   AND ID = @id',
        {['@id'] = vehid ,['@username'] = player, ['@plate'] = plate})
      TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
        icon = "CHAR_SIMEON",
        title = "Simeon",
        text = "Véhicule vendu!\n",
      })
    else
  		TriggerEvent("es:bug")
		end
  end)
end)
