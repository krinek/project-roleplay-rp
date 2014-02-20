marker = createMarker(1277.8544921875, -1800.9716796875, 13.386547088623, "corona", 0, 20, 2, 1)
setElementInterior ( marker, 0)
setElementDimension ( marker, 0 )
function teleport(hitElement, dim)
if getElementType(hitElement)=="player" and source==marker then
local vehicle = getPedOccupiedVehicle(hitElement)
if vehicle then
local seat = getPedOccupiedVehicleSeat(hitElement)
setElementDimension ( hitElement, 243 )
setElementDimension ( vehicle, 243 )
setElementInterior ( hitElement, 2)
setElementInterior ( vehicle, 2)
setElementPosition(hitElement, 616.0283203125, -73.8916015625, 997.9921875)
setElementPosition(vehicle, 616.0283203125, -73.8916015625, 997.9921875)
setElementFrozen(vehicle, true)
setTimer(setElementFrozen, 5000,1,vehicle,false)
warpPedIntoVehicle(hitElement, vehicle, seat)
end
end
end
addEventHandler("onMarkerHit", getRootElement(), teleport)  