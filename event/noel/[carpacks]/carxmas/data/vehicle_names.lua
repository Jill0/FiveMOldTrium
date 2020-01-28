function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	AddTextEntry('0x3AE4D215', 'snowmob')
	AddTextEntry('0x4A7F3C27', 'santasled')
end)