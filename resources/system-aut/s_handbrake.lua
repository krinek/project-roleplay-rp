function toggleHandbrake( player, vehicle )
	local handbrake = getElementData(player, "handbrake") or isElementFrozen(vehicle) and 1 or 0
	if (handbrake == 0) then
		if isVehicleOnGround(vehicle) or getVehicleType(vehicle) == "Boat" or getElementDimension(vehicle) ~= 0 or getElementModel(vehicle) == 573 then -- 573 = Dune
			exports['antyczit']:changeProtectedElementDataEx(vehicle, "handbrake", 1, false)
			setElementFrozen(vehicle, true)
			exports.info:showBox (player,"info","Hamulec reczny zaciągnięty.")
		else
			exports.info:showBox (player,"warning","Hamulec można zaciągnac tylko gdy pojazd przylega na ziemi.")
		end
	else
		exports['antyczit']:changeProtectedElementDataEx(vehicle, "handbrake", 0, false)
		setElementFrozen(vehicle, false) 
		exports.info:showBox (player,"warning","Zwolniłeś hamulec ręczny.")
		triggerEvent("vehicle:handbrake:lifted", vehicle, player)
	end
end


function cmdHandbrake(sourcePlayer)
	if isPedInVehicle ( sourcePlayer ) and (getElementData(sourcePlayer,"realinvehicle") == 1)then
		local playerVehicle = getPedOccupiedVehicle ( sourcePlayer )
		if (getVehicleOccupant(playerVehicle, 0) == sourcePlayer) then
			toggleHandbrake( sourcePlayer, playerVehicle )
		else
			 exports.info:showBox(sourcePlayer,"info","Musisz być kierowcą by zaciągnąć hamulec ręczny...")
		end
	else
		exports.info:showBox (sourcePlayer,"error","Hmmm, jak chcesz zaciągnąć hamulec ręczny nie będąc w pojeździe...")
	end
end
addCommandHandler("reczny", cmdHandbrake)

addEvent("vehicle:handbrake:lifted", true)

addEvent("vehicle:handbrake", true)
addEventHandler( "vehicle:handbrake", root, function( ) if getVehicleType( source ) == "Trailer" then toggleHandbrake( client, source ) end end )
