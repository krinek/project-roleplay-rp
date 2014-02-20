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
 
gui_x,gui_y=guiGetScreenSize()
 
pojazdy= { 602, 545, 496, 517, 401, 410, 518, 600, 527, 436, 589, 580, 419, 439, 533, 549, 526, 491, 474, 445, 467, 604, 426, 507, 547, 585,
405, 587, 409, 466, 550, 492, 566, 546, 540, 551, 421, 516, 529, 485, 552, 431, 
438, 437, 574, 420, 525, 408, 416, 596, 433, 597, 427, 599, 490, 432, 528, 601, 407, 428, 544, 523, 470, 598, 499, 588, 609, 403, 498, 514, 524, 
423, 532, 414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 459, 543, 422, 583, 482, 478, 605, 554, 530, 418, 572, 582, 413, 440, 536, 575, 534, 
567, 535, 576, 412, 402, 542, 603, 475, 449, 537, 538, 441, 464, 501, 465, 564, 568, 557, 424, 471, 504, 495, 457, 539, 483, 508, 571, 500, 
444, 556, 429, 411, 541, 559, 415, 561, 480, 560, 562, 506, 565, 451, 434, 558, 494, 555, 502, 477, 503, 579, 400, 404, 489, 505, 479, 442, 458,581,509,481,462,521,463,510,522,461,448,468,586 
 }
bikes= { 581,509,481,462,521,463,510,522,461,448,468,586 }
samwin_enable=0
function samwinf()
if samwin_enable==0 then
    samwin_enable=1
    showCursor(true)
    outputChatBox("Wybierz auto , a następnie kliknij przycisk stwórz , aby stworzyć pojazd!",0,255,0)
    samwin = guiCreateWindow(477, 229, 319, 376, "Stwórz pojazd", false)
    guiWindowSetSizable(samwin, false)
 
    lab1 = guiCreateLabel(15, 42, 100, 19, "Wybierz pojazd:", false, samwin)
 
    but1 = guiCreateButton(90, 316, 155, 22, "Stwórz", false, samwin)
    guiSetProperty(but1, "NormalTextColour", "FFAAAAAA")    
    but2 = guiCreateButton(90, 345, 155, 21, "Anuluj", false, samwin)
    guiSetProperty(but2, "NormalTextColour", "FFAAAAAA")
    grid = guiCreateGridList(12, 65, 294, 238, false, samwin)
    col=guiGridListAddColumn(grid, "Samochód", 0.9)
    for i,pojazd in ipairs (pojazdy) do 
        local row = guiGridListAddRow ( grid )
        local nazwa=getVehicleNameFromModel(pojazd)
        guiGridListSetItemText ( grid, row, col, nazwa, false, false )
    end
 
    addEventHandler("onClientGUIClick",but2,function() destroyElement(samwin) showCursor(false) samwin_enable=0 end)
    addEventHandler("onClientGUIClick",but1,function() local nazwa=guiGridListGetItemText ( grid, guiGridListGetSelectedItem ( grid ), 1 )
                                                        triggerServerEvent("spawnPojazdu",localPlayer,localPlayer,nazwa)
                                                        destroyElement(samwin) showCursor(false) samwin_enable=0
                                                        end)
    else
    end
end
 
 
 
 
 
 
function kameraElement(typ)
 
x,y,z,a,b,c=getCameraMatrix()
 
 mx,my,mz,ma,mb,mc = 0
 typ=tonumber(typ)
if typ == 1 then -- tył
 
mx=-2045.9893798828
my=162.44200134277
mz=30.017599105835
ma=-2046.0076904297
mb=167.42308044434
mc=29.824836730957
smoothMoveCamera(x,y,z,a,b,c,mx,my,mz,ma,mb,mc,2000)
elseif typ == 2 then --przód
 
mx=-2049.0688476563
my=173.5984954834
mz=29.736999511719
ma=-2048.381103515
mb=172.88835144043
mc=29.586549758911
smoothMoveCamera(x,y,z,a,b,c,mx,my,mz,ma,mb,mc,2000)
elseif typ == 3 then -- bok
 
