
local fakeWeapon = ''

local weashop_blips ={}
local inrangeofweashop = false
local currentlocation = nil
local boughtWeapon = false

local function LocalPed()
return GetPlayerPed(-1)
end

local weashop_locations = {
{x= 1692.37, y= 3758.19,z = 33.71},
{x= 252.91,y= -48.18, z= 68.94},
{x= 844.35,y= -1033.51,z= 27.09},
{x= -331.48,y= 6082.34,z= 30.35},
{x= -664.26,y= -935.47,z= 20.72},
{x= -1305.42,y= -392.42,z= 35.59},
{x= -1119.14,y= 2697.06,z= 17.45},
{x= 2569.97,y= 294.47,z= 107.63},
{x= -3172.58,y= 1085.85,z= 19.73},
{x= 20.04,y= -1106.46,z= 28.69},
{x= 810.38, y= -2157.05,z= 28.61}
}



RegisterNetEvent("weashop:getFood")
RegisterNetEvent("weashop:selection")

function Chat(t)
	TriggerEvent("chatMessage", 'Ammunation', { 0, 255, 255}, "" .. tostring(t))
end

AddEventHandler("weashop:selection", function(data)
	local item = data.itemid
	local price = data.price
	if (exports.vdk_inventory:notFull() == true) then
		TriggerServerEvent('weashop:testprix',item,price)
	else
		Chat("INVENTAIRE PLEIN")
	end
end)

AddEventHandler("weashop:getFood", function(item)
	TriggerEvent('player:receiveItem',item,1)

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in ipairs(weashop_locations) do

				if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 20.0)then
					DrawMarker(1, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 0, 25, 165, 165, 0,0, 0,0)
					if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 2.0)then
						DisplayHelpText("Appuyer sur ~INPUT_CONTEXT~ pour ouvrir/fermer ~g~l'Ammunation")
						if(IsControlJustReleased(1, 51))then
							Menu.initMenu()
							Menu.isOpen = not Menu.isOpen
						end
						if Menu.isOpen then
							Menu.draw()
							Menu.keyControl()
						end
					end
				end

		end
	end
end)
Menu = {}
Menu.item = {
			['Title'] = 'Ammunation',
			['Items'] = {
				{['Title'] = '~r~ Rouge : Permis requis', ['Close']= false},
				{['Title'] = "Couteau ~g~ 100$",['Function'] = Showtext, text="", ['Event'] = 'weashop:selection',['itemid']=119,['price']=100,['Close']= true},
				{['Title'] = "Marteau ~g~ 50$",['Event'] = 'weashop:selection',['itemid']=120,['price']=50,['Close']= true},
				{['Title'] = "Batte ~g~ 250$", ['Event'] = 'weashop:selection',['itemid']=121,['price']=250,['Close']= true},
				{['Title'] = "Club ~g~300$", ['Event'] = 'weashop:selection',['itemid']=123,['price']=300,['Close']= true},
				{['Title'] = "Tomahawk ~g~300$ ", ['Event'] = 'weashop:selection',['itemid']=122,['price']=300,['Close']= true},
				{['Title'] = "Taser ~g~8000$", ['Event'] = 'weashop:selection',['itemid']=118,['price']=8000,['Close']= true},
				{['Title'] = "Pistolet de détresse ~g~8000$", ['Event'] = 'weashop:selection',['itemid']=124,['price']=8000,['Close']= true},
				{['Title'] = "Jumelles ~g~5000$", ['Event'] = 'weashop:selection',['itemid']=125,['price']=5000,['Close']= true},
				{['Title'] = "~r~Pétoire ~g~8000$", ['Event'] = 'weashop:selection',['itemid']=117,['price']=8000,['Close']= true},
				{['Title'] = "~r~Pistolet Vintage ~g~9000$", ['Event'] = 'weashop:selection',['itemid']=127,['price']=9000,['Close']= true},
				{['Title'] = "~r~Pistolet ~g~10000$", ['Event'] = 'weashop:selection',['itemid']=128,['price']=10000,['Close']= true}


			}



}
--====================================================================================
--  Option Menu
--====================================================================================
Menu.backgroundColor = { 0, 0, 10, 190 }
Menu.backgroundColorActive = { 255, 255, 255, 190 }
Menu.titleTextColor = { 255, 255, 255, 190 }
Menu.titleBackgroundColor = { 50, 0, 10, 190 }
Menu.textColor = { 255, 255, 255, 190 }
Menu.textColorActive = { 0, 0, 10, 190 }

