local myCommandsWindow = nil
local sourcePlayer = getLocalPlayer()

function commandsHelp()
	local loggedIn = getElementData(sourcePlayer, "loggedin")
	if (loggedIn == 1) then
		if (myCommandsWindow == nil) then
			guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
			myCommandsWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Indeks komend dla graczy", false)
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myCommandsWindow)
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Zamknij", true, myCommandsWindow) -- close button

			local commands =
			{
				-- FIXME: Order each tab's contents (alphabetically)
				{
					name = "Czat",
					{ "'t'", "Klawisz 't' [IC Tekst]", "Czat In character.", "'t' Witaj , jestem Jack a ty?" },
					{ "'y' lub /r", "/r [IC Tekst]", "Komenda dla posiadjacych radio." },
					{ "/stacja", "/stacja [radio id] [kanal]", "Strojenie radia-krótkofalówki.", "/stacja 100" },
					{ "'b' or /b", "/b [OOC Tekstt]", "Czat lokalny , na nim piszemy tylko rzeczy poza grą.", "/b dzisiaj moja mama powiedziała ze mam kare?" },
					{ "/me", "/me [IC Akcja]", "Czat używany pod litera T służy do odgrywania akcji.", "/me podaje ręke Nieznajomemu." },
					{ "/do", "/do", "Służy do symulacji zdarzeń i okolic. Podobne do / me.", "/do Silnik zepsuty." },
					{ "/pm", "/pm [Gracz] [OOC Tekst]", "Wysyłanie prywatnych wiaodmości , jednak jest to czat OOC.", "/pm z/w" },
					{ "/s", "/s [IC Tekst]", "Uzywanie tej komendy działa jako krzyk", "/s Pomocy! ukradli mi portwel!" },
					{ "/f", "/f [OOC Tekst]", "Czat frakcyjny , jest to czat OOC , każda frakcja go posiada (LSPD, ...)", "/f Dostałem wczoraj bana" },
					{ "/m", "/m [IC Tekst]", "Jest to komenda na używanie megafonu , szczególnie przydatna dla LSPD.", "/m LSPD! Wypad z auta!" },
					{ "/w", "/w [gracz] [IC Text]", "Używanie tej komendy do szeptu do innego Gracza", "/w Jack_Konstantine on patrzy na mnie." },
					{ "/cw", "/cw [IC Text]", "Uzywanie tje komendy służy za szept do graczy w pojeździe.", "/cw Czekajcie tu na mnie." },
					{ "/c", "/c [IC Text]", "Szept do wszystkich osób które są najbliżej ciebie.", "/c idzie w lewo , potem go dopadniemy." },
				},
				{
					name = "Frakcje",
					{ "'F3'", "Klawisz 'F3'", "Panel frakcyjny.", "'F3'" },
					{ "/dyzur", "/dyzur", "Właczenie dyżuru pracy", "/dyżur" },
					{ "/odznaka", "/odznaka [gracz] [number/name]", "Nadanie graczowi odznaki.", "/odznaka Nathan_Daniels N.Daniels.64" },
					{ "Liderzy", "/fpark", "Parkowanie pojazdu frakcyjnego , zapis jego pozycji do spawnu.", "/fpark"},
					{ "PD", "/wsparcie", "Wezwanie wsparcia (komenda tylko dla Police Department)", "/wsparcie" },
					{ "PD", "/odcisk [gracz]", "Zebranie odcisku palca danej osobie , wymaga do odegrania akcji.", "/odcisk Richard_Banks" },
					{ "PD", "/mandat [gracz] [udane] [powód]", "Wystawienie mandatu dla gracza.", "/mandat Richard_Banks 500 wypadek" },
					{ "PD", "/odbierzlicencje [gracz] [license] [hours=0]", "Takes the license from a player. They have to re-do the license later.", "/takelicense Daniela_Lane 1 20" },
					{ "PD", "/aresztuj [gracz] [fine] [minutes] [crimes]", "Arrests a player for a given amount of time.", "/arrest Daniela_Lane 500 15 Evading" },
					{ "PD", "/jailtime", "Shows how much time in jail you have left.", "/jailtime" },
					{ "PD", "/mdc", "Komputer pokładowy policji.", "/mdc" },
					{ "PD", "/rbs", "system blokad drogowych", "/rbs" },
					{ "PD", "/delrb [id] or /delroadblock [id]", "Usuwanie blokad drogowych.", "/delrb 3" },
					{ "PD", "/delallrbs or /delallroadblocks", "Usunięcie wszystkich blokad drogowych.", "/delallrbs" },
					{ "PD", "/usunkolczatke [id]", "Usunięcie kolczatki.", "/removespikes 3" },
					{ "ES", "/ulecz [gracz]", "Leczenie gracza , TYLKO W SZPITALU po odegraniu akcji", "/ulecz Joe" },
					{ "ES", "/firefighter", "Dyzur dla fire-figihterów/Strażaków.", "/firefighter" },
					{ "SAN", "/wywiad [gracz]", "Przeprowadzenie wywiadu z graczem.", "/wywiad Hans_Vanderburg" },
					{ "SAN", "/zakonczwywiad [gracz]", "Zakończenie wywiadu.", "/zakonczwywiad Hans_Vanderburg" },
					{ "SAN", "/i [IC Text]", "rozmowa w wywiadzie.", "/i Yeah, it was pretty hard to come up with that idea." },
					{ "SAN", "/tognews", "Włączenie nadawania newsów lub wyłączenie.", "/tognews" },
					{ "SAN", "/news", "wysyłanie wiadomości , twój numer jest dołączany.", "/news Mam ochote dzisiaj poruszyć temat...." },
					{ "SAN", "/forecast", "Informacje na temat pogody.", "/forecast" },
				},
				{
					name = "Pojazdy",
					{ "'J'", "Klawisz 'J'", "Właczanie/Wyłączanie silnika.", "'J'" },
					{ "'K'", "Klawisz 'K'", "Zamykanie , otwieranie pojazdu.", "'K'" },
					{ "'L'", "Klawisz 'L'", "SWłaczanie/wyłączanie świateł.", "'L'" },
					{ "'P'", "Klawisz 'P'", "Właczenie świateł policyjnych.", "'P'" },
					{ "'N'", "Klawisz 'N'", "Właczenie syren policyjnych.", "'N'" },
					{ "/zaparkuj", "/zaparkuj", "Zapisanie pozycji pojazdu , oraz jego pozycji respawnu.", "/zaparkuj" },
					{ "/sprzedaj", "/sprzedaj [gracz]", "Oddanie auta drugiemu graczowi.", "/sprzedaj Nathan_Daniels" },
					{ "/reczny", "/reczny", "Zaciągnięcie hamulca ręcznego.", "/reczny" },
					{ "/wywal", "/wywal [gracz]", "Wyrzucenie gracza z twojego auta.", "/wywal James_Halt" },
					{ "/cc or /cruisecontrol", "/cc", "Właczenie kontroli prędkośći.", "/cc" },
					{ "/okno", "/okno", "Otwieranie /zamykanie okna w aucie", "/okno" },
				},
				{
					name = "Budynki",
					{ "'F'", "kliknięcie 'F'", "Wejście do interioru", "'F'" },
					{ "'K'", "Kliknięcie 'K'", "Otwieranie zamykanie domu.", "'K'" },
					{ "/sdom", "/sell [gracz]", "Sprzedanie domu innej osobie.", "/sdom Hans_vanderburg" },
					{ "/sellproperty", "/sellproperty", "Sells the interior you're in back to the Government", "/sellproperty" },
					{ "/zakonczwynajem", "/zakonczwynajem", "Zakończenie wynajmu parceli.", "/zakonczwynajem" },
					{ "/setfee", "/setfee [cena]", "Ustalenie ceny wejściowej do danego interioru , dotyczy tylko biznesów", "/setfee 20" },
					{ "/movesafe", "/movesafe", "Moves the safe in the interior you're in.", "/movesafe" },
					{ "/checksupplies", "/checksupplies", "Sprawdzenie ilości towaru w sklepie.", "/checksupplies" },
					{ "/ordersupplies", "/ordersupplies [cena]", "Zakup nowego towaru do sklepu.", "/ordersupplies 10" },
				},
				{
					name = "Przedmioty",
					{ "'I'", "Kliknicie 'I'", "Otwarcie twojego plecaka/kieszeni.", "'I'" },
					{ "'F5'", "Press 'F5'", "Shows the GPS.", "'F5'" },
					{ "/alkomat", "/alkomat [gracz]", "Sprawdzenie poziomu alkocholu dla danego gracza.", "/alkomat [gracz]" },
					{ "/writenote", "/writenote [IC Text]", "Writes a note on a piece of a notebook.", "/writenote Call me if you want to hang out - #12345" },
					{ "/togglecradar", "/togglecradar", "Toggles the Police Radar.", "/togglecradar" },
					{ "/odbierz", "/odbierz", "Odbieranie rozmowy.", "/pickup" },
					{ "/p", "/p [IC Text]", "Rozmawianie przez telefon.", "/p Hej jak sie masz?" },
					{ "/loudspeaker", "/loudspeaker", "Toggles the phone's loudspeaker, letting other people around you hear the call.", "/loudspeaker" },
					{ "/rozlacz", "/rozlacz", "Zakończenie połączenia" },
					{ "/togglephone", "/togglephone", "Toggles your phone on or off. sponsorzy only.", "/togglephone" },
					{ "/sms", "/sms [numer] [IC tekst]", "Wysyłanie wiaodmości sms.", "/sms 12444 Spotkajmy sie pod urzedem." },
				},
				{
					name = "Prace",
					{ "/startbus", "/startbus", "Rozpoczyna prace kierowcy autobusu.", "/startbus" },
					{ "/ryby", "/ryba", "Rozpoczęcie łowienia ryb", "/ryby" },
					{ "/sprzedajryby", "/sellfish", "Sells your caught fish at the fish market.", "/sellfish" },
					{ "/copykey", "/copykey [type] [id]", "Copies a house, business or vehicle key.", "/copykey 1 50" },
					{ "/zwolnijsie", "Zwolnienie sie z pracy" },
					{ "'Klakson'", "Dla taksówkarzy , kliknięcie przycisku włącza/wyłącza lampe.", "'Horn'" },
				},
				{
					name = "Inne",
					{ "/?", "/?", "Pomoc dla nowych graczy.", "/?" },
					{ "'O'", "Klawisz 'O' ", "Lista przyjaciół.", "'O'" },
					{ "'N'", "Klawisz 'N'", "Zmienianie trybu broni.", "'N'" },
					{ "'F6'", "Klawisz 'F6'", "Menu języków.", "'F6'" },
					{ "/togglespeedo", "/togglespeedo", "Właczenie/Wyłaczenie prędkościomierza.", "/togglespeedo" },
					{ "/clearchat", "/clearchat", "Wyczyszczenie czatu.", "/clearchat" },
					{ "/settag", "/settag [1-8]", "Ustawianie tagu na spreju.", "/settag 2" },
					{ "/animlist", "/animlist", "Lista animacji.", "/animlist" },
					{ "/daj", "/daj [gracz] [amount]", "Przekazanie małej sumy dla innej osoby do ręki.", "/daj Ari_Viere 400" },
					{ "/staty", "/staty", "Statystyki twojej postaci.", "/staty" },
					{ "/gate", "/gate", "Opens various doors, some might require faction membership, a badge or a password", "/gate" },
					{ "/klej", "/klej", "Komenda używana tlyko w razie przypadków problemu z grą.", "/klej" },
					{ "/pokazdokumenty", "/pokazdokumenty [gracz]", "Pokazanie dokumentów danej osobie.", "/pokazdokumenty Darren_Baker" },
				}
			}
			--[[
				icreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommand, "/i", false, false )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommanduse, "/i <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommandexplanation, "This allows an interviewee to participate in the interview." , false, false )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommandexample, "/i At that time, I never thought my idea would be so successful.", false, false )
				]]
			
			for _, levelcmds in pairs( commands ) do
				local tab = guiCreateTab( levelcmds.name, tabPanel)
				local list = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab)
				guiGridListAddColumn (list, "Komenda", 0.15)
				guiGridListAddColumn (list, "Do czego to jest?", 0.2)
				guiGridListAddColumn (list, "", 0.5)
				guiGridListAddColumn (list, "Przykład", 0.7)
				for _, command in ipairs( levelcmds ) do
					local row = guiGridListAddRow ( list )
					guiGridListSetItemText ( list, row, 1, command[1], false, false)
					guiGridListSetItemText ( list, row, 2, command[2], false, false)
					guiGridListSetItemText ( list, row, 3, command[3], false, false)
					guiGridListSetItemText ( list, row, 4, command[4], false, false)
				end
			end
			
			addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
				if (button == "left") then
					if (state == "up") then
						guiSetVisible(myCommandsWindow, false)
						showCursor (false)
						guiSetInputEnabled(false)
						myCommandsWindow = nil
					end
				end
			end, false)

			guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
		else
			local visible = guiGetVisible (myCommandsWindow)
			if (visible == false) then
				guiSetVisible( myCommandsWindow, true)
				showCursor (true)
			else
				showCursor(false)
			end
		end
	end
end
addCommandHandler("komendy", commandsHelp)