local mysql = exports.mysql
function startTalkToPed ()
	
	thePed = source
	thePlayer = client
	
	
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ)<=7) then
		return
	end

	if not (isPedInVehicle(thePlayer)) then
		processMessage(thePed, "Hej, jak mogę ci pomóc?.")
		setConvoState(thePlayer, 3)
		local responseArray = { "Możesz napełnić mój bak?", "Eh.. wlaściwie to nic", "Masz peta?", "ładnie wyglądasz." }
		triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
	else
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (exports['system-aut']:isVehicleWindowUp(theVehicle)) then
			outputChatBox("Zanim rozpoczniesz konwersacje , musisz otworzyć swoje okno", thePlayer, 255,0,0)
			return
		end
		processMeMessage(thePed, "schyla sie do " .. getPlayerName(thePlayer):gsub("_"," ") .. "w celu rozmowy.", thePlayer )
		processMessage(thePed, "Witaj , w czymś pomóc?")
		setConvoState(thePlayer, 1)
		local responseArray = { "Zatankuj do pełna.", "Nie dzięki.", "Masz peta?", "Nie wiem juz co chcialem" }
		triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
	end
end
addEvent( "fuel:startConvo", true )
addEventHandler( "fuel:startConvo", getRootElement(), startTalkToPed )


function talkToPed(answer, answerStr)
	thePed = source
	thePlayer = client
	
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		return
	end
	
	local convState = getElementData(thePlayer, "ped:convoState")
	local currSlot = getElementData(thePlayer, "languages.current")
	local currLang = getElementData(thePlayer, "languages.lang" .. currSlot)
	processMessage(thePlayer, answerStr, currLang)
	if (convState == 1) then -- "Hey , jak mogę ci pomóc??"
		local languageSkill = exports['system-jezykow']:getSkillFromLanguage(thePlayer, 1)
		if (languageSkill < 60) or (currLang ~= 1) then
			processMessage(thePed, "Wow dude, I can't understand a shit of it.")
			setConvoState(thePlayer, 0)
			return
		end
	
		if (answer == 1) then -- "Zatankuj."
			if not (isPedInVehicle(thePlayer)) then
				processMessage(thePed, "Ehm...")
				setConvoState(thePlayer, 0)
				return
			end
			processMessage(thePed, "Jasne  , nie ma sprawy.")
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			if (getElementData(theVehicle, "engine") == 1) then
				processMessage(thePed, "Czy możesz wyłaczyc silnik?")
				local responseArray = { "Jasne , nie ma sprawy.", "Nie możesz zatankować z włączonym silnikiem?", "Eh, CO?" }
				triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
				setConvoState(thePlayer, 2)
				return
			else
				pedWillFillVehicle(thePlayer, thePed)
			end
		elseif (answer == 2) then -- "Nie dzięki."
			processMessage(thePed, "Ok, jeżeli bedziesz chciał zatankować , daj znać.")
			setConvoState(thePlayer, 0)
		elseif (answer == 3) then -- "Do you have a sigarette for me?"
			processMessage(thePed, "Nie , tutaj sie nie pali")
			setConvoState(thePlayer, 0)
		elseif (answer == 4) then -- stop leaning against my car
			processMessage(thePed, "Okay, okay... Spokojnie.")
			processMeMessage(thePed, "stoi spokojnie.", thePlayer )
			processMessage(thePed, "Więc , tankujemy czy nie?.")
			local responseArray = {  "Tak , zatankuj.", "Nie , dzięki." }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 1)
		end
	elseif (convState == 2) then -- "Czy możesz wyłaczyć silnik?"
		if (answer == 1) then -- "Sure, no problemo." / "Ok, okay.."
			if not (isPedInVehicle(thePlayer)) then
				processMessage(thePed, "Ehm...")
				setConvoState(thePlayer, 0)
				return
			end
			processMeMessage(thePlayer, "wyłacza silnik.",thePlayer )
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			setElementData(theVehicle, "engine", 0)
			setVehicleEngineState(theVehicle, false)
			pedWillFillVehicle(thePlayer, thePed)
		elseif (answer == 2) then -- "Czy nie można zatankować przy pracującym silniku?" 
			processMeMessage(thePed, "wzdycha.",thePlayer )
			processMessage(thePed, "Ehm... nie , nie mam zamiaru umierać , wyłaczasz czy nie?")
			local responseArray = {  "Ok nie ma sprawy.", false, false, "Zamknij sie."  }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 2)
		elseif (answer == 3) then -- "Eh, WHAT?"
			processMessage(thePed, "Mam pytanie: Czy mógłbyś wyłączyć silnik?")
			local responseArray = {  "Ok, okay..", false,false, "Nie."  }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 2)
		elseif answer == 4 then -- "Zamknij sie i tankuj." / "Nie."
			processMessage(thePed, "Okay, okay... Jedź z tąd.")
			setConvoState(thePlayer, 0)
		end
	elseif (convState == 3) then
		if answer == 1 then -- Could you fill my fuelcan?
			if (exports.global:hasItem(thePlayer, 57)) then
				processMessage(thePed, "Ok , no to do dzieła!")
				processMeMessage(thePed, "przygotowywuje wąż do tankowania.",thePlayer )
				processMeMessage(thePed, "powoli wlewa paliwo do zbiorniczka.",thePlayer )
				setTimer(pedWillFillFuelCan, 3500, 1, thePlayer, thePed)
			else
				processMessage(thePed, "Najpierw musisz go mieć.")
				setConvoState(thePlayer, 0)
			end
		elseif answer == 2 then -- No thanks
			processMessage(thePed, "Okay, miłego dnia.")
			setConvoState(thePlayer, 0)
		elseif answer == 3 then -- do you have a cigarette for me?
			processMessage(thePed, "Nie. .")
			setConvoState(thePlayer, 0)
		elseif answer == 4 then -- I like your suit
			processMessage(thePed, "Eh, Dz-dzieki.")
			setConvoState(thePlayer, 0)
		end
	end