Menu.keyOpenMenu = 170 -- N+
Menu.keyUp = 172 -- PhoneUp
Menu.keyDown = 173 -- PhoneDown
Menu.keyLeft = 174 -- PhoneLeft || Not use next release Maybe
Menu.keyRight =	175 -- PhoneRigth || Not use next release Maybe
Menu.keySelect = 176 -- PhoneSelect
Menu.KeyCancel = 177 -- PhoneCancel

Menu.posX = 0.01
Menu.posY = 0.1

Menu.ItemWidth = 0.26
Menu.ItemHeight = 0.03

Menu.isOpen = false   -- /!\ Ne pas toucher
Menu.currentPos = {1} -- /!\ Ne pas toucher

--====================================================================================
--  Menu System
--====================================================================================

function Menu.drawRect(posX, posY, width, heigh, color)
    DrawRect(posX + width / 2, posY + heigh / 2, width, heigh, color[1], color[2], color[3], color[4])
end

function Menu.initText(textColor, font, scale)
    font = font or 0
    scale = scale or 0.35
    SetTextFont(font)
    SetTextScale(0.0,scale)
    SetTextCentre(true)
    SetTextDropShadow(0, 0, 0, 0, 0)
    SetTextEdge(0, 0, 0, 0, 0)
    SetTextColour(textColor[1], textColor[2], textColor[3], textColor[4])
    SetTextEntry("STRING")
end

function Menu.draw()
    -- Draw Rect
    local pos = 0
    local menu = Menu.getCurrentMenu()
    local selectValue = Menu.currentPos[#Menu.currentPos]
    local nbItem = #menu.Items
    -- draw background title & title
    Menu.drawRect(Menu.posX, Menu.posY , Menu.ItemWidth, Menu.ItemHeight * 2, Menu.titleBackgroundColor)
    Menu.initText(Menu.titleTextColor, 4, 0.7)
    AddTextComponentString(menu.Title)
    DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY)

    -- draw bakcground items
    Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * 2, Menu.ItemWidth, Menu.ItemHeight + (nbItem-1)*Menu.ItemHeight, Menu.backgroundColor)
    -- draw all items
    for pos, value in pairs(menu.Items) do
        if pos == selectValue then
            Menu.drawRect(Menu.posX, Menu.posY + Menu.ItemHeight * (1+pos), Menu.ItemWidth, Menu.ItemHeight, Menu.backgroundColorActive)
            Menu.initText(Menu.textColorActive)
        else
            Menu.initText(Menu.textColor)
        end
        AddTextComponentString(value.Title)
        DrawText(Menu.posX + Menu.ItemWidth/2, Menu.posY + Menu.ItemHeight * (pos+1))
    end

end

function Menu.getCurrentMenu()
    local currentMenu = Menu.item
    for i=1, #Menu.currentPos - 1 do
        local val = Menu.currentPos[i]
        currentMenu = currentMenu.Items[val].SubMenu
    end
    return currentMenu
end

function Menu.initMenu()
    Menu.currentPos = {1}
end

