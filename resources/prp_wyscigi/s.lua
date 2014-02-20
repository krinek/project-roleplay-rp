function getPlayerFromNamePart(name)
    if name then 
        for i, player in ipairs(getElementsByType("player")) do
            if string.find(getPlayerName(player):lower(), tostring(name):lower(), 1, true) then
                return player 
            end
        end
    end
    return false
end
addCommandHandler( "rcd",
	function( src, cmd, ... )
		local args = {...}
		for o,v in ipairs(args) do
			local ppl = getPlayerFromNamePart(v)
			if ppl then
				triggerClientEvent( ppl, "startCoundownRace", ppl )
			end
		end
		triggerClientEvent( src, "startCoundownRace", src )
	end
)