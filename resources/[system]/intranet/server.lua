RegisterServerEvent("intranet:openintra")
AddEventHandler("intranet:openintra", function()
	local identifier = string.gsub(GetPlayerIdentifier(source), "steam:", "")
	TriggerClientEvent("intranet:open", source, "https://compta.app.triumrp.com/gamelogin.php?steamid="..identifier.."&token="..GetToken(identifier))
end)

function GetToken(identifier)
	math.randomseed(os.clock())
	local rdm = math.random(1000000, 9000000)
	local token = md5sumhexa(tostring(rdm))
	file = io.open("/opt/GTAtmp/"..identifier..".tmp", "w+")
	io.output(file)
	io.write(token)
	io.close(file)
	return token
end
