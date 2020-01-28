--FX

-- HELPER FUNCTIONS
function bankBalance(player)
    return tonumber(MySQL.Sync.fetchScalar('SELECT bankbalance FROM users WHERE identifier = @name', {['@name'] = player}))
end

function numCompte(player)
    return tonumber(MySQL.Sync.fetchScalar('SELECT NumCompte FROM users WHERE identifier = @name', {['@name'] = player}))
end

function deposit(player, amount)
    local bankbalance = bankBalance(player)
    local new_balance = bankbalance + amount
    MySQL.Sync.execute('UPDATE users SET `bankbalance`=@value WHERE identifier = @identifier', {['@value'] = new_balance, ['@identifier'] = player})
end

function withdraw(player, amount)
    local bankbalance = bankBalance(player)
    local new_balance = bankbalance - amount
    MySQL.Sync.execute('UPDATE users SET `bankbalance`=@value WHERE identifier = @identifier', {['@value'] = new_balance, ['@identifier'] = player})
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.abs(math.floor(num * mult + 0.5) / mult)
end

function addsqlbank(numero, montant, ident)
    MySQL.Sync.execute('UPDATE users SET bankbalance = (bankbalance + @montant) WHERE `NumCompte` = @numcompte', {
        ['@numcompte'] = numero,
        ['@montant'] = montant
    })
end

-- Check Bank Balance
TriggerEvent('es:addCommand', 'checkbalance', function(source, args, user)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)

        TriggerClientEvent("ft_libs:AdvancedNotification", source, {
            icon = "CHAR_BANK_MAZE",
            title = "Maze Bank",
            text = "Votre solde actuel est de: " .. bankbalance .. "$",
        })

        TriggerClientEvent("banking:updateBalance", user.source, bankbalance)
    end)
end)

-- Bank Deposit
TriggerEvent('es:addCommand', 'deposit', function(source, args, user)
    local amount = ""
    local player = user.identifier
    for i=1,#args do
        amount = args[i]
    end
    TriggerClientEvent('bank:deposit', source, amount)
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount, charbank)

    TriggerEvent('es:getPlayerFromId', source, function(user)
        local rounded = round(tonumber(amount), 0)
        if(string.len(rounded) >= 9) then
            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = charbank.icon,
                title = charbank.titre,
                text = "~r~Montant trop grand",
            })
        else
            if(tonumber(rounded) <= tonumber(user.money)) then
                user.func.removeMoney((rounded))
				user.func.addBank((rounded))
                local player = user.identifier
                deposit(player, rounded)
                local new_balance = bankBalance(player)
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = charbank.icon,
                    title = charbank.titre,
                    text = "Dépot de ~g~".. rounded .."$",
                })
				sendDepot(rounded)
                TriggerClientEvent("banking:addBalance", user.source, rounded)
                TriggerClientEvent("banking:updateBalance", user.source, new_balance)
            else
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = charbank.icon,
                    title = charbank.titre,
                    text = "~r~Vous n'avez pas assez d'argent sur votre compte",
                })
            end
        end
    end)
end)

-- Bank Withdraw
TriggerEvent('es:addCommand', 'withdraw', function(source, args, user)
    local amount = ""
    local player = user.identifier
    for i=1,#args do
        amount = args[i]
    end
    TriggerClientEvent('bank:withdraw', source, amount)
end)

RegisterServerEvent('bank:triumAmend')
AddEventHandler('bank:triumAmend', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)
        withdraw(player, amount)
        local new_balance = bankBalance(player)
		user.func.removeBank((rounded))
        TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
            icon = "CHAR_BANK_MAZE",
            title = "Maze Bank",
            text = "Amende de ~r~" .. amount .. "$ ~s~payée",
        })

        TriggerClientEvent("banking:removeBalance", user.source, amount)
        TriggerClientEvent("banking:updateBalance", user.source, new_balance)
    end)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount, charbank)
    local mysource = source
    TriggerEvent('es:getPlayerFromId', mysource, function(user)
        local rounded = round(tonumber(amount), 0)
        if(string.len(rounded) >= 10) then

            TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                icon = charbank.icon,
                title = charbank.titre,
                text = "~r~Montant trop grand",
            })

        else
            local player = user.identifier
            local bankbalance = bankBalance(player)
            if(tonumber(rounded) <= tonumber(bankbalance)) then
                withdraw(player, rounded)
                user.func.addMoney((rounded))
				user.func.removeBank((rounded))
                local new_balance = bankBalance(player)
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = charbank.icon,
                    title = charbank.titre,
                    text = "Retrait de ~r~" .. rounded .. "$",
                })
				sendRetrait(rounded)
                TriggerClientEvent("banking:removeBalance", user.source, rounded)
                TriggerClientEvent("banking:updateBalance", user.source, new_balance)
            else
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                    icon = charbank.icon,
                    title = charbank.titre,
                    text = "~r~Vous n'avez pas assez d'argent sur votre compte",
                })
            end
        end
    end)
