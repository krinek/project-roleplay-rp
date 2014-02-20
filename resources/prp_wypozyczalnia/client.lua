rowery_dim = ""..math.random(1,99)..""..math.random(1,99)..""

local sm = {}

sm.object1, sm.object2 = nil, nil
 
local function camRender ()
	local x1, y1, z1 = getElementPosition ( sm.object1 )
	local x2, y2, z2 = getElementPosition ( sm.object2 )
	setCameraMatrix ( x1, y1, z1, x2, y2, z2 )
end
 
function smoothMoveCamera ( x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, timez )
	
	sm.object1 = createObject ( 1337, x1, y1, z1 )
	sm.object2 = createObject ( 1337, x1t, y1t, z1t )
	setElementAlpha ( sm.object1, 0 )
	setElementAlpha ( sm.object2, 0 )
	setObjectScale(sm.object1, 0.01)
	setObjectScale(sm.object2, 0.01)
	moveObject ( sm.object1, timez, x2, y2, z2, 0, 0, 0, "InOutQuad" )
	moveObject ( sm.object2, timez, x2t, y2t, z2t, 0, 0, 0, "InOutQuad" )
 
	addEventHandler ( "onClientPreRender", getRootElement(), camRender )
	
	
	setTimer ( destroyElement, timez,1, sm.object1 )
	setTimer ( destroyElement, timez, 1, sm.object2 )
	setTimer(function() removeEventHandler ( "onClientPreRender", getRootElement(), camRender )   end,timez,1)
	return true
end



function opuscWypo()
fadeCamera(false)
smoothMoveCamera(1500.7679443359,-1465.3397216797,64.792297363281,1500.7629394531,-1464.3509521484,64.643096923828,1500.3399658203,-1524.2188720703,68.009399414063,1500.3488769531,-1523.2205810547,67.951637268066,2000)
setTimer(function() setCameraTarget(localPlayer) fadeCamera(true) end, 3000,1)
removeEventHandler("onClientRender",root,infoRowery)
	unbindKey("f","up",opuscWypo)
	unbindKey("z","up",zmienRower)
	unbindKey("e","up",stworzRower)
setTimer(function() destroyElement(wypo_pojazd) end,2000,1)
setTimer(function() setElementFrozen(localPlayer,false) end,1000,1)
setElementDimension(localPlayer,0)
end



function wybierzRower(x,y,z)
if isElement( wypo_pojazd ) then return end
wx=x
wy=y
wz=z
wypo_pojazd=createVehicle(509,1500.4285888672,-1457.6685791016,63.859375,0,0,90)
setElementData(wypo_pojazd,"wypo",1)
setElementData(wypo_pojazd,"wypo_nazwa","Rower")
setElementData(wypo_pojazd,"wypo_cena",50)
setElementDimension(wypo_pojazd,rowery_dim)
setElementDimension(localPlayer,rowery_dim)

setTimer(function() addEventHandler("onClientRender",root,infoRowery) end,2000,1)
fadeCamera(true)
setTimer(function()
bindKey("z","up",zmienRower)
bindKey("f","up",opuscWypo)
bindKey("e","up",stworzRower)
end,3000,1)
smoothMoveCamera(1500.3399658203,-1524.2188720703,68.009399414063,1500.3488769531,-1523.2205810547,67.951637268066,1500.7679443359,-1465.3397216797,64.792297363281,1500.7629394531,-1464.3509521484,64.643096923828,2000)
end
addEvent("wybierzRower",true)
addEventHandler("wybierzRower",root,wybierzRower)





function infoRowery()

local x, y = guiGetScreenSize()
local pojazdy = getElementsByType("vehicle")
for k,v in ipairs(pojazdy) do
	local x1,y1,z1 = getElementPosition (v)
	local x2,y2,z2 = getElementPosition (v)
	local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	if visibleto > 40 then else
		local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
		if not sx and not sy then else
			if getElementData(v,"wypo") == 1 then
				if getElementDimension(v) == getElementDimension(localPlayer) then
					dxDrawText ( getElementData(v,"wypo_nazwa"), sx,sy,sx,sy, tocolor(255,255,255,255), 2-visibleto/50, "default-small", "center","top",false,false,false )
					dxDrawText ( "Cena wypożyczenia: "..getElementData(v,"wypo_cena").." $", sx,sy+25,sx,sy, tocolor(255,255,255,255), 2-visibleto/50, "default-small", "center","top",false,false,false )
					dxDrawText ( "Naciśnij E , aby wypożyczyć, F , aby zakończyć.", sx,sy-25,sx,sy, tocolor(255,255,255,255), 1.5-visibleto/50, "default-small", "center","top",false,false,false )
					dxDrawText ( "Używaj Z , aby zmienić model roweru.", sx,sy-50,sx,sy, tocolor(255,255,255,255), 1.5-visibleto/50, "default-small", "center","top",false,false,false )
		end			end
		
		end
	end
end
end

function zmienRower()
local model=getElementModel(wypo_pojazd) 
if model == 509 then
	setElementModel(wypo_pojazd,510)
	setElementData(wypo_pojazd,"wypo_nazwa","Rower górski")
elseif model == 510 then 
	setElementModel(wypo_pojazd,481)
	setElementData(wypo_pojazd,"wypo_nazwa","BMX")
elseif model == 481 then 
	setElementModel(wypo_pojazd,509)
	setElementData(wypo_pojazd,"wypo_nazwa","Rower")
end
end


function stworzRower()
if getPlayerMoney(localPlayer) < 50 then -- SPRAWDZAJ KASE GRACZA
	outputChatBox("Wypożyczalnia Rowerów: nie możesz wypożyczyć tego roweru , ponieważ nie masz 50 $.",255,255,255)
else
	triggerServerEvent("stworzRowerS",localPlayer,localPlayer,getElementModel(wypo_pojazd),wx,wy,wz)
	fadeCamera(false)
	smoothMoveCamera(1500.7679443359,-1465.3397216797,64.792297363281,1500.7629394531,-1464.3509521484,64.643096923828,1500.3399658203,-1524.2188720703,68.009399414063,1500.3488769531,-1523.2205810547,67.951637268066,2000)
	setTimer(function() setCameraTarget(localPlayer) fadeCamera(true) end, 4000,1)
	removeEventHandler("onClientRender",root,infoRowery)
	unbindKey("f","up",opuscWypo)
	unbindKey("z","up",zmienRower)
	unbindKey("e","up",stworzRower)
	setTimer(function() destroyElement(wypo_pojazd) end,2000,1)
	setElementDimension(localPlayer,0)
end
end


--[[
function wypoMarkery() -- textdrawy na nazwy urządzeń
local x, y = guiGetScreenSize()
local markery = getElementsByType("marker")
for k,v in ipairs(markery) do
	local x1,y1,z1 = getElementPosition (getLocalPlayer())
	local x2,y2,z2 = getElementPosition (v)
	local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	if visibleto > 40 then else
		local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
		if not sx and not sy then else
			if getElementData(v,"wypozyczalnia_rowerow") == true then
				dxDrawText ( "Wypożyczalnia rowerów", sx,sy-70,sx,sy, tocolor(255,255,255,255), 1.7-visibleto/50, "default-small", "center","top",false,false,false )		
		end
		end
	end
end
end
addEventHandler("onClientRender",getRootElement(),wypoMarkery)
--]]