mx=-2041.3299560547
my=170.71650695801
mz=30.251899719238
ma=-2042.2957763672
mb=170.68521118164
mc=29.994434356689
smoothMoveCamera(x,y,z,a,b,c,mx,my,mz,ma,mb,mc,2000)
end
 
 
 
end
 
 
function powrotKamery()
local mx,my,mz,ma,mb,mc=getCameraMatrix()
 x=-2040.9565429688
 y=168.07679748535
 z=32.633800506592
 a=-2041.6516113281
 b=168.63539123535
 c=32.181129455566
smoothMoveCamera(mx,my,mz,ma,mb,mc,x,y,z,a,b,c,2000)
 
end
 
 
 
 
tuning_enable=0
function tuning()
if tuning_enable==0 then
tuning_enable=1
if isPedInVehicle(getLocalPlayer()) then
    local veh=getPedOccupiedVehicle(getLocalPlayer())
    setPedCanBeKnockedOffBike(getLocalPlayer(),false)
    fadeCamera(false)
    local dim=math.random(100,10000)
    
    local px,py,pz=getElementPosition(veh)
    local pxz,pyz,pzz=getElementRotation(veh)
    setElementData(veh,"tx",x)
    setElementData(veh,"yx",y)
    setElementData(veh,"zx",z)
    obrot=1
    setTimer(function()
    setElementPosition(veh,-2046.1490478516,170.17724609375,29.0359375)
    setElementRotation(veh,0,0,0)
    fadeCamera(true)
    setElementInterior(getLocalPlayer(),1)
    setElementInterior(veh,1)
    setElementDimension(veh,dim)
    setElementDimension(getLocalPlayer(),dim)
    setTimer(function() setElementFrozen(getLocalPlayer(),true)
                        setElementFrozen(veh,true) end,500,1)
    
    setCameraMatrix(-2040.9565429688,168.07679748535,32.633800506592,-2041.6516113281,168.63539123535,32.181129455566)
    setTime(0,0)
    showCursor(true)
    twin = guiCreateWindow(gui_x-gui_y*0.8,0, 500, 400, "Tuning", false)
    guiWindowSetSizable(twin, false)
    tgrid = guiCreateGridList(10, 49, 268, 202, false, twin)
    tlab1 = guiCreateLabel(18, 29, 125, 16, "Wybierz część do auta:", false, twin)
    tbut1 = guiCreateButton(23, 265, 99, 26, "Dodaj część", false, twin)
    guiSetProperty(tbut1, "NormalTextColour", "FFAAAAAA")
    tbut2 = guiCreateButton(132, 265, 99, 26, "Opuść tuning", false, twin)
    guiSetProperty(tbut2, "NormalTextColour", "FFAAAAAA")
    tlab2 = guiCreateLabel(311, 29, 120, 18, "Zmień kolor pojazdu:", false, twin)
    local scr1=guiCreateScrollBar(311,50,20,100,false,false,twin)
    local scr2=guiCreateScrollBar(340,50,20,100,false,false,twin)
    local scr3=guiCreateScrollBar(369,50,20,100,false,false,twin)
    local scr4=guiCreateScrollBar(398,50,20,100,false,false,twin)
    local scr5=guiCreateScrollBar(427,50,20,100,false,false,twin)
    local scr6=guiCreateScrollBar(456,50,20,100,false,false,twin)
    local scr7=guiCreateScrollBar(311,180,20,100,false,false,twin)
    local scr8=guiCreateScrollBar(340,180,20,100,false,false,twin)
    local scr9=guiCreateScrollBar(369,180,20,100,false,false,twin)
    tlab3 = guiCreateLabel(311, 160, 160, 30, "Zmień kolor świateł pojazdu:", false, twin)
    
    
    local r,g,b,z,x,c=getVehicleColor(veh,true)
    local s1,s2,s3=getVehicleHeadLightColor(veh)
    local rp=r/255*100
    local gp=g/255*100
    local bp=b/255*100
    local zp=z/255*100
    local xp=x/255*100
    local cp=c/255*100
    local s1p=s1/255*100
    local s2p=s2/255*100
    local s3p=s3/255*100
    guiScrollBarSetScrollPosition(scr1,rp)
    guiScrollBarSetScrollPosition(scr2,gp)
    guiScrollBarSetScrollPosition(scr3,bp)
    guiScrollBarSetScrollPosition(scr4,zp)
    guiScrollBarSetScrollPosition(scr5,xp)
    guiScrollBarSetScrollPosition(scr6,cp)
    guiScrollBarSetScrollPosition(scr7,s1p)
    guiScrollBarSetScrollPosition(scr8,s2p)
    guiScrollBarSetScrollPosition(scr9,s3p)
    local dodatki=getVehicleCompatibleUpgrades(veh)
    local col=guiGridListAddColumn(tgrid, "ID", 0.5)
    local col2=guiGridListAddColumn(tgrid, "Dodatek", 0.5)
    tbut3 = guiCreateButton(311, 300, 99, 26, "Napraw auto", false, twin)
    tbut4 = guiCreateButton(311, 340, 99, 26, "Usuń wszystkie dodatki", false, twin)
    for i,dodatek in ipairs (dodatki) do 
        local row = guiGridListAddRow ( tgrid )
        guiGridListSetItemText ( tgrid, row, col, tostring(dodatek), false, false )
        guiGridListSetItemText ( tgrid, row, col2, tostring(getVehicleUpgradeSlotName(dodatek)), false, false )
    end
    addEventHandler("onClientGUIClick",tbut4,function()
                            triggerServerEvent("usunDodatki",root,veh)
                            playSoundFrontEnd(46)
                            end)
    
    
    addEventHandler("onClientGUIClick",tbut3,function()
                            setElementHealth(veh,1000)
                            playSoundFrontEnd(46)
                            end)
    
    addEventHandler("onClientGUIClick",tbut2,function() fadeCamera(false)
                                                        destroyElement(twin) showCursor(false)
                                                        setTimer(function() 
                                                        setElementPosition(veh,px,py,pz,pxz,pyz,pzz)
                                                        setElementInterior(veh,0)
                                                        setElementInterior(localPlayer,0)
                                                        setElementFrozen(getLocalPlayer(),false)
                                                        setElementFrozen(veh,false)
                                                        setPedCanBeKnockedOffBike(getLocalPlayer(),true)
                                                        setCameraTarget(getLocalPlayer(),getLocalPlayer())
                                                        setElementDimension(veh,0)
                                                        setElementDimension(getLocalPlayer(),0)
                                                        tuning_enable=0
                                                        fadeCamera(true)
                                                        end,4000,1) end)
    
    addEventHandler("onClientGUIClick",tbut1,function() local nazwa=guiGridListGetItemText ( tgrid, guiGridListGetSelectedItem ( tgrid ), 1 )
                                                        triggerServerEvent("dodajPart",root,getLocalPlayer(),veh,nazwa)
                                                        playSoundFrontEnd(46)
                                                        end)
    addEventHandler("onClientGUIScroll",scr1,function()    local rz=guiScrollBarGetScrollPosition(scr1)
                                                        local gz=guiScrollBarGetScrollPosition(scr2)
                                                        local bz=guiScrollBarGetScrollPosition(scr3)
                                                        local zz=guiScrollBarGetScrollPosition(scr4)
                                                        local xz=guiScrollBarGetScrollPosition(scr5)
                                                        local cz=guiScrollBarGetScrollPosition(scr6)
                                                        triggerServerEvent("zmienKolorAuta",root,veh,rz,gz,bz,zz,xz,cz)
                                                        playSoundFrontEnd(46)
                                                        end)
    addEventHandler("onClientGUIScroll",scr2,function()    local rz=guiScrollBarGetScrollPosition(scr1)
                                                        local gz=guiScrollBarGetScrollPosition(scr2)
                                                        local bz=guiScrollBarGetScrollPosition(scr3)
                                                        local zz=guiScrollBarGetScrollPosition(scr4)
                                                        local xz=guiScrollBarGetScrollPosition(scr5)
                                                        local cz=guiScrollBarGetScrollPosition(scr6)
                                                        triggerServerEvent("zmienKolorAuta",root,veh,rz,gz,bz,zz,xz,cz)
                                                        playSoundFrontEnd(46)
                                                        end)
    addEventHandler("onClientGUIScroll",scr3,function()    local rz=guiScrollBarGetScrollPosition(scr1)
                                                        local gz=guiScrollBarGetScrollPosition(scr2)
                                                        local bz=guiScrollBarGetScrollPosition(scr3)
                                                        local zz=guiScrollBarGetScrollPosition(scr4)
                                                        local xz=guiScrollBarGetScrollPosition(scr5)
                                                        local cz=guiScrollBarGetScrollPosition(scr6)
                                                        triggerServerEvent("zmienKolorAuta",root,veh,rz,gz,bz,zz,xz,cz)
                                                        playSoundFrontEnd(46)
                                                        end)
    addEventHandler("onClientGUIScroll",scr4,function()    local rz=guiScrollBarGetScrollPosition(scr1)
                                                        local gz=guiScrollBarGetScrollPosition(scr2)
                                                        local bz=guiScrollBarGetScrollPosition(scr3)
                                                        local zz=guiScrollBarGetScrollPosition(scr4)
                                                        local xz=guiScrollBarGetScrollPosition(scr5)
                                                        local cz=guiScrollBarGetScrollPosition(scr6)
                                                        triggerServerEvent("zmienKolorAuta",root,veh,rz,gz,bz,zz,xz,cz)
                                                        playSoundFrontEnd(46)
                                                        end)
    addEventHandler("onClientGUIScroll",scr5,function()    local rz=guiScrollBarGetScrollPosition(scr1)
                                                        local gz=guiScrollBarGetScrollPosition(scr2)
                                                        local bz=guiScrollBarGetScrollPosition(scr3)
                                                        local zz=guiScrollBarGetScrollPosition(scr4)
                                                        local xz=guiScrollBarGetScrollPosition(scr5)
                                                        local cz=guiScrollBarGetScrollPosition(scr6)
                                                        triggerServerEvent("zmienKolorAuta",root,veh,rz,gz,bz,zz,xz,cz)
                                                        playSoundFrontEnd(46)
                                                        end)
    addEventHandler("onClientGUIScroll",scr6,function()    local rz=guiScrollBarGetScrollPosition(scr1)
                                                        local gz=guiScrollBarGetScrollPosition(scr2)
                                                        local bz=guiScrollBarGetScrollPosition(scr3)
                                                        local zz=guiScrollBarGetScrollPosition(scr4)
                                                        local xz=guiScrollBarGetScrollPosition(scr5)
                                                        local cz=guiScrollBarGetScrollPosition(scr6)
                                                        triggerServerEvent("zmienKolorAuta",root,veh,rz,gz,bz,zz,xz,cz)
                                                        playSoundFrontEnd(46)
                                                        end)
                                                        
    addEventHandler("onClientGUIScroll",scr7,function()    local s1t=guiScrollBarGetScrollPosition(scr7)
                                                        local s2t=guiScrollBarGetScrollPosition(scr8)
                                                        local s3t=guiScrollBarGetScrollPosition(scr9)
                                                        triggerServerEvent("zmienKolorSwiatelAuta",root,veh,s1t,s2t,s3t)
                                                        playSoundFrontEnd(46)
                                                        end)        
                                                        
    addEventHandler("onClientGUIScroll",scr8,function()    local s1t=guiScrollBarGetScrollPosition(scr7)
                                                        local s2t=guiScrollBarGetScrollPosition(scr8)
                                                        local s3t=guiScrollBarGetScrollPosition(scr9)
                                                        triggerServerEvent("zmienKolorSwiatelAuta",root,veh,s1t,s2t,s3t)
                                                        playSoundFrontEnd(46)
                                                        end)    
                                                        
    addEventHandler("onClientGUIScroll",scr9,function()    local s1t=guiScrollBarGetScrollPosition(scr7)
                                                        local s2t=guiScrollBarGetScrollPosition(scr8)
                                                        local s3t=guiScrollBarGetScrollPosition(scr9)
                                                        triggerServerEvent("zmienKolorSwiatelAuta",root,veh,s1t,s2t,s3t)
                                                        playSoundFrontEnd(46)
                                                        end)                                                            
    czas_kamera=0
    kamera_enable=0
    buffer = nil
    addEventHandler("onClientGUIClick",tgrid,function()
                            local nazwa=guiGridListGetItemText ( tgrid, guiGridListGetSelectedItem ( tgrid ), 2 )
                            local nazwa2=guiGridListGetItemText ( tgrid, guiGridListGetSelectedItem ( tgrid ), 1 )
                            if czas_kamera == 0 then
                                
                                    
                                    czas_kamera=1
                                    setTimer(function() czas_kamera=0 end,2100,1)
                                    if nazwa=="Spoiler" then
                                        kameraElement(1)
                                    elseif nazwa=="Hood" then 
                                        kameraElement(2)
                                    elseif nazwa=="Roof" then 
                                        kameraElement(2)
                                    elseif nazwa=="Sideskirt" then 
                                        kameraElement(3)
                                    elseif nazwa=="Nitro" then 
                                        kameraElement(1)
                                    elseif nazwa=="Exhaust" then 
                                        kameraElement(1)
                                    elseif nazwa=="Wheels" then 
                                        kameraElement(3)
                                    elseif nazwa=="Hydraulics" then 
                                        kameraElement(3)
                                    elseif nazwa=="Front Bumper" then 
                                        kameraElement(2)
                                    elseif nazwa=="Rear Bumper" then 
                                        kameraElement(1)
                                    end
                                
                            end
                            end)                                                    
                                                        
                                                        
                                                        
                                                        
                                                        
    end,4000,1)
    
 
