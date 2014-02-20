silniki = {
	--NAZWA, PREDKOSC, CENA, SKRET, AKCELA
	{"Turbo V6", 260, 200000, 37, 20},
	{"Turbo sport V8", 300, 320000, 38, 25},
}

sklepy = {
	--x,y,z,int,dim
	{1581.3970947266, -1493.3341064453, 13.561769485474, 0, 0},
	{0, 0, 2, 0, 0},
}

zabronioneAuta = {
	[509]=true,
	[481]=true,
	[510]=true
}

montWindow = {}
montButton = {}
montLabel = {}
montProgress = {}
montGrid = {}
montColumn = {}
sklep = {}


montWindow[1] = guiCreateWindow(0.3135,0.25,0.376,0.5534,"Montowanie silnika",true)
montGrid[1] = guiCreateGridList(0.0234,0.0659,0.4286,0.9106,true,montWindow[1])
guiGridListSetSelectionMode(montGrid[1],0)
montColumn[1] = guiGridListAddColumn(montGrid[1],"Nazwa",0.3)
montColumn[2] = guiGridListAddColumn(montGrid[1],"Prędkość",0.3)
montColumn[3] = guiGridListAddColumn(montGrid[1],"Cena",0.3)
montColumn[4] = guiGridListAddColumn(montGrid[1],"L",0.1)
montColumn[5] = guiGridListAddColumn(montGrid[1],"A",0.1)
montButton[1] = guiCreateButton(0.4779,0.1153,0.4909,0.2235,"Zamontuj",true,montWindow[1])
guiSetFont(montButton[1],"default-bold-small")
montLabel[1] = guiCreateLabel(0.4779,0.3812,0.3688,0.0376,"Auto: ",true,montWindow[1])
guiSetFont(montLabel[1],"default-bold-small")
montLabel[2] = guiCreateLabel(0.4779,0.4424,0.3688,0.0376,"Stan auta: ",true,montWindow[1])
guiSetFont(montLabel[2],"default-bold-small")
montLabel[3] = guiCreateLabel(0.4779,0.5035,0.3688,0.0376,"Aktualny silnik: ",true,montWindow[1])
guiSetFont(montLabel[3],"default-bold-small")
montLabel[4] = guiCreateLabel(0.4779,0.5647,0.3688,0.0376,"Silnik do zamontowania:",true,montWindow[1])
guiSetFont(montLabel[4],"default-bold-small")
montLabel[5] = guiCreateLabel(0.4779,0.6259,0.3688,0.0376,"Cena nowego silnika:",true,montWindow[1])
guiSetFont(montLabel[5],"default-bold-small")
montProgress[1] = guiCreateProgressBar(0.4779,0.7059,0.4805,0.0729,true,montWindow[1])
montLabel[6] = guiCreateLabel(0.4675,0.7788,0.0494,0.0635,"0%",true,montWindow[1])
guiSetFont(montLabel[6],"default-bold-small")
montLabel[7] = guiCreateLabel(0.8935,0.7788,0.0935,0.0424,"100%",true,montWindow[1])
guiSetFont(montLabel[7],"default-bold-small")
guiSetEnabled(montButton[1], false)
guiSetVisible(montWindow[1], false)
showCursor(false)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end


function refreshmont(player)
	if not (player == getLocalPlayer()) then return false end
	local car = getPedOccupiedVehicle(player)
	if not getElementData(car, "enginePro:speed") then setElementData(car, "enginePro:speed", false) end
	local row = guiGridListGetSelectedItem(montGrid[1])
	local newsilnik = guiGridListGetItemText(montGrid[1], row, 2)
	local newcena = guiGridListGetItemText(montGrid[1], row, 3)
	guiSetText(montLabel[1], "Auto: "..getVehicleName(car) or "Auto: Error")
	guiSetText(montLabel[2], "Stan auta: "..tostring(getElementHealth(car)) or "Stan auta: Error")
	if getElementData(car, "enginePro:speed") then
		aktualnysilnik = "Aktualny silnik: "..math.round(getElementData(car, "enginePro:speed"))
	else
		aktualnysilnik = "Aktualny silnik: Standard"
	end
	guiSetText(montLabel[3], aktualnysilnik)
	guiSetText(montLabel[4], "Nowy silnik: "..newsilnik or "Nowy silnik: WYBIERZ")
	guiSetText(montLabel[5], "Cena: "..newcena or "Cena: WYBIERZ")
	guiProgressBarSetProgress(montProgress[1], 0)
