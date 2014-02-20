function spawnPojazdu(player,auto)
local veh=getVehicleModelFromName(auto)
local x,y,z=getElementPosition(player)
local a,b,c=getElementRotation(player)
    if isPedInVehicle(player) then
        destroyElement(getPedOccupiedVehicle(player))
        local pojazd=createVehicle(veh,x,y,z,a,b,c,"STWORZ")
        warpPedIntoVehicle(player,pojazd)
    else
        local pojazd=createVehicle(veh,x,y,z,a,b,c,"STWORZ")
        warpPedIntoVehicle(player,pojazd)
    end
outputChatBox("Stworzyłeś: "..auto.." ! ",player,0,255,0)
end
addEvent("spawnPojazdu",true)
addEventHandler("spawnPojazdu",root,spawnPojazdu)
 
 
function dodajPart(player,auto,part)
addVehicleUpgrade(auto,part)
 
end
addEvent("dodajPart",true)
addEventHandler("dodajPart",root,dodajPart)
 
 
 
function zmienKolorAuta(veh,r,g,b,z,x,c)
setVehicleColor(veh,r/100*255,g/100*255,b/100*255,z/100*255,x/100*255,c/100*255)
end
addEvent("zmienKolorAuta",true)
addEventHandler("zmienKolorAuta",root,zmienKolorAuta)
 
function zmienKolorSwiatelAuta(veh,r,g,b)
setVehicleHeadLightColor(veh,r/100*255,g/100*255,b/100*255)
 
end
addEvent("zmienKolorSwiatelAuta",true)
addEventHandler("zmienKolorSwiatelAuta",root,zmienKolorSwiatelAuta)
 
 
 
function swiatla(veh,status)
if status==0 then
    setVehicleLightState(veh,0,0)
    setVehicleLightState(veh,1,0)
    setVehicleLightState(veh,2,0)
    setVehicleLightState(veh,3,0) 
else
    setVehicleLightState(veh,0,1)
    setVehicleLightState(veh,1,1)
    setVehicleLightState(veh,2,1)
    setVehicleLightState(veh,3,1) 
end
end
addEvent("swiatla",true)
addEventHandler("swiatla",root,swiatla)
 
function silnikStatus(veh)
local status = getVehicleEngineState(veh)
setVehicleEngineState(veh , not status)
end
addEvent("silnikStatus",true)
addEventHandler("silnikStatus",root,silnikStatus)
 
function usunDodatki(veh)
local dodatki=getVehicleUpgrades(veh)
 
for i,dodatek in ipairs (dodatki) do
removeVehicleUpgrade(veh,dodatek)
end
end
addEvent("usunDodatki",true)
addEventHandler("usunDodatki",root,usunDodatki)
 
function czas(player)
local h,m=getTime()
triggerClientEvent(player,"zmienCzas",player,h,m)
end
addEvent("przekazCzas",true)
addEventHandler("przekazCzas",root,czas)