function Menu.keyControl()
    if IsControlJustPressed(1, Menu.keyDown) then
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = (Menu.currentPos[slcp] % size) + 1

    elseif IsControlJustPressed(1, Menu.keyUp) then
        local cMenu = Menu.getCurrentMenu()
        local size = #cMenu.Items
        local slcp = #Menu.currentPos
        Menu.currentPos[slcp] = ((Menu.currentPos[slcp] - 2 + size) % size) + 1

    elseif IsControlJustPressed(1, Menu.KeyCancel) then
        table.remove(Menu.currentPos)
        if #Menu.currentPos == 0 then
            Menu.isOpen = false
        end

    elseif IsControlJustPressed(1, Menu.keySelect)  then
        local cSelect = Menu.currentPos[#Menu.currentPos]
        local cMenu = Menu.getCurrentMenu()
        if cMenu.Items[cSelect].SubMenu ~= nil then
            Menu.currentPos[#Menu.currentPos + 1] = 1
        else
            if cMenu.Items[cSelect].Function ~= nil then
                cMenu.Items[cSelect].Function(cMenu.Items[cSelect])
            end
            if cMenu.Items[cSelect].Event ~= nil then
                TriggerEvent(cMenu.Items[cSelect].Event, cMenu.Items[cSelect])
            end
            if cMenu.Items[cSelect].Close == nil or cMenu.Items[cSelect].Close == true then
                Menu.isOpen = false
            end
        end
    end

end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function IsPlayerInRangeOfweashop()
return inrangeofweashop
end

function ShowWeashopBlips(bool)
	if bool and #weashop_blips == 0 then
		for station,pos in pairs(weashop_locations) do
			local loc = pos
			local blip = AddBlipForCoord(pos.x,pos.y,pos.z)
			-- 60 58 137
			SetBlipSprite(blip,110)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Ammunation')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
			table.insert(weashop_blips, {blip = blip, pos = loc})
		end


	elseif bool == false and #weashop_blips > 0 then
		for i,b in ipairs(weashop_blips) do
			if DoesBlipExist(b.blip) then
				SetBlipAsMissionCreatorBlip(b.blip,false)
				Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
			end
		end
		weashop_blips = {}
	end

end

function f(n)
	return n + 0.0001
end

function LocalPed()
	return GetPlayerPed(-1)
end

function try(f, catch_f)
	local status, exception = pcall(f)
	if not status then
		catch_f(exception)
	end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

--local veh = nil
function OpenCreator()
	boughtWeapon = false
	local ped = GetPlayerPed(-1)
	local pos = currentlocation.pos.inside
	FreezeEntityPosition(ped,true)
	SetEntityVisible(ped,false)
	local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B,pos[1],pos[2],pos[3],Citizen.PointerValueFloat(),0)
	SetEntityCoords(ped,pos[1],pos[2],g)
	SetEntityHeading(ped,pos[4])
	weashop.currentmenu = "main"
	weashop.opened = true
	weashop.selectedbutton = 0
end

function CloseCreator()
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(-1)
		if not boughtWeapon then
			local pos = currentlocation.pos.entering
			SetEntityCoords(ped,pos[1],pos[2],pos[3])
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true)
			weashop.opened = false
			weashop.menu.from = 1
			weashop.menu.to = 10
		else
			local pos = currentlocation.pos.entering
			local hash = GetHashKey(fakeWeapon)
			GiveWeaponToPed(ped, hash, 1000, 0, false)
		end
	end)
end

function drawMenuButton(button,x,y,selected)
	local menu = weashop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.title)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = weashop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,150)
	DrawText(0.365, 0.934)
end

function drawPrice(txt,x,y,selected)
	local menu = weashop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(menu.scale, menu.scale)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/5, y - menu.height/2 + 0.0028)
end

function drawMenuTitle(txt,x,y)
local menu = weashop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,150)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function Notify(text)
SetNotificationTextEntry('STRING')
AddTextComponentString(text)
DrawNotification(false, false)
end

function DoesPlayerHaveWeapon(model,button,y,selected, source)
		local t = false
		local hash = GetHashKey(model)
		--t = HAS_PED_GOT_WEAPON(source,hash,false) --Check if player already has selected weapon !!!! THIS DOES NOT WORK !!!!!
		if t then
			drawPrice("OWNED",weashop.menu.x,y,selected)
		else
			drawPrice(button.costs.." $",weashop.menu.x,y,selected)
		end
end




function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end



RegisterNetEvent('FinishMoneyCheckForWea')
AddEventHandler('FinishMoneyCheckForWea', function()
	boughtWeapon = true
	CloseCreator()
end)

RegisterNetEvent('ToManyWeapons')
AddEventHandler('ToManyWeapons', function()
	boughtWeapon = false
	CloseCreator()
end)

function OpenMenu(menu)
	weashop.lastmenu = weashop.currentmenu
	weashop.menu.from = 1
	weashop.menu.to = 10
	weashop.selectedbutton = 0
	weashop.currentmenu = menu
end



function stringstarts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
if firstspawn == 0 then
	ShowWeashopBlips(true)
	firstspawn = 1
end
TriggerServerEvent("weaponshop:playerSpawned", spawn)
end)

RegisterNetEvent('giveWeapon')
AddEventHandler('giveWeapon', function(name, delay)
	Citizen.CreateThread(function()
		local weapon = GetHashKey(name)
        Wait(delay)
        local hash = GetHashKey(name)
        GiveWeaponToPed(GetPlayerPed(-1), weapon, 1000, 0, false)
    end)
end)
