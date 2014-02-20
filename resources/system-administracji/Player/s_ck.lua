
-- /CK
function ckPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy nick / ID] [Przyczyna Zgonu]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					info = table.concat({...}, " ")
					local query = mysql:query_free("UPDATE characters SET cked='1', ck_info='" .. mysql:escape_string(tostring(info)) .. "' WHERE id = " .. mysql:escape_string(getElementData(targetPlayer, "dbid")))
					
					local x, y, z = getElementPosition(targetPlayer)
					local skin = getPedSkin(targetPlayer)
					local rotation = getPedRotation(targetPlayer)
					
					call( getResourceFromName( "system-real" ), "addCharacterKillBody", x, y, z, rotation, skin, getElementData(targetPlayer, "dbid"), targetPlayerName, getElementInterior(targetPlayer), getElementDimension(targetPlayer), getElementData(targetPlayer, "age"), getElementData(targetPlayer, "race"), getElementData(targetPlayer, "weight"), getElementData(targetPlayer, "height"), getElementData(targetPlayer, "chardescription"), info, getElementData(targetPlayer, "gender"))
					
					-- send back to change char screen
					local id = getElementData(targetPlayer, "account:id")
					showCursor(targetPlayer, false)
					triggerEvent("accounts:characters:change", targetPlayer, "Change Character")
					exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "loggedin", 0, false)
					outputChatBox("Twoja postać dostała CK od " .. getPlayerName(thePlayer) .. ".", targetPlayer, 255, 194, 14)
					showChat(targetPlayer, false)
					outputChatBox("Dostałeś CK ".. targetPlayerName ..".", thePlayer, 255, 194, 1, 14)
					--exports.logs:logMessage("[/CK] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." CK'ED ".. targetPlayerName , 4)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "CK powód: "..mysql:escape_string(tostring(info)))
					exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "dbid", 0, false)
					local port = getServerPort()
					local password = getServerPassword()
						
					redirectPlayer(targetPlayer)
				end
			end
		end
	end
end
addCommandHandler("ck", ckPlayer)

-- /UNCK
function unckPlayer(thePlayer, commandName, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Imię Nazwisko]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = mysql:query("SELECT id FROM characters WHERE charactername='" .. mysql:escape_string(tostring(targetPlayer)) .. "' AND cked > 0")
			
			if (mysql:num_rows(result)>1) then
				outputChatBox("Zbyt wiele podobnych - Wprowadź dokładniejsze Imię.", thePlayer, 255, 0, 0)
			elseif (mysql:num_rows(result)==0) then
				outputChatBox("Gracz nie istnieje, lub nie ma CK.", thePlayer, 255, 0, 0)
			else
				local row = mysql:fetch_assoc(result)
				local dbid = tonumber(row["id"]) or 0
				mysql:query_free("UPDATE characters SET cked='0' WHERE id = " .. dbid .. " LIMIT 1")
				
				-- delete all peds for him
				for key, value in pairs( getElementsByType( "ped" ) ) do
					if isElement( value ) and getElementData( value, "ckid" ) then
						if getElementData( value, "ckid" ) == dbid then
							destroyElement( value )
						end
					end
				end
				
				outputChatBox(targetPlayer .. " is no longer CK'ed.", thePlayer, 0, 255, 0)
				--exports.logs:logMessage("[/UNCK] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." UNCK'ED ".. targetPlayer , 4)
				exports.logs:dbLog(thePlayer, 4, "ch"..row["id"], "UNCK")
			end
			mysql:free_result(result)
		end
	end
end
addCommandHandler("unck", unckPlayer)

-- /POGRZEB
function buryPlayer(thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Imię Nazwisko]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = mysql:query("SELECT id, cked FROM characters WHERE charactername='" .. mysql:escape_string(tostring(targetPlayer)) .. "'")
			
			if (mysql:num_rows(result)>1) then
				outputChatBox("Zbyt wiele wyników - Wprowadź dokładniejsze imię.", thePlayer, 255, 0, 0)
			elseif (mysql:num_rows(result)==0) then
				outputChatBox("Gracz nie istnieje.", thePlayer, 255, 0, 0)
			else
				local row = mysql:fetch_assoc(result)
				local dbid = tonumber(row["id"]) or 0
				local cked = tonumber(row["cked"]) or 0
				if cked == 0 then
					outputChatBox("Gracz nie ma CK.", thePlayer, 255, 0, 0)
				elseif cked == 2 then
					outputChatBox("Gracz jest już pogrzebany.", thePlayer, 255, 0, 0)
				else
					mysql:query_free("UPDATE characters SET cked='2' WHERE id = " .. dbid .. " LIMIT 1")
					
					-- delete all peds for him
					for key, value in pairs( getElementsByType( "ped" ) ) do
						if isElement( value ) and getElementData( value, "ckid" ) then
							if getElementData( value, "ckid" ) == dbid then
								destroyElement( value )
							end
						end
					end
					
					outputChatBox(targetPlayer .. " został pogrzebany.", thePlayer, 0, 255, 0)
					exports.logs:logMessage("[/POGRZEB] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." pogrzebany ".. targetPlayer , 4)
					exports.logs:dbLog(thePlayer, 4, "ch"..row["id"], "CK-BURY")
				end
			end
			mysql:free_result(result)
		end
	end
end
addCommandHandler("bury", buryPlayer)