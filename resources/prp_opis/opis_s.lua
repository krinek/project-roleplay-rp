--[[
System pod IP.BOARD, pokazuje graczy online na serwerze/forum

@author Daniex0r <daniex0r@gmail.com>
@author Bartek <>
@copyright 2012-2013 Daniex0r <daniex0r@gmail.com>
@license GPLv2
@package project-roleplay-rp
@link https://github.com/Daniex0r/project-roleplay-rp
]]--

local descs = {}

addEventHandler( "onPlayerJoin", getRootElement(),
	function()
		local s = getPlayerSerial( source )
		if descs[s] then
			setElementData( source, "v_opis", descs[s] )
		end
	end
)

addEventHandler( "onPlayerQuit", getRootElement(),
	function()
		local s = getPlayerSerial( source )
		descs[s] = getElementData( source, "v_opis" )
	end
)