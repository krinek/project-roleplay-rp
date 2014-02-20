armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car
totalTempVehicles = 0
respawnTimer = nil

-- EVENTS
addEvent("onVehicleDelete", false)

-- /unflip
function unflipCar(thePlayer, commandName, targetPlayer)
	if (exports.global:isPlayerAdmin(thePlayer) or getTeamName(getPlayerTeam(thePlayer)) == "Hex Tow 'n Go") then
		if not targetPlayer or not exports.global:isPlayerAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("Nie jesteś w pojeździe.", thePlayer, 255, 0, 0)
			else
				local veh = getPedOccupiedVehicle(thePlayer)
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 0, ry, rz)
				outputChatBox("Twoje auto zostało odwrócone!", thePlayer, 0, 255, 0)
			end
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				else
					local pveh = getPedOccupiedVehicle(targetPlayer)
					if pveh then
						local rx, ry, rz = getVehicleRotation(pveh)
						setVehicleRotation(pveh, 0, ry, rz)
						if getElementData(thePlayer, "hiddenadmin") == 1 then
							outputChatBox("Twoje auto zostało odwrócone przez Ukrytego Administratora.", targetPlayer, 0, 255, 0)
						else
							outputChatBox("Twoje auto zostało odwrócone przez " .. username .. ".", targetPlayer, 0, 255, 0)
						end
						outputChatBox("Postawiłeś na koła auto " .. targetPlayerName:gsub("_"," ") .. ".", thePlayer, 0, 255, 0)
					else
						outputChatBox(targetPlayerName:gsub("_"," ") .. " is not in a vehicle.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("unflip", unflipCar, false, false)

-- /unlockcivcars
function unlockAllCivilianCars(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local count = 0
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			if (isElement(value)) and (getElementType(value)) then
				local id = getElementData(value, "dbid")
				
				if (id) and (id>=0) then
					local owner = getElementData(value, "owner")
					if (owner==-2) then
						setVehicleLocked(value, false)
						count = count + 1
					end
				end
			end
		end
		
		outputChatBox("Otowrzyłeś " .. count .. " cywilnych pojazdów.", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("unlockcivcars", unlockAllCivilianCars, false, false)

-- /veh
local leadplus = { [425] = true, [520] = true, [447] = true, [432] = true, [444] = true, [556] = true, [557] = true, [441] = true, [464] = true, [501] = true, [465] = true, [564] = true, [476] = true }
function createTempVehicle(thePlayer, commandName, ...)
	if (exports.global:isPlayerFullAdmin(thePlayer)) then
		local args = {...}
		if (#args < 1) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [id/nazwa] [kolor1] [kolor2]", thePlayer, 255, 194, 14)
		else
			local vehicleID = tonumber(args[1])
			local col1 = #args ~= 1 and tonumber(args[#args - 1]) or -1
			local col2 = #args ~= 1 and tonumber(args[#args]) or -1
			
			if not vehicleID then -- vehicle is specified as name
				local vehicleEnd = #args
				repeat
					vehicleID = getVehicleModelFromName(table.concat(args, " ", 1, vehicleEnd))
					vehicleEnd = vehicleEnd - 1
				until vehicleID or vehicleEnd == -1
				if vehicleEnd == -1 then
					outputChatBox("Nieprawidłowa nazwa pojazdu.", thePlayer, 255, 0, 0)
					return
				elseif vehicleEnd == #args - 2 then
					col2 = -1
				elseif vehicleEnd == #args - 1 then
					col1 = -1
					col2 = -1
				end
			end
			
			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
			
			if vehicleID then
				local plate = tostring( getElementData(thePlayer, "account:id") )
				if #plate < 8 then
					plate = " " .. plate
					while #plate < 8 do
						plate = string.char(math.random(string.byte('A'), string.byte('Z'))) .. plate
						if #plate < 8 then
						end
					end
				end
				
				if leadplus[ vehicleID ] and not exports.global:isPlayerLeadAdmin(thePlayer) then
					outputChatBox( "Insufficient access.", thePlayer, 255, 0, 0)
					return
				end
				
				local veh = createVehicle(vehicleID, x, y, z, 0, 0, r, plate)
				
				if not (veh) then
					outputChatBox("Niepoprawne id pojazdu.", thePlayer, 255, 0, 0)
				else
					if (armoredCars[vehicleID]) then
						setVehicleDamageProof(veh, true)
					end

					totalTempVehicles = totalTempVehicles + 1
					local dbid = (-totalTempVehicles)
					exports.pool:allocateElement(veh, dbid)
					
					setVehicleColor(veh, col1, col2, col1, col2)
					
					setElementInterior(veh, getElementInterior(thePlayer))
					setElementDimension(veh, getElementDimension(thePlayer))
					
					setVehicleOverrideLights(veh, 1)
					setVehicleEngineState(veh, false)
					setVehicleFuelTankExplodable(veh, false)
					setVehicleVariant(veh, exports['system-aut']:getRandomVariant(getElementModel(veh)))
					
					exports['antyczit']:changeProtectedElementDataEx(veh, "dbid", dbid)
					exports['antyczit']:changeProtectedElementDataEx(veh, "fuel", 100, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "Impounded", 0)
					exports['antyczit']:changeProtectedElementDataEx(veh, "engine", 0, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "oldx", x, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "oldy", y, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "oldz", z, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "faction", -1)
					exports['antyczit']:changeProtectedElementDataEx(veh, "owner", -1, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "job", 0, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "handbrake", 0, false)
					outputChatBox(getVehicleName(veh) .. " zespawnowano z tymczasowym ID# " .. dbid .. ".", thePlayer, 255, 194, 14)
					
					exports['interiory-aut']:add( veh )
					exports.logs:dbLog(thePlayer, 6, thePlayer, "VEH ".. vehicleID .. " created with ID " .. dbid)
				end
			else
				outputChatBox("Niepoprawne ID pojazdu.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("veh", createTempVehicle, false, false)
	
-- /oldcar
function getOldCarID(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.global:isPlayerAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				return
			end
		else
			return
		end
	end

	local oldvehid = getElementData(thePlayer, "lastvehid")
	
	if not (oldvehid) then
		outputChatBox("Nie byłes jeszcze w pojeździe.", showPlayer, 255, 0, 0)
	else
		outputChatBox("Stare ID pojazdu: " .. tostring(oldvehid) .. ".", showPlayer, 255, 194, 14)
	end
end
addCommandHandler("oldcar", getOldCarID, false, false)

-- /thiscar
function getCarID(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	
	if (veh) then
		local dbid = getElementData(veh, "dbid")
		outputChatBox("Pojazd ID: " .. dbid, thePlayer, 255, 194, 14)
	else
		outputChatBox("Nie jesteś w pojeździe.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("thiscar", getCarID, false, false)

-- /gotocar
function gotoCar(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local rx, ry, rz = getVehicleRotation(theVehicle)
				local x, y, z = getElementPosition(theVehicle)
				x = x + ( ( math.cos ( math.rad ( rz ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( rz ) ) ) * 5 )
				
				setElementPosition(thePlayer, x, y, z)
				setPedRotation(thePlayer, rz)
				setElementInterior(thePlayer, getElementInterior(theVehicle))
				setElementDimension(thePlayer, getElementDimension(theVehicle))
				
				exports.logs:dbLog(thePlayer, 6, theVehicle, "GOTOCAR")
				outputChatBox("Teleportowałeś się do lokacji pojazdu.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Nieprawidłowe ID pojazdu.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("gotocar", gotoCar, false, false)

-- /getcar
function getCar(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				local r = getPedRotation(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
				
				if	(getElementHealth(theVehicle)==0) then
					spawnVehicle(theVehicle, x, y, z, 0, 0, r)
				else
					setElementPosition(theVehicle, x, y, z)
					setVehicleRotation(theVehicle, 0, 0, r)
				end
				
				setElementInterior(theVehicle, getElementInterior(thePlayer))
				setElementDimension(theVehicle, getElementDimension(thePlayer))

				exports.logs:dbLog(thePlayer, 6, theVehicle, "GETCAR")
				outputChatBox("Pojazd został teleportowany do twojej lokacji.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("getcar", getCar, false, false)

function getNearbyVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		outputChatBox("Nearby Vehicles:", thePlayer, 255, 126, 0)
		local count = 0
		
		for index, nearbyVehicle in ipairs( exports.global:getNearbyElements(thePlayer, "vehicle") ) do
			local thisvehid = getElementData(nearbyVehicle, "dbid")
			if thisvehid then
				local vehicleID = getElementModel(nearbyVehicle)
				local vehicleName = getVehicleNameFromModel(vehicleID)
				local owner = getElementData(nearbyVehicle, "owner")
				local faction = getElementData(nearbyVehicle, "faction")
				count = count + 1
				
				local ownerName = ""
				
				if (faction>0) then
					local theTeam = exports.pool:getElement("team", faction)
					if theTeam then
						ownerName = getTeamName(theTeam)
					end
				elseif (owner==-1) then
					ownerName = "Admin"
				elseif (owner>0) then
					ownerName = exports['cache']:getCharacterName(owner, true)
				else
					ownerName = "Civilian"
				end
				
				if (thisvehid) then
					outputChatBox("   " .. vehicleName .. " (" .. vehicleID ..") with ID: " .. thisvehid .. ". Owner: " .. ownerName, thePlayer, 255, 126, 0)
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyvehicles", getNearbyVehicles, false, false)

function respawnCmdVehicle(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerLeadGameMaster(thePlayer)) then
		if not (id) then
			outputChatBox("PRZYKŁAD: /respawnveh [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
			if theVehicle then
				if isElementAttached(theVehicle) then
					detachElements(theVehicle)
				end
				exports['antyczit']:changeProtectedElementDataEx(theVehicle, 'i:left')
				exports['antyczit']:changeProtectedElementDataEx(theVehicle, 'i:right')
				local dbid = getElementData(theVehicle,"dbid")
				if (dbid<0) then -- TEMP vehicle
					fixVehicle(theVehicle) -- Can't really respawn this, so just repair it
					if armoredCars[ getElementModel( theVehicle ) ] then
						setVehicleDamageProof(theVehicle, true)
					else
						setVehicleDamageProof(theVehicle, false)
					end
					setVehicleWheelStates(theVehicle, 0, 0, 0, 0)
					exports['antyczit']:changeProtectedElementDataEx(theVehicle, "enginebroke", 0, false)
				else
					exports.logs:dbLog(thePlayer, 6, theVehicle, "RESPAWN")
					respawnVehicle(theVehicle)
					setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
					setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
					if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0  then
						setVehicleLocked(theVehicle, false)
					end
				end
				outputChatBox("Pojazd został Zrespawnowany.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Niepoprawne ID pojazdu.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("respawnveh", respawnCmdVehicle, false, false)

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function respawnAllVehicles(thePlayer, commandName, timeToRespawn)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if commandName then
			if isTimer(respawnTimer) then
				outputChatBox("Zostal uruchomiony respawn pojazdów, /respawnstop aby zatrzymać.", thePlayer, 255, 0, 0)
			else
				timeToRespawn = tonumber(timeToRespawn) or 30
				timeToRespawn = timeToRespawn < 10 and 10 or timeToRespawn
				for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
					local logged = getElementData(arrayPlayer, "loggedin")
					if (logged) then
						if exports.global:isPlayerLeadAdmin(arrayPlayer) then
							outputChatBox( "LeadAdmWarn: " .. getPlayerName(thePlayer) .. " executed a vehicle respawn.", arrayPlayer, 255, 194, 14)
						end
					end
				end
				
				outputChatBox("*** Wszystkie pojazdy zostały respawnowane w "..timeToRespawn.." sekund! ***", getRootElement(), 255, 194, 14)
				outputChatBox("Możesz zatrzymać proces wpisując /respawnstop!", thePlayer)
				respawnTimer = setTimer(respawnAllVehicles, timeToRespawn*1000, 1, thePlayer)
			end
			return
		end
		local tick = getTickCount()
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		local tempcounter = 0
		local tempoccupied = 0
		local occupiedcounter = 0
		local unlockedcivs = 0
		local notmoved = 0
		
		local dimensions = { }
		for k, p in ipairs(getElementsByType("player")) do
			dimensions[ getElementDimension( p ) ] = true
		end
		
		for k, theVehicle in ipairs(vehicles) do
			if isElement( theVehicle ) then
				local dbid = getElementData(theVehicle, "dbid")
				if not (dbid) or (dbid<0) then -- TEMP vehicle
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if (dbid and dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
						tempoccupied = tempoccupied + 1
					else
						destroyElement(theVehicle)
						tempcounter = tempcounter + 1
					end
				else
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if (dimensions[dbid + 20000]) or (pass1) or (pass2) or (pass3) or (driver) or (getVehicleTowingVehicle(theVehicle)) or #getAttachedElements(theVehicle) > 0 then
						occupiedcounter = occupiedcounter + 1
					else
						if isVehicleBlown(theVehicle) then --or isElementInWater(theVehicle) then
							fixVehicle(theVehicle)
							if armoredCars[ getElementModel( theVehicle ) ] then
								setVehicleDamageProof(theVehicle, true)
							else
								setVehicleDamageProof(theVehicle, false)
							end
							for i = 0, 5 do
								setVehicleDoorState(theVehicle, i, 4) -- all kind of stuff missing
							end
							setElementHealth(theVehicle, 300) -- lowest possible health
							exports['antyczit']:changeProtectedElementDataEx(theVehicle, "enginebroke", 1, false)
						end
						
						exports['antyczit']:changeProtectedElementDataEx(theVehicle, 'i:left')
						exports['antyczit']:changeProtectedElementDataEx(theVehicle, 'i:right')
						if getElementData(theVehicle, "owner") == -2 and getElementData(theVehicle,"Impounded") == 0 then
							if isElementAttached(theVehicle) then
								detachElements(theVehicle)
							end
							respawnVehicle(theVehicle)
							setVehicleLocked(theVehicle, false)
							unlockedcivs = unlockedcivs + 1
						else 
							local checkx, checky, checkz = getElementPosition( theVehicle )
							local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))
							
							if (round(checkx, 6) == x) and (round(checky, 6) == y) then
								notmoved = notmoved + 1
							else
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
								end
								setElementPosition(theVehicle, x, y, z)
								setVehicleRotation(theVehicle, rx, ry, rz)
								counter = counter + 1
							end
						end
						
						setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
						setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
						
						-- fix faction vehicles
						if getElementData(theVehicle, "faction") ~= -1 then
							fixVehicle(theVehicle)
							if (getElementData(theVehicle, "Impounded") == 0) then
								exports['antyczit']:changeProtectedElementDataEx(theVehicle, "enginebroke", 0, false)
								exports['antyczit']:changeProtectedElementDataEx(theVehicle, "handbrake", 1, false)
								setTimer(setElementFrozen, 2000, 1, theVehicle, true)
								if armoredCars[ getElementModel( theVehicle ) ] then
									setVehicleDamageProof(theVehicle, true)
								else
									setVehicleDamageProof(theVehicle, false)
								end
							end
						end
					end
				end
			end
		end
		local timeTaken = (getTickCount() - tick)/1000
		outputChatBox(" =-=-=-=-=-=- Wszystkie pojazdy zostały respawnowane =-=-=-=-=-=-=")
		outputChatBox("Respawned " .. counter .. "/" .. counter + notmoved .. " vehicles. (" .. occupiedcounter .. " Occupied) .", thePlayer)
		outputChatBox("Deleted " .. tempcounter .. " temporary vehicles. (" .. tempoccupied .. " Occupied).", thePlayer)
		outputChatBox("Unlocked and Respawned " .. unlockedcivs .. " civilian vehicles.", thePlayer)
		outputChatBox("All that in " .. timeTaken .." seconds.", thePlayer)
	end
end
addCommandHandler("respawnall", respawnAllVehicles, false, false)

function respawnVehiclesStop(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) and isTimer(respawnTimer) then
		killTimer(respawnTimer)
		respawnTimer = nil
		if commandName then
			local name = getPlayerName(thePlayer):gsub("_", " ")
			if getElementData(thePlayer, "hiddenadmin") == 1 then
				name = "Hidden Admin"
			end
			outputChatBox( "*** " .. name .. " anulował respawn pojazdów ***", getRootElement(), 255, 194, 14)
		end
	end
end
addCommandHandler("respawnstop", respawnVehiclesStop, false, false)

function respawnAllCivVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		
		for k, theVehicle in ipairs(vehicles) do
			local dbid = getElementData(theVehicle, "dbid")
			if dbid and dbid > 0 then
				if getElementData(theVehicle, "owner") == -2 then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then				
						if isElementAttached(theVehicle) then
							detachElements(theVehicle)
						end
						exports['antyczit']:changeProtectedElementDataEx(theVehicle, 'i:left')
						exports['antyczit']:changeProtectedElementDataEx(theVehicle, 'i:right')
						respawnVehicle(theVehicle)
						setVehicleLocked(theVehicle, false)
						setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
						setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
						counter = counter + 1
					end
				end
			end
		end
		outputChatBox(" =-=-=-=-=-=- Wszystkie cywilne auta zostały zrespawnowane =-=-=-=-=-=-=")
		outputChatBox("Zrespawnowano " .. counter .. " pojazdów.", thePlayer)
	end
end
addCommandHandler("respawnciv", respawnAllCivVehicles, false, false)

function respawnAllInteriorVehicles(thePlayer, commandName, repair)
	local repair = tonumber( repair ) == 1 and exports.global:isPlayerAdmin( thePlayer )
	local dimension = getElementDimension(thePlayer)
	if dimension > 0 and ( exports.global:hasItem(thePlayer, 4, dimension) or exports.global:hasItem(thePlayer, 5, dimension) ) then
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		
		for k, theVehicle in ipairs(vehicles) do
			if getElementData(theVehicle, "dimension") == dimension then
				local dbid = getElementData(theVehicle, "dbid")
				if dbid and dbid > 0 then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then
						local checkx, checky, checkz = getElementPosition( theVehicle )
						if getElementData(theVehicle, "respawnposition") then
						
						
							local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))
							
							if (round(checkx, 6) ~= x) or (round(checky, 6) ~= y) then
								if isElementAttached(theVehicle) then
									detachElements(theVehicle)
								end
								if repair then
									respawnVehicle(theVehicle)
									
									setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
									setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
								else
									setElementPosition(theVehicle, x, y, z)
									setVehicleRotation(theVehicle, rx, ry, rz)
									setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
									setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
								end
								counter = counter + 1
							end
						else
							exports.global:sendMessageToAdmins("[Respawn] There's something wrong with vehicle "..dbid)
						end
					end
				end
			end
		end
		outputChatBox("Respawned " .. counter .. " district vehicles.", thePlayer)
	else
		outputChatBox( "Ain't your place, is it?", thePlayer, 255, 0, 0 )
	end
end
addCommandHandler("respawnint", respawnAllInteriorVehicles, false, false)


function respawnDistrictVehicles(thePlayer, commandName)
	if exports.global:isPlayerAdmin( thePlayer ) then
		local zoneName = exports.global:getElementZoneName(thePlayer)
		local vehicles = exports.pool:getPoolElementsByType("vehicle")
		local counter = 0
		
		for k, theVehicle in ipairs(vehicles) do
			local vehicleZoneName = exports.global:getElementZoneName(theVehicle)
			if (zoneName == vehicleZoneName) then
				local dbid = getElementData(theVehicle, "dbid")
				if dbid and dbid > 0 then
					local driver = getVehicleOccupant(theVehicle)
					local pass1 = getVehicleOccupant(theVehicle, 1)
					local pass2 = getVehicleOccupant(theVehicle, 2)
					local pass3 = getVehicleOccupant(theVehicle, 3)

					if not pass1 and not pass2 and not pass3 and not driver and not getVehicleTowingVehicle(theVehicle) and #getAttachedElements(theVehicle) == 0 then
						local checkx, checky, checkz = getElementPosition( theVehicle )
						local x, y, z, rx, ry, rz = unpack(getElementData(theVehicle, "respawnposition"))
						
						if (round(checkx, 6) ~= x) or (round(checky, 6) ~= y) then
							if isElementAttached(theVehicle) then
								detachElements(theVehicle)
							end
							setElementPosition(theVehicle, x, y, z)
							setVehicleRotation(theVehicle, rx, ry, rz)
							setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
							setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
							
							counter = counter + 1
						end
					end
				end
			end
		end
		exports.global:sendMessageToAdmins("AdmWrn: ".. getPlayerName(thePlayer) .." respawned " .. counter .. " district vehicles in '"..zoneName.."'.", thePlayer)
	end
end
addCommandHandler("respawndistrict", respawnDistrictVehicles, false, false)

function addUpgrade(thePlayer, commandName, target, upgradeID)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (target) or not (upgradeID) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy Nick/ID] [Ulepszenie ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("Ten gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					local success = addVehicleUpgrade(theVehicle, upgradeID)
					
					if (success) then
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "ADDUPGRADE ".. upgradeID .. " " .. getVehicleUpgradeSlotName(upgradeID) )
						outputChatBox(getVehicleUpgradeSlotName(upgradeID) .. " ulepszenie dodane do pojazdu " .. targetPlayerName .. ".", thePlayer)
						outputChatBox("Admin " .. username .. " dodał ulepszenie " .. getVehicleUpgradeSlotName(upgradeID) .. " do twojego pojazdu.", targetPlayer)
						exports['zapis-aut']:saveVehicleMods(theVehicle)
					else
						outputChatBox("Błędne ID ulepszenia. Ten pojazd nie obsługuje tego ulepszenia.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("addupgrade", addUpgrade, false, false)

function addPaintjob(thePlayer, commandName, target, paintjobID)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (target) or not (paintjobID) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy Nick/ID] [Paintjob ID]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("That player is not in a vehicle.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					paintjobID = tonumber(paintjobID)
					if paintjobID == getVehiclePaintjob(theVehicle) then
						outputChatBox("Te Auto posiada już ten sam paintjob.", thePlayer, 255, 0, 0)
					else
						local success = setVehiclePaintjob(theVehicle, paintjobID)
						
						if (success) then
							exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "PAINTJOB ".. paintjobID )
							outputChatBox("Paintjob #" .. paintjobID .. " dodany do auta " .. targetPlayerName .. ".", thePlayer)
							outputChatBox("Admin " .. username .. " dodał Paintjob #" .. paintjobID .. " do twego pojazdu.", targetPlayer)
							exports['zapis-aut']:saveVehicleMods(theVehicle)
						else
							outputChatBox("Niepoprawne ID Paintjobu, lub ten pojazd nie obsługuje opcji Paintjobów.", thePlayer, 255, 0, 0)
						end
					end
				end
			end
		end
	end

end
addCommandHandler("setpaintjob", addPaintjob, false, false)

function resetUpgrades(thePlayer, commandName, target)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("Ten gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "RESETUPGRADES" )
					for key, value in ipairs(getVehicleUpgrades(theVehicle)) do
						removeVehicleUpgrade(theVehicle, value)
					end
					setVehiclePaintjob(theVehicle, 3)
					outputChatBox("Usunięto wszystkie ulepszenia z pojazdu gracza " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
					exports['zapis-aut']:saveVehicleMods(theVehicle)
				end
			end
		end
	end
end
addCommandHandler("resetupgrades", resetUpgrades, false, false)

function deleteUpgrade(thePlayer, commandName, target, id)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("Ten gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
				else
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "DELETEUPGRADE ".. id )
					local result = removeVehicleUpgrade(theVehicle, id)
					if result then
						outputChatBox("Usunięto ulepszenie ID# ".. id .." z pojazdu " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						exports['zapis-aut']:saveVehicleMods(theVehicle)
					else
						outputChatBox("Coś poszło nie tak z usuwaniem ulepszenia ID# ".. id .." z pojazdu gracza " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("deleteupgrade", deleteUpgrade, false, false)
addCommandHandler("delupgrade", deleteUpgrade, false, false)

function setVariant(thePlayer, commandName, target, variant1, variant2)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy Nick] [Wariant 1] [Wariant 2]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				if not (isPedInVehicle(targetPlayer)) then
					outputChatBox("Ten gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
				else
					variant1 = tonumber(variant1) or 255
					variant2 = tonumber(variant2) or 255
					local theVehicle = getPedOccupiedVehicle(targetPlayer)
					
					if exports['system-aut']:isValidVariant(getElementModel(theVehicle), variant1, variant2) then
						local a, b = getVehicleVariant(theVehicle)
						if a == variant1 and b == variant2 then
							outputChatBox("Pojazd posiada już ten wariant.", thePlayer, 255, 0, 0)
						else
							local success = setVehicleVariant(theVehicle, variant1, variant2)
							
							if (success) then
								exports.logs:dbLog(thePlayer, 6, { targetPlayer, theVehicle  }, "VARIANT ".. variant1 .. " " .. variant2 )
								outputChatBox("Wariant " .. variant1 .. "/" .. variant2.. " został dodany do pojazdu gracza " .. targetPlayerName .. ".", thePlayer)
								outputChatBox("Admin " .. username .. " dodał " .. variant1 .. "/" .. variant2 .. " do twojego pojazdu.", targetPlayer)
								exports['zapis-aut']:saveVehicleMods(theVehicle)
							else
								outputChatBox("Błędne ID, lub ten pojazd nie obsługuje tego PaintJobu.", thePlayer, 255, 0, 0)
							end
						end
					else
						outputChatBox(variant1 .. "/" .. variant2 .. " nie jest prawidłowym wariantem pojazdu " .. getVehicleName(theVehicle) .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end

end
addCommandHandler("setvariant", setVariant, false, false)

function findVehID(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowa nazwa]", thePlayer, 255, 194, 14)
		else
			local vehicleName = table.concat({...}, " ")
			local carID = getVehicleModelFromName(vehicleName)
			
			if (carID) then
				local fullName = getVehicleNameFromModel(carID)
				outputChatBox(fullName .. ": ID " .. carID .. ".", thePlayer)
			else
				outputChatBox("Nie znaleziono pojazdu.", thePlayer, 255, 0 , 0)
			end
		end
	end
end
addCommandHandler("findvehid", findVehID, false, false)
	
-----------------------------[FIX VEH]---------------------------------
function fixPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						fixVehicle(veh)
						if (getElementData(veh, "Impounded") == 0) then
							exports['antyczit']:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
							if armoredCars[ getElementModel( veh ) ] then
								setVehicleDamageProof(veh, true)
							else
								setVehicleDamageProof(veh, false)
							end
						end
						for i = 0, 5 do
							setVehicleDoorState(veh, i, 0)
						end
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "FIXVEH")
						outputChatBox("Naprawiłeś pojazd gracza " .. targetPlayerName .. ".", thePlayer)
						outputChatBox("Twój pojazd został naprawiony przez Administratora " .. username .. ".", targetPlayer)
					else
						outputChatBox("Ten gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fixveh", fixPlayerVehicle, false, false)

-----------------------------[FIX VEH VIS]---------------------------------
function fixPlayerVehicleVisual(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local health = getElementHealth(veh)
						fixVehicle(veh)
						setElementHealth(veh, health)
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "FIXVEHVIS" )
						outputChatBox("Naprawiłeś wizualne uszkodzenia pojazu gracza " .. targetPlayerName .. ".", thePlayer)
						outputChatBox("Twój pojazd został wizualnie naprawiony przez Administratora " .. username .. ".", targetPlayer)
					else
						outputChatBox("Ten gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fixvehvis", fixPlayerVehicleVisual, false, false)

-----------------------------[BLOW CAR]---------------------------------
function blowPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						blowVehicle(veh)
						outputChatBox("Wysadziłeś w powietrze pojazd gracza " .. targetPlayerName .. ".", thePlayer)
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "BLOWVEH" )
					else
						outputChatBox("Gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("blowveh", blowPlayerVehicle, false, false)

-----------------------------[SET CAR HP]---------------------------------
function setCarHP(thePlayer, commandName, target, hp)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) or not (hp) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy Nick] [Poziom HP]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						local sethp = setElementHealth(veh, tonumber(hp))
						
						if (sethp) then
							outputChatBox("Ustawiłeś graczowi " .. targetPlayerName .. "życie pojazdu na " .. hp .. "%.", thePlayer)
							--exports.logs:logMessage("[/SETCARHP] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." set ".. targetPlayerName .. "his car to hp: " .. hp , 4)
							exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "SETVEHHP ".. hp )
						else
							outputChatBox("Błędna wartość Życia.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Ten gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcarhp", setCarHP, false, false)

function fixAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			fixVehicle(value)
			if (not getElementData(value, "Impounded")) then
				exports['antyczit']:changeProtectedElementDataEx(value, "enginebroke", 0, false)
				if armoredCars[ getElementModel( value ) ] then
					setVehicleDamageProof(value, true)
				else
				setVehicleDamageProof(value, false)
				end
			end
		end
		outputChatBox("Wszystkie pojazdy zostały napawione przez administratora " .. username .. ".")
		exports.logs:dbLog(thePlayer, 6, { targetPlayer }, "FIXALLVEHS")
	end
end
addCommandHandler("fixvehs", fixAllVehicles)

-----------------------------[FUEL VEH]---------------------------------
function fuelPlayerVehicle(thePlayer, commandName, target)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy Nick]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						exports['antyczit']:changeProtectedElementDataEx(veh, "fuel", 100, false)
						triggerClientEvent(targetPlayer, "syncFuel", veh)
						outputChatBox("Uzupełniłeś paliwo w pojeździe gracza " .. targetPlayerName .. ".", thePlayer)
						outputChatBox("Twój pojazd został natankowany przez Administratora ;) " .. username .. ".", targetPlayer)
						exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "FUELVEH")
					else
						outputChatBox("Ten gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("fuelveh", fuelPlayerVehicle, false, false)

function fuelAllVehicles(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local username = getPlayerName(thePlayer)
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			exports['antyczit']:changeProtectedElementDataEx(value, "fuel", 100, false)
		end
		outputChatBox("Wszystkie pojazdy zostały natankowane przez Admina " .. username .. ".")
		exports.logs:dbLog(thePlayer, 6, { thePlayer  }, "FUELVEHS" )
	end
end
addCommandHandler("fuelvehs", fuelAllVehicles, false, false)

-----------------------------[SET COLOR]---------------------------------
function setPlayerVehicleColor(thePlayer, commandName, target, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (target) or not (...) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy nick] [Kolory ...]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				else
					local veh = getPedOccupiedVehicle(targetPlayer)
					if (veh) then
						-- parse colors
						local colors = {...}
						local col = {}
						for i = 1, math.min( 4, #colors ) do
							local r, g, b = getColorFromString(#colors[i] == 6 and ("#" .. colors[i]) or colors[i])
							if r and g and b then
								col[i] = {r=r, g=g, b=b}
							elseif tonumber(colors[1]) and tonumber(colors[1]) >= 0 and tonumber(colors[1]) <= 255 then
								col[i] = math.floor(tonumber(colors[i]))
							else
								outputChatBox("Błędny kolor: " .. colors[i], thePlayer, 255, 0, 0)
								return
							end
						end
						if not col[2] then col[2] = col[1] end
						if not col[3] then col[3] = col[1] end
						if not col[4] then col[4] = col[2] end
						
						local set = false
						if type( col[1] ) == "number" then
							set = setVehicleColor(veh, col[1], col[2], col[3], col[4])
						else
							set = setVehicleColor(veh, col[1].r, col[1].g, col[1].b, col[2].r, col[2].g, col[2].b, col[3].r, col[3].g, col[3].b, col[4].r, col[4].g, col[4].b)
						end
						
						if set then
							outputChatBox("Kolor pojazdu został zmieniony.", thePlayer, 0, 255, 0)
							exports['zapis-aut']:saveVehicleMods(veh)
							exports.logs:dbLog(thePlayer, 6, { targetPlayer, veh  }, "SETVEHICLECOLOR ".. table.concat({...}, " ") )
						else
							outputChatBox("Błędne ID koloru.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("Ten gracz nie jest w pojeździe.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("setcolor", setPlayerVehicleColor, false, false)
-----------------------------[GET COLOR]---------------------------------
function getAVehicleColor(thePlayer, commandName, carid)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (carid) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Car ID]", thePlayer, 255, 194, 14)
		else
			local acar = nil
			for i,c in ipairs(getElementsByType("vehicle")) do
				if (getElementData(c, "dbid") == tonumber(carid)) then
					acar = c
				end
			end
			if acar then
				local col =  { getVehicleColor(acar, true) }
				outputChatBox("Vehicle's colors are:", thePlayer)
				outputChatBox("1. " .. col[1].. "," .. col[2] .. "," .. col[3] .. " = " .. ("#%02X%02X%02X"):format(col[1], col[2], col[3]), thePlayer)
				outputChatBox("2. " .. col[4].. "," .. col[5] .. "," .. col[6] .. " = " .. ("#%02X%02X%02X"):format(col[4], col[5], col[6]), thePlayer)
				outputChatBox("3. " .. col[7].. "," .. col[8] .. "," .. col[9] .. " = " .. ("#%02X%02X%02X"):format(col[7], col[8], col[9]), thePlayer)
				outputChatBox("4. " .. col[10].. "," .. col[11] .. "," .. col[12] .. " = " .. ("#%02X%02X%02X"):format(col[10], col[11], col[12]), thePlayer)
			else
				outputChatBox("Niepoprawne ID pojazdu.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("getcolor", getAVehicleColor, false, false)

function deleteVehicle(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", dbid)
			if theVehicle then
				triggerEvent("onVehicleDelete", theVehicle)
				if (dbid<0) then -- TEMP vehicle
					destroyElement(theVehicle)
				else
					if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
						mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
						call( getResourceFromName( "system-przedmiotow" ), "deleteAll", 3, dbid )
						call( getResourceFromName( "system-przedmiotow" ), "clearItems", theVehicle )
						exports.logs:dbLog(thePlayer, 6, { theVehicle }, "DELVEH" )
						destroyElement(theVehicle)
						--exports.logs:logMessage("[DELVEH] " .. getPlayerName( thePlayer ) .. " deleted vehicle #" .. dbid, 9)
					else
						outputChatBox("Nie masz uprawnień do usuwania pojazdów zrespawnowowanych na stałe.", thePlayer, 255, 0, 0)
						return
					end
				end
				outputChatBox("Pojazd usunięty.", thePlayer)
			else
				outputChatBox("Nie ma pojadu o takim ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delveh", deleteVehicle, false, false)

-- DELTHISVEH

function deleteThisVehicle(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	local dbid = getElementData(veh, "dbid")
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if dbid < 0 or exports.global:isPlayerSuperAdmin(thePlayer) then
			if not (isPedInVehicle(thePlayer)) then
				outputChatBox("Nie jesteđ w pojedździe.", thePlayer, 255, 0, 0)
			else
				if dbid > 0 then
					mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
					call( getResourceFromName( "system-przedmiotow" ), "deleteAll", 3, dbid )
					call( getResourceFromName( "system-przedmiotow" ), "clearItems", veh )
					exports.logs:logMessage("[DELVEH] " .. getPlayerName( thePlayer ) .. " deleted vehicle #" .. dbid, 9)
					exports.logs:dbLog(thePlayer, 6, { veh  }, "DELVEH")
				end
				destroyElement(veh)
			end
		else
			outputChatBox("Nie masz uprawnień do usuwania pojazdów zrespawnowowanych na stałe.", thePlayer, 255, 0, 0)
			return
		end
	end
end
addCommandHandler("delthisveh", deleteThisVehicle, false, false)

function setVehicleFaction(thePlayer, theCommand, vehicleID, factionID)
	if (exports.global:isPlayerSuperAdmin(thePlayer) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer))) then
		if not (vehicleID) or not (factionID) then
			outputChatBox("PRZYKŁAD: /" .. theCommand .. " [pojazd ID] [frakcja ID]", thePlayer, 255, 194, 14)
		else
			local owner = -1
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			local factionElement = exports.pool:getElement("team", factionID)
			if theVehicle then
				if (tonumber(factionID) == -1) then
					owner = getElementData(thePlayer, "account:character:id")
				else
					if not factionElement then
						outputChatBox("Brak frakcji o podanym ID.", thePlayer, 255, 0, 0)
						return
					end
				end
			
				mysql:query_free("UPDATE `vehicles` SET `owner`='".. mysql:escape_string(owner) .."', `faction`='" .. mysql:escape_string(factionID) .. "' WHERE id = '" .. mysql:escape_string(vehicleID) .. "'")
				
				local x, y, z = getElementPosition(theVehicle)
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				exports['system-aut']:reloadVehicle(tonumber(vehicleID))
				local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
				setElementPosition(newVehicleElement, x, y, z)
				setElementInterior(newVehicleElement, int)
				setElementDimension(newVehicleElement, dim)
				outputChatBox("Zrobione ;) .", thePlayer)
			else
				outputChatBox("Nie znaleziono pojazdu o tym ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setvehiclefaction", setVehicleFaction)

--Adding/Removing tint
function setVehTint(admin, command, target, status)
	if (exports.global:isPlayerSuperAdmin(admin) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer))) then
		if not (target) or not (status) then
			outputChatBox("PRZYKŁAD: /" .. command .. " [Gracz] [0- Nie, 1- Tak]", admin, 255, 194, 14)
		else
			local username = getPlayerName(admin):gsub("_"," ")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(admin, target)
			
			if (targetPlayer) then
				local pv = getPedOccupiedVehicle(targetPlayer)
				if (pv) then
					local vid = getElementData(pv, "dbid")
					local stat = tonumber(status)
					if (stat == 1) then
						mysql:query_free("UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. mysql:escape_string(vid) .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("setTintName", pv, player)
							end
						end
						
						exports['antyczit']:changeProtectedElementDataEx(pv, "tinted", true, true)

						outputChatBox("Dodałeś przyciemnienie szyb do pojazdu #" .. vid .. ".", admin)
						for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
							local logged = getElementData(arrayPlayer, "loggedin")
							if (logged) then
								if exports.global:isPlayerLeadAdmin(arrayPlayer) then
									outputChatBox( "LeadAdmWarn: " .. getPlayerName(admin):gsub("_"," ") .. " dodał przyciemniane szyby do pojazdu #" .. vid .. ".", arrayPlayer, 255, 194, 14)
								end
							end
						end
						
						exports.logs:dbLog(thePlayer, 6, {pv, targetPlayer}, "SETVEHTINT 1" )
					elseif (stat == 0) then
						mysql:query_free("UPDATE vehicles SET tintedwindows = '0' WHERE id='" .. mysql:escape_string(vid) .. "'")
						for i = 0, getVehicleMaxPassengers(pv) do
							local player = getVehicleOccupant(pv, i)
							if (player) then
								triggerEvent("resetTintName", pv, player)
							end
						end
						exports['antyczit']:changeProtectedElementDataEx(pv, "tinted", false, true)

						outputChatBox("Usunięto przyciemnienie szyb z pojazdu #" .. vid .. ".", admin)
						for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
							local logged = getElementData(arrayPlayer, "loggedin")
							if (logged) then
								if exports.global:isPlayerLeadAdmin(arrayPlayer) then
									outputChatBox( "LeadAdmWarn: " .. getPlayerName(admin):gsub("_"," ") .. " usuwawa przyciemnienie szyb z pojazdu #" .. vid .. ".", arrayPlayer, 255, 194, 14)
								end
							end
						end
						exports.logs:dbLog(thePlayer, 4, {pv, targetPlayer}, "SETVEHTINT 0" )
					end
				else
					outputChatBox("Gracz nie jest w pojeździe.", admin, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("setvehtint", setVehTint)

function setVehiclePlate(thePlayer, theCommand, vehicleID, ...)
	if (exports.global:isPlayerSuperAdmin(thePlayer) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer))) then
		if not (vehicleID) or not (...) then
			outputChatBox("PRZYKŁAD: /" .. theCommand .. " [pojazd ID] [Treść]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			if theVehicle then
				if exports['system-aut']:hasVehiclePlates(theVehicle) then
					local plateText = table.concat({...}, " ")
					if (exports['system-tablic-rej']:checkPlate(plateText)) then
						local cquery = mysql:query_fetch_assoc("SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. mysql:escape_string(plateText).."'")
						if (tonumber(cquery["no"]) == 0) then
							local insertnplate = mysql:query_free("UPDATE vehicles SET plate='" .. mysql:escape_string(plateText) .. "' WHERE id = '" .. mysql:escape_string(vehicleID) .. "'")
							local x, y, z = getElementPosition(theVehicle)
							local int = getElementInterior(theVehicle)
							local dim = getElementDimension(theVehicle)
							exports['system-aut']:reloadVehicle(tonumber(vehicleID))
							local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
							setElementPosition(newVehicleElement, x, y, z)
							setElementInterior(newVehicleElement, int)
							setElementDimension(newVehicleElement, dim)
							outputChatBox("Zrobione Like A Boss ;) .", thePlayer)
						else
							outputChatBox("Ta tablica jest już w użyciu! =( umadbro?", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Niepoprawny tekst na tablicy.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Ten pojazd nie ma tablic rejestracyjnych.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Nie znaleziono pojazdu z tym ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("setvehicleplate", setVehiclePlate)

--[[
function deleteVehicle(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local dbid = tonumber(id)
		if not (dbid) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [id]", thePlayer, 255, 194, 14)
		else
			local theVehicle = exports.pool:getElement("vehicle", dbid)
			if theVehicle then
				triggerEvent("onVehicleDelete", theVehicle)
				if (dbid<0) then -- TEMP vehicle
					destroyElement(theVehicle)
				else
					if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
						mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(dbid) .. "'")
						call( getResourceFromName( "system-przedmiotow" ), "deleteAll", 3, dbid )
						call( getResourceFromName( "system-przedmiotow" ), "clearItems", theVehicle )
						exports.logs:dbLog(thePlayer, 6, { theVehicle }, "DELVEH" )
						destroyElement(theVehicle)
						--exports.logs:logMessage("[DELVEH] " .. getPlayerName( thePlayer ) .. " deleted vehicle #" .. dbid, 9)
					else
						outputChatBox("You do not have permission to delete permanent vehicles.", thePlayer, 255, 0, 0)
						return
					end
				end
				outputChatBox("Vehicle deleted.", thePlayer)
			else
				outputChatBox("No vehicles with that ID found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delveh", deleteVehicle, false, false)

]]

-- /entercar
function warpPedIntoVehicle2(player, car, ...)
	local dimension = getElementDimension(player)
	local interior = getElementInterior(player)
	
	setElementDimension(player, getElementDimension(car))
	setElementInterior(player, getElementInterior(car))
	if warpPedIntoVehicle(player, car, ...) then
		exports['antyczit']:changeProtectedElementDataEx(player, "realinvehicle", 1, false)
		return true
	else
		setElementDimension(player, dimension)
		setElementInterior(player, interior)
	end
	return false
end

function enterCar(thePlayer, commandName, targetPlayerName, targetVehicle, seat)
	if exports.global:isPlayerAdmin(thePlayer) then
		targetVehicle = tonumber(targetVehicle)
		seat = tonumber(seat)
		if targetPlayerName and targetVehicle then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer then
				local theVehicle = exports.pool:getElement("vehicle", targetVehicle)
				if theVehicle then
					if seat then
						local occupant = getVehicleOccupant(theVehicle, seat)
						if occupant then
							removePedFromVehicle(occupant)
							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has put " .. targetPlayerName .. " onto your seat.", occupant)
							exports['antyczit']:changeProtectedElementDataEx(occupant, "realinvehicle", 0, false)
						end
						
						if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then
							
							outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
							outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", targetPlayer)
						else
							outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
						end
					else
						local found = false
						local maxseats = getVehicleMaxPassengers(theVehicle) or 2
						for seat = 0, maxseats  do
							local occupant = getVehicleOccupant(theVehicle, seat)
							if not occupant then
								found = true
								if warpPedIntoVehicle2(targetPlayer, theVehicle, seat) then
									outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_", " ") .. " has warped you into this " .. getVehicleName(theVehicle) .. ".", targetPlayer)
									outputChatBox("You warped " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", targetPlayer)
								else
									outputChatBox("Unable to warp " .. targetPlayerName .. " into " .. getVehicleName(theVehicle) .. " #" .. targetVehicle .. ".", thePlayer, 255, 0, 0)
								end
								break
							end
						end
						
						if not found then
							outputChatBox("No free seats.", thePlayer, 255, 0, 0)
						end
					end
				else
					outputChatBox("Vehicle not found", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [player] [car ID] [seat]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("entercar", enterCar, false, false)
addCommandHandler("enterveh", enterCar, false, false)
addCommandHandler("entervehicle", enterCar, false, false)

