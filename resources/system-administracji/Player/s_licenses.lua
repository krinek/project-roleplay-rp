
--give player license
function givePlayerLicense(thePlayer, commandName, targetPlayerName, licenseType)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2")) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy nick] [Typ]", thePlayer, 255, 194, 14)
			outputChatBox("Type 1 = Prawo jazdy", thePlayer, 255, 194, 14)
			outputChatBox("Type 2 = Broń", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local licenseTypeOutput = licenseType == "1" and "prawo jazdy" or "broń"
					licenseType = licenseType == "1" and "car" or "gun"
					if getElementData(targetPlayer, "license."..licenseType) == 1 then
						outputChatBox(getPlayerName(thePlayer).." posiada teraz licencje na"..licenseTypeOutput.." .", thePlayer, 255, 255, 0)
					else
						if (licenseType == "gun") then
							if exports.global:isPlayerSuperAdmin(thePlayer) then
								exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
								mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='1' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
								
								outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." dał ci licencje na "..licenseTypeOutput.." .", targetPlayer, 0, 255, 0)
								exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE GUN")
								local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
								if (hiddenAdmin==0) then
									local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
									exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " dał " .. targetPlayerName .. " licencje na broń.")
								else
									outputChatBox("Gracz "..targetPlayerName.." ma teraz licencje na "..licenseTypeOutput.." .", thePlayer, 0, 255, 0)
								end
							else
								outputChatBox("Nie masz uprwnień by dawać licencje.", thePlayer, 255, 0, 0)
							end
						else
							exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='1' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." dał ci licencję na "..licenseTypeOutput.." .", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE CAR")
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " dał " .. targetPlayerName .. " prawo jazdy.")
							else
								outputChatBox("Gracz "..targetPlayerName.." ma teraz licencje na "..licenseTypeOutput.." .", thePlayer, 0, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("agivelicense", givePlayerLicense)


--take player license
function takePlayerLicense(thePlayer, commandName, dtargetPlayerName, licenseType)
	if exports.global:isPlayerSuperAdmin(thePlayer) then
		if not dtargetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2")) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Częściowy nick] [Typ]", thePlayer, 255, 194, 14)
			outputChatBox("Type 1 = Prawo Jazdy", thePlayer, 255, 194, 14)
			outputChatBox("Type 2 = Broń", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(nil, dtargetPlayerName)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local licenseTypeOutput = licenseType == "1" and "prawo jazdy" or "broń"
					licenseType = licenseType == "1" and "car" or "gun"
					if getElementData(targetPlayer, "license."..licenseType) == 0 then
						outputChatBox(getPlayerName(thePlayer).." nie ma licencji na "..licenseTypeOutput.." .", thePlayer, 255, 255, 0)
					else
						if (licenseType == "gun") then
							exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='0' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							--outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." zarekwirował ci licencje na "..licenseTypeOutput.." .", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE GUN")
							
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " zabrał " .. targetPlayerName .. " jego licencje na ".. licenseType .." .")
							else
								outputChatBox("Gracz "..targetPlayerName.." now  has his  "..licenseType.." license revoked.", thePlayer, 0, 255, 0)
							end
						else
							exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='0' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							outputChatBox("Gracz "..targetPlayerName.." posiada teraz licencje na "..licenseTypeOutput.." .", thePlayer, 0, 255, 0)
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." zabrał ci licencje na "..licenseTypeOutput.." .", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE CAR")
							
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " zabrał " .. targetPlayerName .. " jego licencje na ".. licenseType .." .")
							else
								outputChatBox("Gracz "..targetPlayerName.." stracił licencję na  "..licenseType.." .", thePlayer, 0, 255, 0)
							end
						end
					end
				end
			else
				local resultSet = mysql:query_fetch_assoc("SELECT `id`,`car_license`,`gun_license` FROM `characters` where `charactername`='"..mysql:escape_string(dtargetPlayerName).."'")
				if resultSet then
					licenseType = licenseType == "1" and "car" or "gun"
					if (tonumber(resultSet[licenseType.."_license"]) ~= 0) then
						local resultQry = mysql:query_free("UPDATE `characters` SET `"..licenseType.."_license`=0 WHERE `charactername`='"..mysql:escape_string(dtargetPlayerName).."'")
						if (resultQry) then
							exports.logs:dbLog(thePlayer, 4, { "ch"..resultSet["id"] }, "TAKELICENSE "..licenseType)
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " zabrał " .. dtargetPlayerName .. " jego licencje na ".. licenseType .." .")
							else
								outputChatBox("Gracz "..dtargetPlayerName.." stracił licencję na  "..licenseType.." .", thePlayer, 0, 255, 0)
							end
						else
							outputChatBox("Ooo Kurwa, coś poszło nie tak!..", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Ten gracz nie ma takiej licencji.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("Nie znaleziono gracza.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("atakelicense", takePlayerLicense)
