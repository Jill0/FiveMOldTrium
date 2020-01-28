RegisterServerEvent('vote:Autor')
AddEventHandler('vote:Autor', function()
	local vote = nil
	local voteAutor = false
	TriggerEvent('es:getPlayerFromId', source, function(user)
		vote = tonumber(MySQL.Sync.fetchScalar('SELECT vote FROM users WHERE identifier = @identifier', {['@identifier'] = user.identifier}))
		if vote == 0 then
			voteAutor = true
		end
		TriggerClientEvent('vote:isautorize', user.source, voteAutor)
	end)
end)

RegisterServerEvent('vote:setVote')
AddEventHandler('vote:setVote', function(id)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if id then
			MySQL.Sync.execute('UPDATE users SET `vote`=@id WHERE identifier = @identifier', {['@id'] = id, ['@identifier'] = user.identifier})
			TriggerClientEvent('vote:ok', user.source)
		end
	end)
end)

RegisterServerEvent('vote:voteactif')
AddEventHandler('vote:voteactif', function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		local voteactif = false
		local beforevote = false
		local aftervote = false
		local osdate = os.time()
		local votedeb = os.time(votedebu)
		local votefin = os.time(votefini)
		if votedeb <= osdate and osdate <= votefin then
			voteactif = true
		else
			voteactif = false
		end
		if osdate < votedeb then
			beforevote = true
		elseif osdate > votefin then
			aftervote = true
		end
		TriggerClientEvent('vote:isactif', user.source, voteactif, beforevote, aftervote)
	end)
end)

local voteres = nil
RegisterServerEvent('vote:res')
AddEventHandler('vote:res', function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if not voteres then
			voteres = MySQL.Sync.fetchAll('SELECT vote, COUNT(*) AS compte FROM users WHERE vote<>0 GROUP BY vote ORDER BY vote ASC;')
		end
		TriggerClientEvent('vote:result', user.source, voteres)
	end)
end)