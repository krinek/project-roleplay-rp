local gabby = createPed(150, 359.7138671875, 173.6357421875, 1008.3893432617)
setPedRotation(gabby, 259.50)
setElementDimension(gabby, 6)
setElementInterior(gabby, 3)
--setElementData(gabby, "talk", 1, false)
setElementData(gabby, "name", "Katarzyna Roik", false)
setElementFrozen(gabby, true)
--setPedAnimation(gabby, "INT_OFFICE", "OFF_Sit_Idle_Loop", -1, true, false, false)
local bot_marker = createMarker(  362.5888671875, 173.603515625, 1008.3828125 - 0.8, "cylinder", 1, 0, 255, 255, 128 )
setElementDimension(bot_marker, 6)
setElementInterior(bot_marker, 3)

addEventHandler( "onClientMarkerHit", bot_marker,
	function( thePlayer, dimension )
		if not dimension then return end
		if thePlayer ~= getLocalPlayer() then return end
		triggerEvent("cBeginPlate", getLocalPlayer())
	end
)

local plateCheck, newplates, efinalWindow = nil

function cBeginGUI()
	local lplayer = getLocalPlayer()
	triggerServerEvent("platePedTalk", lplayer, 1)
	
	local width, height = 100, 60
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	greetingWindow = guiCreateWindow(x, y, width, height, "Zaczynamy?", false)
	
	local width2, height2 = 10, 10
	local x = scrWidth/2 - (width2/2)
	local y = scrHeight/2 - (height2/2)
	
	--Buttons
	yes = guiCreateButton(0.10, 0.50, 0.30, 0.50, "Tak", true, greetingWindow)
	addEventHandler("onClientGUIClick", yes, fetchPlateList)
	--Buttons
	no = guiCreateButton(0.60, 0.50, 0.30, 0.50, "Nie", true, greetingWindow)
	addEventHandler("onClientGUIClick", no, closeWindow)
	
	--Quick Settings
	guiWindowSetSizable(greetingWindow, false)
	guiWindowSetMovable(greetingWindow, true)
	guiSetVisible(greetingWindow, true)
	showCursor(true)
end
addEvent("cBeginPlate", true)
addEventHandler("cBeginPlate", getRootElement(), cBeginGUI)

function fetchPlateList()
	if (source==yes) then
		destroyElement(greetingWindow)
		triggerServerEvent("platePedTalk", getLocalPlayer(), 3)
		triggerServerEvent("system-tablic-rej:list", getLocalPlayer())
		showCursor(false)
	end
end

function PlateWindow(vehicleList)
	local lplayer = getLocalPlayer()

	local width, height = 260, 300
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
			
	mainVehWindow = guiCreateWindow(x, y, width, height, "Rejestracja pojazdów", false)
			
	guiCreateLabel(0.03, 0.08, 2.0, 0.1, "Jakie auto zamierzasz zarejestrować?", true, mainVehWindow)
	vehlist = guiCreateGridList(0.03, 0.15, 1, 0.73, true, mainVehWindow)
			
	ovid = guiGridListAddColumn(vehlist, "ID", 0.2)
	ov = guiGridListAddColumn(vehlist, "Pojazdy", 0.4)
	ovcp = guiGridListAddColumn(vehlist, "Rejestracje", 0.3)
			
		
	for i,r in ipairs(vehicleList) do
		local row = guiGridListAddRow(vehlist)
		local vid = r[1]
		local v = r[2]
		local vm = getElementModel(v)
		guiGridListSetItemText(vehlist, row, ovid, tostring(vid), false, false)		
		guiGridListSetItemText(vehlist, row, ov, tostring(getVehicleNameFromModel(vm)), false, false) 
		guiGridListSetItemText(vehlist, row, ovcp, tostring(getVehiclePlateText(v)), false, false)
	end

	--Buttons
	close = guiCreateButton(0.50, 0.90, 0.50, 0.10, "Zamknij okno", true, mainVehWindow)
	addEventHandler("onClientGUIClick", close, closeWindow)
			
	--OnDoubleClick
	addEventHandler("onClientGUIDoubleClick", vehlist, editPlateWindow)
			
	--Quick Settings
	guiWindowSetSizable(mainVehWindow, false)
	guiWindowSetMovable(mainVehWindow, true)
	guiSetVisible(mainVehWindow, true)
	
	showCursor(true)
