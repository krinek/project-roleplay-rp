﻿function toggleWindow(source)
	local thePlayer = source
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if theVehicle then
		if hasVehicleWindows(theVehicle) then
			if (getVehicleOccupant(theVehicle) == thePlayer) or (getVehicleOccupant(theVehicle, 1) == thePlayer) then
				if not (isVehicleWindowUp(theVehicle)) then
					exports['antyczit']:changeProtectedElementDataEx(theVehicle, "vehicle:windowstat", 0, true)
					exports.global:sendLocalMeAction(source, "zamyka okno.")
					triggerClientEvent("removeWindow", getRootElement())
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerEvent("setTintName", player)
						end
					end
				else
					exports['antyczit']:changeProtectedElementDataEx(theVehicle, "vehicle:windowstat", 1, true)
					exports.global:sendLocalMeAction(source, "otwiera okno.")
					triggerClientEvent("addWindow", getRootElement())
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerEvent("resetTintName", theVehicle, player)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("okno", toggleWindow)

function addIcon()
	if (getElementData(source, "vehicle:windowstat") == 0) then
		triggerClientEvent("addWindow", getRootElement())
	end
end
addEventHandler("onVehicleEnter", getRootElement(), addIcon)