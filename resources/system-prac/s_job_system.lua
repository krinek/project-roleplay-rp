mysql = exports.mysql

chDimension = 125
chInterior = 3

-- CALL BACKS FROM CLIENT

function onEmploymentServer()
	exports.global:sendLocalText(source, "Jessie Smith mówi: Witaj poszukujesz nowej pracy?", nil, nil, nil, 10)
	exports.global:sendLocalText(source, " *Jessie Smith pokazuje liste dostepnych prac dla " .. getPlayerName(source):gsub("_", " ") .. ".", 255, 51, 102)
end

addEvent("onEmploymentServer", true)
addEventHandler("onEmploymentServer", getRootElement(), onEmploymentServer)

function givePlayerJob(jobID)
	local charname = getPlayerName(source)
	
	exports['antyczit']:changeProtectedElementDataEx(source, "job", jobID, false)
	mysql:query_free("UPDATE characters SET job=" .. mysql:escape_string(jobID) .. ", jobcontract = 3 WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )

	if (jobID==4) then -- CITY MAINTENANCE
		exports.global:giveWeapon(source, 41, 1500, true)
		outputChatBox("Użyj spraya by zamalować tagi na ulicy.", source, 255, 194, 14)
		exports['antyczit']:changeProtectedElementDataEx(source, "tag", 9, false)
		mysql:query_free("UPDATE characters SET tag=9 WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )
	end
end
addEvent("acceptJob", true)
addEventHandler("acceptJob", getRootElement(), givePlayerJob)

function quitJob(source)
	local logged = getElementData(source, "loggedin")
	if logged == 1 then
		local job = getElementData(source, "job")
		if job == 0 then
			outputChatBox("Jesteś obecnie bezrobotny.", source, 255, 0, 0)
		else
			local result = mysql:query_fetch_assoc("SELECT jobcontract FROM characters WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )
			if result then
				local contracttime = tonumber( result["jobcontract"] ) or 0
				if contracttime > 0 then
					outputChatBox( "Musisz odczekać " .. contracttime .. "  wypłat by sie zwolnić", source, 255, 0, 0)
				else
					exports['antyczit']:changeProtectedElementDataEx(source, "job", 0, false)
					mysql:query_free("UPDATE characters SET job=0 WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )
					if job == 4 then
						exports['antyczit']:changeProtectedElementDataEx(source, "tag", 1, false)
						mysql:query_free("UPDATE characters SET tag=1 WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )
					end
					
					triggerClientEvent(source, "quitJob", source, job)
				end
			else
				outputDebugString( "QuitJob: SQL error" )
			end
		end
	end
end

addCommandHandler("endjob", quitJob, false, false)
addCommandHandler("zwolnijsie", quitJob, false, false)

function resetContract( thePlayer, commandName, targetPlayerName )
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if targetPlayerName then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if targetPlayer then
				if getElementData( targetPlayer, "loggedin" ) == 1 then
					local result = mysql:query_free("UPDATE characters SET jobcontract = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) .. " AND jobcontract > 0" )
					if result then
						outputChatBox( "Reset Job Contract for " .. targetPlayerName, thePlayer, 0, 255, 0 )
					else
						outputChatBox( "Failed to reset Job Contract Time.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "PRZYKŁAD: /" .. commandName .. " [player]", thePlayer, 255, 194, 14 )
		end
	end
end
addCommandHandler("resetcontract", resetContract, false, false)