end)

-- Bank Transfer
RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(numcompte, amount, charbank)
	numcompte = tonumber(numcompte)
	if numcompte and numcompte >= 100000 and numcompte <= 999999 then
		local comptexist = MySQL.Sync.fetchScalar('SELECT Count(*) FROM users WHERE `NumCompte` = @numcompte', {
			['@numcompte'] = numcompte
		})
		if comptexist == 1 then
			local identifier = GetPlayerIdentifiers(source)[1]
			local mynumcompte = 0
			mynumcompte = MySQL.Sync.fetchScalar('SELECT NumCompte FROM users WHERE `identifier` = @identifier', {
				['@identifier'] = identifier
			})
			if mynumcompte ~= numcompte then
				TriggerEvent('es:getPlayerFromId', source, function(user)
					if amount ~= nil and amount ~= '' then
						local rounded = round(tonumber(amount), 0)
						if rounded > 49 then
							if(string.len(rounded) >= 10) then
                TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                  icon = charbank.icon,
                  title = charbank.titre,
                  text = "~r~Montant trop grand",
                })
								CancelEvent()
							else
								local player = user.identifier
								local bankbalance = bankBalance(player)
								if(tonumber(rounded) <= tonumber(bankbalance)) then
									withdraw(player, rounded)
									local new_balance = bankBalance(player)
                                    TriggerClientEvent("ft_libs:AdvancedNotification", user.source, {
                                        icon = charbank.icon,
                                        title = charbank.titre,
                                        text = "~g~Virement de " .. rounded .. "$ effectué avec succès !",
                                    })
									TriggerClientEvent("banking:removeBalance", user.source, rounded)
									TriggerClientEvent("banking:updateBalance", user.source, new_balance)
									user.func.removeBank(rounded)
									addsqlbank(numcompte, rounded, identifier)
									--
									compte_dest = MySQL.Sync.fetchAll('SELECT identifier,nom,prenom FROM users WHERE `NumCompte` = @numcompte', {
										['@numcompte'] = numcompte
									})
					            	MySQL.Async.execute("INSERT INTO transferts_joueurs (`expediteur`, `destinataire`, `montant`,`type`) VALUES (@expediteur, @destinataire, @montant, @type)",{
					                    ['@expediteur'] = user.prenom .. " " .. user.nom,
					                    ['@destinataire'] = compte_dest[1].prenom .. " " .. compte_dest[1].nom,
					                    ['@montant'] = rounded,
					                    ['@type'] = "Banque"
					                })
					            	--
					            	UpdateBankAccountNotification(compte_dest[1].identifier, rounded)
									CancelEvent()
								else
                                    TriggerClientEvent("ft_libs:AdvancedNotification", source, {
                                        icon = charbank.icon,
                                        title = charbank.titre,
                                        text = "~r~Vous n'avez pas assez d'argent sur votre compte",
                                    })
									CancelEvent()
								end
							end
						else
                            TriggerClientEvent("ft_libs:AdvancedNotification", source, {
                                icon = charbank.icon,
                                title = charbank.titre,
                                text = "~r~Un virement doit être de 50$ minimum",
                            })
							CancelEvent()
						end
					else
                        TriggerClientEvent("ft_libs:AdvancedNotification", source, {
                            icon = charbank.icon,
                            title = charbank.titre,
                            text =  "~r~Montant incorrect",
                        })
						CancelEvent()
					end
				end)
			else
                TriggerClientEvent("ft_libs:AdvancedNotification", source, {
                    icon = charbank.icon,
                    title = charbank.titre,
                    text = "~r~Vous ne pouvez pas faire de virement à vous-même",
                })
				CancelEvent()
			end
		else
            TriggerClientEvent("ft_libs:AdvancedNotification", source, {
                icon = charbank.icon,
                title = charbank.titre,
                text = "~r~Ce numéro de compte n'existe pas",
            })
			CancelEvent()
		end
	else
        TriggerClientEvent("ft_libs:Notification", source, {
            icon = charbank.icon,
            title = charbank.titre,
            text = "~r~Le numéro de compte a 6 chiffres",
        })
		CancelEvent()
	end
end)

