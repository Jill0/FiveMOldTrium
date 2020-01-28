local CurrentSolde = 0

RegisterServerEvent('entreprises:voiremploye')
AddEventHandler('entreprises:voiremploye', function(Job_ID)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if(user.jobId == Job_ID and Job_ID == 2) then
            MySQL.Async.fetchAll("SELECT id,users.identifier,nom,prenom,job,leader,police.rank FROM users LEFT JOIN police on users.identifier = police.identifier WHERE job = @job_id ", {['@job_id'] = Job_ID}, function (result)
                if (result) then
                    TriggerClientEvent("entreprises:voirlisteemploye", user.source, result)
                end
            end)
        else
            MySQL.Async.fetchAll("SELECT id,nom,prenom,job,leader FROM users WHERE job = @job_id", {['@job_id'] = Job_ID}, function (result)
                if (result) then
                    TriggerClientEvent("entreprises:voirlisteemploye", user.source, result)
                end
            end)
        end
    end)


    RegisterServerEvent('entreprises:licencieremploye')
    AddEventHandler('entreprises:licencieremploye', function(Employ_ID)
        TriggerEvent('es:getPlayerFromId', source, function(user)
            MySQL.Async.execute('UPDATE users SET job = 1, leader = 0 WHERE id = @userid', {['@userid'] = Employ_ID})
            MySQL.Async.fetchScalar("SELECT identifier FROM users WHERE id = @userid", {['@userid'] = Employ_ID}, function (result)
                MySQL.Async.execute('DELETE FROM police WHERE identifier = @identifier', {['@identifier'] = result})
            end)
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = "Nous retirons votre ex-employé de nos dossiers.", 
            })
        end)
    end)

    RegisterServerEvent('entreprises:accesCoffre')
    AddEventHandler('entreprises:accesCoffre', function(accesCoffre)
        TriggerEvent('es:getPlayerFromId', source, function(user)
            if(accesCoffre.toggle == 1) then
                MySQL.Async.execute('UPDATE users SET leader = 1 WHERE id = @userid', {['@userid'] = accesCoffre.idemp})
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Nous ~g~ajoutons ~w~l'accés au coffre pour cet employé.", 
                })
            else
                MySQL.Async.execute('UPDATE users SET leader = 0 WHERE id = @userid', {['@userid'] = accesCoffre.idemp})
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Nous ~r~retirons ~w~l'accés au coffre pour cet employé", 
                })
            end
        end)
    end)

    --Cadet, Officier, Brigadier, Sergent, Lieutenant, Capitaine, Commandant
    RegisterServerEvent('entreprises:modifgradepolice')
    AddEventHandler('entreprises:modifgradepolice', function(num)
        MySQL.Async.fetchAll("SELECT users.identifier,nom,prenom,police.rank FROM users LEFT JOIN police on users.identifier = police.identifier WHERE id = @id", {['@id'] = num}, function (result)
            if(result[1].rank == "Recrue") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Cadet", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Cadet !")
            elseif(result[1].rank == "Cadet") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Officier", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Officier !")
            elseif(result[1].rank == "Officier") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Brigadier", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Brigadier !")
            elseif(result[1].rank == "Brigadier") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Sergent", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Sergent !")
            elseif(result[1].rank == "Sergent") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Lieutenant", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Lieutenant !")
            elseif(result[1].rank == "Lieutenant") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Capitaine", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Capitaine !")
            elseif(result[1].rank == "Capitaine") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Commandant", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Commandant !")
            end
        end)
    end)

    --Cadet, Officier, Brigadier, Sergent, Lieutenant, Capitaine, Commandant
    RegisterServerEvent('entreprises:modifgradepoliceretro')
    AddEventHandler('entreprises:modifgradepoliceretro', function(num)
        MySQL.Async.fetchAll("SELECT users.identifier,nom,prenom,police.rank FROM users LEFT JOIN police on users.identifier = police.identifier WHERE id = @id", {['@id'] = num}, function (result)
            if(result[1].rank == "Recrue") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Cadet", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Cadet !")
            elseif(result[1].rank == "Officier") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Cadet", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Cadet !")
            elseif(result[1].rank == "Brigadier") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Officier", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Officier !")
            elseif(result[1].rank == "Sergent") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Brigadier", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Brigadier !")
            elseif(result[1].rank == "Lieutenant") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Sergent", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Sergent !")
            elseif(result[1].rank == "Capitaine") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Lieutenant", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Lieutenant !")
            elseif(result[1].rank == "Commandant") then
                MySQL.Async.execute('UPDATE police SET rank = @newrank WHERE identifier = @identifier', {['@newrank'] = "Capitaine", ['@identifier'] = result[1].identifier})
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Trésorerie", false, "[" .. result[1].rank .. "] "..result[1].nom.. " " .. result[1].prenom .. " est maintenant : Capitaine !")
            end
        end)
    end)
