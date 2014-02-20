function isNumberAHotline(theNumber)
	local challengeNumber = tonumber(theNumber)
	return challengeNumber == 911 or challengeNumber == 311 or challengeNumber == 411 or challengeNumber == 511  or challengeNumber == 611 or challengeNumber == 921 or challengeNumber == 1501 or challengeNumber == 1502 or challengeNumber == 8294 or challengeNumber == 7331 or challengeNumber == 7332 or challengeNumber == 864
end

function routeHotlineCall(callingElement, callingPhoneNumber, outboundPhoneNumber, startingCall, message)
	local callprogress = getElementData(callingElement, "callprogress")
	if callingPhoneNumber == 911 then
		-- 911: Emergency Services and Police.
		-- Emergency calls that they need to respond to.
		if startingCall then
			outputChatBox("911 Operator [telefon]:  Podaj miejsce swojego przebywania.", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("911 Operator [telefon]: Czy mozna prosic o opis sytuacji?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("911 Operator [telefon]: Dziękujemy za głoszenie poiadomiliśmy juz odpowiednie jednostki o sytuacji!.", callingElement)
				local location = getElementData(callingElement, "call.location")
						

				local playerStack = { } 
				
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Police Department" ) ) ) do
					table.insert(playerStack, value)
				end
				
                                for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Pomoc Drogowa" ) ) ) do
					table.insert(playerStack, value)
				end
			
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Medical Services" ) ) ) do
					table.insert(playerStack, value)
				end
				
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Fire Department" ) ) ) do
					table.insert(playerStack, value)
				end
				
				local affectedElements = { }
									
				for key, value in ipairs( playerStack ) do
					for _, itemRow in ipairs(exports['system-przedmiotow']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end
				
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] Do wszystkich pobliskich jednostek jest wezwanie z numeru #" .. outboundPhoneNumber .. ", Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] Sytuacja: '" .. message .. "', Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] Miejsce sytuacji: '" .. tostring(location) .. "', Out.", value, 0, 183, 239)
				end
				
				executeCommandHandler( "hangup", callingElement )
			end
		end
	elseif callingPhoneNumber == 311 then
		if startingCall then
			outputChatBox("LSPD Operator [telefon]: Linia Policji. Prosze podać miejsce przebywania.", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("LSPD Operator [telefon]: Czy możesz opisać zaistniałą sytuację??", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("LSPD Operator [telefon]: Dziękujemy za zgłoszenie , jednostki zostaną wysłane w miare możliwości.", callingElement)
				local location = getElementData(callingElement, "call.location")
		
				local affectedElements = { }
									
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Police Department" ) ) ) do
					for _, itemRow in ipairs(exports['system-przedmiotow']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end
		
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] Otrzymaliśmy raport z numeru #" .. outboundPhoneNumber .. " via the non-emergency line, Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Powód: '" .. message .. "', Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Miejsce: '" .. tostring(location) .. "', Out.", value, 245, 40, 135)
				end
				executeCommandHandler( "hangup", callingElement )
			end
		end
	elseif callingPhoneNumber == 411 then
		if startingCall then
			outputChatBox("Operator [telefon]: Linia pogotowia , podaj swoją pozycje.", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("Operator [Cellphone]: Czy możesz podac przyczyne dzwonienia?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Dziękujemy za zgłoszenie , nie ruszaj sie z miejsca!.", callingElement)			
				local location = getElementData(callingElement, "call.location")
				
				local affectedElements = { }
									
				for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Services") ) ) do
					for _, itemRow in ipairs(exports['system-przedmiotow']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end				
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] Zgłoszono sytuacje z numeru #" .. outboundPhoneNumber .. " via the non-emergency line, Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Powód: '" .. message .. "', Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Miejsce: '" .. tostring(location) .. "', Out.", value, 245, 40, 135)
				end
				executeCommandHandler( "hangup", callingElement )
			end		
		end
	elseif callingPhoneNumber == 511 then
		if startingCall then
			outputChatBox("Operator [Cellphone]: State Police Info-crime. Please State your name.", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("Operator [Cellphone]: Please state the message you want to pass to our investigators.", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Thank you, we will contact you in the shortest delays.", callingElement)			
				local location = getElementData(callingElement, "call.location")
								
				local affectedElements = { }
									
				for key, value in ipairs( getPlayersInTeam( getTeamFromName("State Police") ) ) do
					for _, itemRow in ipairs(exports['system-przedmiotow']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end		
								
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got a report over 511, Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Situation: '" .. message .. "', Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Name: '" .. tostring(location) .. "', Ph: "..outboundPhoneNumber..", Out.", value, 245, 40, 135)
				end
				executeCommandHandler( "hangup", callingElement )
			end		
		end
	elseif callingPhoneNumber == 611 then
		if startingCall then
			outputChatBox("Operator [Cellphone]: Los Santos Fire Department Hotline. Please state your location.", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("Operator [Cellphone]: Can you please tell us the reason for your call and your phonenumber?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Thanks for your call, we'll get to you soon.", callingElement)			
				local location = getElementData(callingElement, "call.location")
					
				local affectedElements = { }
									
				for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Fire Department") ) ) do
					for _, itemRow in ipairs(exports['system-przedmiotow']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end	
					
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] Wezwanie z numeru #" .. outboundPhoneNumber .. " via the non-emergency line, Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Opis: '" .. message .. "', Over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Miejsce: '" .. tostring(location) .. "', Out.", value, 245, 40, 135)
				end
				executeCommandHandler( "hangup", callingElement )
			end		
		end
	elseif callingPhoneNumber == 921 then
		if startingCall then
			outputChatBox("Operator [Telefon]: Biuro pomocy drogowej podaj swoją lokacje.", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "call.location", message)
				exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 2)
				outputChatBox("Operator [Cellphone]: Czy możesz pisać sytuacje?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Dziękujemy za zgłoszenie , wyślemy odpowiednie jednostki.", callingElement)
				local location = getElementData(callingElement, "call.location")
						
				local affectedElements = { }
						
				for key, value in ipairs( getPlayersInTeam( getTeamFromName("Pomoc Drogowa") ) ) do
					for _, itemRow in ipairs(exports['system-przedmiotow']:getItems(value)) do 
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end	
						
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] Otrzymane wezwanie z numeru #" .. outboundPhoneNumber .. ", Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] Sytuacja: '" .. message .. "', Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] Lokacja: '" .. tostring(location) .. "', Out.", value, 0, 183, 239)
				end
				executeCommandHandler( "hangup", callingElement )
			end		
		end
	elseif callingPhoneNumber == 1501 then
		if (publicphone) then
			outputChatBox("Computer voice [Cellphone]: This service is not available on this phone.", callingElement)
		else
			outputChatBox("Computer voice [Cellphone]: You are now calling with a secret number.", callingElement)
			mysql:query_free( "UPDATE `phone_settings` SET `secretnumber`='1' WHERE `phonenumber`='".. mysql:escape_string(tostring(outboundPhoneNumber)) .."'")
			--exports['antyczit']:changeProtectedElementDataEx(callingElement,"cellphone.secret",1, false)
		end
		executeCommandHandler( "hangup", callingElement )
	elseif callingPhoneNumber == 1502 then
		if (publicphone) then
			outputChatBox("Computer voice [Cellphone]: This service is not available on this phone.", callingElement)
		else
			outputChatBox("Computer voice [Cellphone]: You are now calling with a normal number.", callingElement)
			mysql:query_free( "UPDATE `phone_settings` SET `secretnumber`='0' WHERE `phonenumber`='".. mysql:escape_string(tostring(outboundPhoneNumber)) .."'")
			--exports['antyczit']:changeProtectedElementDataEx(callingElement,"cellphone.secret",0, false)
		end
		executeCommandHandler( "hangup", callingElement )
	elseif callingPhoneNumber == 8294 then
		if startingCall then
			outputChatBox("Taxi Operator [Telefon]: Biuro taksówek ,podaj miejsce gdzie mamy przyjechać", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local founddriver = false
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local job = getElementData(value, "job")						
				if (job == 2) then
					local car = getPedOccupiedVehicle(value)
					if car and (getElementModel(car)==438 or getElementModel(car)==420) then
						outputChatBox("[New Fare] " .. getPlayerName(callingElement):gsub("_"," ") .." Ph:" .. outboundPhoneNumber .. " Location: " .. message .."." , value, 0, 183, 239)
						founddriver = true
					end
				end
			end
								
			if founddriver == true then
				outputChatBox("Taxi Operator [Cellphone]: Dziękujemy za wezwanie , postaramy sie wysłać taksówke w to miejsce.", callingElement)
			else
				outputChatBox("Taxi Operator [Cellphone]: Obecnie brak taksówkarzy na bazie , zadzwoń za chwilkę.", callingElement)
			end
			executeCommandHandler( "hangup", callingElement )
		end
	elseif callingPhoneNumber == 7331 then -- SAN Ads
		if startingCall then
			outputChatBox("Pracownik SNA [Telefon] Dziękujemy że dzwonisz! Co chciałbyś ogłosić?.", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("Pracownik SNA[Telefon]: Err.. Sorry.Obecnie zbyt dużo nadajemy. Zadzwoń z 5 minut.", callingElement)
				executeCommandHandler( "hangup", callingElement )	
				return
			end
			if getElementData(callingElement, "alcohollevel") and getElementData(callingElement, "alcohollevel") ~= 0 then
				outputChatBox("Pracownik SNA [Telefon]: Chyba sie upiłeś , nie przyjmujemy pijanych zgłoszeń!", callingElement)
				executeCommandHandler( "hangup", callingElement )	
				return
			end
			if (getElementData(callingElement, "ads") or 0) >= 2 then
				outputChatBox("Pracownik SNA [Telefon]: Znowu ty? Możemy maksymalnie wystawić dziennie 2 adverty od jednej osoby.", callingElement)	
				executeCommandHandler( "hangup", callingElement )					
				return
			end
				
			if message:sub(-1) ~= "." and message:sub(-1) ~= "?" and message:sub(-1) ~= "!" then
				message = message .. "."
			end

			local cost = math.ceil(string.len(message)/5) + 10
			if not exports.global:takeMoney(callingElement, cost) then
				outputChatBox("Pracownik SNA [Telefon]: Err.. Sorry. We're broadcasting too much. Try again later.", callingElement)
				outputChatBox("((Masz za mało pieniędzy by coś ogłosić))", callingElement)
				return
			end
				
			local name = getPlayerName(callingElement):gsub("_", " ")
			outputChatBox("Pracownik SNA [Telefon]: Thanks, " .. cost .. " dollar will be withdrawn from your account. We'll air it as soon as possible!", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "ads", ( getElementData(callingElement, "ads") or 0 ) + 1, false)
			exports.global:giveMoney(getTeamFromName"San Andreas Network", cost)
			setTimer(
				function(p)
					if isElement(p) then
						local c =  getElementData(p, "ads") or 0
						if c > 1 then
							exports['antyczit']:changeProtectedElementDataEx(p, "ads", c-1, false)
						else
							exports['antyczit']:changeProtectedElementDataEx(p, "ads", false, false)
						end
					end
				end, 300000, 1, callingElement
			)
				
			SAN_newAdvert(message, name, callingElement, cost, outboundPhoneNumber)									
			executeCommandHandler( "hangup", callingElement )			
		end
	elseif callingPhoneNumber == 7332 then -- SAN Hotline
		if startingCall then
			outputChatBox("Pracownik SNA [Telefon]: Thanks for calling SAN. What message can i give through to our reporters?", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local languageslot = getElementData(callingElement, "languages.current")
			local language = getElementData(callingElement, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("system-jezykow"), "getLanguageName", language)
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("Pracownik SNA [Telefon]: Thanks for the message, we'll contact you back if needed.", callingElement)
			elseif getElementData(callingElement, "alcohollevel") and getElementData(callingElement, "alcohollevel") ~= 0 then
				outputChatBox("Pracownik SNA [Telefon]: Hey, shut up you drunk fool. ", callingElement)
			else
				outputChatBox("Pracownik SNA [Telefon]: Thanks for the message, we'll contact you back if needed.", callingElement)
				local playerNumber = getElementData(callingElement, "cellnumber")
						
				for key, value in ipairs( getPlayersInTeam(getTeamFromName("San Andreas Network")) ) do
					local hasItem, index, number, dbid = exports.global:hasItem(value,2)
					if hasItem then
						local reconning2 = getElementData(value, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(value,"receives a text message.")
						end
						
						outputChatBox("[" .. languagename .. "] SMS from #7332 [#"..number.."]: Ph:".. outboundPhoneNumber .." " .. message, value, 120, 255, 80)
					end
				end
				executeCommandHandler( "hangup", callingElement )					
			end
		end
	elseif callingPhoneNumber == 864 then -- UNI-Tel Hotline
		if startingCall then
			outputChatBox("Receptionist [Cellphone]: Hello, UNI-TEL's importing line. What would be your order today?", callingElement)
			exports['antyczit']:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local languageslot = getElementData(callingElement, "languages.current")
			local language = getElementData(callingElement, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("system-jezykow"), "getLanguageName", language)
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("Receptionist [Cellphone]: Thank you. Your message has been sent to your salesman. One shall contact you soon.", callingElement)
			elseif getElementData(callingElement, "alcohollevel") and getElementData(callingElement, "alcohollevel") ~= 0 then
				outputChatBox("Receptionist [Cellphone]: Hey, shut up you drunk fool. ", callingElement)
			else
				outputChatBox("Receptionist [Cellphone]: Thank you. Your message has been sent to your salesman. One shall contact you soon.", callingElement)
				local playerNumber = getElementData(callingElement, "cellnumber")
						
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Uni-Tel" ) ) ) do
					local hasItem, index, number, dbid = exports.global:hasItem(value,2)
					if hasItem then
						local reconning2 = getElementData(value, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(value,"receives a text message.")
						end
						outputChatBox("[" .. languagename .. "] SMS from #864 [#"..number.."]: Ph:".. outboundPhoneNumber .." " .. message, value, 120, 255, 80)
					end
				end
				executeCommandHandler( "hangup", callingElement )					
			end
		end
	end
end

--[[function broadcastSANAd(name, message)
	exports.logs:logMessage("ADVERT: " .. message, 2)
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		if (getElementData(value, "loggedin")==1 and not getElementData(value, "disableAds")) then
			if exports.global:isPlayerAdmin(value) then
				outputChatBox("   ADVERT: " .. message .. " ((" .. name .. "))", value, 0, 255, 64)
			else
				outputChatBox("   ADVERT: " .. message , value, 0, 255, 64)
			end
		end
	end
end]]

