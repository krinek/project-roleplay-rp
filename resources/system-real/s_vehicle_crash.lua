function throwPlayerThroughWindow(x, y, z)	
	if source then
		local occupants = getVehicleOccupants ( source )
		local seats = getVehicleMaxPassengers( source )
	
		if occupants[0] == client then
			for seat = 0, seats do			
				local occupant = occupants[seat] -- Get the occupant
	 
				if occupant and getElementType(occupant) == "player" then -- If the seat is occupied by a player...
					--exports['antyczit']:changeProtectedElementDataEx(occupant, "realinvehicle", 0, false)
					if not isPedDead( occupant ) then
						toggleAllControls( occupant, false, true, false )
						--outputChatBox( "Zrobiles duza kupe! Podetrzesz sie dopiero za 40s", occupant )
						setTimer( toggleAllControls, 40000, 1, occupant, true, true, false )
						--setTimer( outputChatBox, 40000, 1, "Podtarles dupsko, mozesz jechaz dalej.", occupant )
						local serverDisplay = textCreateDisplay()
						textDisplayAddObserver ( serverDisplay, occupant )
						local serverText = textCreateTextItem ( "Po uderzeniu straciłeś przytomność\nMusisz odczekać 40 sekund.", 0.5, 0.5, 2, 255, 0, 0, 255, 4, "center", "center" )
						textDisplayAddText ( serverDisplay, serverText )  
						setTimer( textDisplayRemoveObserver, 40000, 1, serverDisplay, occupant )
						setTimer( textDisplayRemoveText, 40100, 1, serverDisplay, serverText )
					end
					
					--removePedFromVehicle(occupant, vehicle)
					--setElementPosition(occupant, x, y, z)
					--setPedAnimation(occupant, "CRACK", "crckdeth2", 10000, true, false, false)
					--setTimer(setPedAnimation, 10005, 1, occupant)
				end
			end
		end
	end
end
addEvent("crashThrowPlayerFromVehicle", true)
addEventHandler("crashThrowPlayerFromVehicle", getRootElement(), throwPlayerThroughWindow)

function unhookTrailer(thePlayer)
   if (isPedInVehicle(thePlayer)) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			detachTrailerFromVehicle(theVehicle) 
		end
   end
end
addCommandHandler("detach", unhookTrailer)
addCommandHandler("unhook", unhookTrailer)