mysql = exports.mysql

function ciucholandKupCiuch( skin, cost )
	local clientAccountID = getElementData(source, "account:id") or -1
	if clientAccountID then
		mysql:query_free("UPDATE characters SET skin="..skin.." WHERE account='" .. mysql:escape_string(tostring(clientAccountID)) .. "' AND `active` = 1")
		setPedSkin( source, skin )
		exports.global:takeMoney( source, cost )
		outputChatBox( "Kupiłeś ubranie id "..skin.." za $"..cost..".", source )
	end
end
addEvent( "ciucholandKupCiuch", true )
addEventHandler( "ciucholandKupCiuch", getRootElement(), ciucholandKupCiuch )