function UpdateBankAccountNotification(identifiant,montant)
	 exports["essentialmode"]:getAllPlayerConnected(function(users_connected)
		for k,v in pairs(users_connected) do
			if(v.identifier == identifiant) then
        TriggerClientEvent("ft_libs:AdvancedNotification", v.source, {
          icon = "CHAR_BANK_MAZE",
          title = "Maze Bank",
          text = "Argent reçu en banque: ~g~".. montant,
        })
				local new_balance = bankBalance(v.identifier)
				TriggerClientEvent("banking:updateBalance", v.source, new_balance)
				TriggerClientEvent("gcPhone:getsolde", v.source, new_balance)
				break
			end
		end
	end)
end

RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
    local my_source = source
    TriggerEvent('es:getPlayerFromId', my_source, function(user)
        if (tonumber(user.money) >= tonumber(amount)) then
            local player = user.identifier
            user.func.removeMoney(amount)
            TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
                recipient.func.addMoney(amount)
				sendPropre(amount,recipient)
                TriggerClientEvent("ft_libs:Notification", user.source, "Argent donné: ~r~".. amount .."$ ~n~~s~Porte-feuille: " .. (user.money - amount) .. "$")
                TriggerClientEvent("ft_libs:Notification", recipient.source, "Argent reçu: ~g~".. amount .."$ ~n~~s~Porte-feuille: " .. (recipient.money + amount) .. "$")

            	MySQL.Async.execute("INSERT INTO transferts_joueurs (`expediteur`, `destinataire`, `montant`,`type`) VALUES (@expediteur, @destinataire, @montant, @type)",{
                    ['@expediteur'] = user.prenom .. " " .. user.nom,
                    ['@destinataire'] = recipient.prenom .. " " .. recipient.nom,
                    ['@montant'] = amount,
                    ['@type'] = "Main"
                })

            	end)
        else
            if (tonumber(user.money) < tonumber(amount)) then
                TriggerClientEvent('chatMessage', user.source, "", {0, 0, 200}, "^1Pas assez d'argent^0")
				CancelEvent()
            end
        end
    end)
end)

RegisterServerEvent('bank:givedirty')
AddEventHandler('bank:givedirty', function(toPlayer, amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if (tonumber(user.dirty_money) >= tonumber(amount)) then
            local player = user.identifier
            user.func.removeDirty_Money(amount)
            TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
                recipient.func.addDirty_Money(amount)
				sendSale(amount,recipient)
                TriggerClientEvent("ft_libs:Notification", source, "Argent sale donné: ~r~" .. amount .. " ~n~~s~Porte-feuille: " .. (user.dirty_money - amount) .. "$")
                TriggerClientEvent("ft_libs:Notification", toPlayer, "Argent sale reçu: ~g~" .. amount .. " ~n~~s~Porte-feuille: " .. (recipient.dirty_money + amount) .. "$")

            end)
        else
            if (tonumber(user.dirty_money) < tonumber(amount)) then
                TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent^0")
				CancelEvent()
            end
        end
    end)
end)

AddEventHandler('es:playerLoaded', function(source)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)
        local numcompte = numCompte(player)
        TriggerClientEvent("banking:initnumcompte", user.source, numcompte)
        TriggerClientEvent("banking:updateBalance", user.source, bankbalance)
    end)
end)
--################################################
--############### REPORT DISCORD #################
--################################################
--RegisterServerEvent('banking:DepotMsg')
--RegisterServerEvent('banking:RetraitMsg')
--RegisterServerEvent('banking:PropreMsg')
--RegisterServerEvent('banking:SaleMsg')

--AddEventHandler('banking:DepotMsg', function(montant)
function sendDepot(montant)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	TriggerEvent('discord:banking', "INFORMATION :chart_with_upwards_trend: **: **" .. user.nom .. " ".. user.prenom ..  "** a deposé **"..montant.."** $")
end

--AddEventHandler('banking:RetraitMsg', function(montant)
function sendRetrait(montant)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	TriggerEvent('discord:banking', "INFORMATION :chart_with_downwards_trend: **: **" .. user.nom .. " ".. user.prenom ..  "** a retiré **"..montant.."** $")
end
function sendPropre(montant,destinataire)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	TriggerEvent('discord:banking', "INFORMATION :dollar: **: **" .. user.nom .. " ".. user.prenom ..  "** a donné **"..montant.."** $ d'argent propre à **"..destinataire.nom.." "..destinataire.prenom.."**")
end
function sendSale(montant,destinataire)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	TriggerEvent('discord:banking', "INFORMATION :yen: **: **" .. user.nom .. " ".. user.prenom ..  "** a donné **"..montant.."** $ d'argent propre à **"..destinataire.nom.." "..destinataire.prenom.."**")
end
