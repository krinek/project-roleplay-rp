mysql = exports.mysql

local null = mysql_null()
local toLoad = { }
local threads = { }

-- /makeveh
function createPermVehicle(thePlayer, commandName, ...)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
		local args = {...}
		if (#args < 7) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [id/name] [color1] [color2] [Owner] [Faction Vehicle (1/0)] [Cost] [Tinted Windows] ", thePlayer, 255, 194, 14)
			outputChatBox("NOTE: If it is a faction vehicle, Username is the owner of the faction.", thePlayer, 255, 194, 14)
			outputChatBox("NOTE: If it is a faction vehicle, The cost is taken from the faction fund, rather than the player.", thePlayer, 255, 194, 14)
		else
			local vehicleID = tonumber(args[1])
			local col1, col2, userName, factionVehicle, cost, tint
			
			if not vehicleID then -- vehicle is specified as name
				local vehicleEnd = 1
				repeat
					vehicleID = getVehicleModelFromName(table.concat(args, " ", 1, vehicleEnd))
					vehicleEnd = vehicleEnd + 1
				until vehicleID or vehicleEnd == #args
				if vehicleEnd == #args then
					outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
					return
				else
					col1 = tonumber(args[vehicleEnd])
					col2 = tonumber(args[vehicleEnd + 1])
					userName = args[vehicleEnd + 2]
					factionVehicle = tonumber(args[vehicleEnd + 3])
					cost = tonumber(args[vehicleEnd + 4])
					tint = tonumber(args[vehicleEnd + 5])
				end
			else
				col1 = tonumber(args[2])
				col2 = tonumber(args[3])
				userName = args[4]
				factionVehicle = tonumber(args[5])
				cost = tonumber(args[6])
				tint = tonumber(args[7])
			end
			
			local id = vehicleID
			
			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
			
			local targetPlayer, username = exports.global:findPlayerByPartialNick(thePlayer, userName)
			
			if targetPlayer then
				local to = nil
				local dbid = getElementData(targetPlayer, "dbid")
				
				if (factionVehicle==1) then
					factionVehicle = tonumber(getElementData(targetPlayer, "faction"))
					local theTeam = getPlayerTeam(targetPlayer)
					to = theTeam
					
					if not exports.global:takeMoney(theTeam, cost) then
						outputChatBox("This faction cannot afford this vehicle.", thePlayer, 255, 0, 0)
						return
					end
				else
					factionVehicle = -1
					to = targetPlayer
					if not exports.global:takeMoney(targetPlayer, cost) then
						outputChatBox("This player cannot afford this vehicle.", thePlayer, 255, 0, 0)
						return
					elseif not exports.global:canPlayerBuyVehicle(targetPlayer) then
						outputChatBox("This player has too many cars.", thePlayer, 255, 0, 0)
						exports.global:giveMoney(targetPlayer, cost)
						return
					elseif ( getVehicleType(id) == "Helicopter" or getVehicleType(id) == "Plane" ) and not exports.global:hasItem(targetPlayer, 78) then
						outputChatBox("The player has no Pilot Certificate.", thePlayer, 255, 0, 0)
						exports.global:giveMoney(targetPlayer, cost)
						return
					end
				end
				
				local letter1 = string.char(math.random(65,90))
				local letter2 = string.char(math.random(65,90))
				local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
				
				local veh = createVehicle(id, x, y, z, 0, 0, r, plate)
				if not (veh) then
					outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
					exports.global:giveMoney(to, cost)
				else
					local vehicleName = getVehicleName(veh)
					destroyElement(veh)
					local dimension = getElementDimension(thePlayer)
					local interior = getElementInterior(thePlayer)
					local var1, var2 = exports['system-aut']:getRandomVariant(id)
					local insertid = mysql:query_insert_free("INSERT INTO vehicles SET model='" .. mysql:escape_string(id) .. "', x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', rotx='0', roty='0', rotz='" .. mysql:escape_string(r) .. "', color1='[ [ 0, 0, 0 ] ]', color2='[ [ 0, 0, 0 ] ]', color3='[ [ 0, 0, 0 ] ] ', color4='[ [ 0, 0, 0 ] ]', faction='" .. mysql:escape_string(factionVehicle) .. "', owner='" .. mysql:escape_string(( factionVehicle == -1 and dbid or -1 )) .. "', plate='" .. mysql:escape_string(plate) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='0', currry='0', currrz='" .. mysql:escape_string(r) .. "', locked=1, interior='" .. mysql:escape_string(interior) .. "', currinterior='" .. mysql:escape_string(interior) .. "', dimension='" .. mysql:escape_string(dimension) .. "', currdimension='" .. mysql:escape_string(dimension) .. "', tintedwindows='" .. mysql:escape_string(tint) .. "',variant1="..var1..",variant2="..var2..",neony=0")

					if (insertid) then						
						if (factionVehicle==-1) then
							exports.global:giveItem(targetPlayer, 3, tonumber(insertid))
						end
						outputChatBox(vehicleName .. " spawned with ID #" .. insertid .. ".", thePlayer, 255, 194, 14)
						
						local owner = ""
						if factionVehicle == -1 then
							owner = "Owner: " .. getPlayerName( targetPlayer )
						else
							owner = "Faction #" .. factionVehicle
						end
						
						exports.logs:logMessage("[MAKEVEH] " .. getPlayerName( thePlayer ) .. " created car #" .. insertid .. " (" .. vehicleName .. ") - " .. owner, 9)
						
						exports.logs:dbLog(thePlayer, 6, { "ve" .. insertid }, "SPAWNVEH '"..vehicleName.."' $"..cost.." "..owner )
						
						reloadVehicle(insertid)
					end
				end
			end
		end
	end
end
addCommandHandler("makeveh", createPermVehicle, false, false)

-- /makecivveh
function createCivilianPermVehicle(thePlayer, commandName, ...)
	if (exports.global:isPlayerSuperAdmin(thePlayer)) then
		local args = {...}
		if (#args < 4) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [id/name] [color1 (-1 for random)] [color2 (-1 for random)] [Job ID -1 for none]", thePlayer, 255, 194, 14)
			outputChatBox("Job 1 = Delivery Driver", thePlayer, 255, 194, 14)
			outputChatBox("Job 2 = Taxi Driver", thePlayer, 255, 194, 14)
			outputChatBox("Job 3 = Bus Driver", thePlayer, 255, 194, 14)
			outputChatBox("Job 4 = Donut Delivery", thePlayer, 255, 194, 14)
		else
			local vehicleID = tonumber(args[1])
			local col1, col2, job
			
			if not vehicleID then -- vehicle is specified as name
				local vehicleEnd = 1
				repeat
					vehicleID = getVehicleModelFromName(table.concat(args, " ", 1, vehicleEnd))
					vehicleEnd = vehicleEnd + 1
				until vehicleID or vehicleEnd == #args
				if vehicleEnd == #args then
					outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
					return
				else
					col1 = tonumber(args[vehicleEnd])
					col2 = tonumber(args[vehicleEnd + 1])
					job = tonumber(args[vehicleEnd + 2])
				end
			else
				col1 = tonumber(args[2])
				col2 = tonumber(args[3])
				job = tonumber(args[4])
			end
			
			local id = vehicleID
			
			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )
			
			local letter1 = string.char(math.random(65,90))
			local letter2 = string.char(math.random(65,90))
			local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)

			local veh = createVehicle(id, x, y, z, 0, 0, r, plate)
				
			if not (veh) then
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			else
				exports['antyczit']:changeProtectedElementDataEx(veh, "fuel", 100)
				exports['antyczit']:changeProtectedElementDataEx(veh, "handbrake", 0, false)
					
				if (job>0) then
					toggleVehicleRespawn(veh, true)
					setVehicleRespawnDelay(veh, 60000)
					setVehicleIdleRespawnDelay(veh, 180000)
				end
					
				if (job == 4) then
					job = 7
				end
				
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				exports['antyczit']:changeProtectedElementDataEx(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
				
				setVehicleLocked(veh, false)
					
				setVehicleColor(veh, col1, col2, col1, col2)
					
				setVehicleOverrideLights(veh, 1)
				setVehicleEngineState(veh, false)
				setVehicleFuelTankExplodable(veh, false)
				
				local dimension = getElementDimension(thePlayer)
				local interior = getElementInterior(thePlayer)
				
				exports['antyczit']:changeProtectedElementDataEx(veh, "dimension", dimension, false)
				exports['antyczit']:changeProtectedElementDataEx(veh, "interior", interior, false)
				exports['antyczit']:changeProtectedElementDataEx(veh, "job", job, job ~= 0)
				exports['antyczit']:changeProtectedElementDataEx(veh, "odometer", 0, true)
				
				-- Set the vehicle armored if it is armored
				if (armoredCars[id]) then
					setVehicleDamageProof(veh, true)
				end
					
				local insertid = mysql:query_insert_free("INSERT INTO vehicles SET job='" .. mysql:escape_string(job) .. "', model='" .. mysql:escape_string(id) .. "', x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', rotx='" .. mysql:escape_string(rx) .. "', roty='" .. mysql:escape_string(ry) .. "', rotz='" .. mysql:escape_string(rz) .. "', color1='" .. mysql:escape_string(col1) .. "', color2='" .. mysql:escape_string(col2) .. "', faction='-1', owner='-2', plate='" .. mysql:escape_string(plate) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='0', currry='0', currrz='" .. mysql:escape_string(r) .. "', interior='" .. mysql:escape_string(interior) .. "', currinterior='" .. mysql:escape_string(interior) .. "', dimension='" .. mysql:escape_string(dimension) .. "', currdimension='" .. mysql:escape_string(dimension) .. "'")
				
				if (insertid) then
					exports.pool:allocateElement(veh, insertid)
					
					exports['antyczit']:changeProtectedElementDataEx(veh, "dbid", insertid)
					exports['antyczit']:changeProtectedElementDataEx(veh, "fuel", 100)
					exports['antyczit']:changeProtectedElementDataEx(veh, "engine", 0, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "oldx", x, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "oldy", y, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "oldz", z, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "faction", -1)
					exports['antyczit']:changeProtectedElementDataEx(veh, "owner", -2, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "job", job, job ~= 0)
					exports['antyczit']:changeProtectedElementDataEx(veh, "handbrake", 0, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "vehicle:windowstat", 0, true)
					outputChatBox(getVehicleName(veh) .. " (Civilian) spawned with ID #" .. insertid .. ".", thePlayer, 255, 194, 14)
					
					exports.logs:logMessage("[MAKECIVVEH] " .. getPlayerName( thePlayer ) .. " created car #" .. insertid .. " (" .. getVehicleNameFromModel( id ) .. ")", 9)
					
					exports['interiory-aut']:add( veh )
				else
					destroyElement( veh )
				end
			end
		end
	end
end
addCommandHandler("makecivveh", createCivilianPermVehicle, false, false)

function loadAllVehicles(res)
	-- Reset player in vehicle states
	local players = exports.pool:getPoolElementsByType("player")
	for key, value in ipairs(players) do
		exports['antyczit']:changeProtectedElementDataEx(value, "realinvehicle", 0, false)
	end
	

	local result = mysql:query("SELECT id FROM `vehicles` ORDER BY `id` ASC")
	if result then
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			
			toLoad[tonumber(row["id"])] = true
			--loadOneVehicle(row)
		end
		mysql:free_result(result)
		
		for id in pairs( toLoad ) do
			
			local co = coroutine.create(loadOneVehicle)
			coroutine.resume(co, id, true)
			table.insert(threads, co)
		end
		setTimer(resume, 1000, 4)
	else
		outputDebugString( "loadAllVehicles failed" )
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllVehicles)

function resume()
	for key, value in ipairs(threads) do
		coroutine.resume(value)
	end
end

function reloadVehicle(id)
	local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
	if (theVehicle) then
		removeSafe(tonumber(id))
		exports['zapis-aut']:saveVehicle(theVehicle)
		destroyElement(theVehicle)
	end
	loadOneVehicle(id, false)
	return true
end

neony = {
	--id neona, id obiektu
	{1, 14399},
	{2, 14400},
	{3, 14401},
	{4, 14402},
}

neonytrue = {
	[14399]=true,
	[14400]=true,
	[14401]=true,
	[14402]=true
}

function findNeonColor(id)
	for i,v in ipairs(neony) do
		if v[1] == id then
			return v[2]
		end
	end
	return false
end

function loadOneVehicle(id, hasCoroutine)
	if (hasCoroutine==nil) then
		hasCoroutine = false
	end
	
	local row = mysql:query_fetch_assoc("SELECT * FROM vehicles WHERE id = " .. mysql:escape_string(id) .. " LIMIT 1" )
	if row then
		
		if (hasCoroutine) then
			coroutine.yield()
		end
		
		for k, v in pairs( row ) do
			if v == null then
				row[k] = nil
			else
				row[k] = tonumber(row[k]) or row[k]
			end
		end
		-- Valid vehicle variant?
		local var1, var2 = row.variant1, row.variant2
		if not isValidVariant(row.model, var1, var2) then
			var1, var2 = getRandomVariant(row.model)
			mysql:query_free("UPDATE vehicles SET variant1 = " .. var1 .. ", variant2 = " .. var2 .. " WHERE id='" .. mysql:escape_string(row.id) .. "'")
		end

		-- Spawn the vehicle
		local veh = createVehicle(row.model, row.currx, row.curry, row.currz, row.currrx, row.currry, row.currrz, row.plate, false, var1, var2)
		if veh then
			exports['antyczit']:changeProtectedElementDataEx(veh, "dbid", row.id)
			exports.pool:allocateElement(veh, row.id)
					
			-- color and paintjob
			local color1 = fromJSON(row.color1) 
			local color2 = fromJSON(row.color2) 
			local color3 = fromJSON(row.color3) 
			local color4 = fromJSON(row.color4) 
			setVehicleColor(veh, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3], color3[1], color3[2], color3[3], color4[1], color4[2], color4[3])
			if row.paintjob ~= 0 then
				setVehiclePaintjob(veh, row.paintjob)
			end	
			-- Set the vehicle armored if it is armored
			if (armoredCars[row.model]) then
				setVehicleDamageProof(veh, true)
			end
			
			-- Cosmetics
			local upgrades = fromJSON(row["upgrades"])
			for slot, upgrade in ipairs(upgrades) do
				if upgrade and tonumber(upgrade) > 0 then
					addVehicleUpgrade(veh, upgrade)
				end
			end
			
			local panelStates = fromJSON(row["panelStates"])
			for panel, state in ipairs(panelStates) do
				setVehiclePanelState(veh, panel-1 , tonumber(state) or 0)
			end
			
			local doorStates = fromJSON(row["doorStates"])
			for door, state in ipairs(panelStates) do
				setVehicleDoorState(veh, door-1, tonumber(state) or 0)
			end
			
			local headlightColors = fromJSON(row["headlights"])
			if headlightColors then
				setVehicleHeadLightColor ( veh, headlightColors[1], headlightColors[2], headlightColors[3])
			end
			exports['antyczit']:changeProtectedElementDataEx(veh, "headlightcolors", headlightColors, true)
			
			local neony = fromJSON(row["neony"])
			if not neony == 0 then
				setElementData(veh, "neonyava", neony)
			else
				setElementData(veh, "neonyava", false)
			end
			
			if row["maxspeed"] == 0 then
			else
				setVehicleHandling(getPedOccupiedVehicle(player), "maxVelocity", row["maxspeed"])
				setVehicleHandling(getPedOccupiedVehicle(player), "engineAcceleration", row["acceleration"])
				setVehicleHandling(getPedOccupiedVehicle(player), "steeringLock", row["steeringlock"])
				setElementData(getPedOccupiedVehicle(player), "enginePro:speed", row["maxspeed"])
			end
			
			local wheelStates = fromJSON(row["wheelStates"])
			setVehicleWheelStates(veh, tonumber(wheelStates[1]) , tonumber(wheelStates[2]) , tonumber( wheelStates[3]) , tonumber(wheelStates[4]) )
			
			-- lock the vehicle if it's locked
			setVehicleLocked(veh, row.owner ~= -2 and row.locked == 1)
			
			-- set the sirens on if it has some
			setVehicleSirensOn(veh, row.sirens == 1)
				
			-- job
			if row.job > 0 then
				toggleVehicleRespawn(veh, true)
				setVehicleRespawnDelay(veh, 60000)
				setVehicleIdleRespawnDelay(veh, 15 * 60000)
				exports['antyczit']:changeProtectedElementDataEx(veh, "job", row.job)
			else
				exports['antyczit']:changeProtectedElementDataEx(veh, "job", 0, false)
			end
			
			setVehicleRespawnPosition(veh, row.x, row.y, row.z, row.rotx, row.roty, row.rotz)
			exports['antyczit']:changeProtectedElementDataEx(veh, "respawnposition", {row.x, row.y, row.z, row.rotx, row.roty, row.rotz}, false)
			
			-- element data
			exports['antyczit']:changeProtectedElementDataEx(veh, "fuel", row.fuel, false)
			exports['antyczit']:changeProtectedElementDataEx(veh, "oldx", row.currx, false)
			exports['antyczit']:changeProtectedElementDataEx(veh, "oldy", row.curry, false)
			exports['antyczit']:changeProtectedElementDataEx(veh, "oldz", row.currz, false)
			exports['antyczit']:changeProtectedElementDataEx(veh, "faction", tonumber(row.faction))
			exports['antyczit']:changeProtectedElementDataEx(veh, "owner", tonumber(row.owner))
			exports['antyczit']:changeProtectedElementDataEx(veh, "vehicle:windowstat", 0, true)
			
			if tonumber(row.faction) >= 0 then
				setVehicleLocked(veh, true)
			end
			
			-- impound shizzle
			exports['antyczit']:changeProtectedElementDataEx(veh, "Impounded", tonumber(row.Impounded))
			if tonumber(row.Impounded) > 0 then
				setVehicleDamageProof(veh, true)
			end
			
			-- interior/dimension
			setElementDimension(veh, row.currdimension)
			setElementInterior(veh, row.currinterior)
			
			exports['antyczit']:changeProtectedElementDataEx(veh, "dimension", row.dimension, false)
			exports['antyczit']:changeProtectedElementDataEx(veh, "interior", row.interior, false)
			
			-- lights
			setVehicleOverrideLights(veh, row.lights == 0 and 1 or row.lights )
			
			-- engine
			if row.hp <= 350 then
				setElementHealth(veh, 300)
				setVehicleDamageProof(veh, true)
				setVehicleEngineState(veh, false)
				exports['antyczit']:changeProtectedElementDataEx(veh, "engine", 0, false)
				exports['antyczit']:changeProtectedElementDataEx(veh, "enginebroke", 1, false)
			else
				setElementHealth(veh, row.hp)
				setVehicleEngineState(veh, row.engine == 1)
				exports['antyczit']:changeProtectedElementDataEx(veh, "engine", row.engine, false)
				exports['antyczit']:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
			end
			setVehicleFuelTankExplodable(veh, false)
			
			-- handbrake
			exports['antyczit']:changeProtectedElementDataEx(veh, "handbrake", row.handbrake, false)
			if row.handbrake > 0 then
				setElementFrozen(veh, true)
			end
			
			local hasInterior, interior = exports['interiory-aut']:add( veh )
			if hasInterior and row.safepositionX and row.safepositionY and row.safepositionZ and row.safepositionRZ then
				addSafe( row.id, row.safepositionX, row.safepositionY, row.safepositionZ, row.safepositionRZ, interior )
			end
			
			if row.tintedwindows == 1 then
				exports['antyczit']:changeProtectedElementDataEx(veh, "tinted", true, true)
			end
			exports['antyczit']:changeProtectedElementDataEx(veh, "odometer", tonumber(row.odometer), false)
		end
	end
end

function vehicleExploded()
	local job = getElementData(source, "job")
	
	if not job or job<=0 then
		setTimer(respawnVehicle, 60000, 1, source)
	end
end
addEventHandler("onVehicleExplode", getRootElement(), vehicleExploded)

function vehicleRespawn(exploded)
	local id = getElementData(source, "dbid")
	local faction = getElementData(source, "faction")
	local job = getElementData(source, "job")
	local owner = getElementData(source, "owner")
	local windowstat = getElementData(source, "vehicle:windowstat")
	
	if (job>0) then
		toggleVehicleRespawn(source, true)
		setVehicleRespawnDelay(source, 60000)
		setVehicleIdleRespawnDelay(source, 15 * 60000)
		setElementFrozen(source, true)
		exports['antyczit']:changeProtectedElementDataEx(source, "handbrake", 1, false)
	end
	
	-- Set the vehicle armored if it is armored
	local vehid = getElementModel(source)
	if (armoredCars[tonumber(vehid)]) then
		setVehicleDamageProof(source, true)
	else
		setVehicleDamageProof(source, false)
	end
		
	setVehicleFuelTankExplodable(source, false)
	setVehicleEngineState(source, false)
	setVehicleLandingGearDown(source, true)

	exports['antyczit']:changeProtectedElementDataEx(source, "enginebroke", 0, false)
	
	exports['antyczit']:changeProtectedElementDataEx(source, "dbid", id)
	exports['antyczit']:changeProtectedElementDataEx(source, "fuel", 100)
	exports['antyczit']:changeProtectedElementDataEx(source, "engine", 0, false)
	exports['antyczit']:changeProtectedElementDataEx(source, "vehicle:windowstat", windowstat, false)
	
	local x, y, z = getElementPosition(source)
	exports['antyczit']:changeProtectedElementDataEx(source, "oldx", x, false)
	exports['antyczit']:changeProtectedElementDataEx(source, "oldy", y, false)
	exports['antyczit']:changeProtectedElementDataEx(source, "oldz", z, false)
	
	exports['antyczit']:changeProtectedElementDataEx(source, "faction", faction)
	exports['antyczit']:changeProtectedElementDataEx(source, "owner", owner, false)
	
	setVehicleOverrideLights(source, 1)
	setElementFrozen(source, false)
	
	-- Set the sirens off
	setVehicleSirensOn(source, false)
	
	setVehicleLightState(source, 0, 0)
	setVehicleLightState(source, 1, 0)
	
	local dimension = getElementDimension(source)
	local interior = getElementInterior(source)
	
	setElementDimension(source, dimension)
	setElementInterior(source, interior)
	
	-- unlock civ vehicles
	if owner == -2 then
		setVehicleLocked(source, false)
		setElementFrozen(source, true)
		exports['antyczit']:changeProtectedElementDataEx(source, "handbrake", 1, false)
	end
	
	setElementFrozen(source, getElementData(source, "handbrake") == 1)
end
addEventHandler("onVehicleRespawn", getResourceRootElement(), vehicleRespawn)

function setEngineStatusOnEnter(thePlayer, seat)
	if seat == 0 then
		local engine = getElementData(source, "engine")
		local model = getElementModel(source)
		if not (enginelessVehicle[model]) then
			if (engine==0) then
				toggleControl(thePlayer, 'brake_reverse', false)
				setVehicleEngineState(source, false)
			else
				toggleControl(thePlayer, 'brake_reverse', true)
				setVehicleEngineState(source, true)
			end
		else
			toggleControl(thePlayer, 'brake_reverse', true)
			
			setVehicleEngineState(source, true)
			exports['antyczit']:changeProtectedElementDataEx(source, "engine", 1, false)
		end
	end
	triggerEvent("sendCurrentInventory", thePlayer, source)
end
addEventHandler("onVehicleEnter", getRootElement(), setEngineStatusOnEnter)

function vehicleExit(thePlayer, seat)
	if (isElement(thePlayer)) then
		toggleControl(thePlayer, 'brake_reverse', true)
		-- For oldcar
		local vehid = getElementData(source, "dbid")
		exports['antyczit']:changeProtectedElementDataEx(thePlayer, "lastvehid", vehid, false)
		setPedGravity(thePlayer, 0.008)
		setElementFrozen(thePlayer, false)
	end
end
addEventHandler("onVehicleExit", getRootElement(), vehicleExit)

function destroyTyre(veh)
	local tyre1, tyre2, tyre3, tyre4 = getVehicleWheelStates(veh)
	
	if (tyre1==1) then
		tyre1 = 2
	end
	
	if (tyre2==1) then
		tyre2 = 2
	end
	
	if (tyre3==1) then
		tyre3 = 2
	end
	
	if (tyre4==1) then
		tyre4 = 2
	end
	
	if (tyre1==2 and tyre2==2 and tyre3==2 and tyre4==2) then
		tyre3 = 0
	end
	
	exports['antyczit']:changeProtectedElementDataEx(veh, "tyretimer")
	setVehicleWheelStates(veh, tyre1, tyre2, tyre3, tyre4)
end

function damageTyres()
	local tyre1, tyre2, tyre3, tyre4 = getVehicleWheelStates(source)
	local tyreTimer = getElementData(source, "tyretimer")
	
	if (tyretimer~=1) then
		if (tyre1==1) or (tyre2==1) or (tyre3==1) or (tyre4==1) then
			exports['antyczit']:changeProtectedElementDataEx(source, "tyretimer", 1, false)
			local randTime = math.random(5, 15)
			randTime = randTime * 1000
			setTimer(destroyTyre, randTime, 1, source)
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), damageTyres)

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "j", "down", toggleEngine)) then
			bindKey(arrayPlayer, "j", "down", toggleEngine)
		end
		
		if not(isKeyBound(arrayPlayer, "l", "down", toggleLights)) then
			bindKey(arrayPlayer, "l", "down", toggleLights)
		end
		
		if not(isKeyBound(arrayPlayer, "k", "down", toggleLock)) then
			bindKey(arrayPlayer, "k", "down", toggleLock)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "j", "down", toggleEngine)
	bindKey(source, "l", "down", toggleLights)
	bindKey(source, "k", "down", toggleLock)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function toggleEngine(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = getElementData(source, "realinvehicle")

	if veh and inVehicle == 1 then
		local seat = getPedOccupiedVehicleSeat(source)
		
		if (seat == 0) then
			local model = getElementModel(veh)
			if not (enginelessVehicle[model]) then
				local engine = getElementData(veh, "engine")
				local vehID = getElementData(veh, "dbid")
				local vehKey = exports['global']:hasItem(source, 3, vehID)
				if engine == 0 then
					local vjob = tonumber(getElementData(veh, "job"))
					local job = getElementData(source, "job")
					local owner = getElementData(veh, "owner")
					local faction = tonumber(getElementData(veh, "faction"))
					local playerFaction = tonumber(getElementData(source, "faction"))
					if (vehKey) or (owner < 0) and (faction == -1) or (playerFaction == faction) and (faction ~= -1) or ((getElementData(source, "adminduty") or 0) == 1) then
						local fuel = getElementData(veh, "fuel")
						local broke = getElementData(veh, "enginebroke")
						if broke == 1 then
							exports.global:sendLocalMeAction(source, "próbuje uruchomić silnik jednak bezskutecznie.")
							exports.info:showBox(source,"info","Silnik jest uszkodzony.")
						elseif exports.global:hasItem(veh, 74) then
							while exports.global:hasItem(veh, 74) do
								exports.global:takeItem(veh, 74)
							end
							
							blowVehicle(veh)
						elseif fuel >= 1 then
							toggleControl(source, 'brake_reverse', true)
							
							setVehicleEngineState(veh, true)
							exports['antyczit']:changeProtectedElementDataEx(veh, "engine", 1, false)
						elseif fuel < 1 then
							exports.global:sendLocalMeAction(source, "próbuje uruchomić silnik bezskutecznie.")
							exports.info:showBox(source,"info","Brak paliwa.")
						end
					else
						exports.info:showBox(source,"info","Nie posiadasz Kluczy do tego pojazdu.")
					end
				else
					toggleControl(source, 'brake_reverse', false)
					
					setVehicleEngineState(veh, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "engine", 0, false)
				end
			end
		end
	end
end

function toggleLock(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = getElementData(source, "realinvehicle")
	
	if (veh) and (inVehicle==1) then
		triggerEvent("lockUnlockInsideVehicle", source, veh)
	elseif not veh then
		if getElementDimension(source) >= 19000 then
			local vehicle = exports.pool:getElement("vehicle", getElementDimension(source) - 20000)
			if vehicle and exports['interiory-aut']:isNearExit(source, vehicle) then
				local model = getElementModel(vehicle)
				local owner = getElementData(vehicle, "owner")
				local dbid = getElementData(vehicle, "dbid")
				
				if (owner ~= -2) then
					if ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
						local locked = isVehicleLocked(vehicle)
						if (locked) then
							setVehicleLocked(vehicle, false)
							exports.global:sendLocalMeAction(source, "otwiera swój pojazd.")
						else
							setVehicleLocked(vehicle, true)
							exports.global:sendLocalMeAction(source, "zakluczył swój pojazd.")
						end
					else
						outputChatBox("(( You can't lock impounded vehicles. ))", source, 255, 195, 14)
					end
				else
					outputChatBox("(( You can't lock civilian vehicles. ))", source, 255, 195, 14)
				end
				return
			end
		end
		
		local interiorFound, interiorDistance = exports['system-domow']:lockUnlockHouseEvent(source, true)
		
		local x, y, z = getElementPosition(source)
		local nearbyVehicles = exports.global:getNearbyElements(source, "vehicle", 30)
		
		local found = nil
		local shortest = 31
		for i, veh in ipairs(nearbyVehicles) do
			local dbid = tonumber(getElementData(veh, "dbid"))
			local distanceToVehicle = getDistanceBetweenPoints3D(x, y, z, getElementPosition(veh))
			if shortest > distanceToVehicle and ( getElementData(source, "adminduty") == 1 or exports.global:hasItem(source, 3, dbid) or (getElementData(source, "faction") > 0 and getElementData(source, "faction") == getElementData(veh, "faction")) ) then
				shortest = distanceToVehicle
				found = veh
			end
		end
		
		if (interiorFound and found) then
			if shortest < interiorDistance then
				triggerEvent("lockUnlockOutsideVehicle", source, found)
			else
				triggerEvent("lockUnlockHouse", source)
			end
		elseif found then
			triggerEvent("lockUnlockOutsideVehicle", source, found)
		elseif interiorFound then
			triggerEvent("lockUnlockHouse", source)
		end
	end
end

function checkLock(thePlayer, seat, jacked)
	local locked = isVehicleLocked(source)
	
	if (locked) and not (jacked) then
		cancelEvent()
		exports.info:showBox(thePlayer,"info","Drzwi są zamknięte.")
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), checkLock)

