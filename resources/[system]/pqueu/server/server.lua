local Config = {}
local initialisation = false
Config.RequireSteam = true
Config.PriorityOnly = false -- whitelist only server
Config.Priority = {}

Config.IsBanned = function(src, callback)
    callback(false) -- not banned
    -- or callback(true, "reason") -- banned and the reason
end

-- easy localization
Config.Language = {
    joining = "🛫 Voyage vers Trium RP 🛫",
    connecting = "Connexion...",
    err = "Error: Impossible de retrouver votre ID.",
    _err = "Une erreur est survenue",
    pos = "🛩️ Vous êtes %d/%d en attente d'un avion ! 👯",
    connectingerr = "Impossible de vous ajouter dans la file d'attente",
    banned = "Vous êtes bannis, vous pouvez passer sur Discord pour en discuter (discord.me/trium) | Raison: %s",
    steam = "Erreur : Steam doit étre lancé.",
    prio = "Serveur Whitelisté. discord.me/trium"
}
-----------------------------------------------------------------------------------------------------------------------

local Queue = {}
Queue.QueueList = {}
Queue.PlayerList = {}
Queue.PlayerCount = 0
Queue.Priority = {}
Queue.Connecting = {}
Queue.ThreadCount = 0

local debug = true
local displayQueue = false
local initHostName = false
local maxPlayers = 32
--
local bridePolicier = true
local brideAmbulancier = true
local brideEguale = true
local brideReset = true
--
local tostring = tostring
local tonumber = tonumber
local ipairs = ipairs
local pairs = pairs
local print = print
local string_sub = string.sub
local string_format = string.format
local string_lower = string.lower
local math_abs = math.abs
local math_floor = math.floor
local os_time = os.time
local table_insert = table.insert
local table_remove = table.remove

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(900000)
        nbPolicier = exports["c_services"]:GetPoliceConnected()
        nbAmbulancier = exports["c_services"]:GetAmbuConnected()
        TriggerEvent("discord:attente", "Il y a actuellement : " .. Queue.PlayerCount .. " connectés | " .. Queue:GetSize() .. " en attente | " .. nbPolicier .. " policiers | " .. nbAmbulancier .. " ambulanciers")
    end
end)

Citizen.CreateThread(function ()
    if(initialisation == false) then
        -- Début de l'initialisation de base
        Citizen.Wait(1000)
        local identifier_prios = MySQL.Sync.fetchAll("SELECT identifier,job,donateur,permission_level,vip FROM users")
        for k, v in pairs(identifier_prios) do
            if(v.vip == 1) then
                if(v.permission_level > 0) then -- STAFF ID
                    if(Config.Priority[v.identifier] == nil) then
                        Config.Priority[v.identifier] = 100
                    end
                elseif(v.job == 15) then -- LSES ID
                    if(Config.Priority[v.identifier] == nil) then
                        Config.Priority[v.identifier] = 95
                    end
                elseif(v.job == 2) then -- LSPD ID
                    if(Config.Priority[v.identifier] == nil) then
                        Config.Priority[v.identifier] = 90
                    end
                elseif(v.donateur == 1) then -- DONATEUR ID
                    if(Config.Priority[v.identifier] == nil) then
                        Config.Priority[v.identifier] = 85
                    end
                else
                    if(Config.Priority[v.identifier] == nil) then
                        Config.Priority[v.identifier] = 80
                    end
                end
            end
        end
        -- TOTAL JOUEURS PRIORITAIRES
        local vartot = 0
        for k, v in pairs(Config.Priority) do
            vartot = vartot + 1
        end
        print('Nombre de joueurs traités :' .. vartot)
        for k, v in pairs(Config.Priority) do
            Queue.Priority[string_lower(k)] = v
        end
    end
    --Citizen.Wait(2000)
    initialisation = true
    -- Lancement du rafraichissement des priorités
    refreshPriorityPlayers()
end)

