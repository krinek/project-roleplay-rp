--[[
Skrypt polegajacy na zablokowanu mozliwosci niszczenia pustego pojazdu

@author Daniex0r <daniex0r@gmail.com>
@author Bartek <>
@copyright 2012-2013 Daniex0r <daniex0r@gmail.com>
@license GPLv2
@package project-roleplay-rp
@link https://github.com/Daniex0r/project-roleplay-rp
]]--

addEventHandler( "onResourceStart", getResourceRootElement(getThisResource()),
	function()
		for i,v in ipairs(getElementsByType("vehicle")) do
			checkDamage( v )
		end
	end
)

function checkDamage( veh )
	local occupants = getVehicleOccupants( veh )
	local maxp = getVehicleMaxPassengers( veh )
	local isany = false
	
	for i=0,maxp do
		if occupants[i] then
			isany = true
		end
	end
	
	if isany then
		setVehicleHandling( veh, "collisionDamageMultiplier", getOriginalHandling(getElementModel(veh)).collisionDamageMultiplier )
	else
		setVehicleHandling( veh, "collisionDamageMultiplier", 0 )
	end
end

function checkDamageH()
	if source then
		checkDamage( source )
	end
end

addEventHandler( "onVehicleExit", getRootElement(), checkDamageH )
addEventHandler( "onVehicleEnter", getRootElement(), checkDamageH )