function toggleLights(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = getElementData(source, "realinvehicle")

	if (veh) and (inVehicle==1) then
		local model = getElementModel(veh)
		if not (lightlessVehicle[model]) then
			local lights = getVehicleOverrideLights(veh)
			local seat = getPedOccupiedVehicleSeat(source)

			if (seat==0) then
				if (lights~=2) then
					setVehicleOverrideLights(veh, 2)
					exports['antyczit']:changeProtectedElementDataEx(veh, "lights", 1, false)
				elseif (lights~=1) then
					setVehicleOverrideLights(veh, 1)
					exports['antyczit']:changeProtectedElementDataEx(veh, "lights", 0, false)
				end
			end
		end
	end
end

--/////////////////////////////////////////////////////////
--Fix for spamming keys to unlock etc on entering
--/////////////////////////////////////////////////////////

-- bike lock fix
function checkBikeLock(thePlayer)
	if (isVehicleLocked(source)) and (getVehicleType(source)=="Bike" or getVehicleType(source)=="Boat" or getVehicleType(source)=="BMX" or getVehicleType(source)=="Quad" or getElementModel(source)==568 or getElementModel(source)==571 or getElementModel(source)==572 or getElementModel(source)==424) then
		if not getElementData(thePlayer, "interiormarker") then
			exports.info:showBox(thePlayer,"info","Ten pojazd jest zamknięty.")
		end
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), checkBikeLock)

