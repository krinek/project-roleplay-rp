--
-- s_sPanelLite.lua
--

function onClientJoin()
	outputChatBox ( "Kliknij F4 ,lub wpisz /grafika ,aby ustawic efekty graficzne!", source, 255, 255, 255, true )
end
addEventHandler("onPlayerJoin", getRootElement(), onClientJoin)

function onEventStart()
	if getElementType ( source ) == "player" then
		local account = getPlayerAccount ( source )
		if account and not isGuestAccount ( account ) then
			if getAccountData ( account, "spl.on" ) then
				setElementData ( source, "spl_logged", true )
				setElementData ( source, "spl_water", getAccountData ( account, "spl.water" ) )
				setElementData ( source, "spl_carpaint", getAccountData ( account, "spl.carpaint" ) )
				setElementData ( source, "spl_bloom", getAccountData ( account, "spl.bloom" ) )
				setElementData ( source, "spl_palette", getAccountData ( account, "spl.palette" ) )
			end
		else
			setElementData ( source, "spl_looged", false )
		end
	end
end

function splsave ( water, carpaint, bloom, palette )
	local account = getPlayerAccount ( source )
	if account and not isGuestAccount ( account ) then
	    setAccountData ( account, "spl.on",true )
		--setAccountData ( account, "spl.water", water )
		setAccountData ( account, "spl.carpaint", carpaint )
		setAccountData ( account, "spl.bloom", bloom )
		setAccountData ( account, "spl.palette", palette )
		outputChatBox ( "Grafika: Twoje ustawienia zostaly zapisane!", source )
		else
	outputChatBox ( "Grafika: Zapisano !", source )
	end
	--setElementData ( source, "spl_water", water )
	setElementData ( source, "spl_carpaint", carpaint )
	setElementData ( source, "spl_bloom", bloom )
	setElementData ( source, "spl_palette", palette )
end

addEvent ( "splSave", true )
addEventHandler ( "splSave", root, splsave )
addEventHandler ( "onResourceStart", resourceRoot, onEventStart )
addEventHandler ( "onPlayerLogin", root, onEventStart )
addEventHandler ( "onPlayerLogin", root, function() triggerClientEvent ( "onClientPlayerLogin", source ) end )