--1 - czerwone
--2 - niebieskie
--3 - zielone
--4 - zolte


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

addCommandHandler("dajneony", function(source, cmd, pid, id)
	if exports.global:isPlayerAdmin(source) then
		local player = getPlayerFromName(pid)
		if not player then outputChatBox("/dajneony [IMIE_NAZWISKO] [KOLOR-1,2,3 LUB 4]", source, 255, 0, 0) return false end
		if not id then outputChatBox("/dajneony [IMIE_NAZWISKO] [KOLOR-1,2,3 LUB 4]", source, 255, 0, 0) return false end
		if not (getPedOccupiedVehicle(player)) then return false end
		local x,y,z = getElementPosition(player)
		setElementData(getPedOccupiedVehicle(player), "neonyava", tonumber(id))
		setElementData(getPedOccupiedVehicle(player), "neony", false)
		outputChatBox(getPlayerName(player).." otrzymał neony o ID "..id, source, 0, 255, 0)
	end
end)

addCommandHandler("neony", function(source, cmd)
	local player = source
	if not (getPedOccupiedVehicle(player)) then return false end
	
	if getElementData(getPedOccupiedVehicle(player), "neony") then
		local car = getPedOccupiedVehicle(player)
		for i,v in ipairs(getAttachedElements(car)) do
			if getElementType(v) == "object" then
				if neonytrue[getElementModel(v)] then
					destroyElement(v)
					setElementData(car, "neony", false)
				end
			end
		end
	else
		local pid=getElementData(getPedOccupiedVehicle(player), "neonyava")
		if not pid then return false end
		local neon_id = findNeonColor(tonumber(pid))
		local neon1 = createObject(neon_id, 0, 0, 0)
		attachElements(neon1, getPedOccupiedVehicle(player), 1, 0, -0.5)
		local neon2 = createObject(neon_id, 0, 0, 0)
		attachElements(neon2, getPedOccupiedVehicle(player), -1, -0, -0.5)
		setElementData(getPedOccupiedVehicle(player), "neony", neon_id)
	end
end)