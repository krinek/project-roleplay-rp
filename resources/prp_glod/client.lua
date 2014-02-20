local CzasSpadkuGlodu = 60000 -- MINUTA

function Rozpocznij()
setElementData(getLocalPlayer(),"Glod",false)
setTimer(SpadekGlodu,CzasSpadkuGlodu,0,getLocalPlayer())
end
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource() ), Rozpocznij )
 
 


function PokazujeGlod()
if getElementData(getLocalPlayer(),"Glod") == false then
setElementData(getLocalPlayer(),"Glod",100)
else
if getElementData(getLocalPlayer(),"Glod") >= 6 then
local PoziomGlodu = getElementData(getLocalPlayer(),"Glod")
Glod = dxDrawImage(1000, 173, 68, 62, "Hamburger.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
Procent = dxDrawText(PoziomGlodu.."%", 1004, 192, 1058, 215, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "center", false, false, true, false, false)
else
if getElementData(getLocalPlayer(),"Glod") <= 5 then
local PoziomGlodu = getElementData(getLocalPlayer(),"Glod")
Glod = dxDrawImage(1000, 173, 68, 62, "Hamburger.png", 0, 0, 0, tocolor(255, 255, 50, 150), true)
Procent = dxDrawText(PoziomGlodu.."%", 1004, 192, 1058, 215, tocolor(255, 0, 0, 150), 0.50, "bankgothic", "center", "center", false, false, true, false, false)
end
end
end

end
addEventHandler("onClientRender",getRootElement(),PokazujeGlod)

function SpadekGlodu()
setElementData(getLocalPlayer(), "Glod", getElementData(getLocalPlayer(), "Glod") - 1)
if getElementData(getLocalPlayer(),"Glod") <= 0 then
setElementHealth ( getLocalPlayer(), getElementHealth(getLocalPlayer()) - 5 )
setElementData(getLocalPlayer(),"Glod",false)
  end
end