local sizex,sizey = guiGetScreenSize()
 --gInteriorName, gOwnerName, gBuyMessage = nil

gIntWindow = guiCreateWindow( sizex-330, sizey-230, 300, 200, "Interior Info", false )
gInteriorName = guiCreateLabel( 20, 30, 300, 50, "", false, gIntWindow )
guiSetFont(gInteriorName, "default-bold-small")
gOwnerName = guiCreateLabel( 20, 70, 300, 50, "", false, gIntWindow )
guiSetFont(gOwnerName, "default-bold-small")
gBuyMessage = guiCreateLabel( 20, 130, 300, 100, "", false, gIntWindow )
guiSetFont(gBuyMessage, "default-bold-small")
guiSetAlpha(gIntWindow, 0)
 
timer = nil

-- Message on enter
function showIntName(name, ownerName, inttype, cost, fee)
	--[[
	if (isElement(gInteriorName) and guiGetVisible(gInteriorName)) then
		if isTimer(timer) then
			killTimer(timer)
			timer = nil
		end
		
		--destroyElement(gInteriorName)
		--gInteriorName = nil
			
		--destroyElement(gOwnerName)
		--gOwnerName = nil
			
		if (gBuyMessage) then
			--destroyElement(gBuyMessage)
			--gBuyMessage = nil
		end
	end
	--]]
	
	--guiSetText( gInteriorName, "" )
	--guiSetText( gOwnerName, "" )
	--guiSetText( gBuyMessage, "" )
	
	if name == "Brak" then
		return
	elseif name then
		if (inttype==3) then -- Interior name and Owner for rented
			--[[
			gInteriorName = guiCreateLabel(0.0, 0.85, 1.0, 0.3, tostring(name), true)
			guiSetFont(gInteriorName, "sa-header")
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			guiSetAlpha(gInteriorName, 0.0)
		
			gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Wynajmuje: " .. tostring(ownerName), true)
			guiSetFont(gOwnerName, "default-bold-small")
			guiLabelSetHorizontalAlign(gOwnerName, "center", true)
			guiSetAlpha(gOwnerName, 0.0)
			--]]
			guiSetText( gInteriorName, "Nazwa: " .. tostring(name) )
			--guiSetText( gOwnerName, "Wynajmuje: " .. tostring(ownerName) )
		else -- Interior name and Owner for the rest
			--[[
			gInteriorName = guiCreateLabel(0.0, 0.85, 1.0, 0.3, tostring(name), true)
			guiSetFont(gInteriorName, "sa-header")
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			guiSetAlpha(gInteriorName, 0.0)
			
			gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Właściciel: " .. tostring(ownerName), true)
			guiSetFont(gOwnerName, "default-bold-small")
			guiLabelSetHorizontalAlign(gOwnerName, "center", true)
			guiSetAlpha(gOwnerName, 0.0)
			guiSetText( gInteriorName, "" )
			--]]
			guiSetText( gInteriorName, "Nazwa: " .. tostring(name) )
			--guiSetText( gOwnerName, "Właściciel: " .. tostring(ownerName) )
		end
		if (ownerName=="Brak") and (inttype==3) then -- Unowned type 3 (rentable)
			--[[
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Naciśnij E, aby wynająć za $" .. tostring(exports.global:formatMoney(cost)) .. ".", true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
			--]]
			guiSetText( gBuyMessage, "Naciśnij E, aby wynająć za $" .. tostring(exports.global:formatMoney(cost)) .. "." )
		elseif (ownerName=="Brak") and (inttype<2) then -- Unowned any other type
			--[[
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Naciśnij E, aby wynająć za $" .. tostring(exports.global:formatMoney(cost)) .. ".", true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
			--]]
			guiSetText( gBuyMessage, "Naciśnij E, aby wynająć za $" .. tostring(exports.global:formatMoney(cost)) .. "." )
		else
			local msg = "Kliknij E, aby wejsc do srodka."
			if fee and fee > 0 then
				msg = "Oplata za wejscie: $" .. exports.global:formatMoney(fee)
				
				if exports.global:hasMoney( getLocalPlayer(), fee ) then
					msg = msg .. "\nKliknij E aby wejść."
				end
			else
				--enterInterior()
			end
			--[[
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, msg, true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
			--]]
			guiSetText( gBuyMessage, msg )
		end
		
		if isTimer(timer) then
			killTimer(timer)
			timer = nil
		end
		timer = setTimer(fadeMessage, 50, 20, true)
	end