function setRealInVehicle(thePlayer)
	if isVehicleLocked(source) then
		exports['antyczit']:changeProtectedElementDataEx(thePlayer, "realinvehicle", 0, false)
		removePedFromVehicle(thePlayer)
		setVehicleLocked(source, true)
	else
		exports['antyczit']:changeProtectedElementDataEx(thePlayer, "realinvehicle", 1, false)
		
		-- 0000464: Car owner message. 
		local owner = getElementData(source, "owner")
		local faction = getElementData(source, "faction")
		local carName = getVehicleName(source)
		
		if owner < 0 and faction == -1 then
			outputChatBox("(( Ten pojazd " .. carName .. " jest pojazdem cywilnym. ))", thePlayer, 255, 195, 14)
		elseif (faction==-1) and (owner>0) then
			local ownerName = exports['cache']:getCharacterName(owner)
			
			if ownerName then
				outputChatBox("(( Pojazd " .. carName .. " należy do " .. ownerName .. ". ))", thePlayer, 255, 195, 14)
				if (getElementData(source, "Impounded") > 0) then
					local output = getRealTime().yearday-getElementData(source, "Impounded")
					outputChatBox("(( Ten pojazd " .. carName .. " has been Impounded for: " .. output .. (output == 1 and " Day." or " Days.") .. " ))", thePlayer, 255, 195, 14)
				end
			end
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), setRealInVehicle)