end

function montShow(player)
	if not (player == getLocalPlayer()) then return false end
	if not (isPedInVehicle(player)) then return false end
	if (zabronioneAuta[getElementModel(getPedOccupiedVehicle(player))]) then return false end
	guiSetVisible(montWindow[1], true)
	showCursor(true)
	refreshmont(player)
end

function montHide(player)
	if not (player == getLocalPlayer()) then return false end
	guiSetVisible(montWindow[1], false)
	showCursor(false)
end

for i,v in ipairs(sklepy) do
	sklep[i] = createColSphere(v[1], v[2], v[3], 3)
	setElementInterior(sklep[i], v[4])
	setElementDimension(sklep[i], v[5])
	addEventHandler("onClientColShapeHit", sklep[i], montShow)
	addEventHandler("onClientColShapeLeave", sklep[i], montHide)
	createBlip(v[1], v[2], v[3])
end

for i,v in ipairs(silniki) do
	local row = guiGridListAddRow(montGrid[1])
    guiGridListSetItemText(montGrid[1], row, montColumn[1], v[1], false, false)
	guiGridListSetItemText(montGrid[1], row, montColumn[2], tostring(v[2]), false, false)
	guiGridListSetItemText(montGrid[1], row, montColumn[3], tostring(v[3]), false, false)
	guiGridListSetItemText(montGrid[1], row, montColumn[4], v[4], false, false)
	guiGridListSetItemText(montGrid[1], row, montColumn[5], v[5], false, false)
end





---KUPOWANIE
addEventHandler("onClientGUIClick", montGrid[1], function()
	local row = guiGridListGetSelectedItem(montGrid[1])
	local nazwa = guiGridListGetItemText(montGrid[1], row, 1)
	local speed = guiGridListGetItemText(montGrid[1], row, 2)
	local cena = guiGridListGetItemText(montGrid[1], row, 3)
	if (nazwa == "") then return false end
	guiSetEnabled(montButton[1], true)
	refreshmont(getLocalPlayer())
end)

addEventHandler("onClientGUIClick", resourceRoot, function()
	local row = guiGridListGetSelectedItem(montGrid[1])
	local nazwa = guiGridListGetItemText(montGrid[1], row, 1)
	if not (nazwa == "") then return false end
	guiSetEnabled(montButton[1], false)
	refreshmont(getLocalPlayer())
end)

addEventHandler("onClientGUIClick", montButton[1], function()
	local row = guiGridListGetSelectedItem(montGrid[1])
	local nazwa = guiGridListGetItemText(montGrid[1], row, 1)
	local speed = tonumber(guiGridListGetItemText(montGrid[1], row, 2))
	local cena = tonumber(guiGridListGetItemText(montGrid[1], row, 3))
	local lock = tonumber(guiGridListGetItemText(montGrid[1], row, 4))
	local akc = tonumber(guiGridListGetItemText(montGrid[1], row, 5))
	if (nazwa == "") then return false end
	if getPlayerMoney(getLocalPlayer())-cena < 0 then outputChatBox("Nie stać cię na to!", 255, 0, 0) return false end
	i = 0
	setTimer(function() i=i+0.55 guiProgressBarSetProgress(montProgress[1], i) end, 50, 200)
	setTimer(function(player, speed, cena) triggerServerEvent("engineMont", getRootElement(), player, speed, cena, lock, akc) guiSetEnabled(montButton[1], false) guiSetVisible(montWindow[1], false) showCursor(false) end, 10000, 1, getLocalPlayer(), speed, cena)
end, false)