end

function fadeMessage(fadein)
	local alpha = guiGetAlpha(gIntWindow)
	
	if (fadein) and (alpha) then
		local newalpha = alpha + 0.05
		--guiSetAlpha(gInteriorName, newalpha)
		--guiSetAlpha(gOwnerName, newalpha)
		
		if (gBuyMessage) then
			--guiSetAlpha(gBuyMessage, newalpha)
		end
		
		guiSetAlpha(gIntWindow, math.min(newalpha,1))
		
		if(newalpha>=1.0) then
			timer = setTimer(hideIntName, 4000, 1)
		end
	elseif (alpha) then
		local newalpha = alpha - 0.05
		--guiSetAlpha(gInteriorName, newalpha)
		--guiSetAlpha(gOwnerName, newalpha)
		
		if (gBuyMessage) then
			--guiSetAlpha(gBuyMessage, newalpha)
		end
		
		guiSetAlpha(gIntWindow, math.min(newalpha,1))
		
		if(newalpha<=0.0) then
			--destroyElement(gInteriorName)
			--gInteriorName = nil
			
			--destroyElement(gOwnerName)
			--gOwnerName = nil
			
			if (gBuyMessage) then
				--destroyElement(gBuyMessage)
				--gBuyMessage = nil
			end
		end
	end
end

function hideIntName()
	setTimer(fadeMessage, 50, 20, false)
end

addEvent("displayInteriorName", true )
addEventHandler("displayInteriorName", getRootElement(), showIntName)

-- Creation of clientside blips
function createBlipsFromTable(interiors)
	-- remove existing house blips
	for key, value in ipairs(getElementsByType("blip")) do
		local blipicon = getBlipIcon(value)
		
		if (blipicon == 31 or blipicon == 32) then
			destroyElement(value)
		end
	end

	-- spawn the new ones
	for key, value in ipairs(interiors) do
		createBlipAtXY(interiors[key][1], interiors[key][2], interiors[key][3])
	end
end
addEvent("createBlipsFromTable", true)
addEventHandler("createBlipsFromTable", getRootElement(), createBlipsFromTable)

function createBlipAtXY(inttype, x, y)
	if inttype == 3 then inttype = 0 end
	createBlip(x, y, 10, 31+inttype, 2, 255, 0, 0, 255, 0, 300)
end
addEvent("createBlipAtXY", true)
addEventHandler("createBlipAtXY", getRootElement(), createBlipAtXY)

function removeBlipAtXY(inttype, x, y)
	if inttype == 3 or type(inttype) ~= 'number' then inttype = 0 end
	for key, value in ipairs(getElementsByType("blip")) do
		local bx, by, bz = getElementPosition(value)
		local icon = getBlipIcon(value)
		
		if (icon==31+inttype and bx==x and by==y) then
			destroyElement(value)
			break
		end
	end
end
addEvent("removeBlipAtXY", true)
addEventHandler("removeBlipAtXY", getRootElement(), removeBlipAtXY)

