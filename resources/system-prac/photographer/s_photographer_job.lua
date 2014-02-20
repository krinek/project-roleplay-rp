function getPaid(collectionValue)
	exports.global:giveMoney(getPlayerTeam(source), tonumber(collectionValue))
	
	local gender = getElementData(source, "gender")
	local genderm = "his"
	if (gender == 1) then
		genderm = "her"
	end
	
	exports.global:sendLocalMeAction(source,"hands " .. genderm .. " collection of photographs to the woman behind the desk.")
	exports.global:sendLocalText(source, "Victoria Greene says: Thank you. These should make the morning edition. Keep up the good work.", nil, nil, nil, 10)
	outputChatBox("#FF9933SAN News made $".. exports.global:formatMoney(collectionValue) .." from the photographs.", source, 255, 104, 91, true)
	exports.global:sendMessageToAdmins("SANNews: " .. tostring(getPlayerName(source)) .. " sold photos for $" .. exports.global:formatMoney(collectionValue) .. ".")
	exports.logs:logMessage(tostring(getPlayerName(source)) .. " sprzedaje zdjęcia za $" .. exports.global:formatMoney(collectionValue) .. ".", 10)
	updateCollectionValue(0)
end
addEvent("submitCollection", true)
addEventHandler("submitCollection", getRootElement(), getPaid)


function info()
	exports.global:sendLocalText(source, "Victoria Greene mówi: Witaj , zajmuje sie odkupowaniem zdjęć od fotografów z San News Andreas -", nil, nil, nil, 10)
	exports.global:sendLocalText(source, "jeżeli nie jeste pracownikiem tej frakcji , zatrudnij sie. ((tylko na forum))!", nil, nil, nil, 10)
end
addEvent("sellPhotosInfo", true)
addEventHandler("sellPhotosInfo", getRootElement(), info)

function updateCollectionValue(value)
	mysql:query_free("UPDATE characters SET photos = " .. mysql:escape_string((tonumber(value) or 0)) .. " WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )
end
addEvent("updateCollectionValue", true)
addEventHandler("updateCollectionValue", getRootElement(), updateCollectionValue)

addEvent("getCollectionValue", true)
addEventHandler("getCollectionValue", getRootElement(),
	function()
		if getElementData( source, "loggedin" ) == 1 then
			local result = mysql:query_fetch_assoc("SELECT photos FROM characters WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )
			if result then
				triggerClientEvent( source, "updateCollectionValue", source, tonumber( result["photos"] ) )
			end
		end
	end
)

function sanAD()
	exports['global']:sendLocalText(source, "Victoria Greene mói: Jeżeli chcesz co ogłosić skontaktuj sie z Frakcjš News pod numerem 7331.", 255, 255, 255, 10)
end
addEvent("cSANAdvert", true)
addEventHandler("cSANAdvert", getRootElement(), sanAD)

function photoHeli(thePlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local teamType = getElementData(theTeam, "type")
	if teamType == 6 then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			local vehicleModel = getElementModel(theVehicle)
			if vehicleModel == 488 or vehicleModel == 487 then
				triggerClientEvent(thePlayer, "job:photo:heli", thePlayer)
			end
		end
	end
end
addCommandHandler("photoheli", photoHeli)