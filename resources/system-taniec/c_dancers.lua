function pedDamage()
	cancelEvent()
end
addEventHandler("onClientPedDamage", getResourceRootElement(), pedDamage)


fileDelete("c_dancers.lua")