else
    tuning_enable=0
    outputChatBox("Nie jesteś w aucie!",255,0,0)
end
 
else
end
end
 
 
wenable=0
function wwine()
if wenable==0 then
showCursor(true)
wenable=1
 
wwin = guiCreateWindow(0, -20, 237, 190, "", false)
 
 
guiWindowSetSizable(wwin, true)
 
wbut1 = guiCreateButton(12, 31, 101, 28, "Stwórz pojazd", false, wwin)
guiSetProperty(wbut1, "NormalTextColour", "FFAAAAAA")
wbut2 = guiCreateButton(12, 69, 101, 28, "Tuning pojazdu", false, wwin)
guiSetProperty(wbut2, "NormalTextColour", "FFAAAAAA")
 
if isPedInVehicle(getLocalPlayer()) then
wbut3 = guiCreateButton(120, 90, 101, 28, "Zapłon", false, wwin)
sw1=guiCreateRadioButton(120,31,120,30,"Światła zapalone",false,wwin)
sw2=guiCreateRadioButton(120,50,120,30,"Światła zgaszone",false,wwin)
if getVehicleLightState(getPedOccupiedVehicle(getLocalPlayer()),0)=="0" then
guiRadioButtonSetSelected(sw1,true)
else
guiRadioButtonSetSelected(sw2,true)
end
 
 
addEventHandler("onClientGUIClick",wbut3,function() if isPedInVehicle(getLocalPlayer()) then
                                                        
                                                        local veh=getPedOccupiedVehicle(getLocalPlayer())
                                                        if getVehicleController ( veh) == getLocalPlayer() then
                                                        triggerServerEvent("silnikStatus",root,veh)
                                                        end end end)
                                                        
addEventHandler("onClientGUIClick",sw1,function() local veh=getPedOccupiedVehicle(getLocalPlayer())
                                                        if getVehicleController ( veh) == getLocalPlayer() then 
                                                        triggerServerEvent("swiatla",root,veh,0) end end)
                                                        
addEventHandler("onClientGUIClick",sw2,function() local veh=getPedOccupiedVehicle(getLocalPlayer())
                                                        if getVehicleController ( veh) == getLocalPlayer() then
                                                        triggerServerEvent("swiatla",root,veh,1) end end)
end
addEventHandler("onClientGUIClick",wbut1,samwinf)
addEventHandler("onClientGUIClick",wbut2,tuning)
else
    destroyElement(wwin)
 
    wenable=0
    showCursor(false)
 
    
    
end
end
bindKey("F1","up",wwine)
 
function przekazCzasSerwera()
triggerServerEvent("przekazCzasSerwera",getLocalPlayer(),getLocalPlayer())
 
end
function zmienCzas(h,m)
setTime(h,m)
end
addEvent("zmienCzas",true)
addEventHandler("zmienCzas",root,zmienCzas)