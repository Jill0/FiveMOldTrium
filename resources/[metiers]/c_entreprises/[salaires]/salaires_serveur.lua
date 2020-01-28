RegisterServerEvent('salaires:saveMoney')
AddEventHandler('salaires:saveMoney', function()
    local mysource = source
    local time_played = math.floor((fraqSauv / 1000) / 60)
    SaveMoneyForPlayer(mysource, time_played)
end)

AddEventHandler('playerDropped', function()
    local mysource = source
    local time_played = 0
    SaveMoneyForPlayer(mysource, time_played)
end)

function SaveMoneyForPlayer(source, time_played)
    local user = exports["essentialmode"]:getPlayerFromId(source)
    local time_calc = math.floor(user.func.getTimePlayed() + time_played)
    user.func.setTimePlayed(time_calc)
    MySQL.Async.execute("UPDATE `users` SET `money`=@value, `dirty_money`=@v2, `time_played` = `time_played` + @time_played_calc WHERE `identifier` = @identifier", {['@value'] = user.money, ['@v2'] = user.dirty_money, ['@time_played_calc'] = time_played, ['@identifier'] = user.identifier})
    print("Sauvegarde argent :" .. user.prenom .. " " ..user.nom)
end

RegisterServerEvent('salaires:salary')
AddEventHandler('salaires:salary', function()
    local user = exports["essentialmode"]:getPlayerFromId(source)
    -- Ajout de l'argent à l'utilisateur
    if(user ~= nil)then
        if user.func.getSessionVar('PrimeConnexion') == nil then
            user.func.setSessionVar('PrimeConnexion', {0, os.clock()})
        else
            local tableprimeconnexion = user.func.getSessionVar('PrimeConnexion')
            --print(tableprimeconnexion[1].." - "..tableprimeconnexion[2])
            local actutime = os.clock()
            --print(tableprimeconnexion[2]+(freqSal/40000).." - "..actutime)
            if tableprimeconnexion[2] + (freqSal / 40000) < actutime then
                local PrimeConnexion = tableprimeconnexion[1] + 1
                user.func.setSessionVar('PrimeConnexion', {PrimeConnexion, actutime})
                local primeco = 50 * PrimeConnexion
                local user_id = user.identifier
                local user_job = user.jobId
                local salaire = 0
                if(user_job == 2) then -- Police
                    if(user.func.getSessionVar('policeInService') ~= nil) then
                        if(user.func.getSessionVar('policeInService') == true) then
                            salaire = Liste_Metier[user_job].salaire
                        else
                            salaire = (Liste_Metier[user_job].salaire - 500)
                        end
                    else
                        salaire = (Liste_Metier[user_job].salaire - 500)
                    end
                elseif(user_job == 15) then -- Ambulancier
                    if(user.func.getSessionVar('ambuInService') ~= nil) then
                        if(user.func.getSessionVar('ambuInService') == true) then
                            salaire = Liste_Metier[user_job].salaire
                        else
                            salaire = (Liste_Metier[user_job].salaire - 500)
                        end
                    else
                        salaire = (Liste_Metier[user_job].salaire - 500)
                    end
                elseif(user_job == 16) then -- Mécano
                    if(user.func.getSessionVar('mecaInService') ~= nil) then
                        if(user.func.getSessionVar('mecaInService') == true) then
                            salaire = Liste_Metier[user_job].salaire
                        else
                            salaire = (Liste_Metier[user_job].salaire - 500)
                        end
                    else
                        salaire = (Liste_Metier[user_job].salaire - 500)
                    end
                elseif(user_job == 17) then -- Taxi
                    if(user.func.getSessionVar('taxiInService') ~= nil) then
                        if(user.func.getSessionVar('taxiInService') == true) then
                            salaire = Liste_Metier[user_job].salaire
                        else
                            salaire = (Liste_Metier[user_job].salaire - 500)
                        end
                    else
                        salaire = (Liste_Metier[user_job].salaire - 500)
                    end
                elseif(user_job == 18) then -- Chef LSPD
                    if(user.func.getSessionVar('policeInService') ~= nil) then
                        if(user.func.getSessionVar('policeInService') == true) then
                            salaire = Liste_Metier[user_job].salaire
                        else
                            salaire = (Liste_Metier[user_job].salaire - 500)
                        end
                    else
                        salaire = (Liste_Metier[user_job].salaire - 500)
                    end
                elseif(user_job == 22) then -- Avocat
                    if(user.func.getSessionVar('avocatInService') ~= nil) then
                        if(user.func.getSessionVar('avocatInService') == true) then
                            salaire = Liste_Metier[user_job].salaire
                        else
                            salaire = (Liste_Metier[user_job].salaire - 500)
                        end
                    else
                        salaire = (Liste_Metier[user_job].salaire - 500)
                    end
                else
                    salaire = Liste_Metier[user_job].salaire
                end
                user.func.addMoney(salaire + primeco)
                TriggerClientEvent("ft_libs:AdvancedNotification", source, {
                    icon = "CHAR_ANDREAS",
                    title = "Maze Bank",
                    text = "Prime de temps de connexion :  + "..primeco.."~g~$~s~~n~Salaire métier reçu : + "..salaire.." ~g~$",
                })
            else
                TriggerEvent('discord:antiCheat', "(possible cheater) Demande de salaire refusé **** : " .. user.prenom .. " " .. user.nom .. " (ID : " .. user.source .. ")") -- msg Discord
            end
        end
    end
end)
