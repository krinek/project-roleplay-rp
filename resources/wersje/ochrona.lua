local gates =
{
	{ gate = createObject(2930, 239.7255859375, 118.5390625, 1004.71875, 0, 0, 0), offset = { 0 , -1.6, 0, 0, 0, 0 } },
        { gate = createObject(2930, 239.61328125, 125.954375, 1004.71875, 0, 0, 0), offset = { 0 , -1.6, 0, 0, 0, 0 } },
        { gate = createObject(2930, 253.375, 125.9790234375, 1004.7116088867, 0, 0, 0), offset = { 0 , -1.6, 0, 0, 0, 0 } },
        { gate = createObject(2930, 253.3388671875, 109.8375390625, 1004.71875, 0, 0, 0), offset = { 0 , -1.6, 0, 0, 0, 0 } },
        { gate = createObject(2930, 233.1116015625, 119.4228515625, 1004.71875, 0, 0, 90), offset = { 0 , -1.6, 0, 0, 0, 0 } },
}

for _, gate in pairs(gates) do
	setElementInterior(gate.gate, 10)
	setElementDimension(gate.gate, 2)
end

local function resetBusy( shortestID )
	gates[ shortestID ].busy = nil
end

local function closeDoor( shortestID )
	gate = gates[ shortestID ]
	local nx, ny, nz = getElementPosition( gate.gate )
	moveObject( gate.gate, 1000, nx - gate.offset[1], ny - gate.offset[2], nz - gate.offset[3], -gate.offset[4], -gate.offset[5], -gate.offset[6] )
	gate.busy = true
	gate.timer = nil
	setTimer( resetBusy, 1000, 1, shortestID )
end

local function openDoor(thePlayer, commandName, pass)
	if getTeamName(getPlayerTeam(thePlayer)) == "Los Santos Police Department" and getElementDimension(thePlayer) == 2 then
		local shortest, shortestID, dist = nil, nil, 10
		local px, py, pz = getElementPosition(thePlayer)
		
		for id, gate in pairs(gates) do
			local d = getDistanceBetweenPoints3D(px,py,pz,getElementPosition(gate.gate))
			if d < dist then
				shortest = gate
				shortestID = id
				dist = d
			end
		end
		
		if shortest then
			if shortest.busy then
				return
			elseif shortest.timer then
				killTimer( shortest.timer )
				shortest.timer = nil
				outputChatBox( "Brama już otwarta!", thePlayer, 0, 255, 0 )
			else
				local nx, ny, nz = getElementPosition( shortest.gate )
				moveObject( shortest.gate, 1000, nx + shortest.offset[1], ny + shortest.offset[2], nz + shortest.offset[3], shortest.offset[4], shortest.offset[5], shortest.offset[6] )
				outputChatBox( "You opened the door!", thePlayer, 0, 255, 0 )
			end
			shortest.timer = setTimer( closeDoor, 5000, 1, shortestID )
		end
	end
end
addCommandHandler( "gate", openDoor)