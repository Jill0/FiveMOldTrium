--
-- @Project: Trium
-- @License: No License
--

--
-- Vars
--
local WeebHookTest = "https://discordapp.com/api/webhooks/445204928781221898/6bSs14aMGvEitQjgk_z-R_KzExDQjB4Q8ali6c3vnN3VnoYAEQCZ7LQmaFsIFfZcB1O6"

--
-- Get current time
--
function getTime()
    local date = os.date('*t')

    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

    local return_date = {day = date.day, month = date.month, hour = date.hour, min = date.min, sec = date.sec, year = date.year}
    return return_date
end

--
--	Send message to discord
--
function sendToDiscord(webHook, message)

	if message ~= nil and message ~= "" then
		local date = getTime()
        local serverName = GetConvar("current_server", "SERVEUR #TEST")
        if serverName == "SERVEUR #TEST" or serverName == "SERVEUR TEST" then
            webHook = WeebHookTest
        end

		message =  "**" .. date.day .. "/" .. date.month .. "/" .. date.year .. " à " .. date.hour .. ":" .. date.min .. ":" .. date.sec .. "**: " .. message
		PerformHttpRequest(
			webHook,
			function(err, text, headers) end,
			"POST",
			json.encode({username = serverName, content = message}),
			{
				['Content-Type'] = 'application/json'
			}
		)
	else
		print("[DISCORD] Message non valide")
	end

end

--
-- Send message to banking webhooks
--
RegisterServerEvent("discord:banking")
AddEventHandler("discord:banking", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/443811129748094986/3gKB26ueEVaDDjeHzoqPJwxyACS-Yc-WJlLw2F_E0CeDv4ZwhCx4I0rif4dsxOr9FnJR", message)
end)

--
-- Send message to report webhooks
--
RegisterServerEvent("discord:report")
AddEventHandler("discord:report", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/361161989185077258/2PGegGveSBU47LpUMyJbShGJDu8_m4Bu8mu5QjKbjCQGUg8OeKavGXzmLvKzgsneW-pg", message)
end)

--
-- Send message to antiCheat webhooks
--
RegisterServerEvent("discord:antiCheat")
AddEventHandler("discord:antiCheat", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/372472764147302431/q8A2Z6Oj3ozn_-cSRA07mz5UjFoRWwmt8FfUEhsXJVlncmGypxXRqVwdqv8EXCyfaSBW", message)
end)

--
-- Send message to mello webhooks
--
RegisterServerEvent("discord:mello")
AddEventHandler("discord:mello", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/446052821956165634/TdkeGLB1voEUcvf7v0pECz2B5qKvmJAxv63ZNFoKU7uMACNQn7LDZ9lxUfO-3A79wXh0", message)
end)

--
-- Send message to trade webhooks
--
RegisterServerEvent("discord:trade")
AddEventHandler("discord:trade", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/444127415363436544/t00dfMmLQ_qiM8rT5rWlhKacscwwhWyLrAFzQQsRHwnND2pAEJRn-JaDHyTm4gx6aJJi", message)
end)

--
-- Send message to kickban webhooks
--
RegisterServerEvent("discord:kickban")
AddEventHandler("discord:kickban", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/442623018523688961/W3ffa3-Lfg2QFmNh7S70rGZcZr7ibVt3dA0c1xKV9MG4DYqtZv3xGiAamu7VcRIL7TqQ", message)
end)

--
-- Send message to attente webhooks
--
RegisterServerEvent("discord:attente")
AddEventHandler("discord:attente", function(message)
    sendToDiscord("https://discordapp.com/api/webhooks/444776655928557580/HVf-3Ri6qR6FismvcueLBvlJjxlSC3lcRTqnLHeTyTJhvDLV9gUco-Ok7sH9AcPkW1DC", message)
end)

--
-- Send message to vente concess webhooks
--
RegisterServerEvent("discord:venteConcess")
AddEventHandler("discord:venteConcess", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/444885267141230592/mBpocFJ4T6qhswdKW97vmmPzCbES-lzRT7jGLdZpnPSOS_SL_x5SfXIJoeVrNuSK3as3", message)
end)
RegisterServerEvent("discord:braquage")
AddEventHandler("discord:braquage", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/458539001381519370/Runhz1LjEW-34vfYop8Ie-2xee4zR0kFLRQejho2OrU4FHDDDseEqU5Kr5rnePDVPeYJ", message)
end)

RegisterServerEvent("discord:LSPD")
AddEventHandler("discord:LSPD", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/460412145000251403/XUwLpy7zOCZ-C8MV60OHvO-onacz98ScCt5xHksxIvgTcBjqE9JVPQgDA23LlcCCCjuR", message)
end)

RegisterServerEvent("discord:NewPlayer")
AddEventHandler("discord:NewPlayer", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/461846536574337034/lliLZHrPcxZ7OXaBISOt6mI_gbG2yzHNCYYXFWwjUVsRAYe10wqyMmIP1opvhxBSUn7j", message)
end)
RegisterServerEvent("discord:Connexion")
AddEventHandler("discord:Connexion", function(message)
	sendToDiscord("https://discordapp.com/api/webhooks/461846767957442560/9Bw5VVU8s3-c1JQPKIcn-2DyuNA71lbSk4pf5MzDEgfR5553FsqSEiz-hGthYNEJeAL-", message)
end)
