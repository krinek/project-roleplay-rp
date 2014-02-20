job = 0
localPlayer = getLocalPlayer()

function playerSpawn()
	local logged = getElementData(localPlayer, "loggedin")

	if (logged==1) then
		job = tonumber(getElementData(localPlayer, "job"))
		if (job==1) then -- TRUCKER
			displayTruckerJob()
		else
			resetTruckerJob()
		end
		
		if (job==2) then -- TAXI
			displayTaxiJob()
		else
			resetTaxiJob()
		end
		
		if (job==3) then -- BUS
			displayBusJob()
		else
			resetBusJob()
		end
	end
end
addEventHandler("onClientPlayerSpawn", localPlayer, 
	function()
		setTimer(playerSpawn, 1000, 1)
	end
)

function quitJob(job)
	if (job==1) then -- TRUCKER JOB
		resetTruckerJob()
		outputChatBox("Zwolniłeś sie.", 0, 255, 0)
	elseif (job==2) then -- TAXI JOB
		resetTaxiJob()
		outputChatBox("Zwolniłeś sie.", 0, 255, 0)
	elseif (job==3) then -- BUS JOB
		resetBusJob()
		outputChatBox("Możesz sie już zwolnić.", 0, 255, 0)
	elseif (job==4) then -- CITY MAINTENANCE
		outputChatBox("Zwolniłeś sie.", 0, 255, 0)
		triggerServerEvent("cancelCityMaintenance", localPlayer)
	elseif (job==5) then -- MECHANIC
		outputChatBox("Zwolniłeś sie.", 0, 255, 0)
	elseif (job==6) then -- LOCKSMITH
		outputChatBox("Zwolniłeś sie.", 0, 255, 0)
	end
end
addEvent("quitJob", true)
addEventHandler("quitJob", getLocalPlayer(), quitJob)


fileDelete("c_job_framework.lua")