local mysql = exports.mysql

function getElementDataEx(theElement, theParameter)
	return getElementData(theElement, theParameter)
end

function setElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	if syncToClient == nil then
		syncToClient = false
	end
	
	if noSyncAtall == nil then
		noSyncAtall = false
	end
	
	if tonumber(theValue) then
		theValue = tonumber(theValue)
	end
	
	exports['antyczit']:changeProtectedElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	return true
end

function resourceStart(resource)
	setGameType("MTA:SA")
	setMapName("Roleplay 1.1")
	setRuleValue("Script Version", scriptVersion)
	setRuleValue("Author", "Project-Roleplay")
	setTimer( 
			function( )
				outputServerLog( " __               _____     __             __" )
				outputServerLog( "|  |    __  | __  _ |      |  | __ |    __|  ||   __ |    |" )
 				outputServerLog( "|__||_-|  | ||__ /  |  === |__||  ||   |__|__||  |  | |__|" )
	   			outputServerLog( "|   |  |__|_/|__ |_ |      | | |__||___|__|   |__|__|_ ||" )                   
			end, 50, 1
		)

	--local motdresult = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name='motd' LIMIT 1")
	--exports['antyczit']:changeProtectedElementDataEx(getRootElement(), "account:motd", motdresult["value" ], false )
	--local amotdresult = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name='amotd' LIMIT 1")
	--exports['antyczit']:changeProtectedElementDataEx(getRootElement(), "account:amotd", amotdresult["value" ], false )

	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		triggerEvent("playerJoinResourceStart", value, resource)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceStart)
	
function onJoin()
	local skipreset = false
	local loggedIn = getElementData(source, "loggedin")
	if loggedIn == 1 then
		local accountID = getElementData(source, "account:id")
		local seamlessHash = getElementData(source, "account:seamlesshash")
		local mQuery1 = mysql:query("SELECT `id` FROM `accounts` WHERE `id`='"..mysql:escape_string(accountID).."' AND `loginhash`='".. mysql:escape_string(seamlessHash) .."'")
		if mysql:num_rows(mQuery1) == 1 then
			skipreset = true
			setElementDataEx(source, "account:seamless:validated", true, false, true)
		end
		mysql:free_result(mQuery1)
	end
	if not skipreset then 
		-- Set the user as not logged in, so they can't see chat or use commands
		exports['antyczit']:changeProtectedElementDataEx(source, "loggedin", 0, false)
		exports['antyczit']:changeProtectedElementDataEx(source, "account:loggedin", false, false)
		exports['antyczit']:changeProtectedElementDataEx(source, "account:username", "", false)
		exports['antyczit']:changeProtectedElementDataEx(source, "account:id", "", false)
		exports['antyczit']:changeProtectedElementDataEx(source, "dbid", false)
		exports['antyczit']:changeProtectedElementDataEx(source, "adminlevel", 0, false)
		exports['antyczit']:changeProtectedElementDataEx(source, "hiddenadmin", 0, false)
		exports['antyczit']:changeProtectedElementDataEx(source, "globalooc", 1, false)
		exports['antyczit']:changeProtectedElementDataEx(source, "muted", 0, false)
		exports['antyczit']:changeProtectedElementDataEx(source, "loginattempts", 0, false)
		exports['antyczit']:changeProtectedElementDataEx(source, "timeinserver", 0, false)
		setElementData(source, "chatbubbles", 0, false)
		setElementDimension(source, 9999)
		setElementInterior(source, 0)
	end
	
	exports.global:updateNametagColor(source)
end
addEventHandler("onPlayerJoin", getRootElement(), onJoin)
addEvent("playerJoinResourceStart", false)
addEventHandler("playerJoinResourceStart", getRootElement(), onJoin)

function resetNick(oldNick, newNick)
	exports['antyczit']:changeProtectedElementDataEx(client, "legitnamechange", 1)
	setPlayerName(client, oldNick)
	exports['antyczit']:changeProtectedElementDataEx(client, "legitnamechange", 0)
	exports.global:sendMessageToAdmins("AdmWrn: " .. tostring(oldNick) .. " tried to change name to " .. tostring(newNick) .. ".")
end

addEvent("resetName", true )
addEventHandler("resetName", getRootElement(), resetNick)