------
local wRightClick, ax, ay = nil
local house = nil
local houseID = nil
local sx, sy = guiGetScreenSize( )
function showHouseMenu( )
	ax = math.max( math.min( sx - 160, ax - 75 ), 10 )
	ay = math.max( math.min( sx - 210, ay - 100 ), 10 )
	wRightClick = guiCreateWindow(ax, ay, 150, 200, "Dom " .. tostring( houseID ), false)

	bLock = guiCreateButton(0.05, 0.13, 0.9, 0.1, "Zamknij/Otworz", true, wRightClick)
	addEventHandler("onClientGUIClick", bLock, lockUnlockHouse, false)
	
	bKnock = guiCreateButton(0.05, 0.27, 0.9, 0.1, "Zapukaj do drzwi", true, wRightClick)
	addEventHandler("onClientGUIClick", bKnock, knockHouse, false)
		
	bCloseMenu = guiCreateButton(0.05, 0.41, 0.9, 0.1, "Zamknij Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideHouseMenu, false)
end

local lastKnocked = 0
function knockHouse()
	local tick = getTickCount( )
	if tick - lastKnocked > 10000 then
		triggerServerEvent("onKnocking", getLocalPlayer(), house)
		hideHouseMenu()
		lastKnocked = tick
	else
		outputChatBox("Poczekaj trochę, zanim znów zapukasz.", 255, 0, 0)
	end
end

function lockUnlockHouse( )
	local px, py, pz = getElementPosition(getLocalPlayer())
	local interiorEntrance = getElementData(house, "entrance")
	local interiorExit = getElementData(house, "exit")
	local x, y, z = getElementPosition(house)
	if getDistanceBetweenPoints3D(interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], px, py, pz) < 5 then
		triggerServerEvent( "lockUnlockHouseID", getLocalPlayer( ), houseID )
	elseif getDistanceBetweenPoints3D(interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], px, py, pz) < 5 then
		triggerServerEvent( "lockUnlockHouseID", getLocalPlayer( ), houseID )
	end
	hideHouseMenu()
end

function hideHouseMenu( )
	if wRightClick then
		destroyElement( wRightClick )
		wRightClick = nil
		showCursor( false )
	end
	house = nil
	houseID = nil
end

local function hasKey( key )
	return exports.global:hasItem(getLocalPlayer(), 4, key) or exports.global:hasItem(getLocalPlayer(), 5,key)
end
function clickHouse(button, state, absX, absY, wx, wy, wz, e)
	if (button == "right") and (state=="down") and not e then
		if getElementData(getLocalPlayer(), "exclusiveGUI") then
			return
		end
		
		local element, id = nil, nil
		local px, py, pz = getElementPosition(getLocalPlayer())
		local x, y, z = nil
		local interiorres = getResourceRootElement(getResourceFromName("system-domow"))
		local elevatorres = getResourceRootElement(getResourceFromName("podnosniki"))

		for key, value in ipairs(getElementsByType("pickup")) do
			if isElementStreamedIn(value) then
				x, y, z = getElementPosition(value)
				local minx, miny, minz, maxx, maxy, maxz
				local offset = 4
				
				minx = x - offset
				miny = y - offset
				minz = z - offset
				
				maxx = x + offset
				maxy = y + offset
				maxz = z + offset
				
				if (wx >= minx and wx <=maxx) and (wy >= miny and wy <=maxy) and (wz >= minz and wz <=maxz) then
					local dbid = getElementData(getElementParent( value ), "dbid")
					if getElementType(getElementParent( value )) == "interior" then -- house found
						element = getElementParent( value )
						id = dbid
						break
					elseif  getElementType(getElementParent( value ) ) == "elevator" then
						-- it's an elevator
						if getElementData(value, "dim") and getElementData(value, "dim")  ~= 0 then
							element = getElementParent( value )
							id = getElementData(value, "dim")
							break
						elseif getElementData( getElementData( value, "other" ), "dim")  and getElementData( getElementData( value, "other" ), "dim")  ~= 0 then
							element = value
							id = getElementData( getElementData( value, "other" ), "dim")
							break
						end
					end
				end
			end
		end
		
		if element then
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 5 then
				ax, ay = getScreenFromWorldPosition(x, y, z, 0, false)
				if ax then
					hideHouseMenu()
					house = element
					houseID = id
					showHouseMenu()
				end
			else
				outputChatBox("Jestes zbyt daleko domu.", 255, 0, 0)
			end
		else
			hideHouseMenu()
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickHouse, true)

