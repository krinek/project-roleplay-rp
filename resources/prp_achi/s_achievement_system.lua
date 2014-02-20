mysql = exports.mysql

local savedAchievements = {}

function doesPlayerHaveAchievement(thePlayer, id)
	if (getElementType(thePlayer)) then
		if not savedAchievements[thePlayer] then
			savedAchievements[thePlayer] = {}
		elseif savedAchievements[thePlayer][id] then
			return true
		end
		
		local gameaccountID = getElementData(thePlayer, "gameaccountid")

		if (gameaccountID) then
			local result = mysql:query("SELECT id FROM achievements WHERE achievementid='" .. mysql:escape_string(id) .. "' AND account='" .. mysql:escape_string(gameaccountID) .. "'")
			if (mysql:num_rows(result)>0) then
				mysql:free_result(result)
				savedAchievements[thePlayer][id] = true
				return true
			else
				mysql:free_result(result)
				return false
			end
		end
	end
end

function givePlayerAchievement(thePlayer, id)
	if not (doesPlayerHaveAchievement(thePlayer, id)) then
		local gameaccountID = getElementData(thePlayer, "gameaccountid")

		if (gameaccountID) then
			local time = getRealTime()
			local days = time.monthday
			local months = (time.month+1)
			local years = (1900+time.year)
					
			local date = days .. "/" .. months .. "/" .. years
		
			local result = mysql:query_free("INSERT INTO achievements SET account='" .. mysql:escape_string(gameaccountID) .. "', achievementid='" .. mysql:escape_string(id) .. "', date='" .. mysql:escape_string(date) .. "'")
		
			if result then
				triggerClientEvent(thePlayer, "onPlayerGetAchievement", thePlayer, id)
				return true
			else
				return false
			end
		end
	end
end
addEvent("cGivePlayerAchievement", true)
addEventHandler("cGivePlayerAchievement", getRootElement(), givePlayerAchievement)

addEventHandler( "onPlayerQuit", getRootElement(), function() savedAchievements[source] = nil end)