function setRealNotInVehicle(thePlayer)
	local locked = isVehicleLocked(source)
	
	if not (locked) then
		if (thePlayer) then
			exports['antyczit']:changeProtectedElementDataEx(thePlayer, "realinvehicle", 0, false)
		end
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), setRealNotInVehicle)

-- Faction vehicles removal script
function removeFromFactionVehicle(thePlayer)
	local faction = getElementData(thePlayer, "faction")
	local vfaction = tonumber(getElementData(source, "faction"))
	local CanTowDriverEnter = (call(getResourceFromName("system-cholownikow"), "CanTowTruckDriverVehPos", thePlayer) == 2)
	if (vfaction~=-1) then
		local seat = getPedOccupiedVehicleSeat(thePlayer)
		local factionName = "this faction"
		for key, value in ipairs(exports.pool:getPoolElementsByType("team")) do
			local id = tonumber(getElementData(value, "id"))
			if (id==vfaction) then
				factionName = getTeamName(value)
				break
			end
		end
		if (faction~=vfaction) and (seat==0) then
			if (CanTowDriverEnter) then
				outputChatBox("(( This " .. getVehicleName(source) .. " belongs to '" .. factionName .. "'. ))", thePlayer, 255, 194, 14)
				exports['antyczit']:changeProtectedElementDataEx(source, "enginebroke", 1, false)
				setVehicleDamageProof(source, true)
				setVehicleEngineState(source, false)
				return
			end
			outputChatBox("(( Ten Pojazd " .. getVehicleName(source) .. " należy do frakcji '" .. factionName .. "'. ))", thePlayer, 255, 194, 14)
		end
	end
	local Impounded = getElementData(source,"Impounded")
	if (Impounded and Impounded > 0) then
		exports['antyczit']:changeProtectedElementDataEx(source, "enginebroke", 1, false)
		setVehicleDamageProof(source, true)
		setVehicleEngineState(source, false)
	end
	if (CanTowDriverEnter) then -- Nabs abusing
		return
	end
	local vjob = tonumber(getElementData(source, "job"))
	local job = getElementData(thePlayer, "job")
	local seat = getPedOccupiedVehicleSeat(thePlayer)	
	if (vjob>0) and (seat==0) then
		if (job~=vjob) then
			if (vjob==1) then
				outputChatBox("Nie pracujesz jako kurier, znajdź prace w urzedzie miasta.", thePlayer, 255, 0, 0)
			elseif (vjob==2) then
				outputChatBox("Nie jesteś kierowcą taksówki ,zatrudnij sie w urzędzie", thePlayer, 255, 0, 0)
			elseif (vjob==3) then
				outputChatBox("Nie jesteś kierowcą Lini Autobusowych , zatrudnij sie w urzędzie", thePlayer, 255, 0, 0)
			end
			exports['antyczit']:changeProtectedElementDataEx(thePlayer, "realinvehicle", 0, false)
			removePedFromVehicle(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			setElementPosition(thePlayer, x, y, z)
			return
		end
		
		-- remove masks etc. for civilian job vehicles
		for key, value in pairs(exports['system-przedmiotow']:getMasks()) do
			if getElementData(thePlayer, value[1]) then
				exports.global:sendLocalMeAction(thePlayer, value[3] .. ".")
				exports['antyczit']:changeProtectedElementDataEx(thePlayer, value[1], false, true)
			end
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), removeFromFactionVehicle)