function refreshPriorityPlayers()
    Citizen.CreateThread(function ()
        while true do
            Citizen.Wait(120000)
            --
            print("Rafraichissement des priorités")
            -- Initialisation des Int
            local nbPolicier = 0
            local nbAmbulancier = 0
            local max_policier = 4
            local max_lses = 3

            nbPolicier = exports["c_services"]:GetPoliceConnected()
            nbAmbulancier = exports["c_services"]:GetAmbuConnected()
            --[[ Vérification de tous les joueurs connectés
            local users_connected = exports["essentialmode"]:getAllPlayerConnected()
        for k,v in pairs(users_connected) do
            if v.jobId == 2 then
                nbPolicier = nbPolicier + 1
            end
            if v.jobId == 15 then
            nbAmbulancier = nbAmbulancier + 1
            end
        end
    ]]-- Messages
            print("PQUEU : Il y a " .. nbPolicier .. " Policiers connectés")
            print("PQUEU : Il y a " .. nbAmbulancier .. " Ambulanciers connectés")
            Citizen.Wait(2000)
            -- Changement des priorités
            if(nbPolicier > max_policier and nbAmbulancier > max_lses) then
                if(brideEguale) then
                    --
                    brideEguale = false
                    brideReset = true
                    bridePolicier = true
                    brideAmbulancier = true
                    --
                    print("PQUEU [Changement des priorités] : Trop de Policiers ET d'Ambulanciers")
                    refreshJobQueuePriority(0)
                end
            elseif(nbPolicier < max_policier and nbAmbulancier < max_lses) then
                if(brideReset) then
                    --
                    brideEguale = true
                    brideReset = false
                    bridePolicier = true
                    brideAmbulancier = true
                    --
                    print("PQUEU [Changement des priorités] : Pas assez de Policiers et d'Ambulanciers")
                    refreshJobQueuePriority(-1)
                end
            elseif(nbPolicier > max_policier and nbAmbulancier < max_lses) then
                if(bridePolicier) then
                    --
                    brideEguale = true
                    brideReset = true
                    bridePolicier = false
                    brideAmbulancier = true
                    --
                    print("PQUEU [Changement des priorités] : Trop de Policiers")
                    refreshJobQueuePriority(2)
                end
            elseif(nbAmbulancier > max_lses and nbPolicier < max_policier) then
                if(brideAmbulancier) then
                    --
                    brideEguale = true
                    brideReset = true
                    bridePolicier = true
                    brideAmbulancier = false
                    --
                    print("PQUEU [Changement des priorités] : Trop d'Ambulanciers")
                    refreshJobQueuePriority(15)
                end
            end
            if not brideReset then print("PQUEU [Bride en cours] : Pas assez d'Ambulanciers et de Policiers")
            elseif not brideEguale then print("PQUEU [Bride en cours] : Trop de Policiers et d'Ambulanciers")
            elseif not brideAmbulancier then print("PQUEU [Bride en cours] : Trop d'Ambulanciers")
            elseif not bridePolicier then print("PQUEU [Bride en cours] : Trop de Policiers")
            end
        end
    end)
end

