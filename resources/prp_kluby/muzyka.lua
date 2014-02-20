local D=1
local I=17

local nazewnatrz=playSound3D("audio/muzyka.ogg", 1837.03,-1682.26,13.32,true)
setSoundVolume(nazewnatrz,0.2)
setSoundMaxDistance(nazewnatrz,60)


local naglosnienie=playSound3D("http://www.bassdrive.com/v2/streams/BassDrive6.pls",487.92,-14.14,1000.67,true)
--local naglosnienie=playSound3D("audiodump.ogg",898.42,2511.23,1055.26,true)
setElementInterior(naglosnienie,I)
setElementDimension(naglosnienie,D)
setSoundMinDistance(naglosnienie,45)
setSoundMaxDistance(naglosnienie,100)
setSoundVolume(naglosnienie,200)



local tancerka=createPed(246,937.54,2498.62,1054.83,132.3,false)
setElementDimension(tancerka,D)
setElementInterior(tancerka,I)
setElementFrozen(tancerka, true)
setElementData(tancerka, "npc", true)
--setPedAnimation ( tancerka, "STRIP", "strip_G", -1, true, false )
setPedAnimation ( tancerka, "STRIP", "STR_C2", -1, true, false )