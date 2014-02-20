wEmployment, jobList, bAcceptJob, bCancel = nil

local jessie = createPed( 141, 1465.556640625, -1778.326171875, 1250.9418945313 )
local jessie = createPed( 141, 359.11392822266, 173.68501281738, 1007.5893432617 )
setPedRotation( jessie, 280 )
setElementDimension( jessie, 1 )
setElementInterior( jessie , 3 )
setElementData( jessie, "talk", 1, false )
setElementData( jessie, "name", "Jessie Smith", false )
setPedAnimation ( jessie, "INT_OFFICE", "OFF_Sit_Idle_Loop", -1, true, false, false )
setElementFrozen(jessie, true)

function showEmploymentWindow()
	
	-- Employment Tooltip
	if(getResourceFromName("podpowiedzi"))then
		triggerEvent("tooltips:showHelp",getLocalPlayer(),7)
	end
	
	triggerServerEvent("onEmploymentServer", getLocalPlayer())
	local width, height = 260, 300
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wEmployment = guiCreateWindow(x, y, width, height, "Urząd Miasta", false)
	
	jobList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, wEmployment)
	local column = guiGridListAddColumn(jobList, "Tytuł Pracy", 0.9)

	-- TRUCKER
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Kurier", false, false)
	
	-- TAXI
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Taksówkarz", false, false)
	
	-- BUS
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Kierowca Autobusu", false, false)
	
	-- CITY MAINTENACE
	local team = getPlayerTeam(getLocalPlayer())
	local ftype = getElementData(team, "type")
	if ftype ~= 2 then
		local rowmaintenance = guiGridListAddRow(jobList)
		guiGridListSetItemText(jobList, rowmaintenance, column, "Służby porządkowe", false, false)
	end
	
	-- MECHANIC
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Mechanik", false, false)
	
	-- LOCKSMITH
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Klucznik", false, false)
	
	bAcceptJob = guiCreateButton(0.05, 0.89, 0.40, 0.1, "Zatrudnij sie", true, wEmployment)
	bCancel = guiCreateButton(0.5, 0.89, 0.40, 0.1, "Zamknij okno", true, wEmployment)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", bAcceptJob, acceptJob)
	addEventHandler("onClientGUIDoubleClick", jobList, acceptJob)
	addEventHandler("onClientGUIClick", bCancel, cancelJob)
end
addEvent("onEmployment", true)
addEventHandler("onEmployment", getRootElement(), showEmploymentWindow)

function acceptJob(button, state)
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(jobList)
		local job = getElementData(getLocalPlayer(), "job")
		
		if (row==-1) or (col==-1) then
			outputChatBox("Musisz pierw wybrać pracę!", 255, 0, 0)
		elseif (job>0) then
			outputChatBox("obecnie posiadasz juz prace wpisz  (( /zwolnijsie )).", 255, 0, 0)
		else
			local job = 0
			local jobtext = guiGridListGetItemText(jobList, guiGridListGetSelectedItem(jobList), 1)
			
			if ( jobtext=="Delivery Driver" or jobtext=="Taxi Driver" or jobtext=="Bus Driver" ) then  -- Driving job, requires the license
				local carlicense = getElementData(getLocalPlayer(), "license.car")
				if (carlicense~=1) then
					outputChatBox("Ta praca wymaga posiadania licencji prawa jazdy.", 255, 0, 0)
					return
				end
			end
			
			if (jobtext=="Kurier") then
				displayTruckerJob()
				job = 1
			elseif (jobtext=="Taksówkarz") then
				job = 2
				displayTaxiJob()
			elseif  (jobtext=="Kierowca Autobusu") then
				job = 3
				displayBusJob()
			elseif (jobtext=="Służby porządkowe") then
				job = 4
			elseif (jobtext=="Mechanik") then
				displayMechanicJob()
				job = 5
			elseif (jobtext=="Klucznik") then
				displayLocksmithJob()
				job = 6
			end
			
			triggerServerEvent("acceptJob", getLocalPlayer(), job)
			
			destroyElement(jobList)
			destroyElement(bAcceptJob)
			destroyElement(bCancel)
			destroyElement(wEmployment)
			wEmployment, jobList, bAcceptJob, bCancel = nil, nil, nil, nil
			showCursor(false)
		end
	end
end

function cancelJob(button, state)
	if (source==bCancel) and (button=="left") then
		destroyElement(jobList)
		destroyElement(bAcceptJob)
		destroyElement(bCancel)
		destroyElement(wEmployment)
		wEmployment, jobList, bAcceptJob, bCancel = nil, nil, nil, nil
		showCursor(false)
	end
end

fileDelete("c_job_system.lua")