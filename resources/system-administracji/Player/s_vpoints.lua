function givevPoint(thePlayer, commandName, targetPlayer, vPoints, ...)
	if exports.global:isPlayerHeadAdmin(thePlayer) then
		if (not targetPlayer or not vPoints or not (...)) then
			outputChatBox("Przykład: /" .. commandName .. " [gracz] [Punkty] [Powód]", thePlayer, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if (tplayer) then
				local loggedIn = getElementData(tplayer, "loggedin")
				if loggedIn == 1 then
					if (tonumber(vPoints) < 120) then
						local reasonStr = table.concat({...}, " ")
						local accountID = getElementData(tplayer, "account:id")
						triggerClientEvent(tplayer, "onPlayerGetAchievement", thePlayer, "Doładowanie!", "Doładowanie konta!", "Zakupiłeś właśnie punkty na grze w MTA:SA , notatka administratora: \n" .. reasonStr, vPoints)
						mysql:query_free("UPDATE `accounts` SET `credits`=`credits`+".. tostring(vPoints) .." WHERE `id`=".. tostring(accountID)  .."")
						setElementData(tplayer, "account:credits",tonumber(getElementData(tplayer,"account:credits") or 0)+vPoints)
						exports.logs:dbLog(thePlayer, 26, tplayer, "GIVEVPOINTS "..tostring(vPoints).." "..reasonStr)
						outputChatBox("Dałeś "..targetPlayerName.." "..vPoints.." Punktów , twoja notatka: ".. reasonStr, thePlayer)
						mysql:query_free('INSERT INTO adminhistory (user_char, user, admin_char, admin, hiddenadmin, action, duration, reason) VALUES ("' .. mysql:escape_string(getPlayerName(tplayer)) .. '",' .. mysql:escape_string(tostring(getElementData(tplayer, "account:id") or 0)) .. ',"' .. mysql:escape_string(getPlayerName(thePlayer)) .. '",' .. mysql:escape_string(tostring(getElementData(thePlayer, "account:id") or 0)) .. ',0,6,'.. vPoints ..',"' .. mysql:escape_string(vPoints .. " Notatka admina: " .. reasonStr) .. '")' )
					else
						outputChatBox("Max 3 punkty.", thePlayer)
					end
				else
					outputChatBox("This player is not logged in.", thePlayer)
				end
			else
				outputChatBox("Something went wrong with picking the player.", thePlayer)
			end
		end
	end
end
addCommandHandler("punkty", givevPoint)