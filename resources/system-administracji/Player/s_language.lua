-- Language commands
function getLanguageByName( language )
	for i = 1, call( getResourceFromName( "system-jezykow" ), "getLanguageCount" ) do
		if language:lower() == call( getResourceFromName( "system-jezykow" ), "getLanguageName", i ):lower() then
			return i
		end
	end
	return false
end

function setLanguage(thePlayer, commandName, targetPlayerName, language, skill)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not language or not tonumber( skill ) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy nick] [Język] [Skill]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Gracz nie jest zalogowany.", thePlayer, 255, 0, 0 )
			else
				local lang = tonumber( language ) or getLanguageByName( language )
				local skill = tonumber( skill )
				if not lang then
					outputChatBox( language .. " nie jest poprawnym językiem.", thePlayer, 255, 0, 0 )
				else
					local langname = call( getResourceFromName( "system-jezykow" ), "getLanguageName", lang )
					local success, reason = call( getResourceFromName( "system-jezykow" ), "learnLanguage", targetPlayer, lang, false, skill )
					if success then
						outputChatBox( targetPlayerName .. " nauczył się " .. langname .. ".", thePlayer, 0, 255, 0 )
					else
						outputChatBox( targetPlayerName .. " nie może się nauczyć " .. langname .. ": " .. tostring( reason ), thePlayer, 255, 0, 0 )
					end
					--exports.logs:logMessage("[/SETLANGUAGE] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." learned ".. targetPlayerName .. " " .. langname , 4)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETLANGUAGE "..langname.." "..tostring(skill))
				end
			end
		end
	end
end
addCommandHandler("setlanguage", setLanguage)

function deleteLanguage(thePlayer, commandName, targetPlayerName, language)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not language then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy nick] [Język]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Gracz nie jest zalogowany.", thePlayer, 255, 0, 0 )
			else
				local lang = tonumber( language ) or getLanguageByName( language )
				if not lang then
					outputChatBox( language .. " to nie jest poprawny język.", thePlayer, 255, 0, 0 )
				else
					local langname = call( getResourceFromName( "system-jezykow" ), "getLanguageName", lang )
					if call( getResourceFromName( "system-jezykow" ), "removeLanguage", targetPlayer, lang ) then
						outputChatBox( targetPlayerName .. " zapomniał " .. langname .. ".", thePlayer, 0, 255, 0 )
					else
						outputChatBox( targetPlayerName .. " nie mówi po " .. langname, thePlayer, 255, 0, 0 )
					end
				end
			end
		end
	end
end
addCommandHandler("dellanguage", deleteLanguage)
