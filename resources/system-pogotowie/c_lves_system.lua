rot = 0.0
vehicle = false
effect = false
isdead = false
deathTimer = 1
deathTimerTimer = false

function realisticDamage(attacker, weapon, bodypart)
	if getElementData(source, "reconx") and getElementData(source, "reconx") ~= true then
		cancelEvent( )
	else
		-- Only AK47, M4 and Sniper can penetrate armor
		local armor = getPedArmor(source)
		
		if (weapon>0) and (attacker) then
			local armorType = getElementData(attacker, "armortype")
			local bulletType = getElementData(attacker, "bullettype")
			
			if (armor>0) and (armorType==1) and (bulletType~=1) and (weapon>0) then
				if ((weapon~=30) and (weapon~=31) and (weapon~=34)) and (bodypart~=9) then
					cancelEvent()
				end
			end
		end
		
		-- Damage effect
		local gasmask = getElementData(source, "gasmask")
		if not (effect) and ((not gasmask or gasmask==0) and (weapon==17)) then
			fadeCamera(false, 1.0, 255, 0, 0)
			effect = true
			setTimer(endEffect, 250, 1)
		end
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), realisticDamage)

function endEffect()
	fadeCamera(true, 1.0)
	effect = false
	isdead = false
end

function playerDeath()
	if isdead then
		return
	end
	isdead = true
	deathTimer = math.random(240,900)
	if getElementData(source, "bartek_respawntime") then
		deathTimer = getElementData(source, "bartek_respawntime")
	else
		setElementData(source, "bartek_respawntime", deathTimer)
	end
	deathLabel = nil
	rot = 0.0
	fadeCamera(false, 29)
	vehicle = isPedInVehicle(getLocalPlayer())
	exports.info:showBox ("warning","Twoja postać została brutalnie pobita, posiadasz teraz BW, tzw omdlenie.")
	local pX, pY, pZ = getElementPosition(getLocalPlayer())

	-- Setup the text
	deathTimerTimer = setTimer(lowerTimer, 1000, deathTimer)
	addEventHandler("onClientPreRender",getRootElement(),renderRedTubeScreen)
	
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local width = 300
	local height = 100
	local x = (screenwidth - width)/2
	local y = screenheight - (screenheight/8 - (height/8))
	--deathLabel = guiCreateLabel(x, y, width, height, "", false)
	--guiSetFont(deathLabel, "sa-gothic")
	
	setGameSpeed(0.5)
end
addEventHandler("onClientPlayerWasted", getLocalPlayer(), playerDeath)

local BWCANGLE = nil

function renderRedTubeScreen()
	BWCANGLE = BWCANGLE or 0
	local sizex,sizey = guiGetScreenSize()
	dxDrawRectangle( 0, 0, sizex, sizey, tocolor(255,0,0,128) )
	dxDrawText( "BW - " .. convertSeconds(deathTimer), 0, 0, sizex-sizex/10, sizey-sizey/8, tocolor(255,255,255,255), 3, "default", "right", "bottom" )
	local x,y,z = getElementPosition(getLocalPlayer())
	local a = math.rad(90 - BWCANGLE)
	local dist = 4
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
	local x2,y2 = x+dx, y+dy
	setCameraMatrix( x2, y2, z+1.5, x, y, z )
	BWCANGLE = BWCANGLE+0.7
	if deathTimer == 1 then
		setElementData(source, "bartek_respawntime", nil)
		removeEventHandler("onClientPreRender",getRootElement(),renderRedTubeScreen)
		if isTimer(deathTimerTimer) then killTimer(deathTimerTimer) end
		effect = false
		isdead = false
		BWCANGLE = nil
		setCameraTarget(getLocalPlayer())
	end
end

function lowerTimer()
	deathTimer = deathTimer - 1
	
	if (deathTimer>1) then
		--guiSetText(deathLabel, tostring(deathTimer) .. " Sekund")
	else
		if (isElement(deathLabel)) then
			if deathTimer <= 0 then
				--setElementData(source, "bartek_respawntime", nil)
				--removeEventHandler("onClientPreRender",getRootElement(),renderRedTubeScreen)
				--guiSetText(deathLabel, "")
			else
				--setElementData(source, "bartek_respawntime", nil)
				--removeEventHandler("onClientPreRender",getRootElement(),renderRedTubeScreen)
				--guiSetText(deathLabel, tostring(deathTimer) .. " Sekund")
			end
		end
	end
end

function UNBWc()
	setElementData(source, "bartek_respawntime", nil)
	removeEventHandler("onClientPreRender",getRootElement(),renderRedTubeScreen)
	if isTimer(deathTimerTimer) then killTimer(deathTimerTimer) end
	effect = false
	isdead = false
	setCameraTarget(getLocalPlayer())
end
addEvent( "UNBWc", true )
addEventHandler( "UNBWc", getRootElement( ), UNBWc )

--deathTimer = 100000
deathLabel = nil

function playerRespawn()
	setGameSpeed(1)
	if (isElement(deathLabel)) then
		destroyElement(deathLabel)
	end
	setCameraTarget(getLocalPlayer())
end
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), playerRespawn)

local sx, sy = guiGetScreenSize()
local start = 0
local fadeTime = 4000

addEvent("fadeCameraOnSpawn", true)
addEventHandler("fadeCameraOnSpawn", getLocalPlayer(),
	function()
		start = getTickCount()
	end
)


addEventHandler("onClientRender",getRootElement(),
	function()
		local currTime = getTickCount() - start
		if currTime < fadeTime then
			local height = ( sx / 2 ) * ( 1 - currTime / fadeTime )
			local alpha = 255 * ( 1 - currTime / fadeTime )
			dxDrawRectangle( 0, 0, sx, height, tocolor( 0, 0, 0, 255 ) )
			dxDrawRectangle( 0, sy - height, sx, height, tocolor( 0, 0, 0, 255 ) )
			dxDrawRectangle( 0, 0, sx, sy, tocolor( 0, 0, 0, alpha ) )
		end
	end
)



function convertSeconds( tick )
	local sec = tick % 60
	tick = tick - sec
	local minutes = tick / 60
	if sec < 10 then
		sec = "0" .. sec
	end
	if minutes < 10 then
		minutes = "0" .. minutes
	end
	return minutes .. ":" .. sec 
end

fileDelete("c_lves_system.lua")