function refreshJobQueuePriority(jobID)
    local identifier_prios = MySQL.Sync.fetchAll("SELECT identifier,job,donateur,permission_level,vip FROM users")
    if(refreshJobQueuePriority == 0) then -- TROP DES DEUX
        for k, v in pairs(identifier_prios) do
            if(v.vip == 1) then
                if(v.job == 15) then -- LSES ID
                    if(v.permission_level == 0 and v.donateur == 0) then
                        self.Priority[string_lower(v.identifier)] = 80
                    end
                end
                if(v.job == 2) then -- LSPD ID
                    if(v.permission_level == 0 and v.donateur == 0) then
                        self.Priority[string_lower(v.identifier)] = 80
                    end
                end
            end
        end
    elseif(refreshJobQueuePriority == -1) then -- AUCUN DES DEUX
        for k, v in pairs(identifier_prios) do
            if(v.vip == 1) then
                if(v.job == 15) then -- LSES ID
                    if(v.permission_level == 0 and v.donateur == 0) then
                        self.Priority[string_lower(v.identifier)] = 95
                    end
                end
                if(v.job == 2) then -- LSPD ID
                    if(v.permission_level == 0 and v.donateur == 0) then
                        self.Priority[string_lower(v.identifier)] = 90
                    end
                end
            end
        end
    elseif(refreshJobQueuePriority == 2) then -- TROP DE POLICIERS
        for k, v in pairs(identifier_prios) do
            if(v.vip == 1) then
                if(v.job == 15) then -- LSES ID
                    if(v.permission_level == 0 and v.donateur == 0) then
                        self.Priority[string_lower(v.identifier)] = 95
                    end
                end
                if(v.job == 2) then -- LSPD ID
                    if(v.permission_level == 0 and v.donateur == 0) then
                        self.Priority[string_lower(v.identifier)] = 80
                    end
                end
            end
        end
    elseif(refreshJobQueuePriority == 15) then -- TROP D'AMBULANCIERS
        for k, v in pairs(identifier_prios) do
            if(v.vip == 1) then
                if(v.job == 15) then -- LSES ID
                    if(v.permission_level == 0 and v.donateur == 0) then
                        self.Priority[string_lower(v.identifier)] = 80
                    end
                end
                if(v.job == 2) then -- LSPD ID
                    if(v.permission_level == 0 and v.donateur == 0) then
                        self.Priority[string_lower(v.identifier)] = 90
                    end
                end
            end
        end
    end
end

-- converts hex steamid to SteamID 32
function Queue:HexIdToSteamId(hexId)
    local cid = math_floor(tonumber(string_sub(hexId, 7), 16))
    local steam64 = math_floor(tonumber(string_sub(cid, 2)))
    local a = steam64 % 2 == 0 and 0 or 1
    local b = math_floor(math_abs(6561197960265728 - steam64 - a) / 2)
    local sid = "steam_0:"..a..":" .. (a == 1 and b - 1 or b)
    return sid
end

function Queue:IsSteamRunning(src)
    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 5) == "steam" then
            return true
        end
    end

    return false
end

function Queue:DebugPrint(msg)
    if debug then
        msg = "QUEUE: " .. tostring(msg)
        print(msg)
    end
end

function Queue:IsInQueue(ids, rtnTbl, bySource, connecting)
    for k, v in ipairs(connecting and self.Connecting or self.QueueList) do
        local inQueue = false

        if not bySource then
            for i, j in ipairs(v.ids) do
                if inQueue then break end

                for q, e in ipairs(ids) do
                    if e == j then inQueue = true break end
                end
            end
        else
            inQueue = ids == v.source
        end

        if inQueue then
            if rtnTbl then
                return k, connecting and self.Connecting[k] or self.QueueList[k]
            end

            return true
        end
    end

    return false
end

function Queue:IsPriority(ids)
    for k, v in ipairs(ids) do
        v = string_lower(v)

        if string_sub(v, 1, 5) == "steam" and not self.Priority[v] then
            local steamid = self:HexIdToSteamId(v)
            if self.Priority[steamid] then return self.Priority[steamid] ~= nil and self.Priority[steamid] or false end
        end

        if self.Priority[v] then return self.Priority[v] ~= nil and self.Priority[v] or false end
    end
end

function Queue:AddToQueue(ids, connectTime, name, src, deferrals)
    if self:IsInQueue(ids) then return end

    local tmp = {
        source = src,
        ids = ids,
        name = name,
        firstconnect = connectTime,
        priority = self:IsPriority(ids) or (src == "debug" and math.random(0, 15)),
        timeout = 0,
        deferrals = deferrals
    }

    local _pos = false
    local queueCount = self:GetSize() + 1

    for k, v in ipairs(self.QueueList) do
        if tmp.priority then
            if not v.priority then
                _pos = k
            else
                if tmp.priority > v.priority then
                    _pos = k
                end
            end

            if _pos then
                self:DebugPrint(string_format("%s[%s] was prioritized and placed %d/%d in queue", tmp.name, ids[1], _pos, queueCount))
                break
            end
        end
    end

    if not _pos then
        _pos = self:GetSize() + 1
        self:DebugPrint(string_format("%s[%s] was placed %d/%d in queue", tmp.name, ids[1], _pos, queueCount))
    end

    table_insert(self.QueueList, _pos, tmp)