end
addEvent("system-tablic-rej:clist", true)
addEventHandler("system-tablic-rej:clist", getRootElement(), PlateWindow)

function editPlateWindow()
	local sr, sc = guiGridListGetSelectedItem(vehlist)
	svnum = guiGridListGetItemText(vehlist, sr, sc)
	if (source == vehlist) and not (svnum == "") then
		local width, height = 250, 210
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		efinalWindow = guiCreateWindow(x, y, width, height, "Wypełnij właściwie informacje:", false)
		local mainT = guiCreateLabel(0.03, 0.08, 2.0, 0.1, "Rejestrowanie pojazdu #" .. svnum .. ".", true, efinalWindow)
		guiLabelSetHorizontalAlign(mainT, nil, true)
	
		guiCreateLabel(0.03, 0.22, 2.0, 0.1, "Wpisz rejestracje:", true, efinalWindow)
		newplates = guiCreateEdit(0.03, 0.30, 2.0, 0.1, "", true, efinalWindow)
		guiEditSetMaxLength(newplates, 8)
		
		addEventHandler("onClientGUIChanged", newplates, checkPlateBox) 
		
		plateCheck = guiCreateLabel(0.03, 0.41, 2.0, 0.1, "Niepoprawna nazwa", true, efinalWindow)
		guiLabelSetColor(plateCheck, 255, 0, 0)
		
		--Buttons
		finalx = guiCreateButton(0.25, 0.75, 0.50, 0.10, "Zamknij okno", true, efinalWindow)
		addEventHandler("onClientGUIClick", finalx, closeWindow)
		submitNP = guiCreateButton(0.25, 0.60, 0.50, 0.10, "Potwierdź rejestracje", true, efinalWindow)
		addEventHandler("onClientGUIClick", submitNP, getPlateNText)
		
		--Quick Settings
		guiSetInputEnabled(true)
		guiSetEnabled(mainVehWindow, false)
		guiWindowSetSizable(efinalWindow, false)
		guiWindowSetMovable(efinalWindow, true)
		guiSetVisible(efinalWindow, true)
		showCursor(true)
	end
end


function checkPlateBox()
	if (source==newplates) then
		local theText = guiGetText(source)
		
		destroyElement(plateCheck)
		if checkPlate(theText) then
			plateCheck = guiCreateLabel(0.03, 0.41, 2.0, 0.1, "Poprawna nazwa", true, efinalWindow)
			guiLabelSetColor(plateCheck, 0, 255, 0)
		else
			plateCheck = guiCreateLabel(0.03, 0.41, 2.0, 0.1, "Niepoprawna nazwa", true, efinalWindow)
			guiLabelSetColor(plateCheck, 255, 0, 0)
		end
	end
end

function getPlateNText()
	if (source==submitNP) and (newplates) then
		local data = guiGetText(newplates)
		local vehid = tonumber(svnum)
		triggerServerEvent("sNewPlates", getLocalPlayer(), data, vehid)
		
		guiSetInputEnabled(false)
		destroyElement(mainVehWindow)
		destroyElement(efinalWindow)
		showCursor(false)
	end
end

function closeWindow()
	if (source==close) then
		showCursor(false)
		destroyElement(mainVehWindow)
		toggleAllControls(true)
		triggerEvent("onClientPlayerWeaponCheck", localPlayer)
	elseif (source==no) then
		showCursor(false)
		destroyElement(greetingWindow)
		toggleAllControls(true)
		triggerEvent("onClientPlayerWeaponCheck", localPlayer)
		triggerServerEvent("platePedTalk", getLocalPlayer(), 4)
	elseif (source==finalx) then
		guiSetInputEnabled(false)
		destroyElement(mainVehWindow)
		destroyElement(efinalWindow)
		showCursor(false)
		toggleAllControls(true)
		triggerEvent("onClientPlayerWeaponCheck", localPlayer)
		triggerServerEvent("platePedTalk", getLocalPlayer(), 4)
	end
end

fileDelete("c_plate_system.lua")