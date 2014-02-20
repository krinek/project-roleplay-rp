function toggleWindowa(source)
	local thePlayer = source
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if theVehicle then
		if hasVehicleWindows(theVehicle) then
			if (getVehicleOccupant(theVehicle) == thePlayer) or (getVehicleOccupant(theVehicle, 1) == thePlayer) then
				if not (isVehicleWindowUp(theVehicle)) then
					exports['antyczit']:changeProtectedElementDataEx(theVehicle, "vehicle:pasy", 0, true)
					exports.global:sendLocalMeAction(source, "Odpina pasy.")
					triggerClientEvent("removeWindow", getRootElement())
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerEvent("setTintNamea", player)
						end
					end
				else
					exports['antyczit']:changeProtectedElementDataEx(theVehicle, "vehicle:pasy", 1, true)
					exports.global:sendLocalMeAction(source, "Zapina pasy.")
					triggerClientEvent("addWindow", getRootElement())
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerEvent("resetTintNamea", theVehicle, player)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("pasy", toggleWindowa)

function addIcona()
	if (getElementData(source, "vehicle:pasy") == 0) then
		triggerClientEvent("addWindow", getRootElement())
	end
end
addEventHandler("onVehicleEnter", getRootElement(), addIcona)