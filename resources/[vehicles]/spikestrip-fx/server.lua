TriggerEvent('es:addCommand', 'spike', function(source) -- usage /spike in chat maybe change to a hot key at later date
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if  tonumber(user.jobId) == 2 or tonumber(user.jobId) == 18 then  -- set police job can also use [ user.permission_level >= 2 ] in place of job if need be
        TriggerClientEvent('c_setSpike', user.source)
     end
  end)
end)