end)
RegisterServerEvent('entreprises:updateaftersell')
AddEventHandler('entreprises:updateaftersell', function(newsolde)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        MySQL.Async.execute('UPDATE entreprises_coffres SET solde = solde + @nouveausolde WHERE job_id = @jobid', {['@nouveausolde'] = newsolde, ['@jobid'] = user.jobId})
    end)
end)

function removeCoffre(jobid, player, prixajoute)
    MySQL.Async.execute('UPDATE entreprises_coffres SET solde = solde - @prixadd WHERE job_id = @jobid', {['@prixadd'] = prixajoute, ['@jobid'] = jobid})
end

function addCoffre(jobid, player, prixajoute)
    MySQL.Async.execute('UPDATE entreprises_coffres SET solde = solde + @prixadd WHERE job_id = @jobid', {['@prixadd'] = prixajoute, ['@jobid'] = jobid})
end

function GetSolde()
    return CurrentSolde
end

RegisterServerEvent('entreprises:showsolde')
AddEventHandler('entreprises:showsolde', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        MySQL.Async.fetchScalar('SELECT solde FROM entreprises_coffres WHERE job_id = @jobid', {['@jobid'] = user.jobId}, function (result)
            CurrentSolde = result
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = "Solde restant : "..tostring(CurrentSolde) .. "~g~€", 
            })
        end)
    end)
end)

RegisterServerEvent('entreprises:recruteremp')
AddEventHandler('entreprises:recruteremp', function(result, jobId)
    if(GetPlayerName(tonumber(result)) ~= nil) then
        local player = tonumber(result)
        TriggerEvent('es:getPlayerFromId', player, function(target)
            if(target.jobId ~= jobId) then
                TriggerClientEvent('metiers:jobadmintriumnontuv', player, jobId)
                TriggerClientEvent('chatMessage', target.source, 'GOUVERNEMENT', {255, 0, 0}, "C'est bon, il est dans votre métier !")
            else
                TriggerClientEvent('chatMessage', target.source, 'GOUVERNEMENT', {255, 0, 0}, "Cette personne est déjà dans votre entreprise.")
            end
        end)
    else
        TriggerClientEvent('chatMessage', source, 'GOUVERNEMENT', {255, 0, 0}, "Cet ID n'existe pas !")
    end
end)

RegisterServerEvent('entreprises:getsolde')
AddEventHandler('entreprises:getsolde', function(Job_ID)
        MySQL.Async.fetchScalar('SELECT solde FROM entreprises_coffres WHERE job_id = @jobid', {['@jobid'] = Job_ID}, function (result)
            CurrentSolde = result
            return CurrentSolde
    end)
end)