end
addEvent( "fuel:convo", true )
addEventHandler( "fuel:convo", getRootElement(), talkToPed )

function pedWillFillFuelCan(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		exports['czat']:localShout(thePed, "do", "NIE MA TU DLA CIEBIE PALIWA!")
		return
	end
	
	local hasItem, itemSlot, itemValue, itemUniqueID = exports.global:hasItem(thePlayer, 57)
	if not (hasItem) then
		processMessage(thePed, "śmieje sie...")
		processMeMessage(thePed, "wzdycha.",thePlayer )
		return
	end
	
	if itemValue >= 10 then
		processMessage(thePed, "Eh... bak jest już pełen.")
		return
	end
	
	local theLitres = 10 - itemValue
		
	local currentTax = exports.global:getTaxAmount()
	local fuelCost = math.floor(theLitres*(FUEL_PRICE + (currentTax*FUEL_PRICE)))
	
	if not (exports.global:takeMoney(thePlayer, fuelCost, true)) then
		processMessage(thePed, "Jak za to zapłacisz?!")
		return
	end
	
	if not (exports['system-przedmiotow']:updateItemValue(thePlayer, itemSlot, itemValue + theLitres)) then
		outputChatBox("Something went wrong, please /report.", thePlayer)
		return
	end
			
	processMeMessage(thePed, "przekazuje paragon do " .. getPlayerName(thePlayer):gsub("_"," ") .. "." ,thePlayer )	
	processMeMessage(thePlayer, "otrzymuje paragon i czyta go" ,thePlayer )	
	outputChatBox("============================", thePlayer)
	outputChatBox("Paragon Stacji benzynowej:", thePlayer)
	outputChatBox("    " .. math.ceil(theLitres) .. " Litrów Paliwa    -    " .. fuelCost .. "$", thePlayer)
	outputChatBox("============================", thePlayer)
	if (fuelCost > 0) then
		processMeMessage(thePlayer, "daje ".. fuelCost .." $ za takowanie." ,thePlayer )	
	else
		processMeMessage(thePlayer, "spogląda na paragon." ,thePlayer )	
	end
	setTimer(processMessage, 500, 1, thePed, "Szerokiej drogi")			
end

function pedWillFillVehicle(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	processMeMessage(thePed, "Przygotowywuje wąż do tankowania.",thePlayer )
	processMeMessage(thePed, "Rozpoczyna tankowanie pojazdu..",thePlayer )
	setTimer(processMessage, 7000, 1, thePed, "Prawie gotowe..")
	setTimer(pedWillFuelTheVehicle, 10000, 1, thePlayer, thePed)
end

function pedWillFuelTheVehicle(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		exports['czat']:localShout(thePed, "do", "TY IDIOTO , CHCESZ UMRZEC GNOJKU?!")
		return
	end
	
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	
	if (getVehicleEngineState(theVehicle)) then
		exports['czat']:localShout(thePed, "do", "TY IDIOTO , CHCESZ UMRZEC GNOJKU!")
		--processDoMessage(thePlayer, "The vehicle explodes", thePlayer)
		--blowVehicle (theVehicle, false )
		return
	end
	
	if not (isPedInVehicle(thePlayer)) then
		processMessage(thePed, "Ehm...")
		setConvoState(thePlayer, 0)
		return
	end
	

		
	local theLitres, free, factionToCharge = calculateFuelPrice(thePlayer, thePed)
	local currentTax = exports.global:getTaxAmount()
	local fuelCost = math.floor(theLitres*(FUEL_PRICE + (currentTax*FUEL_PRICE)))
	if (free) then
		if factionToCharge then
			exports.global:takeMoney(factionToCharge, fuelCost, true)
		end
		fuelCost = 0
	end
	
	exports.global:takeMoney(thePlayer, fuelCost, true)
					
	local loldFuel = getElementData(theVehicle, "fuel")
	local newFuel = loldFuel+theLitres
	exports['antyczit']:changeProtectedElementDataEx(theVehicle, "fuel", newFuel, false)
	triggerClientEvent(thePlayer, "syncFuel", theVehicle, newFuel)
		
	processMeMessage(thePed, "przekazuje paragon do " .. getPlayerName(thePlayer):gsub("_"," ") .. "." ,thePlayer )	
	processMeMessage(thePlayer, "odbiera paragon i odczytuje go." ,thePlayer )	
	outputChatBox("============================", thePlayer)
	outputChatBox("Paragon :", thePlayer)
	outputChatBox("    " .. math.ceil(theLitres) .. " Litrów Paliwa    -    " .. fuelCost .. "$", thePlayer)
	outputChatBox("============================", thePlayer)
	if (fuelCost > 0) then
		processMeMessage(thePlayer, "przekazuje ".. fuelCost .." $ za tankowanie." ,thePlayer )	
	else
		processMeMessage(thePlayer, "Kiwa głową na tankującego." ,thePlayer )	
	end
	setTimer(processMessage, 500, 1, thePed, "Szerokiej drogi.")			
end

function setConvoState(thePlayer, state)
	exports['antyczit']:changeProtectedElementDataEx(thePlayer, "ped:convoState", state, false)
end

function processMessage(thePed, message, language)
	if not (language) then
		language = 1
	end
	exports['czat']:localIC(thePed, message, language)
end

function processMeMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " *" ..  string.gsub(name, "_", " ").. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message, 255, 51, 102)
end

function processDoMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " * " .. message .. " *      ((" .. name:gsub("_", " ") .. "))", 255, 51, 102)
end

function calculateFuelPrice(thePlayer, thePed)
	local litresAffordable = MAX_FUEL
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local currFuel = tonumber(getElementData(theVehicle, "fuel"))
	local faction = getPlayerTeam(thePlayer)
	local ftype = getElementData(faction, "type")
	local fid = getElementData(faction, "id")
	local ratio = getElementData(thePed, "fuel:priceratio") or 100
	local factionToCharge = false
	
	local free = false
	if (ftype~=2) and (ftype~=3) and (ftype~=4) and (fid~=30) and not (exports.sponsorzy:hasPlayerPerk(thePlayer, 7)) then
		local money = exports.global:getMoney(thePlayer)
				
		local tax = exports.global:getTaxAmount()
		local cost = FUEL_PRICE + (tax*FUEL_PRICE)
		local cost = (cost / 100) * ratio
		local litresAffordable = math.ceil(money/cost)
			
		if amount and amount <= litresAffordable and amount > 0 then
			litresAffordable = amount
		end
					
		if (litresAffordable>MAX_FUEL) then
			litresAffordable=MAX_FUEL
		end
	else
		if not exports.sponsorzy:hasPlayerPerk(thePlayer, 7) then
			factionToCharge = faction
			local tax = exports.global:getTaxAmount()
			local cost = FUEL_PRICE + (tax*FUEL_PRICE)
			local cost = (cost / 100) * ratio
			local litresAffordable=MAX_FUEL
		end
		
		
		free = true
	end
	
	if (litresAffordable+currFuel>MAX_FUEL) then
		litresAffordable = MAX_FUEL - currFuel
	end
	return litresAffordable, free, factionToCharge
end

function createFuelPed(skin, posX, posY, posZ, rotZ, name, priceratio)
	theNewPed = createPed (skin, posX, posY, posZ)
	exports.pool:allocateElement(theNewPed)
	setPedRotation (theNewPed, rotZ)
	setElementFrozen(theNewPed, true)
	--setPedAnimation(theNewPed, "FOOD", "FF_Sit_Loop",  -1, true, false, true)
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "talk",1, true)
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "name", name:gsub("_", " "), true)
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "ped:name", name, true)
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "ped:type", "fuel", true)
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "ped:fuelped",true, true)
	
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "fuel:priceratio" , priceratio or 100, false)
	
	-- For the language system
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "languages.lang1" , 1, false)
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "languages.lang1skill", 100, false)
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "languages.lang2" , 2, false)
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "languages.lang2skill", 100, false)
	exports['antyczit']:changeProtectedElementDataEx(theNewPed, "languages.current", 1, false)	
	createBlip(posX, posY, posZ, 55, 2, 255, 0, 0, 255, 0, 300)
	return theNewPed
end
function onServerStart()
	local sqlHandler = mysql:query("SELECT * FROM fuelpeds")
	if (sqlHandler) then
		while true do
			local row = mysql:fetch_assoc( sqlHandler )
			if not row then break end
			
			createFuelPed(tonumber(row["skin"]),tonumber(row["posX"]),tonumber(row["posY"]),tonumber(row["posZ"]), tonumber(row["rotZ"]), row["name"],tonumber(row["priceratio"]))
		end
		
	end
	mysql:free_result(sqlHandler)
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), onServerStart)


--createFuelPed(217, 2112.86328125, 915.0595703125, 10.9609375, 0)