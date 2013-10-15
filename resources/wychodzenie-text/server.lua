--[[
Skrypt pokazujacy powody opuszczenia gry

@author Daniex0r <daniex0r@gmail.com>
@author Karer <karer.programmer@gmail.com>
@copyright 2012-2013 Daniex0r <daniex0r@gmail.com>
@license GPLv2
@package project-roleplay-rp
@link https://github.com/Daniex0r/project-roleplay-rp
]]--

local whys = {
				["Quit"]="Wyszedł z gry",
				["Kicked"]="Wyrzucony",
				["Banned"]="Zbanowany",
				["Bad Connection"]="Problem z połączeniem",
				["Timed out"]="Problem z połączeniem"
			}


addEventHandler( "onPlayerQuit", getRootElement(),
	function( why, reason )
		local name = getPlayerName( source )
		name = string.gsub( name, "_", " " )
		why = whys[why]
		if why then
			local text = name .. "\n" .. why
			if reason then
				text = name .. "\n{" .. why .. ")"
			end
			local x,y,z = getElementPosition( source )
			local t=createElement("text")
			setElementPosition(t,x, y, z)
			setElementData(t,"text",text)
			setElementData(t,"scale", 1.25)
			setTimer( destroyElement, 30000, 1, t )
		end
	end
)