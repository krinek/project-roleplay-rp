function carshop_showInfo(carPrice, taxPrice)
	outputChatBox("")
	outputChatBox("Idąc koło auta możesz zobaczyć specjalne karty na szybach:")
	--outputChatBox(" --------------------------------------")
	outputChatBox("| "..getVehicleNameFromModel( getElementModel( source ) ) )
	outputChatBox("| Koszt $"..exports.global:formatMoney(carPrice).."!" )
	outputChatBox("| Podatki: $"..tostring(taxPrice) )
	--outputChatBox(" --------------------------------------")
	outputChatBox("Wcisnij F by zakupic pojazd")
end
addEvent("carshop:showInfo", true)
addEventHandler("carshop:showInfo", getRootElement(), carshop_showInfo)

local gui, theVehicle = {}
function carshop_buyCar(carPrice, cashEnabled, bankEnabled)
	if gui["_root"] then
		return
	end
	
	theVehicle = source
	
	guiSetInputEnabled(true)
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Kup Pojazd", false)
	guiWindowSetSizable(gui["_root"], false)
		
	gui["lblText1"] = guiCreateLabel(10, 25, 320, 16, "Masz zamiar kupić następujący pojazd:", false, gui["_root"])
	gui["lblVehicleName"] = guiCreateLabel(20, 45, 80, 13, getVehicleNameFromModel( getElementModel( source ) ), false, gui["_root"])
	gui["lblVehicleCost"] = guiCreateLabel(150, 45, 80, 13, "$ "..tostring(carPrice), false, gui["_root"])
	
	gui["lblText2"] = guiCreateLabel(10, 75, 320, 70, "Mozesz potwierdzic zakup pojazdu. \Następujące przyciski w dolnej części ekranu. z\nklikając na przycisk płatności, zgadzasz się, że zwrot\npieniędzy będzie niemozliwy.", false, gui["_root"])
	
	gui["btnCash"] = guiCreateButton(10, 145, 105, 41, "Zapłać gotówką", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCash"], carshop_buyCar_click, false)
	guiSetEnabled(gui["btnCash"], cashEnabled)
	
	gui["btnBank"] = guiCreateButton(120, 145, 105, 41, "Zapłać Przelewem", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnBank"], carshop_buyCar_click, false)
	guiSetEnabled(gui["btnBank"], bankEnabled)
	
	gui["btnCancel"] = guiCreateButton(232, 145, 105, 41, "Anuluj", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCancel"], carshop_buyCar_close, false)
end
addEvent("carshop:buyCar", true)
addEventHandler("carshop:buyCar", getRootElement(), carshop_buyCar)

function carshop_buyCar_click()
	if exports.global:hasSpaceForItem(getLocalPlayer(), 3, 1) then
		local sourcestr = "cash"
		if (source == gui["btnBank"]) then
			sourcestr = "bank"
		end
		triggerServerEvent("carshop:buyCar", theVehicle, sourcestr)
	else
		outputChatBox("Nie masz miejsca w kieszeni na kluczyki", 0, 255, 0)
	end
	carshop_buyCar_close()
end


function carshop_buyCar_close()
	destroyElement(gui["_root"])
	gui = { }
	guiSetInputEnabled(false)
end