RegisterServerEvent('entreprises:gererpartage')
AddEventHandler('entreprises:gererpartage', function(ajout, Job_ID)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if (user.jobId == Job_ID and ajout ~= nil) then
            local ajout = tonumber(ajout)
            if Job_ID == 23 then
                if ajout < 0 or ajout > 10 then
                    TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                        icon = "CHAR_BANK_MAZE", 
                        title = "Banque", 
                        text = "Vous ne pouvez pas mettre ce pourcentage ! Choisissez entre 0 et 10.", 
                    })
                else
                    MySQL.Async.execute('UPDATE entreprises_coffres SET percent = @newpercent WHERE job_id = @jobid', {['@newpercent'] = ajout, ['@jobid'] = Job_ID})
                    local partcoffre = 100 - ajout
                    TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                        icon = "CHAR_BANK_MAZE", 
                        title = "Banque", 
                        text = "Pourcentage de taxe modifié : ~g~" .. ajout .. "% ~w~ pour le Gouvernement et ~g~" .. partcoffre .. "% ~w~pour les entreprises !", 
                    })
                end
            elseif ajout < 20 or ajout > 80 then
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Vous ne pouvez pas mettre ce pourcentage ! Choisissez entre 20 et 80.", 
                })
            elseif Job_ID == 15 or Job_ID == 2 then
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Votre métier ne vous permet pas de modifier cette fonctionnalité !", 
                })
            else
                MySQL.Async.execute('UPDATE entreprises_coffres SET percent = @newpercent WHERE job_id = @jobid', {['@newpercent'] = ajout, ['@jobid'] = Job_ID})
                local partcoffre = 100 - ajout
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Pourcentage de gain modifié : ~ g ~ " .. ajout .. " % ~ w ~ pour l'employé et ~g~" .. partcoffre .. "% ~w~pour le coffre !", 
                })
            end
        else
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = "~r~Vous ne pouvez pas toucher à ce coffre !", 
            })
        end
    end)
end)

RegisterServerEvent('entreprises:sellpartage')
AddEventHandler('entreprises:sellpartage', function(montant)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local part_coffre = 0
        local montant_employe = 0
        local montant_gouv = 0
        if(montant > 0) then
            -- PART GOUVERNEMENT
            local resultaxe = MySQL.Sync.fetchAll('SELECT percent FROM entreprises_coffres WHERE job_id = 23')
            if(resultaxe) then
                montant_gouv = math.floor((montant * resultaxe[1].percent) / 100)
            else
                montant_gouv = math.floor((montant * 4) / 100)
            end

            montant = montant - montant_gouv -- Nouveau montant = motant total - part gouvernement
            --

            -- PART EMPLOYE
            local resultemploye = MySQL.Sync.fetchAll('SELECT percent FROM entreprises_coffres WHERE job_id = @jobid', {['@jobid'] = user.jobId})
            if (resultemploye) then
                montant_employe = math.floor((montant * resultemploye[1].percent) / 100)
            else
                montant_employe = math.floor((montant * 77) / 100)
            end

            if (user.jobId ~= 2) then
                user.func.addMoney(montant_employe)
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Votre part : "..montant_employe.." ~ g ~ $", 
                })
            end
            --

            -- PART COFFRE METIER
            part_coffre = math.floor(montant - montant_employe)
            --
			if user.jobId ~= 28 then 
				-- PAIEMENT COFFRE METIER
				MySQL.Async.execute('UPDATE entreprises_coffres SET `solde` = solde + @montant WHERE job_id = @jobid', {['@montant'] = part_coffre, ['@jobid'] = user.jobId})
				--
				--PAIEMENT COFFRE GOUV
				MySQL.Async.execute('UPDATE entreprises_coffres SET `solde` = solde + @montant WHERE job_id = @jobid', {['@montant'] = montant_gouv, ['@jobid'] = 23})
				--
			else
			--PAIEMENT COFFRE GOUV
				MySQL.Async.execute('UPDATE entreprises_coffres SET `solde` = solde + @montant WHERE job_id = @jobid', {['@montant'] = (montant_gouv+part_coffre), ['@jobid'] = 23})
				--
			end
			
        end
    end)
end)

