﻿addEvent("engineMont", true)
addEventHandler("engineMont", getRootElement(), function(player, speed, cena, lock, akc)
	takePlayerMoney(player, cena)
	outputChatBox("Zapłaciłeś "..tostring(cena).."$ za zamontowanie silnika "..tostring(speed).."km/h.", player, 255, 0, 0)
	setVehicleHandling(getPedOccupiedVehicle(player), "maxVelocity", speed)
	setVehicleHandling(getPedOccupiedVehicle(player), "engineAcceleration", akc)
	setVehicleHandling(getPedOccupiedVehicle(player), "steeringLock", lock)
	setElementData(getPedOccupiedVehicle(player), "enginePro:speed", speed)
	
	setElementData(getPedOccupiedVehicle(player), "maxVelocity", tonumber(speed))
	setElementData(getPedOccupiedVehicle(player), "engineAcceleration", tonumber(akc))
	setElementData(getPedOccupiedVehicle(player), "steeringLock", tonumber(lock))
end)