end

function Queue:RemoveFromQueue(ids, bySource)
    if self:IsInQueue(ids, false, bySource) then
        local pos, data = self:IsInQueue(ids, true, bySource)
        table_remove(self.QueueList, pos)
    end
end

function Queue:GetSize()
    return #self.QueueList
end

function Queue:ConnectingSize()
    return #self.Connecting
end

function Queue:IsInConnecting(ids, bySource, refresh)
    local inConnecting, tbl = self:IsInQueue(ids, refresh and true or false, bySource and true or false, true)

    if not inConnecting then return false end

    if refresh and inConnecting and tbl then
        self.Connecting[inConnecting].timeout = 0
    end

    return true
end

function Queue:RemoveFromConnecting(ids, bySource)
    for k, v in ipairs(self.Connecting) do
        local inConnecting = false

        if not bySource then
            for i, j in ipairs(v.ids) do
                if inConnecting then break end

                for q, e in ipairs(ids) do
                    if e == j then inConnecting = true break end
                end
            end
        else
            inConnecting = ids == v.source
        end

        if inConnecting then
            table_remove(self.Connecting, k)
            return true
        end
    end

    return false
end

function Queue:AddToConnecting(ids, ignorePos, autoRemove, done)
    local function removeFromQueue()
        if not autoRemove then return end

        done(Config.Language.connectingerr)
        self:RemoveFromConnecting(ids)
        self:RemoveFromQueue(ids)
        self:DebugPrint("Player could not be added to the connecting list")
    end

    if self:ConnectingSize() >= 5 then removeFromQueue() return false end
    if ids[1] == "debug" then
        table_insert(self.Connecting, {source = ids[1], ids = ids, name = ids[1], firstconnect = ids[1], priority = ids[1], timeout = 0})
        return true
    end

    if self:IsInConnecting(ids) then self:RemoveFromConnecting(ids) end

    local pos, data = self:IsInQueue(ids, true)
    if not ignorePos and (not pos or pos > 1) then removeFromQueue() return false end

    table_insert(self.Connecting, data)
    self:RemoveFromQueue(ids)
    return true
end

function Queue:GetIds(src)
    local ids = GetPlayerIdentifiers(src)
    ids = (ids and ids[1]) and ids or {"ip:" .. GetPlayerEP(src)}
    ids = ids ~= nil and ids or false

    if ids and #ids > 1 then
        for k, v in ipairs(ids) do
            if string.sub(v, 1, 3) == "ip:" then table_remove(ids, k) end
        end
    end

    return ids
end

function Queue:AddPriority(id, power)
    if not id then return false end

    if type(id) == "table" then
        for k, v in pairs(id) do
            if k and type(k) == "string" and v and type(v) == "number" then
                self.Priority[k] = v
            else
                self:DebugPrint("Error adding a priority id, invalid data passed")
                return false
            end
        end

        return true
    end

    power = (power and type(power) == "number") and power or 10
    self.Priority[string_lower(id)] = power

    return true
end

function Queue:RemovePriority(id)
    if not id then return false end
    self.Priority[id] = nil
    return true
end

function Queue:UpdatePosData(src, ids, deferrals)
    local pos, data = self:IsInQueue(ids, true)
    self.QueueList[pos].source = src
    self.QueueList[pos].ids = ids
    self.QueueList[pos].timeout = 0
    self.QueueList[pos].deferrals = deferrals
end

function Queue:NotFull(firstJoin)
    local canJoin = self.PlayerCount + self:ConnectingSize() < maxPlayers and self:ConnectingSize() < 5
    canJoin = firstJoin and (self:GetSize() <= 1 and canJoin) or canJoin
    return canJoin
end