RegisterServerEvent('entreprises:selltaxe')
AddEventHandler('entreprises:selltaxe', function(cible, montant)
    local havemoney = false
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if user.money < montant then
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = "Pas assez d'argent", 
            })
            havemoney = false
        else
            user.func.removeMoney(tonumber(montant))
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = "Votre banque vous retire : "..montant.." ~ g ~ $", 
            })
            havemoney = true
        end
    end)
    TriggerEvent('es:getPlayerFromId', cible, function(user)
        local part_coffre = 0
        local montant_employe = 0
        local montant_gouv = 0
        if (montant > 0) and havemoney == true then
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = "Montant en cours de transaction : "..montant.." ~ g ~ $", 
            })
            -- PART GOUVERNEMENT
            local resultaxe = MySQL.Sync.fetchAll('SELECT percent FROM entreprises_coffres WHERE job_id = 23')
            if(resultaxe) then
                montant_gouv = math.floor((montant * resultaxe[1].percent) / 100)
            else
                montant_gouv = math.floor((montant * 4) / 100)
            end
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = "Taxe du Gouvernement : "..montant_gouv.." ~ g ~ $", 
            })
            montant = montant - montant_gouv -- Nouveau montant = motant total - part gouvernement
            --
            -- PART EMPLOYE
            local resultemploye = MySQL.Sync.fetchAll('SELECT percent FROM entreprises_coffres WHERE job_id = @jobid', {['@jobid'] = user.jobId})
            if (resultemploye) then
                montant_employe = math.floor((montant * resultemploye[1].percent) / 100)
            else
                montant_employe = math.floor((montant * 77) / 100)
            end
            --
            user.func.addMoney(montant_employe)
            --
            -- PART COFFRE METIER
            part_coffre = math.floor(montant - montant_employe)
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = "Retrait de la part entreprise : "..part_coffre.." ~ g ~ $", 
            })
            --
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = "Votre part : "..montant_employe.." ~ g ~ $", 
            })
            -- PAIEMENT COFFRE METIER
            MySQL.Async.execute('UPDATE entreprises_coffres SET `solde` = solde + @montant WHERE job_id = @jobid', {['@montant'] = part_coffre, ['@jobid'] = user.jobId})
            --
            --PAIEMENT COFFRE GOUV
            MySQL.Async.execute('UPDATE entreprises_coffres SET `solde` = solde + @montant WHERE job_id = @jobid', {['@montant'] = montant_gouv, ['@jobid'] = 23})
            --
        end
    end)
end)
--function UpdateSolde(prixtotal)
--CurrentSolde = prixtotal
--end

RegisterServerEvent('entreprises:ajoutsolde')
AddEventHandler('entreprises:ajoutsolde', function(ajout, Job_ID)
    TriggerEvent('es:getPlayerFromId', source, function(user)
	TriggerEvent("entreprises:getsolde")
        local player = user.identifier
        local jobid = user.jobId
        -- Here change id Job (allowed to withdraw/deposit )
        if (jobid == Job_ID) then
            local prixavant = GetSolde()
            local prixajoute = ajout
            local prixtotal = prixavant + prixajoute
            if((user.money - prixajoute) >= 0)then
                user.func.removeMoney(tonumber(prixajoute))
                addCoffre(jobid, player, prixajoute)
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Vous avez rajouté: "..prixajoute.." ~ g ~ $", 
                })
                --UpdateSolde(prixtotal)
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Nouveau solde : "..prixtotal.." ~ g ~ $", 
                })
            else
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = " ~ r ~ Vous n'avez pas assez d'argent !", 
                })
            end
        else
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = " ~ r ~ Vous ne pouvez pas toucher à ce coffre !", 
            })
        end
    end)
end)


RegisterServerEvent('entreprises:retirersolde')
AddEventHandler('entreprises:retirersolde', function(ajout, Job_ID)
    TriggerEvent('es:getPlayerFromId', source, function(user)
	TriggerEvent("entreprises:getsolde")
        local player = user.identifier
        local jobid = user.jobId
        -- Here change id Job (allowed to withdraw/deposit )
        if(jobid == Job_ID)then


            local prixavant = GetSolde()
            local prixenleve = ajout
            local prixtotal = prixavant - prixenleve
            
            
            if(prixtotal < -1)then
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "~ r ~ Transfert impossible !", 
                })
            else
                removeCoffre(jobid, player, prixenleve)
                user.func.addMoney(tonumber(prixenleve))
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Vous avez enlevé : "..prixenleve.." ~ r ~ $", 
                })
                --UpdateSolde(prixtotal)
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = "CHAR_BANK_MAZE", 
                    title = "Banque", 
                    text = "Nouveau solde : "..prixtotal.." ~ g ~ $", 
                })
            end
        else
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = "CHAR_BANK_MAZE", 
                title = "Banque", 
                text = " ~ r ~ Vous n'avez pas la permission!", 
            })
        end
    end)
end)













