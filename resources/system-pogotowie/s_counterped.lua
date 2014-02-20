addEvent("lses:ped:start", true)
function lsesPedStart(pedName)
	exports['global']:sendLocalText(client, "Rosie Jenkins says: Witaj przechodniu coś sie stało?", 255, 255, 255, 10)
	--exports.global:sendLocalMeAction(source,"hands " .. genderm .. " collection of photographs to the woman behind the desk.")
end
addEventHandler("lses:ped:start", getRootElement(), lsesPedStart)

addEvent("lses:ped:help", true)
function lsesPedHelp(pedName)
	exports['global']:sendLocalText(client, pedName.." says: Naprawde? Zadzwonie po pomoc , nie ruszaj sie stąd!!", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Services") ) ) do
		outputChatBox("[RADIO] Wezwanie w szpitalu!.", value, 0, 183, 239)
		outputChatBox("[RADIO] Ktoś potrzebuje waszej pomocy.  ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Location: Wszystkie jednostki proszone pod szpital!. (("..pedName.."))", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:help", getRootElement(), lsesPedHelp)

addEvent("lses:ped:appointment", true)
function lsesPedAppointment(pedName)
	exports['global']:sendLocalText(client, "Rosie Jenkins says: Poczekaj chwilkę , zadzwonie po kolegów.", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Services") ) ) do
		outputChatBox("[RADIO] Jeden z obywateli chciał porozmawiać z jakimś doktorem . ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Tuz przed wejściem do szpitala czeka na was. (("..pedName.."))", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:appointment", getRootElement(), lsesPedAppointment)