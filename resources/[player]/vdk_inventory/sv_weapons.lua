--Vérifie si le joueur 'player' possède déjà l'arme 'weapon_model'
RegisterServerEvent("weapon:hasWeapon")
AddEventHandler("weapon:hasWeapon", function(item)
  TriggerEvent('es:getPlayerFromId', source, function(player)
		MySQL.Async.fetchAll("SELECT weapon_model FROM user_weapons WHERE identifier = @username",{['@username'] = player.identifier}, function(result)
            local hasWeapon = false
            for k,v in pairs(result) do
              if(string.upper(v.weapon_model) == string.upper(item.weapon_model)) then
                hasWeapon = true
              end
            end

			if hasWeapon then
			  TriggerClientEvent("notify:hasWeaponAlready", player.source, item.libelle)
			else
			  TriggerClientEvent("weapon:equip", player.source, item)
			end
		end)
  	end)
end)

--Vérifie si le joueur 'player' possède déjà l'arme 'weapon_model'
RegisterServerEvent("weapon:controlWeapon")
AddEventHandler("weapon:controlWeapon", function(armeID)
  TriggerEvent('es:getPlayerFromId', source, function(player)
      MySQL.Async.fetchAll("SELECT weapon_model FROM user_weapons WHERE identifier = @username",{['@username'] = player.identifier}, function(result)
            local hasWeapon = false
            for k,v in pairs(result) do
              if(string.upper(v.weapon_model) == string.upper(armeID)) then
                hasWeapon = true
              end
            end

            if hasWeapon then
              MySQL.Async.execute("DELETE FROM user_weapons WHERE identifier = @username AND weapon_model = @wp_model",{['@username'] = player.identifier,['@wp_model'] = string.upper(armeID)})
              MySQL.Async.fetchAll("SELECT id FROM items WHERE weapon_model =@arme_libelle",{['@arme_libelle'] = string.upper(armeID)}, function(result)
               	if result then
               		 TriggerClientEvent("player:receiveItem", player.source, result[1].id, 1)
               	end
               end)
              TriggerClientEvent("weapon:dropWeapon", player.source, armeID, true)
            else
              TriggerClientEvent("weapon:dropWeapon", player.source, armeID, false)
            end
      end)
    end)
end)
