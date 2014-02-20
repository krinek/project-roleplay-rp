local x,y=guiGetScreenSize()
actual= { }
respawn = 2
rysowanie_enable=0
przesuniecie=2
status_okregu=0
client_marker=nil
ryby_zlowione=0
ryby_combo=0
kurs_ryb=1



function rybyStart(marker)
setTimer(function() setElementFrozen(localPlayer,true) end,300,1)
rybyTimer=setTimer(function() respawn=(respawn)-1  if respawn<0 then respawn=2 end end,300,0)
kolko=guiCreateStaticImage(x/2-64,80,64,64,"circle.PNG",false)
addEventHandler("onClientRender",root,rysujGre)
addEventHandler("onClientRender",root,ryby)
setTimer(function() zbindujKlawisze() end,500,1)
client_marker=marker
local a,b,c,a1,b1,c1=getCameraMatrix()
local a2,b2,c2=getElementPosition(localPlayer)
smoothMoveCamera(a,b,c,a1,b1,c1,a,b-15,c+2,a2,b2,c2,1000)
toggleAllControls(false)
ryby_zlowione=0
end
addEvent("rybyStart",true)
addEventHandler("rybyStart",root,rybyStart)





function rysujGre()
if respawn < 1 then
	if rysowanie_enable == 0 then
		rysowanie_enable = 1
		setTimer(function() rysowanie_enable=0 end,300,1)
		typ_strzaly=math.random(1,4)
		if typ_strzaly==1 then
			strzala=guiCreateStaticImage(x/2+200,100,32,32,"arrow.PNG",false)
			setElementData(strzala,"kierunek","lewo")
		elseif typ_strzaly==2 then
			strzala=guiCreateStaticImage(x/2+200,100,32,32,"arrow2.PNG",false)
			setElementData(strzala,"kierunek","prawo")
		elseif typ_strzaly==3 then
			strzala=guiCreateStaticImage(x/2+200,100,32,32,"arrow3.PNG",false)
			setElementData(strzala,"kierunek","gora")
		elseif typ_strzaly==4 then
			strzala=guiCreateStaticImage(x/2+200,100,32,32,"arrow4.PNG",false)
			setElementData(strzala,"kierunek","dol")
		end
		setElementData(strzala,"ryby",1)
	end
end

for i,img in ipairs (getElementsByType('gui-staticimage')) do
if getElementData(img,"ryby")==1 then
	local xg,yg=guiGetPosition(img,false)
	if xg<x/2-200 then
	destroyElement(img)
	else
	guiSetPosition(img,xg-przesuniecie,yg,false)
	end
	if xg > x/2-64 then
		if xg < x/2 then
			status_okregu=0
			grot=getElementData(img,"kierunek")
		else
			status_okregu=1
		end
	end
end
end

end



function zbindujKlawisze()
bindKey("arrow_l","up",grajKolko)
bindKey("arrow_r","up",grajKolko)
bindKey("arrow_u","up",grajKolko)
bindKey("arrow_d","up",grajKolko)
bindKey("e","up",opuscGre)
end

klawisz=0
function grajKolko(key,keystate)
if klawisz == 0 then
	if key == "arrow_l" then
		if grot == "lewo" then
			rybyCombo()
		end
	elseif key == "arrow_r" then
		if grot == "prawo" then
			rybyCombo()
		end
	elseif key == "arrow_u" then
		if grot == "gora" then
			rybyCombo()
		end
	elseif key == "arrow_d" then
		if grot == "dol" then
			rybyCombo()
		end
	end
klawisz = 1
setTimer(function() klawisz=0 end,300,1)
end

end




function opuscGre()
killTimer(rybyTimer)
outputChatBox("[INFO]Złowiłeś "..ryby_zlowione.." ryb(y)! Pamiętaj,aby je sprzedać!",255,255,255)
removeEventHandler("onClientRender",root,rysujGre)
removeEventHandler("onClientRender",root,ryby)
destroyElement(kolko)
unbindKey("arrow_l","up",grajKolko)
unbindKey("arrow_r","up",grajKolko)
unbindKey("arrow_u","up",grajKolko)
unbindKey("arrow_d","up",grajKolko)
unbindKey("e","up",opuscGre)
setElementFrozen(localPlayer,false)
setCameraTarget(localPlayer,localPlayer)
setElementData(client_marker,"ryby_enabled",true)
toggleAllControls(true)
for i , img in ipairs (getElementsByType("gui-staticimage")) do
	destroyElement(img)
end
setElementData(localPlayer,"ryby_zlowione",getElementData(localPlayer,"ryby_zlowione")+ryby_zlowione)

end

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

function rybyInfo() 
local x, y = guiGetScreenSize()
local markery = getElementsByType("marker")
for k,v in ipairs(markery) do
	local x1,y1,z1 = getElementPosition (getLocalPlayer())
	local x2,y2,z2 = getElementPosition (v)
	local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
	if visibleto > 40 then else
		local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
		if not sx and not sy then else
			if getElementData(v,"ryby_marker") == true then
				if getElementData(v,"ryby_enabled") == true then
					dxDrawText ( "Wędkarstwo", sx,sy-70,sx,sy, tocolor(255,255,255,255), 1.7-visibleto/50, "default-small", "center","top",false,false,false )		
				end
				if getElementData(v,"ryby_baza") == true then
					dxDrawText ( "Hurtownia ryb", sx,sy-70,sx,sy, tocolor(255,255,255,255), 1.7-visibleto/50, "default-small", "center","top",false,false,false )
				end
			end
		end
	end
end
end
addEventHandler("onClientRender",getRootElement(),rybyInfo)


function ryby()


local x, y = guiGetScreenSize()
dxDrawText ( "            Złowione ryby: "..ryby_zlowione..".", x/2+100,y-100,200,200, tocolor(255,255,255,255), 2, "default-small", "center","top",false,false,false )
dxDrawText ( "Używaj strzałek, aby łowić ryby.", x/2+100,y-50,200,200, tocolor(255,255,255,255), 2, "default-small", "center","top",false,false,false )
dxDrawText ( "Naciśnij E, aby opuścić wędkarstwo.", x/2+100,y-30,200,200, tocolor(255,255,255,255), 2, "default-small", "center","top",false,false,false )

end


function rybyCombo()
ryby_combo=(ryby_combo)+1
if ryby_combo == 10 then
	ryby_combo=0
	local liczba = math.random(1,10) 
	if liczba == 1 or 2 or 3 or 4 or 5 or 6 or 7 or 8 or 9 then
	ryby_zlowione=(ryby_zlowione)+math.random(1,2)
	elseif liczba==10 then
	ryby_zlowione=(ryby_zlowione)+math.random(1,5)
end
end
end

function sprzedajRyby()
local rybska = getElementData(localPlayer,"ryby_zlowione")
	if rybska then
	else rybska=0 end
setElementData(localPlayer,"ryby_zlowione",0)
--setPlayerMoney(getPlayerMoney(localPlayer)+rybska*kurs_ryb) -- KASA ZA RYBY ZMIEN TO !!!!!!!!!!!!!!!!!!!!!!!!!!!
triggerServerEvent( "givePlayerMoney", getLocalPlayer(), rybska*kurs_ryb )
outputChatBox("[INFO]Sprzedałeś "..rybska.." ryb(y) za "..rybska*kurs_ryb.."$!",255,255,255)



end
addEvent("sprzedajRyby",true)
addEventHandler("sprzedajRyby",root,sprzedajRyby)



