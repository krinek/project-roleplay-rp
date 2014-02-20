Czekanie = {".","..","..."}

function NameTagsEX3()
if getElementData(getLocalPlayer(),"Admin") == true then
	local players = getElementsByType("marker")
		for k,v in ipairs(players) do
			if v == getLocalPlayer() then else
				local r = getElementData(v,"red")
				local g = getElementData(v,"green")
				local b = getElementData(v,"blue")
				local x1,y1,z1 = getElementPosition (getLocalPlayer())
				local x2,y2,z2 = getElementPosition (v)
				local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
					if visibleto > 5 then else
local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
local Nazwa = string.gsub(getMarkerSize(v),"_", " ")		
local Zycie1 = getMarkerCount(v)	
local Typ2 = getElementType(v)		
local R, G, B, A = getMarkerColor(v)
if not sx and not sy then else	   					
dxDrawText("Wielkosc:"..Nazwa, sx-2, sy-80, sx, sy, tocolor(255,0,0, 255 ),2,"defalut", "center", "center" )		
dxDrawText("Liczba Znakow:"..Zycie1, sx, sy-150, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Kolor: R:"..R..",G:"..G..", B:,"..B..", A:"..A, sx, sy-298, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Typ:"..Typ2, sx, sy+446, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
end
end
end
end
end

end
addEventHandler("onClientRender",getRootElement(),NameTagsEX3)



function NameTagsEX2()
if getElementData(getLocalPlayer(),"Admin") == true then

	local players = getElementsByType("ped")
		for k,v in ipairs(players) do
			if v == getLocalPlayer() then else
				local r = getElementData(v,"red")
				local g = getElementData(v,"green")
				local b = getElementData(v,"blue")
				local x1,y1,z1 = getElementPosition (getLocalPlayer())
				local x2,y2,z2 = getElementPosition (v)
				local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
					if visibleto > 5 then else
local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
local Nazwa = string.gsub(getElementModel(v),"_", " ")		
local Zycie1 = getElementHealth (v)	
local Typ2 = getElementType(v)		
if not sx and not sy then else	     					
dxDrawText("MODEL:"..Nazwa, sx-2, sy-80, sx, sy, tocolor(255,0,0, 255 ),2,"defalut", "center", "center" )		
dxDrawText("Zycie:"..Zycie1, sx, sy-150, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Typ:"..Typ2, sx, sy+446, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
end
end
end
end
end

end
addEventHandler("onClientRender",getRootElement(),NameTagsEX2)


function RadioRender()
	local obj = getElementsByType("object")
		for k,v in ipairs(obj) do
			if v == getLocalPlayer() then else
				local r = getElementData(v,"red")
				local g = getElementData(v,"green")
				local b = getElementData(v,"blue")
				local x1,y1,z1 = getElementPosition (getLocalPlayer())
				local x2,y2,z2 = getElementPosition (v)
				local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
				local Song = getElementData(v,"Piosenka")
				local GraczR = getElementData(getLocalPlayer(),"ZmienStacje ")
				if visibleto > 2 then else
local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
if not sx and not sy then else	 
if GraczR == true then
local Stacja = getElementData(getLocalPlayer(),"NowaStacja")
setElementData(v,"Radio",Stacja)
setElementData(getLocalPlayer(),"ZmienStacje",false)
else
local Sprawdzanie = getElementData(getLocalPlayer(),"Sprawdzanie")
local Muza = getElementData(v,"Radio")
if Sprawdzanie == false then 
local Radia = getElementsByType("Sound")
for k,v in ipairs(Radia) do
destoryElement(v)
dxDrawText("BLAD ERROR #405 (SPRAWDZANIE OBIEKTU NIE POWIODLO SIE)", sx, sy-980, sx, sy, tocolor(255,0,0, 255 ),2,"defalut", "center", "center" )
end
else
if Song == Muza then 
else				
local Dzwiek = playSound3D(Muza,x1,y1,z1)
attachElements(Dzwiek,v)
setElementData(v,"Piosenka",Muza)
setObjectMass(v,1.5)
end
end
end
end
end 

end
end

end
addEventHandler("onClientRender",getRootElement(),RadioRender)



function NameTagsEX1()
if getElementData(getLocalPlayer(),"Admin") == true then

	local players = getElementsByType("vehicle")
		for k,v in ipairs(players) do
			if v == getLocalPlayer() then else
				local r = getElementData(v,"red")
				local g = getElementData(v,"green")
				local b = getElementData(v,"blue")
				local x1,y1,z1 = getElementPosition (getLocalPlayer())
				local x2,y2,z2 = getElementPosition (v)
				local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
					if visibleto > 5 then else
local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
local Nazwa = string.gsub(getElementModel(v),"_", " ")	
local P1 =  getVehicleName(v)	
local Zycie1 = getElementHealth (v)	
local Typ2 = getElementType(v)		
handlingData = getVehicleHandling (v)
local ID2 =  handlingData["mass"]
local Silnik = handlingData["numberOfGears"]
local SilnikTyp = handlingData["engineType"]
local SilnikAkceleracja = handlingData["engineAcceleration"]
local SilnikInteria = handlingData["engineInertia"]
local Kolizja = handlingData["collisionDamageMultiplier"]
local Hamulec = handlingData["brakeDeceleration"]
local Masa = handlingData["turnMass"]
local MaxPredkosc = handlingData["maxVelocity"]
local ABS = handlingData["ABS"] or "BRAK"
local TypPojazdu = getVehicleType(v)
local plateText = getVehiclePlateText (v)


speedx, speedy, speedz = getElementVelocity (v)
actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
kmh = math.ceil(actualspeed * 180)

if not sx and not sy then else	     					
dxDrawText("MODEL:"..Nazwa..","..P1.." Rejestracja:"..plateText, sx-2, sy-80, sx, sy, tocolor(255,0,0, 255 ),2,"defalut", "center", "center" )		
dxDrawText("Zycie:"..Zycie1, sx, sy-150, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Masa:"..ID2.." kg \n Masa w turna:"..Masa.."\n KM/H:"..kmh, sx, sy-298, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Silnik: ["..Silnik.."], Typ:"..SilnikTyp..", Akceleracja:"..SilnikAkceleracja.."\nBezwladnosc:"..SilnikInteria.." ,Silnik Maksymalna Predkosc:"..MaxPredkosc, sx, sy+46, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Kolizja:"..Kolizja.."\n Hamulec:"..Hamulec.."\n ABS:"..ABS, sx, sy+290, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Typ:"..Typ2.."\n Typ Pojazdu:"..TypPojazdu, sx, sy+446, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
end
end
end
end
end

end
addEventHandler("onClientRender",getRootElement(),NameTagsEX1)


local Predkosc = {0.1} 
 
function FizykaObiekty()
	local players = getElementsByType("object")
		for k,v in ipairs(players) do
			if v == getLocalPlayer() then else
				local r = getElementData(v,"red")	
				local g = getElementData(v,"green")
				local b = getElementData(v,"blue")
				local x1,y1,z1 = getElementPosition (getLocalPlayer())
				local x2,y2,z2 = getElementPosition (v)
				local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
					if visibleto > 4 then else
local sx,sy,sz = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
local gx = getGroundPosition ( x2,y2,z2 ) 
local Wysokosc = getGroundPosition ( x1,y1,z1 ) 
setElementData(getLocalPlayer(),"Wysokosc",Wysokosc)
setElementData(v,"Wysokosc",gx)
local P1= getElementData(v,"Predkosc")
local H = math.ceil(getElementData(v,"Wysokosc"))
local WH = math.ceil(getElementData(getLocalPlayer(),"Wysokosc"))
local P2 = math.random ( 1, #Predkosc ) 
local PP2 = Predkosc[P2]
if not sx and not sy then else	  
if H == WH then 
else
setElementPosition ( v,x2,y2,z2 - PP2 )
end	

end
end
end
end
end

addEventHandler("onClientRender",getRootElement(),FizykaObiekty)


function NameTagsEX()
if getElementData(getLocalPlayer(),"Admin") == true then
	local players = getElementsByType("object")
		for k,v in ipairs(players) do
			if v == getLocalPlayer() then else
				local r = getElementData(v,"red")	
				local g = getElementData(v,"green")
				local b = getElementData(v,"blue")
				local x1,y1,z1 = getElementPosition (getLocalPlayer())
				local x2,y2,z2 = getElementPosition (v)
				local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
					if visibleto > 10 then else
local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
local playerName = string.gsub(getElementModel(v),"_", " ")		
local ID = getObjectMass(v) 
local Zycie = getElementHealth (v)	
local Typ = getElementType(v)	
local IID = getElementID(v) 	
local rx,ry,rz = getElementRotation (v)
local Int =  getElementInterior(getLocalPlayer())
local Postaw = getElementData(getLocalPlayer(),"Postawiony")
local Muza = getElementData(v,"Radio")

if not sx and not sy then else	     
if getElementHealth (v) == 0 then
setElementRotation(v,rx,ry,rz+5)
 setElementAlpha(v,150) 
setElementHealth(v,0)
setElementInterior ( v, Int )
setElementCollisionsEnabled(v, false)
dxDrawText("Masa:"..ID.." kg", sx, sy-298, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Typ:"..Typ, sx, sy+446, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )	

local text = "Obiekt jest znisczony."
    dxDrawText(text, sx + 1 - 150, sy, sx + 1, sy, tocolor(0,   0,   0, 255),   2)
    dxDrawText(text, sx - 1 -150, sy, sx - 1, sy, tocolor(0,   0,   0, 255),   2)
    dxDrawText(text, sx-150, sy + 1, sx, sy + 1, tocolor(0,   0,   0, 255),   2)
    dxDrawText(text, sx-150, sy - 1, sx, sy - 1, tocolor(0,   0,   0, 255),   2)
    dxDrawText(text, sx-150, sy, sx, sy, tocolor(255,0, 0, 255), 2)
else		
 setElementAlpha(v,255) 		
setElementData(v,"Model",playerName)
setElementInterior ( v, Int )
dxDrawText("MODEL:"..playerName..", Nazwa:"..IID, sx-2, sy-80, sx, sy, tocolor(255,0,0, 255 ),2,"defalut", "center", "center" )		
dxDrawText("Zycie:"..Zycie, sx, sy-150, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Masa:"..ID.." kg", sx, sy-298, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )
dxDrawText("Typ:"..Typ.."\n Stacja:"..Muza, sx, sy+446, sx, sy, tocolor(255, 255,255, 255 ),2,"defalut", "center", "center" )

if getElementData(v,"Postawiony") == true then

local ID = math.random ( 1, #Czekanie ) 
local TEKST = Czekanie[ID]

local text = "Ładowanie Obiektu"..TEKST
    dxDrawText(text, sx + 1 - 150, sy, sx + 1, sy, tocolor(0,   0,   0, 255),   2)
    dxDrawText(text, sx - 1 -150, sy, sx - 1, sy, tocolor(0,   0,   0, 255),   2)
    dxDrawText(text, sx-150, sy + 1, sx, sy + 1, tocolor(0,   0,   0, 255),   2)
    dxDrawText(text, sx-150, sy - 1, sx, sy - 1, tocolor(0,   0,   0, 255),   2)
    dxDrawText(text, sx-150, sy, sx, sy, tocolor(255,0, 0, 255), 2)
else
setElementInterior ( v, Int )
	
end	

end
end
end
end
end

end
end

addEventHandler("onClientRender",getRootElement(),NameTagsEX)


setElementData(getLocalPlayer(),"Podnies",false)
setElementData(getLocalPlayer(),"Postaw",false)

function BranieObiektu()
if getElementData(getLocalPlayer(),"Admin") == true then
	local players = getElementsByType("object")
		for k,v in ipairs(players) do		
			if v == getLocalPlayer() then else
				local r = getElementData(v,"red")	
				local g = getElementData(v,"green")
				local b = getElementData(v,"blue")
				local x1,y1,z1 = getElementPosition (getLocalPlayer())
				local x2,y2,z2 = getElementPosition (v)
				local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
					if visibleto > 2 then else
local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )
if getElementData(v,"RadioP") == true then else
if getElementData(getLocalPlayer(),"Postaw") == true then
setElementHealth(v,1000)
local x,y,z = getElementPosition(getLocalPlayer())
local Masa = math.random(20,150)
local xg,yg,zg = getElementPosition(getLocalPlayer())
setElementPosition ( v, x, y - 2, zg+ 2 )
detachElements(v,getLocalPlayer())
setObjectMass(v,Masa)
setElementCollisionsEnabled(v, true)
setElementData(getLocalPlayer(),"Postaw",false)
setElementData(v,"Postawiony",false)
else
if getElementData(getLocalPlayer(),"Podnies") == true then
local rx,ry,rz = getElementRotation (v)
attachElements ( v, getLocalPlayer(), 0, 1,1 )
setElementCollisionsEnabled(v, false)
setElementData(getLocalPlayer(),"Podnies",false)
setElementData(v,"Postawiony",true)
else
if getElementData(getLocalPlayer(),"Gora") == true then
local x,y,z = getElementPosition(v)
setElementPosition ( v, x, y,z+0.5)
setElementData(getLocalPlayer(),"Gora",false)
else
if getElementData(getLocalPlayer(),"Dol") == true then
local x,y,z = getElementPosition(v)
setElementPosition ( v, x, y,z-0.5)
setElementData(getLocalPlayer(),"Dol",false)
else
if getElementData(getLocalPlayer(),"Lew") == true then
local x,y,z = getElementPosition(v)
setElementPosition ( v, x+0.5, y,z)
setElementData(getLocalPlayer(),"Lew",false)
else
if getElementData(getLocalPlayer(),"Praw") == true then
local x,y,z = getElementPosition(v)
setElementPosition ( v, x-0.5, y,z)
setElementData(getLocalPlayer(),"Praw",false)
else

if getElementData(getLocalPlayer(),"Prosto") == true then
local x,y,z = getElementPosition(v)
setElementPosition ( v, x, y+0.5,z)
setElementData(getLocalPlayer(),"Prosto",false)
else
if getElementData(getLocalPlayer(),"Tyl") == true then
local x,y,z = getElementPosition(v)
setElementPosition ( v, x, y-0.5,z)
setElementData(getLocalPlayer(),"Tyl",false)
else
dxDrawText("KLKNIJ [PALT] aby podniesc - Klknij [LATL] aby opuscic", sx, sy-500, sx, sy, tocolor(255, 255,0, 50 ),2.5,"defalut", "center", "center" )	
end
end
end
end
end
end

end
end
end
end 
end

end
end

end
addEventHandler("onClientRender",getRootElement(),BranieObiektu)

function Podnies()
setElementData(getLocalPlayer(),"Postaw",true)
end
bindKey ( "lalt", "down", Podnies )

function Podnies2()
setElementData(getLocalPlayer(),"Podnies",true)
end
bindKey ( "ralt", "down", Podnies2 )

function Dol()
setElementData(getLocalPlayer(),"Dol",true)
end
bindKey ( "num_2", "down", Dol )

function Gora()
setElementData(getLocalPlayer(),"Gora",true)
end
bindKey ( "num_8", "down", Gora )


function Lew()
setElementData(getLocalPlayer(),"Lew",true)
end
bindKey ( "arrow_l", "down", Lew )

function Praw()
setElementData(getLocalPlayer(),"Praw",true)
end
bindKey ( "arrow_r", "down", Praw )


function Tyl()
setElementData(getLocalPlayer(),"Tyl",true)
end
bindKey ( "arrow_d", "down", Tyl )

function Prosto()
setElementData(getLocalPlayer(),"Prosto",true)
end
bindKey ( "arrow_u", "down", Prosto )

function Sprawdz()
setElementData(getLocalPlayer(),"Admin",true)
end
addCommandHandler ( "zobacz", Sprawdz )

function Sprawdz2()
setElementData(getLocalPlayer(),"Admin",false)
end
addCommandHandler ( "schowaj", Sprawdz2 )
------------------------------------------------------------------------------------


function onFire(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if weapon == 23 then
cancelEvent ()
local Obiekt = getElementModel(hitElement)	
local ID = getElementID(hitElement) 
local Zycie = getElementHealth (hitElement)	
 outputChatBox ("Model Obiektu:"..Obiekt.."\nNazwa:"..ID.."\nZycie:"..Zycie) 
 		setObjectBreakable(hitElement, true)		
		end	
end
addEventHandler( "onClientPlayerWeaponFire", getRootElement(), onFire)






function toggleObjectVulnerability()
	local object = createObject(910, 2480.89380,-1662.66028,20)
	if isObjectBreakable(object) then
		local oldMass = getObjectMass(object)
		outputChatBox("Masa stara"..oldMass)
		setObjectMass(object,-1)	
setElementHealth(object,5000)		
	end
end
addEventHandler("onClientResourceStart", resourceRoot, toggleObjectVulnerability)
-----------------
	
	
function TEST()
local oxygen = getPedOxygenLevel ( getLocalPlayer() ) - 1001.1647949219
    local fX = (1012)
    local fY = (205)
	dxDrawRectangle ( fX + 1, fY,99,16, tocolor ( 0, 0, 0, 255 ))
    dxDrawRectangle(1130, 208,oxygen/10, 10, tocolor(0, 0, 153, 255))	
    dxDrawRectangle(1015, 208,-oxygen/10, 10, tocolor(0, 0, 153, 255))

end
addEventHandler("onClientRender",getRootElement(),TEST)

------------------------------------------------------------


-- local D1 = 0.5
-- local D2 = 0.5

-- local x, y = guiGetScreenSize()

-- function PlayerNameTags()
	-- local players = getElementsByType("ped")
		-- for k,v in ipairs(players) do
			-- if v == getLocalPlayer() then else
				-- local r = getElementData(v,"red")
				-- local g = getElementData(v,"green")
				-- local b = getElementData(v,"blue")
				-- local x1,y1,z1 = getElementPosition (getLocalPlayer())
				-- local x2,y2,z2 = getElementPosition (v)
				-- local R = getElementData(getLocalPlayer(), "Rozmiar")
				-- local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
				-- local B1 = getElementData(v,"Bogacz")
					-- if visibleto > 5 then else
					-- if B1  == false then
						-- local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+1.05 )					
-- if not sx and not sy then else	    			
-- dxDrawText("Aby dac biedakowi pieniadze wpisz /biedak kwota", sx-2, sy-50, sx, sy, tocolor(21,248,155, 250 ),3/R,"default-bold", "center", "center" )
-- end
-- end
-- end
-- end
-- end
-- end
-- addEventHandler("onClientRender",getRootElement(),PlayerNameTags)

-- setTimer(function() KODXX() end,100,1)



-- function KODXX()
-- if getElementData(getLocalPlayer(), "Rozmiar") == 1 then
-- setElementData(getLocalPlayer(), "Rozmiar", getElementData(getLocalPlayer(), "Rozmiar") + D1)
-- setTimer ( KODXX,500, 1)
-- else
-- setElementData(getLocalPlayer(), "Rozmiar", getElementData(getLocalPlayer(), "Rozmiar") - D2)
-- setTimer ( KODXX,500, 1) 
-- end
-- end

-- setElementData(getLocalPlayer(), "Rozmiar",1)


