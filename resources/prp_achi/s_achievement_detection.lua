-- /////////////// ACHIEVEMENT ID 3 - The Wheelman ///////////////////
function giveAchievementOnVehicleEnter(thePlayer)
	if (not doesPlayerHaveAchievement(thePlayer, 3)) then
		outputChatBox("Vehicle Controls:", thePlayer, 255, 194, 14)
		outputChatBox("Engine: Press J", thePlayer, 255, 194, 14)
		outputChatBox("Locks: Press K", thePlayer, 255, 194, 14)
		outputChatBox("Headlights: Press L", thePlayer, 255, 194, 14)
	end
	givePlayerAchievement(thePlayer, 3)
end
addEventHandler("onVehicleEnter", getRootElement(), giveAchievementOnVehicleEnter)

-- /////////////// ACHIEVEMENT ID 4 - The Newbie ///////////////////
function giveAchievementOnFirstCharacter()
	givePlayerAchievement(source, 4)
end
addEventHandler("onPlayerCreateCharacter", getRootElement(), giveAchievementOnFirstCharacter)

-- /////////////// ACHIEVEMENT ID 8 - Banged Up ///////////////////
mtaPickup = createPickup(1444.1369628906, 1903.8308105469, 10.8203125, 3, 1248)
exports.pool:allocateElement(mtaPickup)
function giveAchievementOnMTAPickup(thePlayer)
	cancelEvent()
	givePlayerAchievement(thePlayer, 32)
end
addEventHandler("onPickupHit", mtaPickup, giveAchievementOnMTAPickup)

-- /////////////// Client-side achievement requests ///////////////
addEvent("givePlayerAchievement", true)
addEventHandler("givePlayerAchievement", getRootElement(),
	function( id )
		givePlayerAchievement(source, id)
	end
)