-- engines dont break down
function doBreakdown()
	if exports.global:hasItem(source, 74) then
		while exports.global:hasItem(source, 74) do
			exports.global:takeItem(source, 74)
		end
		
		blowVehicle(source)
	else
		local health = getElementHealth(source)
		local broke = getElementData(source, "enginebroke")

		if (health<=350) and (broke==0 or broke==false) then
			setElementHealth(source, 300)
			setVehicleDamageProof(source, true)
			setVehicleEngineState(source, false)
			exports['antyczit']:changeProtectedElementDataEx(source, "enginebroke", 1, false)
			exports['antyczit']:changeProtectedElementDataEx(source, "engine", 0, false)
			
			local player = getVehicleOccupant(source)
			if player then
				toggleControl(player, 'brake_reverse', false)
			end
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), doBreakdown)



------------------------------------------------
-- SELLS A VEHICLE
------------------------------------------------
function sellVehicle(thePlayer, commandName, targetPlayerName)
	-- can only sell vehicles outdoor, in a dimension is property
	if isPedInVehicle(thePlayer) then
		if not targetPlayerName then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [partial player name / id]", thePlayer, 255, 194, 14)
			outputChatBox("Sprzedanie auta innemu graczowi.", thePlayer, 255, 194, 14)
			outputChatBox("Pamietaj by osoba kupująca najpierw zapłaciła za kupowany pojazd.", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer and getElementData(targetPlayer, "dbid") then
				local px, py, pz = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) < 20 then
					local theVehicle = getPedOccupiedVehicle(thePlayer)
					if theVehicle then
						local vehicleID = getElementData(theVehicle, "dbid")
						if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") or exports.global:isPlayerSuperAdmin(thePlayer) or (exports.sponsorzy:hasPlayerPerk(thePlayer, 16) and exports.global:isPlayerFullAdmin(thePlayer)) then
							if getElementData(targetPlayer, "dbid") ~= getElementData(theVehicle, "owner") then
								if exports.global:hasSpaceForItem(targetPlayer, 3, vehicleID) then
									if exports.global:canPlayerBuyVehicle(targetPlayer) then
										if exports.global:isPlayerFullAdmin(thePlayer) or exports['salony']:isForSale(theVehicle) then
											local query = mysql:query_free("UPDATE vehicles SET owner = '" .. mysql:escape_string(getElementData(targetPlayer, "dbid")) .. "' WHERE id='" .. mysql:escape_string(vehicleID) .. "'")
											if query then
												exports['antyczit']:changeProtectedElementDataEx(theVehicle, "owner", getElementData(targetPlayer, "dbid"))
												
												exports.global:takeItem(thePlayer, 3, vehicleID)
												exports.global:giveItem(targetPlayer, 3, vehicleID)
												
												exports.logs:logMessage("[SELL] car #" .. vehicleID .. " was sold from " .. getPlayerName(thePlayer):gsub("_", " ") .. " to " .. targetPlayerName, 9)
												
												outputChatBox("Zakupiłeś pojazd " .. getVehicleName(theVehicle) .. " to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
												outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " sprzedałeś " .. getVehicleName(theVehicle) .. ".", targetPlayer, 0, 255, 0)
												outputChatBox("Zapamiętaj by wpisać /zaparkuj w twoim " .. getVehicleName(theVehicle) .. ".", targetPlayer, 255, 255, 0)
												
												exports.logs:dbLog(thePlayer, 6, { theVehicle, thePlayer, targetPlayer }, "SELL '".. getVehicleName(theVehicle).."' '".. (getPlayerName(thePlayer):gsub("_", " ")) .."' => '".. targetPlayerName .."'")
												
											else
												outputChatBox("Unable to process request - report on bugs.mta.vg.", thePlayer, 255, 0, 0)
											end
										else
											outputChatBox("You can not sell special vehicles. Contact an admin via F2 to have it refunded.", thePlayer, 255, 0, 0)
										end
									else
										outputChatBox(targetPlayerName .. " posiada zbyt wiele pojazdów.", thePlayer, 255, 0, 0)
										outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " chciał sprzedać ci pojazd lecz posiadasz już maksymalny limit", targetPlayer, 255, 0, 0)
									end
								else
									outputChatBox(targetPlayerName .. " has no space for the vehicle keys.", thePlayer, 255, 0, 0)
									outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " tried to sell you a car, but you haven't got space for a key.", targetPlayer, 255, 0, 0)
								end
							else
								outputChatBox("Nie możesz sprzedać pojazdu sobie.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("Ten pojazd nie jest twój.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("You must be in a Vehicle.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Jesteś za daleko " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("sprzedaj", sellVehicle)

function lockUnlockInside(vehicle)
	local model = getElementModel(vehicle)
	local owner = getElementData(vehicle, "owner")
	local dbid = getElementData(vehicle, "dbid")
	
	if (owner ~= -2) then
		if ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
			if not locklessVehicle[model] or exports.global:hasItem( source, 3, dbid ) then
				if (getElementData(source, "realinvehicle") == 1) then
					local locked = isVehicleLocked(vehicle)
					local seat = getPedOccupiedVehicleSeat(source)
					if seat == 0 or exports.global:hasItem( source, 3, dbid ) then
						if (locked) then
							setVehicleLocked(vehicle, false)
							exports.global:sendLocalMeAction(source, "otwiera pojazd.")
							exports.logs:dbLog(source, 31, {  vehicle }, "UNLOCK FROM INSIDE")
						else
							setVehicleLocked(vehicle, true)
							exports.global:sendLocalMeAction(source, "zamyka pojazd.")
							exports.logs:dbLog(source, 31, {  vehicle }, "LOCK FROM INSIDE")
						end
					end
				end
			end
		else
			outputChatBox("(( You can't lock impounded vehicles. ))", source, 255, 195, 14)
		end
	else
		outputChatBox("(( You can't lock civilian vehicles. ))", source, 255, 195, 14)
	end
	
end
addEvent("lockUnlockInsideVehicle", true)
addEventHandler("lockUnlockInsideVehicle", getRootElement(), lockUnlockInside)


local storeTimers = { }

function lockUnlockOutside(vehicle)
	if (not source or exports.global:isPlayerAdmin(source)) or ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
		local dbid = getElementData(vehicle, "dbid")
		
		exports.global:applyAnimation(source, "GHANDS", "gsign3LH", 2000, false, false, false)
		
		if (isVehicleLocked(vehicle)) then
			setVehicleLocked(vehicle, false)
			exports.global:sendLocalMeAction(source, "otwiera swój pojazd. ((" .. getVehicleName(vehicle) .. "))")
			exports.logs:dbLog(source, 31, {  vehicle }, "UNLOCK FROM OUTSIDE")
			if not (exports.global:hasItem(source, 3, dbid) or (getElementData(source, "faction") > 0 and getElementData(source, "faction") == getElementData(vehicle, "faction"))) then
				exports.logs:logMessage("[CAR-UNLOCK] car #" .. dbid .. " was unlocked by " .. getPlayerName(source), 21)
			end
		else
			setVehicleLocked(vehicle, true)
			exports.global:sendLocalMeAction(source, "zamyka swój pojazd ((" .. getVehicleName(vehicle) .. "))")
			exports.logs:dbLog(source, 31, {  vehicle }, "LOCK FROM OUTSIDE")
			if not (exports.global:hasItem(source, 3, dbid) or (getElementData(source, "faction") > 0 and getElementData(source, "faction") == getElementData(vehicle, "faction"))) then
				exports.logs:logMessage("[CAR-LOCK] car #" .. dbid .. " was locked by " .. getPlayerName(source), 21)
			end
		end

		if (storeTimers[vehicle] == nil) or not (isTimer(storeTimers[vehicle])) then
			storeTimers[vehicle] = setTimer(storeVehicleLockState, 180000, 1, vehicle, dbid)
		end
	end
end
addEvent("lockUnlockOutsideVehicle", true)
addEventHandler("lockUnlockOutsideVehicle", getRootElement(), lockUnlockOutside)

function storeVehicleLockState(vehicle, dbid)
	if (isElement(vehicle)) then
		local newdbid = getElementData(vehicle, "dbid")
		if tonumber(newdbid) > 0 then
			local locked = isVehicleLocked(vehicle)
			
			local state = 0
			if (locked) then 
				state = 1 
			end
			
			local query = mysql:query_free("UPDATE vehicles SET locked='" .. mysql:escape_string(tostring(state)) .. "' WHERE id='" .. mysql:escape_string(tostring(newdbid)) .. "' LIMIT 1")
		end
		storeTimers[vehicle] = nil
	end
end

function fillFuelTank(veh, fuel)
	local currFuel = getElementData(veh, "fuel")
	local engine = getElementData(veh, "engine")
	if (math.ceil(currFuel)==100) then
		exports.info:showBox(source,"info","Ten pojazd ma pełny bak.")
	elseif (fuel==0) then
		exports.info:showBox(source,"info","Pojemnik na paliwo jest pusty.")
	elseif (engine==1) then
		exports.info:showBox(source,"warning","Nie możesz tankować pojazdu, który chodzi.")
	else
		local fuelAdded = fuel
		
		if (fuelAdded+currFuel>100) then
			fuelAdded = 100 - currFuel
		end
		
		outputChatBox("Wlałeś " .. math.ceil(fuelAdded) .. " litrów paliwa do twojego auta z karnistra.", source, 0, 255, 0 )
		
		local gender = getElementData(source, "gender")
		local genderm = "jego"
		if (gender == 1) then
			genderm = "jej"
		end
		exports.global:sendLocalMeAction(source, "napełnił/a bak  " .. genderm .. " pojazdu wlewając paliwo z karnistra.")
		
		exports.global:takeItem(source, 57, fuel)
		exports.global:giveItem(source, 57, math.ceil(fuel-fuelAdded))
		
		exports['antyczit']:changeProtectedElementDataEx(veh, "fuel", currFuel+fuelAdded, false)
		triggerClientEvent(source, "syncFuel", veh, currFuel+fuelAdded)
	end
end
addEvent("fillFuelTankVehicle", true)
addEventHandler("fillFuelTankVehicle", getRootElement(), fillFuelTank)

function getYearDay(thePlayer)
	local time = getRealTime()
	local currYearday = time.yearday
	
	outputChatBox("Dzień roku: " .. currYearday, thePlayer)
end
addCommandHandler("dzienroku", getYearDay)

function removeNOS(theVehicle)
	removeVehicleUpgrade(theVehicle, getVehicleUpgradeOnSlot(theVehicle, 8))
	exports.global:sendLocalMeAction(source, "usuwa nitro z " .. getVehicleName(theVehicle) .. ".")
	exports['zapis-aut']:saveVehicleMods(theVehicle)
	exports.logs:dbLog(source, 4, {  theVehicle }, "MODDING REMOVENOS")
end
addEvent("removeNOS", true)
addEventHandler("removeNOS", getRootElement(), removeNOS)

-- /VEHPOS /zaparkuj
local destroyTimers = { }
--[[
function createShopVehicle(dbid, ...)
	local veh = createVehicle(unpack({...}))
	exports.pool:allocateElement(veh, dbid)
	
	exports['antyczit']:changeProtectedElementDataEx(veh, "dbid", dbid)
	exports['antyczit']:changeProtectedElementDataEx(veh, "requires.vehpos", 1, false)
	local timer = setTimer(checkVehpos, 3600000, 1, veh, dbid)
	table.insert(destroyTimers, {timer, dbid})
	
	exports['interiory-aut']:add( veh )
	
	return veh
end
]]

function checkVehpos(veh, dbid)
	local requires = getElementData(veh, "requires.vehpos")
	
	if (requires) then
		if (requires==1) then
			local id = tonumber(getElementData(veh, "dbid"))
			
			if (id==dbid) then
				exports.logs:logMessage("[VEHPOS DELETE] car #" .. id .. " was deleted", 9)
				destroyElement(veh)
				local query = mysql:query_free("DELETE FROM vehicles WHERE id='" .. mysql:escape_string(id) .. "' LIMIT 1")
				
				call( getResourceFromName( "system-przedmiotow" ), "clearItems", veh )
				call( getResourceFromName( "system-przedmiotow" ), "deleteAll", 3, id )
			end
		end
	end
end
-- VEHPOS
local PershingSquareCol = createColRectangle( 1420, -1775, 130, 257 )
local HospitalCol = createColRectangle( 1166, -1384, 52, 92 )

function setVehiclePosition(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or getElementData(thePlayer, "realinvehicle") == 0 then
		exports.info:showBox(thePlayer,"warning","Musisz być w pojeździe,aby go zaparkować....")
	else
		if call( getResourceFromName("system-cholownikow"), "cannotVehpos", thePlayer, veh ) then
			outputChatBox("It is not possible to park your vehicle here.", thePlayer, 255, 0, 0)
		elseif isElementWithinColShape( thePlayer, HospitalCol ) and getElementData( thePlayer, "faction" ) ~= 2 and not exports.global:isPlayerAdmin(thePlayer) then
			outputChatBox("Only Los Santos Emergency Service is allowed to park their vehicles in front of the Hospital.", thePlayer, 255, 0, 0)
		elseif isElementWithinColShape( thePlayer, PershingSquareCol ) and getElementData( thePlayer, "faction" ) ~= 1  and not exports.global:isPlayerAdmin(thePlayer) then
			outputChatBox("Tylko pojazdy uprzywilejowane mogą zapisywac tutaj pozycje swoich aut.", thePlayer, 255, 0, 0)
		else
			local playerid = getElementData(thePlayer, "dbid")
			local playerfl = getElementData(thePlayer, "factionleader")
			local playerfid = getElementData(thePlayer, "faction")
			local owner = getElementData(veh, "owner")
			local dbid = getElementData(veh, "dbid")
			local carfid = getElementData(veh, "faction")
			local x, y, z = getElementPosition(veh)
			local TowingReturn = call(getResourceFromName("system-cholownikow"), "CanTowTruckDriverVehPos", thePlayer) -- 2 == in towing and in col shape, 1 == colshape only, 0 == not in col shape
			if (owner==playerid and TowingReturn == 0) or (exports.global:hasItem(thePlayer, 3, dbid)) or (TowingReturn == 2) or (exports.global:isPlayerAdmin(thePlayer) and exports.logs:logMessage("[AVEHPOS] " .. getPlayerName( thePlayer ) .. " parked car #" .. dbid .. " at " .. x .. ", " .. y .. ", " .. z, 9)) then
				if (dbid<0) then
					exports.info:showBox(thePlayer,"warning","Ten pojazd nie jest zespawnowany na stałe.")
				else
					if (call(getResourceFromName("system-cholownikow"), "CanTowTruckDriverGetPaid", thePlayer)) then
						-- pd has to pay for this impound
						exports.global:giveMoney(getTeamFromName("Pomoc Drogowa"), 75)
						exports.global:takeMoney(getTeamFromName("Pomoc Drogowa"), 75)
					end
					exports['antyczit']:changeProtectedElementDataEx(veh, "requires.vehpos")
					local rx, ry, rz = getVehicleRotation(veh)
					
					local interior = getElementInterior(thePlayer)
					local dimension = getElementDimension(thePlayer)
					
					local query = mysql:query_free("UPDATE vehicles SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .."', z='" .. mysql:escape_string(z) .. "', rotx='" .. mysql:escape_string(rx) .. "', roty='" .. mysql:escape_string(ry) .. "', rotz='" .. mysql:escape_string(rz) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='" .. mysql:escape_string(rx) .. "', currry='" .. mysql:escape_string(ry) .. "', currrz='" .. mysql:escape_string(rz) .. "', interior='" .. mysql:escape_string(interior) .. "', currinterior='" .. mysql:escape_string(interior) .. "', dimension='" .. mysql:escape_string(dimension) .. "', currdimension='" .. mysql:escape_string(dimension) .. "' WHERE id='" .. mysql:escape_string(dbid) .. "'")
					setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
					exports['antyczit']:changeProtectedElementDataEx(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
					exports['antyczit']:changeProtectedElementDataEx(veh, "interior", interior)
					exports['antyczit']:changeProtectedElementDataEx(veh, "dimension", dimension)
					exports.info:showBox(thePlayer,"info","Zaparkowałeś pojazd.")
					exports.logs:dbLog(thePlayer, 4, {  veh }, "PARK")
					for key, value in ipairs(destroyTimers) do
						if (tonumber(destroyTimers[key][2]) == dbid) then
							local timer = destroyTimers[key][1]
							
							if (isTimer(timer)) then
								killTimer(timer)
								table.remove(destroyTimers, key)
							end
						end
					end
					
					if ( getElementData(veh, "Impounded") or 0 ) > 0 then
						local owner = getPlayerFromName( exports['cache']:getCharacterName( getElementData( veh, "owner" ) ) )
						if isElement( owner ) and exports.global:hasItem( owner, 2 ) then
							outputChatBox("((Pomoc Drogowa)) #921 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the Impound to release it.", owner, 120, 255, 80)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("vehpos", setVehiclePosition, false, false)
addCommandHandler("zaparkuj", setVehiclePosition, false, false)

function setVehiclePosition2(thePlayer, commandName, vehicleID)
	if exports.global:isPlayerAdmin( thePlayer ) then
		local vehicleID = tonumber(vehicleID)
		if not vehicleID or vehicleID < 0 then
			outputChatBox( "PRZYKŁAD: /" .. commandName .. " [vehicle id]", thePlayer, 255, 194, 14 )
		else
			local veh = exports.pool:getElement("vehicle", vehicleID)
			if veh then
				exports['antyczit']:changeProtectedElementDataEx(veh, "requires.vehpos")
				local x, y, z = getElementPosition(veh)
				local rx, ry, rz = getVehicleRotation(veh)
				
				local interior = getElementInterior(thePlayer)
				local dimension = getElementDimension(thePlayer)
				
				local query = mysql:query_free("UPDATE vehicles SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .."', z='" .. mysql:escape_string(z) .. "', rotx='" .. mysql:escape_string(rx) .. "', roty='" .. mysql:escape_string(ry) .. "', rotz='" .. mysql:escape_string(rz) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='" .. mysql:escape_string(rx) .. "', currry='" .. mysql:escape_string(ry) .. "', currrz='" .. mysql:escape_string(rz) .. "', interior='" .. mysql:escape_string(interior) .. "', currinterior='" .. mysql:escape_string(interior) .. "', dimension='" .. mysql:escape_string(dimension) .. "', currdimension='" .. mysql:escape_string(dimension) .. "' WHERE id='" .. mysql:escape_string(vehicleID) .. "'")
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				exports['antyczit']:changeProtectedElementDataEx(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
				exports['antyczit']:changeProtectedElementDataEx(veh, "interior", interior)
				exports['antyczit']:changeProtectedElementDataEx(veh, "dimension", dimension)
				outputChatBox("Vehicle spawn position for #" .. vehicleID .. " set.", thePlayer)
				exports.logs:dbLog(thePlayer, 4, {  veh }, "PARK")
				for key, value in ipairs(destroyTimers) do
					if (tonumber(destroyTimers[key][2]) == vehicleID) then
						local timer = destroyTimers[key][1]
						
						if (isTimer(timer)) then
							killTimer(timer)
							table.remove(destroyTimers, key)
						end
					end
				end
				
				if ( getElementData(veh, "Impounded") or 0 ) > 0 then
					local owner = getPlayerFromName( exports['cache']:getCharacterName( getElementData( veh, "owner" ) ) )
					if isElement( owner ) and exports.global:hasItem( owner, 2 ) then
						outputChatBox("((Pomoc Drogowa)) #921 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the Impound to release it.", owner, 120, 255, 80)
					end
				end
				exports.logs:logMessage("[AVEHPOS] " .. getPlayerName( thePlayer ) .. " parked car #" .. vehicleID .. " at " .. x .. ", " .. y .. ", " .. z, 9)
			else
				exports.info:showBox(thePlayer,"warning","Nie znaleziono pojazdu.")
			end
		end
	end
end
addCommandHandler("avehpos", setVehiclePosition2, false, false)
addCommandHandler("apark", setVehiclePosition2, false, false)

function setVehiclePosition3(veh)
	if call( getResourceFromName("system-cholownikow"), "cannotVehpos", source ) then
		outputChatBox("Only Pomoc Drogowa is allowed to park their vehicles on the Impound Lot.", source, 255, 0, 0)
	elseif isElementWithinColShape( source, HospitalCol ) and getElementData( source, "faction" ) ~= 2 and not exports.global:isPlayerAdmin(source) then
		outputChatBox("Only Los Santos Emergency Service is allowed to park their vehicles in front of the Hospital.", source, 255, 0, 0)
	elseif isElementWithinColShape( source, PershingSquareCol ) and getElementData( source, "faction" ) ~= 1  and not exports.global:isPlayerAdmin(source) then
		outputChatBox("Only Los Santos Police Department is allowed to park their vehicles on Pershing Square.", source, 255, 0, 0)
	else
		local playerid = getElementData(source, "dbid")
		local owner = getElementData(veh, "owner")
		local dbid = getElementData(veh, "dbid")
		local x, y, z = getElementPosition(veh)
		local TowingReturn = call(getResourceFromName("system-cholownikow"), "CanTowTruckDriverVehPos", source) -- 2 == in towing and in col shape, 1 == colshape only, 0 == not in col shape
		if (owner==playerid and TowingReturn == 0) or (exports.global:hasItem(source, 3, dbid)) or (TowingReturn == 2) or (exports.global:isPlayerAdmin(source) and exports.logs:logMessage("[AVEHPOS] " .. getPlayerName( source ) .. " parked car #" .. dbid .. " at " .. x .. ", " .. y .. ", " .. z, 9)) then
			if (dbid<0) then
				exports.info:showBox(source,"warning","Ten pojazd nie jest zespawnowany na stałe.")
			else
				if (call(getResourceFromName("system-cholownikow"), "CanTowTruckDriverGetPaid", source)) then
					-- pd has to pay for this impound
					exports.global:giveMoney(getTeamFromName("Pomoc Drogowa"), 75)
					exports.global:takeMoney(getTeamFromName("Los Santos Police Department"), 75)
				end
				exports['antyczit']:changeProtectedElementDataEx(veh, "requires.vehpos")
				local rx, ry, rz = getVehicleRotation(veh)
				
				local interior = getElementInterior(source)
				local dimension = getElementDimension(source)
				
				local query = mysql:query_free("UPDATE vehicles SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .."', z='" .. mysql:escape_string(z) .. "', rotx='" .. mysql:escape_string(rx) .. "', roty='" .. mysql:escape_string(ry) .. "', rotz='" .. mysql:escape_string(rz) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='" .. mysql:escape_string(rx) .. "', currry='" .. mysql:escape_string(ry) .. "', currrz='" .. mysql:escape_string(rz) .. "', interior='" .. mysql:escape_string(interior) .. "', currinterior='" .. mysql:escape_string(interior) .. "', dimension='" .. mysql:escape_string(dimension) .. "', currdimension='" .. mysql:escape_string(dimension) .. "' WHERE id='" .. mysql:escape_string(dbid) .. "'")
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				exports['antyczit']:changeProtectedElementDataEx(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
				exports['antyczit']:changeProtectedElementDataEx(veh, "interior", interior)
				exports['antyczit']:changeProtectedElementDataEx(veh, "dimension", dimension)
				outputChatBox("Vehicle spawn position set.", source)
				exports.logs:dbLog(thePlayer, 4, {  veh }, "PARK")
				for key, value in ipairs(destroyTimers) do
					if (tonumber(destroyTimers[key][2]) == dbid) then
						local timer = destroyTimers[key][1]
						
						if (isTimer(timer)) then
							killTimer(timer)
							table.remove(destroyTimers, key)
						end
					end
				end
				
				if ( getElementData(veh, "Impounded") or 0 ) > 0 then
					local owner = getPlayerFromName( exports['cache']:getCharacterName( getElementData( veh, "owner" ) ) )
					if isElement( owner ) and exports.global:hasItem( owner, 2 ) then
						outputChatBox("((Pomoc Drogowa)) #921 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the Impound to release it.", owner, 120, 255, 80)
					end
				end
			end
		else
			exports.info:showBox(source,"warning","Nie możesz zaparkować tego pojazdu.")
		end
	end
end
addEvent( "parkVehicle", true )
addEventHandler( "parkVehicle", getRootElement( ), setVehiclePosition3 )

function setVehiclePosition4(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or getElementData(thePlayer, "realinvehicle") == 0 then
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
	else
		local playerid = getElementData(thePlayer, "dbid")
		local playerfl = getElementData(thePlayer, "factionleader")
		local playerfid = getElementData(thePlayer, "faction")
		local owner = getElementData(veh, "owner")
		local dbid = getElementData(veh, "dbid")
		local carfid = getElementData(veh, "faction")
		if (playerfl == 1) and (playerfid==carfid) then
			exports['antyczit']:changeProtectedElementDataEx(veh, "requires.vehpos")

			local x, y, z = getElementPosition(veh)
			local rx, ry, rz = getVehicleRotation(veh)
			
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			
			local query = mysql:query_free("UPDATE vehicles SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .."', z='" .. mysql:escape_string(z) .. "', rotx='" .. mysql:escape_string(rx) .. "', roty='" .. mysql:escape_string(ry) .. "', rotz='" .. mysql:escape_string(rz) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='" .. mysql:escape_string(rx) .. "', currry='" .. mysql:escape_string(ry) .. "', currrz='" .. mysql:escape_string(rz) .. "', interior='" .. mysql:escape_string(interior) .. "', currinterior='" .. mysql:escape_string(interior) .. "', dimension='" .. mysql:escape_string(dimension) .. "', currdimension='" .. mysql:escape_string(dimension) .. "' WHERE id='" .. mysql:escape_string(dbid) .. "'")
			setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
			exports['antyczit']:changeProtectedElementDataEx(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
			exports['antyczit']:changeProtectedElementDataEx(veh, "interior", interior)
			exports['antyczit']:changeProtectedElementDataEx(veh, "dimension", dimension)
			outputChatBox("Vehicle spawn position for #" .. dbid .. " set.", thePlayer)
			exports.logs:dbLog(thePlayer, 4, {  veh }, "PARK")
			for key, value in ipairs(destroyTimers) do
				if (tonumber(destroyTimers[key][2]) == dbid) then
					local timer = destroyTimers[key][1]
					
					if (isTimer(timer)) then
						killTimer(timer)
						table.remove(destroyTimers, key)
					end
				end
			end
			
			if ( getElementData(veh, "Impounded") or 0 ) > 0 then
				local owner = getPlayerFromName( exports['cache']:getCharacterName( getElementData( veh, "owner" ) ) )
				if isElement( owner ) and exports.global:hasItem( owner, 2 ) then
					outputChatBox("((Pomoc Drogowa)) #921 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the Impound to release it.", owner, 120, 255, 80)
				end
			end
		end
	end
end
addCommandHandler("fvehpos", setVehiclePosition4, false, false)
addCommandHandler("fpark", setVehiclePosition4, false, false)

function quitPlayer ( quitReason )
	if (quitReason == "Timed out") then -- if timed out
		if (isPedInVehicle(source)) then -- if in vehicle
			local vehicleSeat = getPedOccupiedVehicleSeat(source)
			if (vehicleSeat == 0) then	-- is in driver seat?
				local theVehicle = getPedOccupiedVehicle(source)
				local dbid = tonumber(getElementData(theVehicle, "dbid"))
				local passenger1 = getVehicleOccupant( theVehicle , 1 )
				local passenger2 = getVehicleOccupant( theVehicle , 2 )
				local passenger3 = getVehicleOccupant( theVehicle , 3 )
				if not (passenger1) and not (passenger2) and not (passenger3) then
					local vehicleFaction = tonumber(getElementData(theVehicle, "faction"))
					local playerFaction = tonumber(getElementData(source, "faction"))
					if exports.global:hasItem(source, 3, dbid) or ((playerFaction == vehicleFaction) and (vehicleFaction ~= -1)) then
						if not isVehicleLocked(theVehicle) then -- check if the vehicle aint locked already
							lockUnlockOutside(theVehicle)
							exports.logs:dbLog(thePlayer, 31, {  theVehicle }, "LOCK FROM CRASH")
						end
						local engine = getElementData(theVehicle, "engine")
						if engine == 1 then -- stop the engine when its running
							setVehicleEngineState(theVehicle, false)
							exports['antyczit']:changeProtectedElementDataEx(theVehicle, "engine", 0, false)
						end
					end	
					exports['antyczit']:changeProtectedElementDataEx(theVehicle, "handbrake", 1, false)
					setElementVelocity(theVehicle, 0, 0, 0)
					setElementFrozen(theVehicle, true)
				end
			end
		end
	end
end
addEventHandler("onPlayerQuit",getRootElement(), quitPlayer)

function detachVehicle(thePlayer)
	if isPedInVehicle(thePlayer) and getPedOccupiedVehicleSeat(thePlayer) == 0 then
		local veh = getPedOccupiedVehicle(thePlayer)
		if getVehicleTowedByVehicle(veh) then
			detachTrailerFromVehicle(veh)
			outputChatBox("The trailer was detached.", thePlayer, 0, 255, 0)
		else
			outputChatBox("There is no trailer...", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("detach", detachVehicle)

safeTable = {}

function addSafe( dbid, x, y, z, rz, interior )
	local tempobject = createObject(2332, x, y, z, 0, 0, rz)
	setElementInterior(tempobject, interior)
	setElementDimension(tempobject, dbid + 20000)
	safeTable[dbid] = tempobject
end

function removeSafe( dbid )
	if safeTable[dbid] then
		destroyElement(safeTable[dbid])
		safeTable[dbid] = nil
	end
end

function getSafe( dbid )
	return safeTable[dbid]
end