function Queue:SetPos(ids, newPos)
    local pos, data = self:IsInQueue(ids, true)

    table_remove(self.QueueList, pos)
    table_insert(self.QueueList, newPos, data)

    Queue:DebugPrint("Set " .. data.name .. "[" .. data.ids[1] .. "] pos to " .. newPos)
end

-- export
function AddPriority(id, power)
    return Queue:AddPriority(id, power)
end

-- export
function RemovePriority(id)
    return Queue:RemovePriority(id)
end

Citizen.CreateThread(function()
    local function playerConnect(name, setKickReason, deferrals)
        debug = GetConvar("sv_debugqueue", "true") == "true" and true or false
        displayQueue = GetConvar("sv_displayqueue", "true") == "true" and true or false
        initHostName = not initHostName and GetConvar("sv_hostname") or initHostName

        local src = source
        local ids = Queue:GetIds(src)
        local connectTime = os_time()
        local connecting = true

        deferrals.defer()

        Citizen.CreateThread(function()
            while connecting do
                Citizen.Wait(500)
                if not connecting then return end
                deferrals.update(Config.Language.connecting)
            end
        end)

        Citizen.Wait(1000)

        local function done(msg)
            connecting = false
            if not msg then deferrals.done() else deferrals.done(tostring(msg) and tostring(msg) or "") CancelEvent() end
        end

        local function update(msg)
            connecting = false
            deferrals.update(tostring(msg) and tostring(msg) or "")
        end

        if not ids then
            -- prevent joining
            done(Config.Language.err)
            CancelEvent()
            Queue:DebugPrint("Dropped " .. name .. ", couldn't retrieve any of their id's")
            return
        end

        if Config.RequireSteam and not Queue:IsSteamRunning(src) then
            done(Config.Language.steam)
            CancelEvent()
            return
        end

        local banned

        Config.IsBanned(src, function(_banned, _reason)
            banned = _banned
            _reason = _reason and tostring(_reason) or ""

            if _banned then
                local msg = string_format(Config.Language.banned, tostring(_reason))
                done(msg)

                Queue:RemoveFromQueue(ids)
                Queue:RemoveFromConnecting(ids)
            end
        end)

        while banned == nil do Citizen.Wait(1) end
        if banned then CancelEvent() return end

        local reason = "You were kicked from joining the queue"

        local function setReason(msg)
            reason = tostring(msg)
        end

        TriggerEvent("queue:playerJoinQueue", src, setReason)

        if WasEventCanceled() then
            done(reason)

            Queue:RemoveFromQueue(ids)
            Queue:RemoveFromConnecting(ids)

            CancelEvent()
            return
        end

        if Config.PriorityOnly and not Queue:IsPriority(ids) then done(Config.Language.prio) return end

        local rejoined = false

        if Queue:IsInQueue(ids) then
            rejoined = true
            Queue:UpdatePosData(src, ids, deferrals)
            Queue:DebugPrint(string_format("%s[%s] has rejoined queue after cancelling", name, ids[1]))
        else
            Queue:AddToQueue(ids, connectTime, name, src, deferrals)
        end

        if Queue:IsInConnecting(ids, false, true) then
            Queue:RemoveFromConnecting(ids)

            if Queue:NotFull() then
                local added = Queue:AddToConnecting(ids, true, true, done)
                if not added then CancelEvent() return end

                done()

                return
            else
                Queue:AddToQueue(ids, connectTime, name, src, deferrals)
                Queue:SetPos(ids, 1)
            end
        end

        local pos, data = Queue:IsInQueue(ids, true)

        if not pos or not data then
            done(Config.Language._err .. "[3]")

            RemoveFromQueue(ids)
            RemoveFromConnecting(ids)

            CancelEvent()
            return
        end

        if Queue:NotFull(true) then
            -- let them in the server
            local added = Queue:AddToConnecting(ids, true, true, done)
            if not added then CancelEvent() return end

            done()
            Queue:DebugPrint(name .. "[" .. ids[1] .. "] is loading into the server")

            return
        end

        update(string_format(Config.Language.pos, pos, Queue:GetSize()))

        Citizen.CreateThread(function()
            if rejoined then return end

            Queue.ThreadCount = Queue.ThreadCount + 1
            local dotCount = 0
            while true do
                Citizen.Wait(1000)

                local dots = ""
                dotCount = dotCount + 1
                if dotCount > 3 then dotCount = 0 end

                -- hopefully people will notice this and realize they don't have to keep reconnecting...
                for i = 1, dotCount do dots = dots .. "." end

local pos, data = Queue:IsInQueue(ids, true)


                -- will return false if not in queue; timed out?
                if not pos or not data then
                    if data and data.deferrals then data.deferrals.done(Config.Language._err) end
                    CancelEvent()
                    Queue:RemoveFromQueue(ids)
                    Queue:RemoveFromConnecting(ids)
                    Queue.ThreadCount = Queue.ThreadCount - 1
                    return
                end

                if pos <= 1 and Queue:NotFull() then
                    -- let them in the server
                    local added = Queue:AddToConnecting(ids)

                    data.deferrals.update(Config.Language.joining)
                    Citizen.Wait(500)

                    if not added then
                        data.deferrals.done(Config.Language.connectingerr)
                        CancelEvent()
                        Queue.ThreadCount = Queue.ThreadCount - 1
                        return
                    end

                    data.deferrals.done()

                    Queue:RemoveFromQueue(ids)
                    Queue.ThreadCount = Queue.ThreadCount - 1
                    Queue:DebugPrint(name .. "[" .. ids[1] .. "] is loading into the server")

                    return
                end
                -- send status update
                local msg = string_format(Config.Language.pos .. "%s", pos, Queue:GetSize(), dots)
                data.deferrals.update(msg)
            end
        end)
    end

    AddEventHandler("playerConnecting", playerConnect)

    local function checkTimeOuts()
        local i = 1

        while i <= Queue:GetSize() do
            local data = Queue.QueueList[i]
            local lastMsg = GetPlayerLastMsg(data.source)

            if lastMsg == 0 or lastMsg >= 30000 then
                data.timeout = data.timeout + 1
            else
                data.timeout = 0
            end

            -- check just incase there is invalid data
            if not data.ids or not data.name or not data.firstconnect or data.priority == nil or not data.source then
                data.deferrals.done(Config.Language._err .. "[1]")
                table_remove(Queue.QueueList, i)
                Queue:DebugPrint(tostring(data.name) .. "[" .. tostring(data.ids[1]) .. "] was removed from the queue because it had invalid data")

            elseif (data.timeout >= 120) and data.source ~= "debug" and os_time() - data.firstconnect > 5 then
                -- remove by source incase they rejoined and were duped in the queue somehow
                data.deferrals.done(Config.Language._err .. "[2]")
                Queue:RemoveFromQueue(data.source, true)
                Queue:RemoveFromConnecting(data.source, true)
                Queue:DebugPrint(data.name .. "[" .. data.ids[1] .. "] was removed from the queue because they timed out")
            else
                i = i + 1
            end
        end

        i = 1

        while i <= Queue:ConnectingSize() do
            local data = Queue.Connecting[i]

            local lastMsg = GetPlayerLastMsg(data.source)

            data.timeout = data.timeout + 1

            if ((data.timeout >= 300 and lastMsg >= 35000) or data.timeout >= 340) and data.source ~= "debug" and os_time() - data.firstconnect > 5 then
                Queue:RemoveFromQueue(data.source, true)
                Queue:RemoveFromConnecting(data.source, true)
                Queue:DebugPrint(data.name .. "[" .. data.ids[1] .. "] was removed from the connecting queue because they timed out")
            else
                i = i + 1
            end
        end

        local qCount = Queue:GetSize()

        -- show queue count in server name
        --if displayQueue and initHostName then SetConvar("sv_hostname", (qCount > 0 and "[" .. tostring(qCount) .. "] " or "") .. initHostName) end

        SetTimeout(1000, checkTimeOuts)
    end

    checkTimeOuts()
end)

