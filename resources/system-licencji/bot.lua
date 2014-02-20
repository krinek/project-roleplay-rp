local BOT = createPed(22, 356.296875, 181.671875, 1008.3762207031)
setPedRotation(BOT, 268.74)
setElementDimension(BOT, 6)
setElementInterior(BOT, 3)
local kutach = createMarker( 358.875, 181.796875, 1007.5, "cylinder", 1 )
setElementDimension(kutach, 6)
setElementInterior(kutach, 3)

 
 
 
function MarkerHit ( thePlayer, matchingDimension )
	if not matchingDimension then return end

	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	if factionType == -1 or not factionType then
		local day = getRealTime().monthday
		local clientAccountID = getElementData(thePlayer, "account:id") or -1
		local result = mysql:query_fetch_assoc("SELECT kasabezdomny FROM characters WHERE account='" .. mysql:escape_string(tostring(clientAccountID)) .. "' AND `active` = 1")
		if result and result.kasabezdomny then
			if tostring(result.kasabezdomny) == tostring(day) then
				exports.info:showBox (thePlayer,"info","Dziś wybrałeś już należny ci zasiłek!")
			else
				exports.global:giveMoney( thePlayer, 100 )
				mysql:query_free("UPDATE characters SET kasabezdomny='"..day.."' WHERE account='" .. mysql:escape_string(tostring(clientAccountID)) .. "' AND `active` = 1")
				exports.info:showBox (thePlayer,"info","Pobrałeś 100$ zasiłku dla bezrobotnych, pamiętaj że zasiłek przysługuje ci raz na dzień!")
			end
		end
	else
		exports.info:showBox (thePlayer,"info","Posiadasz prace, nie przysługuje ci zasiłek dla bezrobotnych.")
	end
end
addEventHandler ( "onMarkerHit" ,kutach, MarkerHit )