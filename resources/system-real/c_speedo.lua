local licence=[[

====================================================================================================
Project-Roleplay (c) Daniex0r , BartekPL <daniex0r@gmail.com>
Wszelkie prawa zastrzezone.

2013-

]]

fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true }

enginelessVehicle = { [510]=true, [509]=true, [481]=true }
local active = true
local fuel = 0

function drawSpeedo()
	if active and not isPlayerMapVisible() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (vehicle) then

			speed = exports.global:getVehicleVelocity(vehicle)
			local width, height = guiGetScreenSize()
			local x = width
			local y = height
								
			dxDrawImage(x-440, y-404, 512, 512, "speedo/tarcza.png", 0, 0, 0, tocolor(255, 255, 255, 200))							
			dxDrawImage(x-(440), y-(404), 512, 512, "speedo/wskaznik.png", speed/(252/180), 0, 0, tocolor(255, 255, 255, 200))
			
			if isElementFrozen( vehicle ) then
				dxDrawImage(x-440, y-404, 512, 512, "speedo/recznywl.png", 0, 0, 0, tocolor(255, 255, 255, 200))	
			else
				dxDrawImage(x-440, y-404, 512, 512, "speedo/recznywyl.png", 0, 0, 0, tocolor(255, 255, 255, 200))	
			end
			--[[if getElementData( vehicle, "i:left" ) then
				dxDrawImage(x-440, y-404, 512, 512, "speedo/kierlewywl.png", 0, 0, 0, tocolor(255, 255, 255, 200))	
			else
				dxDrawImage(x-440, y-404, 512, 512, "speedo/kierlewywyl.png", 0, 0, 0, tocolor(255, 255, 255, 200))	
			end
			if getElementData( vehicle, "i:right" ) then
				dxDrawImage(x-440, y-404, 512, 512, "speedo/kierprawywl.png", 0, 0, 0, tocolor(255, 255, 255, 200))	
			else
				dxDrawImage(x-440, y-404, 512, 512, "speedo/kierprawywyl.png", 0, 0, 0, tocolor(255, 255, 255, 200))	
			end
			--dxDrawText( tostring(math.floor(getDistanceTraveled()/1000)), x - 117, y - 215, 5, 5, tocolor (255,255,255, 200), 1 )--]]
		end
	end
end

function syncFuel(ifuel)
	if not (ifuel) then
		fuel = 100
	else
		fuel = ifuel
	end
end
addEvent("syncFuel", true)
addEventHandler("syncFuel", getRootElement(), syncFuel)

function drawFuel()
	if active and not isPlayerMapVisible() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (vehicle) then
			
			local width, height = guiGetScreenSize()
			local x = width
			local y = height
			local f = math.floor(fuel or 0)
			local r,g,b = 0, 255, 0
			if fuel >= 50 then
				r = 255*(1-((fuel-50)/50))
			else
				r = 255
				g = 255*(fuel/50)
			end
			dxDrawText( "Paliwo:", x-(440-207), y-(404-190), x-(440-207)+97, y-(404-190)+30, tocolor(r,g,b,255), 1.0, "default-bold", "left", "center" )
			dxDrawText( f.."/100L", x-(440-207), y-(404-190), x-(440-207)+97, y-(404-190)+30, tocolor(r,g,b,255), 1.0, "default-bold", "right", "center" )
			
			if f <= 20 then
				--dxDrawImage(x-440, y-404, 512, 512, "speedo/malopaliwawl.png", 0, 0, 0, tocolor(255, 255, 255, 200))	
			else
				--dxDrawImage(x-440, y-404, 512, 512, "speedo/malopaliwawyl.png", 0, 0, 0, tocolor(255, 255, 255, 200))	
			end
		end
	end
end


-- Check if the vehicle is engineless or fuelless when a player enters. If not, draw the speedo and fuel needles.
function onVehicleEnter(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)
			if not (enginelessVehicle[id]) then
				addEventHandler("onClientRender", getRootElement(), drawSpeedo)
				addEventHandler("onClientRender", getRootElement(), drawFuel)
			end
			if seat == 0 and not (fuellessVehicle[id]) then
				--addEventHandler("onClientRender", getRootElement(), drawFuel)
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), onVehicleEnter)

-- Check if the vehicle is engineless or fuelless when a player exits. If not, stop drawing the speedo and fuel needles.
function onVehicleExit(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)
			if not(enginelessVehicle[id]) then
				removeEventHandler("onClientRender", getRootElement(), drawSpeedo)
				removeEventHandler("onClientRender", getRootElement(), drawFuel)
			end
			if seat == 0 and not (fuellessVehicle[id]) then
				--removeEventHandler("onClientRender", getRootElement(), drawFuel)
			end
		end
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), onVehicleExit)

function hideSpeedo()
	removeEventHandler("onClientRender", getRootElement(), drawSpeedo)
	removeEventHandler("onClientRender", getRootElement(), drawFuel)
end

function showSpeedo()
	source = getPedOccupiedVehicle(getLocalPlayer())
	if source then
		if getVehicleOccupant( source ) == getLocalPlayer() then
			onVehicleEnter(getLocalPlayer(), 0)
		elseif getVehicleOccupant( source, 1 ) == getLocalPlayer() then
			onVehicleEnter(getLocalPlayer(), 1)
		end
	end
end

-- If player is not in vehicle stop drawing the speedo needle.
function removeSpeedo()
	if not (isPedInVehicle(getLocalPlayer())) then
		hideSpeedo()
	end
end
setTimer(removeSpeedo, 1000, 0)

addCommandHandler( "licznik",
	function( )
		local source = getPedOccupiedVehicle(getLocalPlayer())
		if source then
			active = not active
			if active then
				outputChatBox( "Liczik został włączony.", 0, 255, 0 )
			else
				outputChatBox( "Licznik został wyłączony.", 255, 0, 0 )
			end
		end
	end
)

addEventHandler( "onClientResourceStart", getResourceRootElement(), showSpeedo )

addEvent("addWindow", true)
addEventHandler("addWindow", getRootElement(), 
	function ()
		if source == getLocalPlayer() then
		end
	end
)

addEvent("removeWindow", true)
addEventHandler("removeWindow", getRootElement(), 
	function ()
		if source == getLocalPlayer() then
		end
	end
)



fileDelete("c_speedo.lua")