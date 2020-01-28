-- FX

--[[ ***** EVENTS GUI ***** ]]
RegisterServerEvent("antirpquestion:kick")
AddEventHandler("antirpquestion:kick", function()
	DropPlayer(source, "Vous n'avez pas reussi le questionnaire, reessayez.")
end)

RegisterServerEvent("antirpquestion:success")
AddEventHandler("antirpquestion:success", function()
	local player = exports["essentialmode"]:getPlayerFromId(source)
	--TriggerEvent("es:getPlayerFromId", source, function(player)
		MySQL.Async.execute("UPDATE users SET question_rp='made' WHERE identifier = @username", { ['@username'] = player.identifier})
	--end)
end)

--[[ ***** SPAWN ***** ]]
RegisterServerEvent("antirpquestion:didQuestion")
AddEventHandler("antirpquestion:didQuestion", function()
	local player = exports["essentialmode"]:getPlayerFromId(source)
    --TriggerEvent("es:getPlayerFromId", source, function(player)
		MySQL.Async.fetchScalar("SELECT question_rp FROM users WHERE identifier = @username", { ['@username'] = player.identifier }, function(result)
        	if (result == "false") then
            	TriggerClientEvent('antirpquestion:notMade',player.source)
        	end
		end)
    --end)
end)

