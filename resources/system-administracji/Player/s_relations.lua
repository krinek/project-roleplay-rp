function marry(thePlayer, commandName, player1, player2)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		if not player1 or not player2 then
			outputChatBox( "PRZYKŁAD: /" .. commandName .. " [Gracz] [Gracz]", thePlayer, 255, 194, 14 )
		else
			local player1, player1name = exports.global:findPlayerByPartialNick( thePlayer, player1 )
			if player1 then
				local player2, player2name = exports.global:findPlayerByPartialNick( thePlayer, player2 )
				if player2 then
					-- check if one of the players is already married
					local p1r = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM characters WHERE marriedto = " .. mysql:escape_string(getElementData( player1, "dbid" )) )
					if p1r then
						if tonumber( p1r["numbr"] ) == 0 then
							local p2r = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM characters WHERE marriedto = " .. mysql:escape_string(getElementData( player2, "dbid" )) )
							if p2r then
								if tonumber( p2r["numbr"] ) == 0 then
									mysql:query_free("UPDATE characters SET marriedto = " .. mysql:escape_string(getElementData( player1, "dbid" )) .. " WHERE id = " .. mysql:escape_string(getElementData( player2, "dbid" )) )
									mysql:query_free("UPDATE characters SET marriedto = " .. mysql:escape_string(getElementData( player2, "dbid" )) .. " WHERE id = " .. mysql:escape_string(getElementData( player1, "dbid" )) ) 
									
									outputChatBox( "Ożeniłeś/aś się z  " .. player2name .. ".", player1, 0, 255, 0 )
									outputChatBox( "Ożeniłeś/aś się z " .. player1name .. ".", player2, 0, 255, 0 )
									
									exports['cache']:clearCharacterName( getElementData( player1, "dbid" ) )
									exports['cache']:clearCharacterName( getElementData( player2, "dbid" ) )
									
									outputChatBox( player1name .. " oraz " .. player2name .. " zostali małżeństwem.", thePlayer, 255, 194, 14 )
								else
									outputChatBox( player2name .. " obecnie jest żonaty.", thePlayer, 255, 0, 0 )
								end
							end
						else
							outputChatBox( player1name .. " is already married.", thePlayer, 255, 0, 0 )
						end
					end
				end
			end
		end
	end
end
addCommandHandler("slub", marry)

function divorce(thePlayer, commandName, targetPlayer)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		if not targetPlayer then
			outputChatBox( "PRZYKŁAD: /" .. commandName .. " [Gracz]", thePlayer, 255, 194, 14 )
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayer )
			if targetPlayer then
				local marriedto = mysql:query_fetch_assoc("SELECT marriedto FROM characters WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
				if marriedto then
					local to = tonumber( marriedto["marriedto"] )
					if to > 0 then
						mysql:query_free("UPDATE characters SET marriedto = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						mysql:query_free("UPDATE characters SET marriedto = 0 WHERE marriedto = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
						
						exports['cache']:clearCharacterName( getElementData( targetPlayer, "dbid" ) )
						exports['cache']:clearCharacterName( to )
						
						outputChatBox( targetPlayerName .. " rozwiedli sie.", thePlayer, 0, 255, 0 )
					else
						outputChatBox( targetPlayerName .. " nie jest z nikim", thePlayer, 255, 194, 14 )
					end
				end
			end
		end
	end
end
addCommandHandler("rozwod", divorce)