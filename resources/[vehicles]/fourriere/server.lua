RegisterServerEvent("fourriere:checkIfMeca")
AddEventHandler("fourriere:checkIfMeca", function()
	TriggerEvent("es:getPlayerFromId", source, function(player)
		local Player_Job = player.jobId
		local isMecaOrNot = false
		if (Player_Job == 16) then
			isMecaOrNot = true
		else
			isMecaOrNot = false
		end
		TriggerClientEvent('fourriere:isMecaOrNot',player.source, isMecaOrNot)
	end)
end)

RegisterServerEvent("fourriere:updateFouriere")
AddEventHandler("fourriere:updateFouriere", function(veh_plate,toggle)
	TriggerEvent("es:getPlayerFromId", source, function(player)
			local state = 0

			if(toggle == 1 ) then -- Mécano qui met le véhicule dans la fourrière
				state = "Fourriere"
				player.func.addMoney(250)
			elseif(toggle == 2) then -- Joueur qui paye son amende
				state = "Rentré"
				player.func.removeMoney(1500)
			elseif(toggle == 3) then -- Mécano qui sort le véhicule
				state = "Rentré"
				player.func.removeMoney(250)
			else
				state = "Sorti"
			end

			MySQL.Sync.execute('UPDATE user_vehicle SET veh_fourriere =@toggle, vehicle_state = @state WHERE vehicle_plate=@plate', {['@plate'] = veh_plate, ['@toggle'] = toggle, ['@state'] = state})
		end)
	end)

RegisterServerEvent("fourriere:getVehInFourriere")
AddEventHandler("fourriere:getVehInFourriere", function(veh_plate,toggle)
		local result = MySQL.Sync.fetchAll('SELECT ID,vehicle_name,vehicle_plate FROM user_vehicle WHERE vehicle_state = "Fourriere"')
		TriggerClientEvent('fourriere:getOutFourriere',source, result)
end)

-- Copié de ES_GARAGES
RegisterServerEvent("fourriere:CheckForSpawnVeh")
AddEventHandler('fourriere:CheckForSpawnVeh', function(veh_id)
  TriggerEvent('es:getPlayerFromId', source, function(user)
  if(user) then
    local veh_id = veh_id
    local player = user.identifier
    local result = MySQL.Sync.fetchAll('SELECT * FROM user_vehicle WHERE ID = @ID',{['@ID'] = veh_id})
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
    TriggerClientEvent('fourriere:SpawnVehicle', user.source, vehicle, veh_id, plate, primarycolor , secondarycolor, pearlescentcolor, wheelcolor, mods, neoncolor, neon, xenon, colorsmoke, windowtint, wheeltype, smoke , pneu , pneum, plac, turbo, health)
	else
		TriggerEvent("es:bug")
	end
 end)
end)

