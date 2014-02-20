marker2 = createMarker(609.169921875, -74.11328125, 997.9921875, "arrow", 0, 20, 2, 2)
setElementInterior ( marker2, 2)
setElementDimension ( marker2, 243 )
function teleport(hitElement, dim)
if getElementType(hitElement)=="player" and source == marker2 then
local vehicle = getPedOccupiedVehicle(hitElement)
if vehicle then
local seat = getPedOccupiedVehicleSeat(hitElement)
setElementDimension ( hitElement, 0 )
setElementDimension ( vehicle, 0 )
setElementInterior ( hitElement, 0)
setElementInterior ( vehicle, 0 )
setElementPosition(hitElement, 1272.46484375, -1811.8994140625, 13.385084152222)
setElementPosition(vehicle, 1272.46484375, -1811.8994140625, 13.385084152222)
warpPedIntoVehicle(hitElement, vehicle, seat)
end
end
end
addEventHandler("onMarkerHit", getRootElement(), teleport) 
