mysql = exports.mysql

function onLicenseServer()
	local gender = getElementData(source, "gender")
	if (gender == 0) then
		exports.global:sendLocalText(source, "Adam Brzuzka mówi: Witaj , w czym mogę pomóc?", nil, nil, nil, 10)
	else
		exports.global:sendLocalText(source, "Adam Brzuzka mówi: Witaj , w czym mogę pomóc?", nil, nil, nil, 10)
	end
end

addEvent("onLicenseServer", true)
addEventHandler("onLicenseServer", getRootElement(), onLicenseServer)

function giveLicense(license, cost)
	if (license==1) then -- car drivers license
		local theVehicle = getPedOccupiedVehicle(source)
		exports['antyczit']:changeProtectedElementDataEx(source, "realinvehicle", 0, false)
		removePedFromVehicle(source)
		respawnVehicle(theVehicle)
		exports['antyczit']:changeProtectedElementDataEx(source, "license.car", 1)
		exports['antyczit']:changeProtectedElementDataEx(theVehicle, "handbrake", 1, false)
		setElementFrozen(theVehicle, true)
		mysql:query_free("UPDATE characters SET car_license='1' WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .. "' LIMIT 1")
		outputChatBox("Gratulacje zaliczyłeś test prawa jazdy.", source, 255, 194, 14)
                exports.global:giveItem( client, 55, 1 )
		outputChatBox("Od teraz jesteś użytkownikiem ruchu drogowego i odblokowane zostały dla ciebie nowe zawody.", source, 255, 194, 14)
		exports.global:takeMoney(source, cost)
	end
end
addEvent("acceptLicense", true)
addEventHandler("acceptLicense", getRootElement(), giveLicense)

function payFee(amount)
	exports.global:takeMoney(source, amount)
end
addEvent("payFee", true)
addEventHandler("payFee", getRootElement(), payFee)

function passTheory()
	exports['antyczit']:changeProtectedElementDataEx(source,"license.car.cangetin",true, false)
	exports['antyczit']:changeProtectedElementDataEx(source,"license.car",3) -- Set data to "theory passed"
	mysql:query_free("UPDATE characters SET car_license='3' WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .. "' LIMIT 1")
end
addEvent("theoryComplete", true)
addEventHandler("theoryComplete", getRootElement(), passTheory)

function showLicenses(thePlayer, commandName, targetPlayer)
	local loggedin = getElementData(thePlayer, "loggedin")

	if (loggedin==1) then
		if not (targetPlayer) then
			outputChatBox("PRZYKŁAD: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
						
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>5) then -- Are they standing next to each other?
						outputChatBox("Jesteś zbyt daleko by pokazać licencje '".. targetPlayerName .."'.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Pokazałeś dokumenty " .. targetPlayerName .. ".", thePlayer, 255, 194, 14)
						outputChatBox(getPlayerName(thePlayer) .. " Pokazuje ci swoje dokumenty.", targetPlayer, 255, 194, 14)
						
						local gunlicense = getElementData(thePlayer, "license.gun")
						local carlicense = getElementData(thePlayer, "license.car")
						
						local guns, cars
						
						if (gunlicense<=0) then
							guns = "Nie"
						else
							guns = "Tak"
						end
						
						if (carlicense<=0) then
							cars = "Nie"
						elseif (carlicense==3)then
							cars = "tylko Teoretyczny"
						else
							cars = "Tak"
						end
						
						outputChatBox("~-~-~-~- " .. getPlayerName(thePlayer) .. " Dokumenty -~-~-~-~", targetPlayer, 255, 194, 14)
						outputChatBox("        Licencja broni: " .. guns, targetPlayer, 255, 194, 14)
						outputChatBox("        Licencja Prawa jazdy: " .. cars, targetPlayer, 255, 194, 14)
					end
				end
			end
		end
	end
end
addCommandHandler("pokazdokumenty", showLicenses, false, false)


function checkDMVCars(player, seat)
	-- aka civilian previons
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and getElementModel(source) == 436 then

		if getElementData(player,"license.car.bartek") ~= source then
			outputChatBox("((  Ten pojazd jest przeznaczony tylko do zbawania prawa jazdy. ))", player, 255, 0, 0)
			cancelEvent()
			return
		end
		--]]
		if getElementData(player,"license.car") == 3 then
			if getElementData(player, "license.car.cangetin") then
				outputChatBox("(( Możesz użyć klawisza J by odpalić silnik oraz klawisza L by odpalić światła. ))", player, 0, 255, 0)
			else
				outputChatBox("(( Ten pojazd jest przeznaczony do testu na prawo jazdy ,aby zdać test udaj się do Adama Brzuzki. ))", player, 255, 0, 0)
				cancelEvent()
			end
		elseif seat > 0 then
			outputChatBox("(( Ten pojazd jest przeznaczony tylko do zdawania prawa jazdy. ))", player, 255, 194, 14)
		else
			outputChatBox("((  Ten pojazd jest przeznaczony tylko do zdawania prawa jazdy. ))", player, 255, 0, 0)
			cancelEvent()
		end
	end
end
addEventHandler( "onVehicleStartEnter", getRootElement(), checkDMVCars)

local carqueue = 0

function createPJCar()
	local car = createVehicle( 436, 1264.43-(carqueue*3), -1445.93, 13.53, 0, 0, 180 )
	local ped = createPed( 186, 1264.43-(carqueue*3), -1445.93, 13.53 )
	carqueue = carqueue + 1
	if carqueue == 6 then carqueue = 0 end
	warpPedIntoVehicle( ped, car, 1 )
	setElementData( car, "owner", -2 )
	setElementData( car, "faction", -1 )
	setElementData( car, "fuel", 70 )
	setElementData( source, "license.car.bartek", car )
	setElementData( car, "owner.bartek", source )
	setElementData( car, "special.bartek.special", true )
	setElementData( car, "owner.bartek.ped", ped )
end
addEvent("createPJCar", true)
addEventHandler("createPJCar", getRootElement(), createPJCar)

function destroyPJCar()
	local car = getElementData( source, "license.car.bartek" )
	local ped = getElementData( car, "owner.bartek.ped" )
	removePedFromVehicle( source )
	removePedFromVehicle( ped )
	destroyElement( car )
	destroyElement( ped )
	setElementData( source, "license.car.bartek", nil )
	
	setElementPosition( source, 1234.6000976562, -1454.1101074219, 13.542560577393 )
end
addEvent("destroyPJCar", true)
addEventHandler("destroyPJCar", getRootElement(), destroyPJCar)

addEventHandler( "onPlayerQuit", getRootElement(),
	function( why, reason )
		local car = getElementData( source, "license.car.bartek" )
		if isElement(car) then
			local ped = getElementData( car, "owner.bartek.ped" )
			removePedFromVehicle( source )
			removePedFromVehicle( ped )
			destroyElement( car )
			destroyElement( ped )
			--setElementData( source, "license.car.bartek", nil )
		end
	end
)
addEventHandler( "onVehicleExit", getRootElement(),
	function(player)
		if getElementData( source, "special.bartek.special") then
			if getElementData( source, "owner.bartek" ) == player then
				local ped = getElementData( source, "owner.bartek.ped" )
				removePedFromVehicle( source )
				removePedFromVehicle( ped )
				destroyElement( source )
				destroyElement( ped )
				triggerClientEvent( player, "bartekDestroyPrawko", player )
			end
		end
	end
)
