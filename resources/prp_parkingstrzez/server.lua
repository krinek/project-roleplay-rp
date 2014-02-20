x, y, size = 1437.9935302734,  -1724.6558837891, 120
local greenzone = createColRectangle ( 1437.9935302734,  -1724.6558837891, 86, 127.22 )
--local greenzonemaparea = createRadarArea (1389.7451171875, -1705.671875, 40, 40.22, 0, 255, 0, 120)
 
function greenzoneEnter ( thePlayer, matchingDimension )
    if getElementType( thePlayer ) ~= "player" then return end
    triggerClientEvent(thePlayer, "zoneEnter", thePlayer)
    toggleControl ( thePlayer, "fire", false )
    toggleControl ( thePlayer, "next_weapon", false )
    toggleControl ( thePlayer, "previous_weapon", false )
    setPedWeaponSlot ( thePlayer, 0 )
    toggleControl ( thePlayer, "aim_weapon", false )
    toggleControl ( thePlayer, "vehicle_fire", false )
    toggleControl ( thePlayer, "vehicle_secondary_fire", false )
end
addEventHandler ( "onColShapeHit", greenzone, greenzoneEnter )
 
function greenzoneExit ( thePlayer, matchingDimension )
    if getElementType( thePlayer ) ~= "player" then return end
    triggerClientEvent(thePlayer, "zoneExit", thePlayer)
    toggleControl ( thePlayer, "fire", true )
    toggleControl ( thePlayer, "next_weapon", true )
    toggleControl ( thePlayer, "previous_weapon", true )
    toggleControl ( thePlayer, "aim_weapon", true )
    toggleControl ( thePlayer, "vehicle_fire", true )
    toggleControl ( thePlayer, "vehicle_secondary_fire", true )
end
addEventHandler ( "onColShapeLeave", greenzone, greenzoneExit )