local function playerActivated()
    local src = source
    local ids = Queue:GetIds(src)

    if not Queue.PlayerList[src] then
        Queue.PlayerCount = Queue.PlayerCount + 1
        Queue.PlayerList[src] = true
        Queue:RemoveFromQueue(ids)
        Queue:RemoveFromConnecting(ids)
    end
end

RegisterServerEvent("Queue:playerActivated")
AddEventHandler("Queue:playerActivated", playerActivated)

local function playerDropped()
    local src = source
    local ids = Queue:GetIds(src)

    if Queue.PlayerList[src] then
        Queue.PlayerCount = Queue.PlayerCount - 1
        Queue.PlayerList[src] = nil
        Queue:RemoveFromQueue(ids)
        Queue:RemoveFromConnecting(ids)
    end
end

AddEventHandler("playerDropped", playerDropped)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if exports and exports.connectqueue then TriggerEvent("queue:onReady") return end
    end
end)

-- debugging / testing commands
local testAdds = 0

AddEventHandler("rconCommand", function(command, args)
    -- adds a fake player to the queue for debugging purposes, this will freeze the queue
    if command == "addq" then
        print("==ADDED FAKE QUEUE==")
        Queue:AddToQueue({"steam:110000103fd1bb1"..testAdds}, os_time(), "Fake Player", "debug")
        testAdds = testAdds + 1
        CancelEvent()

        -- removes targeted id from the queue
    elseif command == "removeq" then
        if not args[1] then return end
        print("REMOVED " .. Queue.QueueList[tonumber(args[1])].name .. " FROM THE QUEUE")
        table_remove(Queue.QueueList, args[1])
        CancelEvent()

        -- print the current queue list
    elseif command == "printq" then
        print("==CURRENT QUEUE LIST==")
        for k, v in ipairs(Queue.QueueList) do
            print(k .. ": [src: " .. v.source .. "] " .. v.name .. "[" .. v.ids[1] .. "] | Priority: " .. (tostring(v.priority and true or false)) .. " | Last Msg: " .. (v.source ~= "debug" and GetPlayerLastMsg(v.source) or "debug") .. " | Timeout: " .. v.timeout)
        end
        CancelEvent()

        -- adds a fake player to the connecting list
    elseif command == "addc" then
        print("==ADDED FAKE CONNECTING QUEUE==")
        Queue:AddToConnecting({"debug"})
        CancelEvent()

        -- removes a player from the connecting list
    elseif command == "removec" then
        print("==REMOVED FAKE CONNECTING QUEUE==")
        if not args[1] then return end
        table_remove(Queue.Connecting, args[1])
        CancelEvent()

        -- prints a list of players that are connecting
    elseif command == "printc" then
        print("==CURRENT CONNECTING LIST==")
        for k, v in ipairs(Queue.Connecting) do
            print(k .. ": [src: " .. v.source .. "] " .. v.name .. "[" .. v.ids[1] .. "] | Priority: " .. (tostring(v.priority and true or false)) .. " | Last Msg: " .. (v.source ~= "debug" and GetPlayerLastMsg(v.source) or "debug") .. " | Timeout: " .. v.timeout)
        end
        CancelEvent()

        -- prints a list of activated players
    elseif command == "printl" then
        for k, v in pairs(Queue.PlayerList) do
            print(k .. ": " .. tostring(v))
        end
        CancelEvent()

        -- prints a list of priority id's
    elseif command == "printp" then
        print("==CURRENT PRIORITY LIST==")
        for k, v in pairs(Queue.Priority) do
            print(k .. ": " .. tostring(v))
        end
        CancelEvent()

        -- prints the current player count
    elseif command == "printcount" then
        print("Player Count: " .. Queue.PlayerCount)
        CancelEvent()

    elseif command == "printt" then
        print("Thread Count: " .. Queue.ThreadCount)
        CancelEvent()
    end
end)

-- prevent duplicating queue count in server name
AddEventHandler("onResourceStop", function(resource)
    if displayQueue and resource == GetCurrentResourceName() then SetConvar("sv_hostname", initHostName) end
end)
