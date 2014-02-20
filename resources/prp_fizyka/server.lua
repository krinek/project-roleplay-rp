


spawny={
 {798.05383,-1581.85461,13.54688,90},
 {779.87317,-1578.82434,13.54688,180},
 {771.59924,-1523.17126,13.54967,250}
 
  
} 


Mysl = {"Miej oczy i patrzaj w serce.","Zdrowie najwazniesze.","Milosc,honor,ojczyzna.","Trzymaj przyjaciol blisko a wrogow jeszcze blizej"
,"Bagnetami można zdobyć tron, ale nie można na nich siedzieć.","Ten się nie myli, kto nic nie robi.","Aby poznać człowieka, trzeba beczkę soli z nim zjeść."
,"Pijaństwo nie tworzy wad, ono je ujawnia.","Wszyscy ludzie są mądrzy: jedni przedtem, inni potem.","Nie bij muchy, która siedzi na głowie tygrysa.","Nie mów dużo, ale powiedz wiele."}


function Daj1(player, cmd,ile)
x1, y1, z1 = getElementPosition ( Biedak )                    
x2, y2, z2 = getElementPosition ( player )
local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
local B1 = getElementData(Biedak,"Bogacz")
if B1 == false then
if visibleto > 1 then else
setElementData(Biedak,"Bogacz",true)
setTimer(function() destroyElement(Biedak) end,3000,1)
setTimer(function() Spawn() end,5000,1)
takePlayerMoney ( player,ile )
local ID2 = math.random ( 1, #Mysl ) 
local MC2 = Mysl[ID2]
outputChatBox (" ",player )
outputChatBox ("******",player )
outputChatBox ("Dałeś biedakowi:"..ile.."$",player )
outputChatBox (" ",player )
outputChatBox ("Biedak mówi:"..MC2,player)
outputChatBox (" ",player )
outputChatBox ("******",player )
end
end
end
addCommandHandler("biedak",Daj1)
 
 
root = getRootElement ()



-- function createLine ()
	-- x1, y1, z1 = getElementPosition ( Biedak )                    
	-- x2, y2, z2 = getElementPosition ( getLocalPlayer ())   
-- local sx,sy = getScreenFromWorldPosition ( x1+2,y1+2,z1+2 )
-- local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
-- if visibleto > 0 then 
-- if  sx and  sy then 	
-- local Dis = math.abs(math.ceil((x1+y2+z1) - (x2+y2+z2)))
-- local text = "Do obiektu pozostało "..Dis.." m"
    -- local fX = (50)
    -- local fY = (250)
    -- dxDrawText(text, fX + 1, fY, fX + 1, fY, tocolor(0,   0,   0, 255),   2)
    -- dxDrawText(text, fX - 1, fY, fX - 1, fY, tocolor(0,   0,   0, 255),   2)
    -- dxDrawText(text, fX, fY + 1, fX, fY + 1, tocolor(0,   0,   0, 255),   2)
    -- dxDrawText(text, fX, fY - 1, fX, fY - 1, tocolor(0,   0,   0, 255),   2)
    -- dxDrawText(text, fX, fY, fX, fY, tocolor(255, 255, 255, 255), 2)		
-- dxDrawLine3D ( x1, y1, z1, x2, y2, z2, tocolor ( 255, 255, 0, 50 ), 5) 
-- end
-- end
-- end
-- addEventHandler("onClientRender", getRootElement(), createLine)    



setTimer(function() Spawn() end,100,1)

function Spawn()
Biedak = createPed(78,unpack(spawny[math.random(1,#spawny)]))
setElementData(Biedak,"Bogacz",false)
setPedAnimation ( Biedak, "CRACK", "crckidle1")
end


function GPT(thePlayer)                   
x1 , y1, z1 = getElementPosition ( thePlayer )
local rx,ry,rz = getElementRotation ( thePlayer )
outputChatBox ("{"..x1..","..y1..","..z1..",".."},",thePlayer)
end
addCommandHandler("gp",GPT)

