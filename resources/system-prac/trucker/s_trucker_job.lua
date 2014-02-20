local lockTimer = nil
local truckruns = { }
local truckwage = { }
local truckroute = { }
local truck = { [414] = true }

function giveTruckingMoney(vehicle)
	outputChatBox("Zarobiłeś $" .. exports.global:formatMoney( truckwage[vehicle] or 0 ) .. " na dowożeniu towarów", source, 255, 194, 15)
	exports.global:giveMoney(source, truckwage[vehicle] or 0)

	if (truckwage[vehicle] == nil) then
		triggerTruckCheatEvent(source, 3)
	elseif (truckwage[vehicle] > 1500) then
		triggerTruckCheatEvent(source, 2, truckwage[vehicle])
	end
	
	-- respawn the vehicle
	exports['antyczit']:changeProtectedElementDataEx(source, "realinvehicle", 0, false)
	removePedFromVehicle(source, vehicle)
	respawnVehicle(vehicle)
	setVehicleLocked(vehicle, false)
	setElementVelocity(vehicle,0,0,0)
	
	-- reset runs/wage
	truckruns[vehicle] = nil
	truckwage[vehicle] = nil
end
addEvent("giveTruckingMoney", true)
addEventHandler("giveTruckingMoney", getRootElement(), giveTruckingMoney)


function checkTruckingEnterVehicle(thePlayer, seat)
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and seat == 0 and truck[getElementModel(source)] and getElementData(source,"job") == 1 and getElementData(thePlayer,"job") == 1 then
		triggerClientEvent(thePlayer, "startTruckJob", thePlayer, truckroute[source] or -1)
		if (truckruns[vehicle] ~= nil) and (truckwage[vehicle] > 0) then
			triggerClientEvent(thePlayer, "spawnFinishMarkerTruckJob", thePlayer)
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), checkTruckingEnterVehicle)

function startEnterTruck(thePlayer, seat, jacked) 
	if seat == 0 and truck[getElementModel(source)] and getElementData(thePlayer,"job") == 1 and jacked then -- if someone try to jack the driver stop him
		if isTimer(lockTimer) then
			killTimer(lockTimer)
			lockTimer = nil
		end
		setVehicleLocked(source, true)
		lockTimer = setTimer(setVehicleLocked, 5000, 1, source, false)
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterTruck)

function saveDeliveryProgress(vehicle, earned)
	if (truckruns[vehicle] == nil) then
		truckruns[vehicle] = 0
		truckwage[vehicle] = 0
	end
	
	truckruns[vehicle] = truckruns[vehicle] + 1
	truckwage[vehicle] = truckwage[vehicle] + earned
	
	outputChatBox("Ukończyłeś  " .. truckruns[vehicle] .. ".  dostawę i zarabiasz z niej $" .. exports.global:formatMoney(earned) .. ".", client, 0, 255, 0)
	if (earned > 100) then
		triggerTruckCheatEvent(client, 1, earned)
	end
	
	if (truckruns[vehicle] == 25) then
		outputChatBox("#FF9933Twój bagaż pusty wróć do #CC0000 bazy #FF9933by załadować nowy towar", client, 0, 0, 0, true)
	else 
		outputChatBox("#FF9933Możesz w każdej chwili wrócić do  #CC0000bazy #FF9933by odebrać wypłatę", client, 0, 0, 0, true)
		outputChatBox("#FF9933lub kontynuuj jadąc  #FFFF00do kolejnych punktów#FF9933 i twoja pensja się zwiększy.", client, 0, 0, 0, true)
		triggerClientEvent( client, "loadNewCheckpointTruckJob",  client)
		triggerEvent("updateGlobalSupplies", client, math.random(10,20))
	end
end
addEvent("saveDeliveryProgress", true)
addEventHandler("saveDeliveryProgress", getRootElement(), saveDeliveryProgress)

function triggerTruckCheatEvent(thePlayer, cheatType, value1)
	local cheatStr = ""
	if (cheatType == 1) then
		cheatStr = "Zarabia za dużo na kurierze, (c:"..value1..", max 100)"
	elseif (cheatType == 2) then
		cheatStr = "Zarobił już za dużo jak na ten kurs. (c:"..value1..", max 1500)"
	else
		cheatStr = "unknown triggerTruckCheatEvent (".. cheatType .."/"..value1..")"
	end
	local finalstr = "[trucking\saveDeliveryProgress]".. getPlayerName(thePlayer) .. " " .. getPlayerIP(thePlayer) .. " ".. cheatStr  
	exports.logs:logMessage(finalstr, 32)
	exports.global:sendMessageToAdmins(finalstr)
end

function updateNextCheckpoint(vehicle, pointid)
	truckroute[vehicle] = pointid
end
addEvent("updateNextCheckpoint", true)
addEventHandler("updateNextCheckpoint", getRootElement(), updateNextCheckpoint)

function restoreTruckingJob()
	if getElementData(source, "job") == 1 then
		triggerClientEvent(source, "restoreTruckerJob", source)
	end
end
addEventHandler("restoreJob", getRootElement(), restoreTruckingJob)