addEvent("playerKnock", true)
addEventHandler("playerKnock", root,
	function()
		outputChatBox(" * Odglos pukania dochodzi z drzwi *      ((" .. getPlayerName(source):gsub("_"," ") .. "))", 255, 51, 102)
		playSound("knocking.mp3")
	end
)

local cache = { }
function findProperty(thePlayer, dimension)
	local dbid = dimension or getElementDimension( thePlayer )
	if dbid > 0 then
		if cache[ dbid ] then
			return unpack( cache[ dbid ] )
		end
		-- find the entrance and exit
		local entrance, exit = nil, nil
		for key, value in pairs(getElementsByType( "pickup", getResourceRootElement() )) do
			if getElementData(value, "dbid") == dbid then
				entrance = value
				break
			end
		end
		
		if entrance then
			cache[ dbid ] = { dbid, entrance }
			return dbid, entrance
		end
	end
	cache[ dbid ] = { 0 }
	return 0
end

function findParent( element, dimension )
	local dbid, entrance = findProperty( element, dimension )
	return entrance
end

--

local inttimer = nil
addEvent( "setPlayerInsideInterior", true )
addEventHandler( "setPlayerInsideInterior", getRootElement( ),
	function( targetLocation, targetInterior )
		if inttimer then
			return
		end

		if targetLocation[INTERIOR_DIM] ~= 0 then
			setGravity(0)
		end
		
		
		setElementFrozen(getLocalPlayer(), true)
		setElementPosition(getLocalPlayer(), targetLocation[INTERIOR_X], targetLocation[INTERIOR_Y], targetLocation[INTERIOR_Z], true)
		setElementInterior(getLocalPlayer(), targetLocation[INTERIOR_INT])
		setCameraInterior(targetLocation[INTERIOR_INT])
		setElementDimension(getLocalPlayer(), targetLocation[INTERIOR_DIM])
		if targetLocation[INTERIOR_ANGLE] then
			setPedRotation(getLocalPlayer(), targetLocation[INTERIOR_ANGLE])
		end
		
		triggerServerEvent("onPlayerInteriorChange", getLocalPlayer(), 0, 0, targetLocation[INTERIOR_DIM], targetLocation[INTERIOR_INT])
		inttimer = setTimer(onPlayerPutInInteriorSecond, 1000, 1, targetLocation[INTERIOR_DIM], targetLocation[INTERIOR_INT])
		engineSetAsynchronousLoading ( false, true )
	end
)

function onPlayerPutInInteriorSecond(dimension, interior)
	setCameraInterior(interior)
	
	local safeToSpawn = true
	if(getResourceFromName("system-obiektow"))then
		safeToSpawn = exports['system-obiektow']:isSafeToSpawn()
	end
	
	if (safeToSpawn) then
		inttimer = nil
		if isElement(getLocalPlayer()) then
			setTimer(onPlayerPutInInteriorThird, 1000, 1)
		end
	else
		setTimer(onPlayerPutInInteriorSecond, 1000, 1, dimension, interior)
	end
end

function onPlayerPutInInteriorThird()
	setGravity(0.008)
	setElementFrozen(getLocalPlayer(), false)
	engineSetAsynchronousLoading ( true, false )
end

function cPKnock()
	if (getElementDimension(getLocalPlayer()) > 20000) then
		triggerServerEvent("onVehicleKnocking", getLocalPlayer())
	else
		triggerServerEvent("onKnocking", getLocalPlayer(), 0)
	end
end
addCommandHandler("zapukaj", cPKnock)


fileDelete("c_interior_system.lua")