
-- Constructor
Player = {}
Player.__index = Player

-- Meta table for users
setmetatable(Player, {
    __call = function(self, source, data)
        
        local pl = data
        pl.func = {}
        pl.connect = true
        pl.source = source
        pl.session = {}
        pl.time_played = data.time_played
        -- Fix ressouces
        pl.phoneNumber = data.phone_number
        pl.jobId = data.job
        pl.bank = data.bankbalance
        pl.group = groups[data.group]
        
        -- Global set
        pl.set = function(name, value)
            pl[name] = value
        end
        
        pl.set = function (...)
            
            local args = {...} -- Get all arguments
            local count = #args -- Count number arguments
            
            if count == 1 and type(args[1]) == "table" then
                for name, value in pairs(args[1]) do
                    pl[name] = value
                end
            elseif count == 2 then
                pl[name] = value
            else
                return false
            end
            
        end
        
        pl.func.setMoney = function(m)
            
            if type(m) == "number" then
                local prevMoney = pl.money
                local newMoney = m
                
                pl.money = m
                
                if((prevMoney - newMoney) < 0)then
                    TriggerClientEvent("es:addedMoney", pl.source, math.abs(prevMoney - newMoney), settings.defaultSettings.nativeMoneySystem)
                else
                    TriggerClientEvent("es:removedMoney", pl.source, math.abs(prevMoney - newMoney), settings.defaultSettings.nativeMoneySystem)
                end
                
                if not settings.defaultSettings.nativeMoneySystem then
                    TriggerClientEvent('es:activateMoney', pl.source, pl.money)
                end
            else
                for _, v in pairs(m)do
                    print(_)
                    print(v)
                end
                print('ERROR: There seems to be an issue while setting money, something else then a number was entered.')
            end
        end
        
        pl.func.getMoney = function()
            m = pl.money
            return pl.money
        end
        
        pl.func.getTimePlayed = function()
            m = pl.time_played
            return pl.time_played
        end
        
        pl.func.setTimePlayed = function(name)
            pl.time_played = name
        end

        pl.func.getIsFirstConnection = function()
            m = pl.isFirstConnection
            return pl.isFirstConnection
        end
        
        pl.func.setIsFirstConnection = function(name)
            pl.isFirstConnection = name
        end
        
        pl.func.getDirty = function()
            m = pl.dirty_money
            return pl.dirty_money
        end
        
        pl.func.setName = function(name)
            pl.nom = name
        end
        
        pl.func.setLastName = function(lastname)
            pl.prenom = lastname
        end
        
        pl.func.setPhoneNumber = function(phone_number)
            pl.phone_number = phone_number
        end
        
        pl.func.setJobId = function(job_id)
            pl.jobId = job_id
            --db.updateUser(v.get('identifier'), {job = job_id}, function()end)
            --if result[1] ~= nil then
            --pl.jobName = result[1].job_name
            --end
        end
        
        ------------ GETTER --------
        pl.func.getName = function()
            return pl.nom
        end
        
        pl.func.getSource = function()
            return pl.source
        end
        
        pl.func.getLastName = function()
            return pl.prenom
        end
        
        pl.func.disconnect = function()
            pl.connect = false
        end
        
        pl.func.getFullName = function()
            return pl.nom.." "..pl.prenom
        end
        
        pl.func.getPhoneNumber = function()
            return pl.phoneNumber
        end
        
        pl.func.getJobId = function()
            return pl.jobId
        end
        
        pl.func.getJobName = function()
            return pl.jobName
        end
        
        --==============Dirty money stuff========================
        -- Sets the player dirty money (required to call this from now)
        pl.func.setDirty_Money = function(m)
            
            if type(m) == "number" then
                local prevMoney = pl.dirty_money
                local newMoney = m
                
                pl.dirty_money = m
                
                if((prevMoney - newMoney) < 0)then
                    TriggerClientEvent("es:addedDirtyMoney", pl.source, math.abs(prevMoney - newMoney))
                else
                    TriggerClientEvent("es:removedDirtyMoney", pl.source, math.abs(prevMoney - newMoney))
                end
                
                TriggerClientEvent('es:activateDirtyMoney', pl.source, pl.dirty_money)
            else
                print('ERROR: There seems to be an issue while setting bank, something else then a number was entered.')
            end
        end
        
        -- Adds to player dirty money (required to call this from now)
        pl.func.addDirty_Money = function(m)
            
            if type(m) == "number" then
                local newMoney = pl.dirty_money + m
                
                pl.dirty_money = newMoney
                
                TriggerClientEvent("es:addedDirtyMoney", pl.source, m)
                TriggerClientEvent('es:activateDirtyMoney', pl.source, pl.dirty_money)
            else
                print('ERROR: There seems to be an issue while setting bank, something else then a number was entered.')
            end
        end
        
        -- Removes from player dirty money (required to call this from now)
        pl.func.removeDirty_Money = function(m)
            
            if type(m) == "number" then
                local newMoney = pl.dirty_money - m
                
                pl.dirty_money = newMoney
                
                TriggerClientEvent("es:removedDirtyMoney", pl.source, m)
                TriggerClientEvent('es:activateDirtyMoney', pl.source, pl.dirty_money)
            else
                print('ERROR: There seems to be an issue while setting bank, something else then a number was entered.')
            end
        end
        --=============End Dirty money stuff=====================
        
        pl.func.setBankBalance = function(m)
            
            if type(m) == "number" then
                TriggerEvent("es:setPlayerData", pl.source, "bankbalance", m, function(response, success)
                    pl.bank = m
                end)
                TriggerClientEvent('banking:updateBalance', pl.source, pl.bank)
            else
                print('ERROR: There seems to be an issue while setting bank, something else then a number was entered.')
            end
        end
        
        pl.func.getBank = function()
            m = pl.bank
            return pl.bank
        end
        
        pl.func.getCoords = function()
            return pl.coords
        end
        
        pl.func.setCoords = function(coords)
            pl.coords = coords
        end
        
        pl.func.kick = function(r)
            DropPlayer(pl.source, r)
        end
        
        pl.func.addMoney = function(m)
            
            if type(m) == "number" then
                local newMoney = pl.money + m
                
                if(m > 999998) then
                    TriggerEvent("es:getAllPlayerConnected", function(users)
                        for k, v in pairs(users) do
                            if(v.permission_level > 0)then
                                --TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, "ID ".. pl.source .." " .. pl.nom .. " " .. pl.prenom .. " vient de recevoir ".. m .."$ dans son portefeuille " .. GetConvar("current_server"))
                            end
                        end
                    end)
                    TriggerEvent("discord:banking", "@everyone REPORT : ID " .. pl.source .. " **" .. pl.nom .. " " .. pl.prenom .. "** vient de recevoir **" .. m .. "**$ dans son ***portefeuille*** " .. GetConvar("current_server"))
                end
                
                pl.money = newMoney
                
                TriggerClientEvent("es:addedMoney", pl.source, m, settings.defaultSettings.nativeMoneySystem)
                if not settings.defaultSettings.nativeMoneySystem then
                    TriggerClientEvent('es:activateMoney', pl.source, pl.money)
                end
            else
                print('ERROR: There seems to be an issue while adding money, a different type then number was trying to be added.')
            end
        end
        
        pl.func.removeMoney = function(m)
            
            if type(m) == "number" then
                local newMoney = pl.money - m
                pl.money = newMoney
                
                TriggerClientEvent("es:removedMoney", pl.source, m, settings.defaultSettings.nativeMoneySystem)
                if not settings.defaultSettings.nativeMoneySystem then
                    TriggerClientEvent('es:activateMoney', pl.source, pl.money)
                end
            else
                print('ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed.')
            end
        end
        
        pl.func.addBank = function(m)
            
            if type(m) == "number" then
                local newBank = pl.bank + m
                if(m > 999998) then
                    TriggerEvent("es:getAllPlayerConnected", function(users)
                        for k, v in pairs(users) do
                            if(v.permission_level > 0)then
                                --TriggerClientEvent('chatMessage', v.source, "CHEAT", {255, 0, 0}, "ID ".. pl.source .." " .. pl.nom .. " " .. pl.prenom .. " vient de recevoir ".. m .."$ en banque " .. GetConvar("current_server"))
                            end
                        end
                    end)
                    TriggerEvent("discord:banking", "@everyone REPORT : ID " .. pl.source .. " **" .. pl.nom .. " " .. pl.prenom .. "** vient de recevoir **" .. m .. "**$ en ***banque*** " .. GetConvar("current_server"))
                end
                pl.bank = newBank
                
                TriggerClientEvent("es:addedBank", pl.source, m)
            else
                print('ERROR: There seems to be an issue while adding to bank, a different type then number was trying to be added.')
            end
        end
        
        pl.func.removeBank = function(m)
            
            if type(m) == "number" then
                local newBank = pl.bank - m
                pl.bank = newBank
                
                TriggerClientEvent("es:removedBank", pl.source, m)
            else
                print('ERROR: There seems to be an issue while removing from bank, a different type then number was trying to be removed.')
            end
        end
        
        pl.func.displayMoney = function(m)
            if settings.defaultSettings.nativeMoneySystem then
                TriggerClientEvent("es:displayMoney", pl.source, math.floor(m))
            else
                TriggerClientEvent('es:activateMoney', pl.source, pl.money)
            end
        end
        
        pl.func.displayBank = function(m)
            if not pl.bankDisplayed then
                TriggerClientEvent("es:displayBank", pl.source, math.floor(m))
                pl.bankDisplayed = true
            end
        end
        
        pl.func.setSessionVar = function(key, value)
            pl.session[key] = value
        end
        
        pl.func.getSessionVar = function(k)
            return pl.session[k]
        end
        
        pl.func.getPermissions = function()
            return pl.permission_level
        end
        
        pl.func.setPermissions = function(p)
            pl.permission_level = p
        end
        
        pl.func.getIdentifier = function()
            return pl.identifier
        end
        
        pl.func.getGroup = function()
            return pl.group
        end
        
        pl.func.set = function(k, v)
            self[k] = v
        end
        
        pl.func.get = function(k)
            return self[k]
        end
        
        pl.func.setGlobal = function(g, default)
            self[g] = default or ""
            
            rTable["get" .. g:gsub("^%l", string.upper)] = function()
                return self[g]
            end
            
            rTable["set" .. g:gsub("^%l", string.upper)] = function(e)
                self[g] = e
            end
            
            Users[pl.source] = rTable
        end
        
        return setmetatable(pl, Player)
    end
})
