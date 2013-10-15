--[[
Skrypt pracy dorywczej

@author Daniex0r <daniex0r@gmail.com>
@author Karer <karer.programmer@gmail.com>
@copyright 2012-2013 Daniex0r <daniex0r@gmail.com>
@license GPLv2
@package project-roleplay-rp
@link https://github.com/Daniex0r/project-roleplay-rp
]]--

mysql = exports.mysql

local bot_marker = createMarker( 358.5947265625, 187.798828125, 1008.3828125 - 0.8, "cylinder", 1, 255, 255, 0, 128 )
local bot_ped = createPed(150, 356.2958984375, 187.7431640625, 1008.3762207031)
setPedRotation(bot_ped, 268.74)
local SQL_TABLE = "pracedorywcze"
setElementDimension(bot_marker, 6)
setElementInterior(bot_marker, 3)
setElementDimension(bot_ped, 6)
setElementInterior(bot_ped, 3)

addEventHandler( "onMarkerHit", bot_marker,
	function( thePlayer, dimension )
		if not dimension then return end
		if getElementType(thePlayer) ~= "player" then return end
		local clientAccountID = getElementData(thePlayer, "account:id") or -1
		local result = mysql:query_fetch_assoc("SELECT "..SQL_TABLE.." FROM characters WHERE account='" .. mysql:escape_string(tostring(clientAccountID)) .. "' AND `active` = 1")
		if result and result[SQL_TABLE] then
			if tonumber(result[SQL_TABLE]) then
				if tonumber(result[SQL_TABLE]) == 0 then
					exports.info:showBox (thePlayer,"info","Nie możesz odbrać pieniędzy bez wykonania pracy dorywczej")
				else
					exports.global:giveMoney( thePlayer, tonumber(result[SQL_TABLE]) )
					mysql:query_free("UPDATE characters SET "..SQL_TABLE.."='0' WHERE account='" .. mysql:escape_string(tostring(clientAccountID)) .. "' AND `active` = 1")
					exports.info:showBox (thePlayer,"info","Otrzymaleś $"..tonumber(result[SQL_TABLE]).." za wykonaną prace.")
				end
			end
		end
		
	end
)