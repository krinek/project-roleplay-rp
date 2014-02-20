local wybraneOgraniczenie=1
local ograniczenia={nil, 90, 50, 20}

local ograniczeniaModeli={
	-- rowery
	[509]=30,
	[510]=35,
	[481]=35,

	[589]=40,	-- elka
    [448]=50, -- pizzaboy
--    [431]=80, -- bus
}

local ograniczeniaWsteczneModeli={
	[531]=5,	-- tractor
	[530]=5,	-- wozek widlowy
	[572]=5,	-- kosiarka

}

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		end
	else
		outputDebugString("Not an element. Can't get speed")
		return false
	end
end

local function getPlayerRep(p)
  return (getElementData(p,"good_reputation") or 0)-(getElementData(p,"bad_reputation") or 0)
end


local function tempomat()
	local ograniczenie=ograniczenia[wybraneOgraniczenie]
    if getPlayerWantedLevel()>=3 and getPlayerRep(localPlayer)>-10 then ograniczenie=30 end

	local v=getPedOccupiedVehicle(localPlayer)
	if not v then return end
	local vm=getElementModel(v)

	if getVehicleController(v)~=localPlayer then return end

	if not isVehicleOnGround(v) then return end




	local vx,vy,vz=getElementVelocity(v)

	if not getVehicleEngineState(v) then
--		outputDebugString(getDistanceBetweenPoints2D(0,0,vx,vy))
		if getDistanceBetweenPoints2D(0,0,vx,vy)<0.1 then
			vx,vy=0,0
			setElementVelocity(v,vx,vy,vz)
			return
		end
	end

	if ograniczeniaWsteczneModeli[vm] and getControlState("brake_reverse") and math.abs(vz)<0.03 then
		-- todo sprawdzic czy pojazd jedzie do tylu!
		local actualspeed = getElementSpeed(v) -- (vx^2 + vy^2 + vz^2)^(0.5) *0.3*180
		if actualspeed>ograniczeniaWsteczneModeli[vm] then
			setElementVelocity(v,vx*0.6,vy*0.6,vz*0.9)
		end
		return
	end


	if getVehicleType(v)~="Automobile" and not ograniczeniaModeli[vm] then return end
	if ograniczeniaModeli[vm] then
		ograniczenie=ograniczeniaModeli[vm]
	end

	if not ograniczenie then return end

	local actualspeed = getElementSpeed(v) -- (vx^2 + vy^2 + vz^2)^(0.5) *0.6*180
	if actualspeed>ograniczenie then
		setElementVelocity(v,vx*0.9,vy*0.9,vz*0.9)
	end
end

setTimer(tempomat, 50, 0)
addCommandHandler("Zmniejsz ograniczenie predkosci", function()
	if isCursorShowing() or isPedDoingGangDriveby(localPlayer) then return end
	local v=getPedOccupiedVehicle(localPlayer)
	if not v then return end
	if getVehicleController(v)~=localPlayer then return end
	if not isVehicleOnGround(v) then return end



	if getVehicleType(v)~="Automobile" then return end

	wybraneOgraniczenie=wybraneOgraniczenie-1
	if wybraneOgraniczenie<1 then wybraneOgraniczenie=#ograniczenia end
	if ograniczenia[wybraneOgraniczenie] then
		outputChatBox("(( Ograniczenie prędkości ustawione na " .. ograniczenia[wybraneOgraniczenie] .. "km/h ))", 150,150,150)
	else
		outputChatBox("(( Ograniczenie prędkości wyłączone. ))", 150,150,150)
	end
end)
bindKey("mouse1","down", "Zmniejsz ograniczenie predkosci")


addCommandHandler("Zwieksz ograniczenie predkosci", function()
	if isCursorShowing() or isPedDoingGangDriveby(localPlayer) then return end
	local v=getPedOccupiedVehicle(localPlayer)
	if not v then return end
	if getVehicleType(v)~="Automobile" then return end
	if getVehicleController(v)~=localPlayer then return end
	if not isVehicleOnGround(v) then return end

	wybraneOgraniczenie=wybraneOgraniczenie+1
	if wybraneOgraniczenie>#ograniczenia then wybraneOgraniczenie=1 end
	if ograniczenia[wybraneOgraniczenie] then
		outputChatBox("(( Ograniczenie prędkości ustawione na " .. ograniczenia[wybraneOgraniczenie] .. "km/h ))", 150,150,150)
	else
		outputChatBox("(( Ograniczenie prędkości wyłączone. ))", 150,150,150)
	end
end)

bindKey("mouse2","down", "Zwieksz ograniczenie predkosci")