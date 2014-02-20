mysql = exports.mysql

local smallRadius = 5 --units

function givePlayerLicense(thePlayer, commandName, targetPlayerName, licenseType)
		

                local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
	
		if (ftype==2) or exports.global:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2")) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [ID lub dane] [Typ]", thePlayer, 255, 194, 14)
			outputChatBox("Typ 1 = Prawo jazdy", thePlayer, 255, 194, 14)
			outputChatBox("Typ 2 = Broń", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Gracz nie jest zalogowany.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local licenseTypeOutput = licenseType == "1" and "driver" or "weapon"
					licenseType = licenseType == "1" and "car" or "gun"
					if getElementData(targetPlayer, "license."..licenseType) == 1 then
						outputChatBox(getPlayerName(thePlayer).." posiada już licencje "..licenseTypeOutput.." .", thePlayer, 255, 255, 0)
					else
						if (licenseType == "gun") then
		                                                if (ftype==2) or exports.global:isPlayerAdmin(thePlayer) then
								exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
								mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='1' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
								
								outputChatBox("Policjant "..getPlayerName(thePlayer):gsub("_"," ").." dał tobie licencje "..licenseTypeOutput.." .", targetPlayer, 0, 255, 0)
								exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE GUN")
								local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
								if (hiddenAdmin==0) then
									local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
									exports.global:sendMessageToAdmins("Policja: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " dał " .. targetPlayerName .. " licencje na broń.")
								else
									outputChatBox("Gracz "..targetPlayerName.." teraz posiada licencje "..licenseTypeOutput.." .", thePlayer, 0, 255, 0)
								end
							else
								outputChatBox("Ne jesteś upoważniony to dawnaia licencji na broń.", thePlayer, 255, 0, 0)
							end
						else
							exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
							mysql:query_free("UPDATE characters SET "..mysql:escape_string(licenseType).."_license='1' WHERE id = "..mysql:escape_string(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							
							outputChatBox("Policjant "..getPlayerName(thePlayer):gsub("_"," ").." upoważnił cie do posiadania licencji "..licenseTypeOutput.." .", targetPlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE CAR")
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							
							if (hiddenAdmin==0) then
								local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
								exports.global:sendMessageToAdmins("Policjant " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " dał " .. targetPlayerName .. " licencje prawa jazdy.")
							else
								outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("licencja", givePlayerLicense)


-- /fingerprint
function fingerprintPlayer(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (factionType==2) then
			if not (targetPlayerNick) then
				outputChatBox("PRZYKŁAD: /" .. commandName .. " [Dane gracza/ID]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						local fingerprint = getElementData(targetPlayer, "fingerprint")
						outputChatBox(targetPlayerName .. "'s Fingerprint: " .. tostring(fingerprint) .. ".", thePlayer, 255, 194, 14)
					else
						outputChatBox("Jesteś za daleko od " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("odcisk", fingerprintPlayer, false, false)

-- /ticket
function ticketPlayer(thePlayer, commandName, targetPlayerNick, amount, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		local dutyLevel = getElementData( thePlayer, "duty")
		if dutyLevel and dutyLevel ~= 0 then
		if (factionType==2 or factionType==5) then
			if not (targetPlayerNick) or not (amount) or not (...) then
				outputChatBox("PRZYKŁAD: /" .. commandName .. " [Dane gracza/ID] [Amount] [Reason]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					
					local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
					
					if (distance<=10) then
						amount = tonumber(amount)
						local reason = table.concat({...}, " ")
						
						local money = exports.global:getMoney(targetPlayer)
						local bankmoney = getElementData(targetPlayer, "bankmoney")
						
						local takeFromCash = math.min( money, amount )
						local takeFromBank = amount - takeFromCash
						exports.global:takeMoney(targetPlayer, takeFromCash)
							
							
						-- Distribute money between the PD and Government
						local tax = exports.global:getTaxAmount()
								
						exports.global:giveMoney( theTeam, math.ceil((1-tax)*amount) )
						if factionType==2 then
							exports.global:giveMoney( getTeamFromName("Los Santos Police Department"), math.ceil(tax*amount) )
						elseif factionType==5 then
							exports.global:giveMoney( getTeamFromName("Pomoc Drogowa"), math.ceil(tax*amount) )
						end
						
						outputChatBox("Wystawiłeś mandat dla " .. targetPlayerName .. " za " .. exports.global:formatMoney(amount) .. ". Powód: " .. reason .. ".", thePlayer)
						outputChatBox("Otrzymałeś mandat wysokości " .. exports.global:formatMoney(amount) .. " od " .. getPlayerName(thePlayer) .. ". Powód: " .. reason .. ".", targetPlayer)
						if takeFromBank > 0 then
							outputChatBox("Brakuje ci pieniędzy z portfela, $" .. exports.global:formatMoney(takeFromBank) .. " zostało odebrane z twojego konta bankowego.", targetPlayer)
							exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "bankmoney", bankmoney - takeFromBank, false)
						end
						exports.logs:logMessage("[PD/TICKET] " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a ticket. Amount: $".. exports.global:formatMoney(amount).. " Reason: "..reason , 30)
					else
						outputChatBox("Jesteś za daleko od " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
					end
				end
			end
		end
		end
	end
end
addCommandHandler("mandat", ticketPlayer, false, false)

function takeLicense(thePlayer, commandName, targetPartialNick, licenseType, hours)

	local username = getPlayerName(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
	
		if (ftype==2) or exports.global:isPlayerAdmin(thePlayer) then
			if not (targetPartialNick) then
				outputChatBox("PRZYKŁAD: /" .. commandName .. " [Dane gracza/ID] [license Type 1:Driving 2:Weapon] [Hours]", thePlayer)
			else
				hours = tonumber(hours)
				if not (licenseType) or not (hours) or hours < 0 or (hours > 10 and not exports.global:isPlayerAdmin(thePlayer)) then
					outputChatBox("PRZYKŁAD: /" .. commandName .. " [Dane gracza/ID] [license Type 1:Driving 2:Weapon] [Hours]", thePlayer)
				else
					local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPartialNick)
					if targetPlayer then
						local name = getPlayerName(thePlayer)
						
						if (tonumber(licenseType)==1) then
							if(tonumber(getElementData(targetPlayer, "license.car")) == 1) then
								mysql:query_free("UPDATE characters SET car_license='" .. mysql:escape_string(-hours) .. "' WHERE id=" .. mysql:escape_string(getElementData(targetPlayer, "dbid")) .. " LIMIT 1")
								outputChatBox(name.." unieważnił twoją licencje prawa jazdy.", targetPlayer, 255, 194, 14)
								outputChatBox("Unieważniłeś licencje prawa jazdy dla " .. targetPlayerName .. "'s .", thePlayer, 255, 194, 14)
								exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "license.car", -hours, false)
								exports.logs:logMessage("[PD/TAKELICENSE] " .. name .. " usunął " .. targetPlayerName .. " their driving license for  "..hours.." hours" , 30)
							else
								outputChatBox(targetPlayerName .. " does not have a driving license.", thePlayer, 255, 0, 0)
							end
						elseif (tonumber(licenseType)==2) then
							if(tonumber(getElementData(targetPlayer, "license.gun")) == 1) then
								mysql:query_free("UPDATE characters SET gun_license='" .. mysql:escape_string(-hours) .. "' WHERE id=" .. mysql:escape_string(getElementData(targetPlayer, "dbid")) .. " LIMIT 1")
								outputChatBox(name.." unieważnił ci licencje na broń.", targetPlayer, 255, 194, 14)
								outputChatBox("Unieważniłeś " .. targetPlayerName .. "'s lcencje na broń.", thePlayer, 255, 194, 14)
								exports['antyczit']:changeProtectedElementDataEx(targetPlayer, "license.gun", -hours, false)
								exports.logs:logMessage("[PD/TAKELICENSE] " .. name .. " revoked " .. targetPlayerName .. " their gun license for  "..hours.." hours" , 30)
							else
								outputChatBox(targetPlayerName .. " does not have a weapon license.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("License type not recognised.", thePlayer, 255, 194, 14)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("odbierzlicencje", takeLicense, false, false)

function tellNearbyPlayersVehicleStrobesOn()
	for _, nearbyPlayer in ipairs(exports.global:getNearbyElements(source, "player", 300)) do
		triggerClientEvent(nearbyPlayer, "forceElementStreamIn", source)
	end
end
addEvent("forceElementStreamIn", true)
addEventHandler("forceElementStreamIn", getRootElement(), tellNearbyPlayersVehicleStrobesOn)