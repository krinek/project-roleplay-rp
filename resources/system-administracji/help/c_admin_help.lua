local myadminWindow = nil

function adminhelp (commandName)

	local sourcePlayer = getLocalPlayer()
	if exports.global:isPlayerAdmin(sourcePlayer) then
		if (myadminWindow == nil) then
			guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
			myadminWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Indeks komend administratora ANG by Support RG", false)
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
			local lists = {}
			for level = 1, 5 do 
				local tab = guiCreateTab("Level " .. level, tabPanel)
				lists[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (lists[level], "Komenda", 0.15)
				guiGridListAddColumn (lists[level], "Przykład", 0.35)
				guiGridListAddColumn (lists[level], "Wyjaśnienie", 1.3)
			end
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Zamknij", true, myadminWindow) -- close button
			
			local commands =
			{
				-- level 1: Trial Admin
				{
					-- player/*
					{ "/adminlounge", "/adminlounge", "Wyluzuj się w bazie." },
					{ "/forceapp", "/forceapp [ID gracza]", "Powoduje iż user musi napisac na nowo aplikację." },
					{ "/check", "/check [ID gracza]", "Pokazuje wszystkie informacje na temat gracza." },
					{ "/staty", "/staty [ID gracza]", "Pokazuje statystyki gracza." },
					{ "/history", "/history [player/account]", "Sprawdza  historię gracza, działa również w trybie offline." },
					{ "/auncuff", "/auncuff [ID gracza]", "Odkuwa gracza" },
					{ "/pmute", "/pmute [ID gracza]", "Blokuje czat graczowi" },
					{ "/togooc", "/togooc", "Włącza czat globalny lub wyłącza" },
					{ "/stogooc", "/stogooc", "Włacza czat po cichu bez informacji dla graczów (ooc)" },
					{ "/disarm", "/disarm [ID gracza]", "Usuwa wszystkie bronie graczowi jakie posiada." },
					{ "/freconnect", "/freconnect [ID gracza]", "Reconnectuje gracza" },
					{ "/giveitem", "/giveitem [ID gracza] [item id] [item value]", "Daje specyficzny item graczowi, zobacz /itemlist " },
					{ "/sethp", "/sethp [ID gracza] [new hp]", "Ustawia ilośc zycia (HP) graczowi." },
					{ "/setarmor", "/setarmor [ID gracza] [new armor]", "Ustawia pancerz graczowi." },
					{ "/setskin", "/setskin [ID gracza] [skin id]", "Ustawia skin graczowi." },
					{ "/changename", "/changename [ID gracza] [new character name]", "Zmienia dane osobowe postaci." },
					{ "/slap", "/slap [ID gracza]", "Usuwa HP od wysokości 15 i wyrzuca gracza w powietrze." },
					{ "/recon", "/recon [ID gracza]", "Podgląd gracza." },
					{ "/fuckrecon", "/stoprecon", "Wyłącza podgląd gracza." },
					{ "/pkick", "/pkick [ID gracza] [reason]", "Komenda wyrzuca gracza z serwera." },
					{ "/pban", "/pban [ID gracza] [hours] [reason]", "Zbanowanie gracza o danym czasie, podaj 0 jako godziny do stałego zakazu." },
					{ "/unban", "/unban [full char name]", "Odbanowywuje gracza." },
					{ "/unbanip", "/unbanip [ip]", "Odbanowanie poprzez IP." },
					{ "/unbanserial", "/unbanip [serial]", "Odbanowanie poprzez serial." },
					{ "/gotoplace", "/gotoplace [ls/sf/lv/pc]", "Teleportuje cię w jedno z tych 4 miejsc." },
					{ "/jail", "/jail [ID gracza] [minutes] [reason]", "Karanie gracza." },
					{ "/unjail", "/unjail [ID gracza]", "Anuluje kare z gracza" },
					{ "/jailed", "/jailed", "Pokazuje listę graczy w więcieniu adminów, pokazuje powód i czas." },
					{ "/goto", "/goto [ID gracza]", "Teleport do gracza." },
					{ "/gethere", "/gethere [ID gracza]", "Teleport gracza do ciebie." },
					{ "/sendto", "/gethere [ID gracza] [dest. player]", "Teleportuje gracza do innego gracza." },
					{ "/freeze", "/freeze [ID gracza]", "Zamraża gracza." },
					{ "/unfreeze", "/unfreeze [ID gracza]", "Odmraża gracza." },
					{ "/mark", "/mark [label]", "Zapis twojej pozycji." },
					{ "/gotomark", "/gotomark [label]", "Teleportacja do pozycji gdzie wpisałeś /mark." },
					{ "/dyzuradmin", "/dyzuradmin", "Wlaczanie lub wyłaczenie pracy admina." },
					{ "/setmotd", "/setmotd [wiadomość]", "Aktualizuje wiaodmośc dnia dla graczy." },
					{ "/setamotd", "/setamotd [wiadomość]", "Aktualizuje wiadomośc dnia dla adminów." },
					{ "/amotd", "/amotd", "Pokazuje obecną wiadomośc adminów." },
					{ "/warn", "/warn [ID gracza]", "Dodanie ostrzezenia dla gracza." },
					{ "/showinv", "/showinv [ID gracza]", "Pokazuje cały inwentarz gracza." },
					{ "/togmytag", "/togmytag", "Włącza twój nametag lub wyłącza." },
					{ "/dropme", "/dropme", "Zostań przy obecnej pozycji z /kamera." },
					{ "/disappear", "/disappear", "Niewidzialność." },
					{ "/listcarprices", "/listcarprices", "Pokazuje listę cen samochodów w salonach." },

					{ "/findalts", "/findalts [ID gracza]", "Pokazuje wszystkie postacie jakie ma dany gracz." },
					{ "/findip", "/findip [player/username/ip]", "Pokazuje wszystkie konta jakie posiada IP gracza." },
					{ "/findserial", "/findserial [player/username/serial]", "Pokazuje wszystkie konta z danego seriala." },

					{ "/setlanguage", "/setlanguage [ID gracza] [language] [skill]", "Dodanie języka dla gracza." },
					{ "/dellanguage", "/dellanguage [ID gracza] [language]", "Usuwanie języka graczowi." },
					{ "/aunblindfold", "/aunblindfold [ID gracza]", "Ściąganie opaski graczowi" },
					{ "/agivelicense", "/agivelicense [ID gracza] [type]", "Nadanie licencji graczowi. 1-Prawo Jazdy, 2-Broń." },
					{ "/resetcontract", "/resetcontract [ID gracza]", "Usunięcie kontraktu z pracą(przydaje sie do zwolnienia)." },

					-- vehicle/*
					{ "/carlist", "/carlist", "Wpisanie listy Id aut i ich kolorów. (nie działa)" },
					{ "/unflip", "/unflip", "Odwraca pojazd." },
					{ "/unlockcivcars", "/unlockcivcars", "Odklucza wszystkie cywilne auta." },
					{ "/oldcar", "/oldcar", "Pobiera identyfikator ostatniego samochodu, który prowadził dany gracz" },
					{ "/thiscar", "/thiscar", "Pobiera id bieżącej samochodu." },
					{ "/gotocar", "/gotocar [id]", "Teleportacja ciebie do auta." },
					{ "/getcar", "/getcar [id]", "Teleportacja wozu do ciebie." },
					{ "/nearbyvehicles", "/nearbyvehicles", "Pokazuje wszystkich pojazdów w promieniu 20." },
					{ "/respawnveh", "/respawnveh [id]", "Respawnuej dany pojazd z danym ID." },
					{ "/respawnall", "/respawnall", "Respawnuje kompletnie wszystkie auta." },
					{ "/respawndistrict", "/respawndirstrict", "Respawnuje wszystkie pojazdy w okolicy." },
					{ "/respawnciv", "/respawnciv", "Respawnuje wszystkie cywilne pojazdy." },
					{ "/findveh", "/findveh [name]", "Poszukuje wskazany pojazd." },
					{ "/fixveh", "/fixveh [ID gracza]", "Całkowita naprawa pojazdu." },
					{ "/fixvehs", "/fixvehs", "Naprawa wszystkich aut." },
					{ "/fixvehis", "/fixvehis [ID gracza]", "Naprawa pojazdu." },
					{ "/blowveh", "/blowveh [ID gracza]", "Powoduje wybuch auta." },--SkubiPL
					{ "/setcarhp", "/setcarhp [ID gracza]", "Ustawienie HP auta." },
					{ "/fuelveh", "/fuelveh [ID gracza]", "Zatankowanie jednego auta." },
					{ "/fuelvehs", "/fuelvehs", "Zatankowanie wsyzstkich aut." },
					{ "/setcolor", "/setcolor [ID gracza] [colors...]", "Zmienia koloru pojazdu." },
					{ "/getcolor", "/getcolor [car]", "Zwraca kolory pojazdu." },
					{ "/entercar", "/entercar [ID gracza] [car] [seat]", "Stawia gracza w danym pojeździe albo na siedzeniu pojazdu." },
					
					-- interior/*
					{ "/getpos", "/getpos", "Wysyła aktualną pozycję, wnętrza i wymiar." },
					{ "/x", "/x [value]", "Podanie pozycji x." },
					{ "/y", "/z [value]", "Podanie pozycji y." },
					{ "/z", "/y [value]", "Podanie pozycji z." },
					{ "/set*", "/set[any combination of xyz] [coordinates]", "Ustawianie pozycji - możliwe: x, y, z, xyz, xy, xz, yz." },
					{ "/reloadinterior", "/reloadinterior [id]","Łąduje na nowo interior." },
					{ "/nearbyinteriors", "/nearbyinteriors","Pokazuje pobliskie interiory." },
					{ "/setinteriorname", "/setinteriorname [newname]","Zmienia nazwe interioru." },
					{ "/setfee", "/setfee [kwota]","Ustala opłatę przy wejściu do wnętrza." },
					{ "/getinteriorid", "/getinteriorid","Pokazuje id domu."},
					
					-- election/*
					{ "/addcandidate", "/addcandidate", "Dodaj eplayera do listy elekcji." },
					{ "/delcandidate", "/delcandidate", "Usuwa playera z lsty elekcji." },
					{ "/showresults", "/showresults", "Pokazuje wyniki elekcji." },
					
					-- factions/*
					{ "/showfactions", "/showfactions", "Pokazuje wszystkie frakcje." },
					
					{ "/resetbackup", "/resetbackup [name]", "Reset systemu wsparcia policji2" },
					{ "/resetassist", "/resetassist", "Reset systemu wsparcia pogotowia." },
					{ "/resettowbackup", "/resettowbackup", "Zresetowanie systemu wsparcia." },
					{ "/aremovespikes", "/aremovespikes", "Usunięcie wsyzstkich kolczatek policj." },
					{ "/clearnearbytag", "/clearnearbytag", "Czyszczeni tagów." },
					{ "/nearbytags", "/nearbytags", "Pokazuje pobliżu tag." },
					
					{ "/changelock", "/changelock", "Ustawienie blokady domu/auta." },
					{ "/restartgatekeepers", "/restartgatekeepers", "Retsartuje skrypt bram." },
					
					{ "/bury", "/bury [ID gracza]", "Pogrzebanie gracza." },
					
					-- advert commands
					{ "/listadverts", "/listadverts", "Podaje listę z niedawno wpisanych i ogłoszeń w toku." },
					{ "/freeze", "/freezead [ID]", "Zapobiega ogłoszenie z emitowany jest, max to 10 minut." },
					{ "/unfreeze", "/unfreezead [ID]", "Odblokowanie advertu." },
					{ "/deletead", "/deletead [ID]", "Zaznacza ogłoszenie jako wyemitowany." },
				},
				-- level 2: Admin
				{
					{ "/superman", "/superman", "Aktywacja supermena." },
					{ "/gotohouse", "/gotohouse [id]", "Teleportacja do danego domu." },
					-- vehicles
					{ "/veh", "/veh [model] [color 1] [color 2]", "Spawn tymczasowego wozu." }

					
				},
				-- level 3: Super Admin
				{
					{ "/setweather", "/setweather", "Zmiana pogody." },
					
					-- vehicles
					{ "/delveh", "/delveh [id]", "Usuwa na zawsze pojazd z ID." },
					{ "/delthisveh", "/delthisveh", "Usuwa pojazd w którym siedzisz.(Na zawsze)" },
					{ "/makeveh", "/makeveh", "Tworzy pojazd." },
					{ "/makecivveh", "/makecivveh", "Twarzy cywilny pojazd." },
					{ "/addupgrade", "/addupgrade [ID gracza] [upgrade id]", "Ulepsza pojazd gracza." },
					{ "/setpaintjob", "/setpaintjob [ID gracza] [upgrade id]", "Ustawia malowanie pojazdu. (jeślij jest możliwe)" },
					{ "/setvariant", "/setvariant [ID gracza] [variant 1] [variant 2]", "Ustawia variant pojazdu." },
					{ "/delupgrade", "/delupgrade [ID gracza] [upgradeid]", "Usuwa ulepszenie pojazdu." },
					{ "/resetupgrades", "/resetupgrades [ID gracza]", "Usuwa wszystkie ulepszenia pojazdu." },
					{ "/aunimpound", "/aunimpound [vehicle id]", "konfiskuje pojazd od BTR" },
					{ "/setvehtint", "/setvehtint [ID gracza] [0- Remove, 1- Add]", "Dodaje lub usuwa odcień pojazdu." },
					{ "/atakelicense", "/atakelicense [ID gracza] [type]", "Usuwa licencję gracza." },
					{ "/setvehicleplate", "/setvehicleplate [carid] [plate text]", "Zmiana rejestracji pojazdu." },
					{ "/setvehiclefaction", "/setvehiclefaction [vehicleid] [factionid]", "Zmiana właściciela pojazdu na frakcję, użyj factionid -1 by ustawić na siebie." },
					-- elevatorssa
					{ "/addelevator", "/addelevator [interior] [dimension] [x] [y] [z]", "Tworzy windę." },
					{ "/delelevator", "/delelevator [id]", "Usuwa windę." },
					{ "/nearbyelevators", "/nearbyelevators", "Pobliskie windy." },
					{ "/toggleelevator", "/toggleelevator [id]", "Włącz/wyłącz windę." },

					
					
				},
				-- level 4: Lead Admins
				{
					
					{ "/addatm", "/addatm", "Dodaje bankomat." },
					{ "/delatm", "/delatm [id]", "Usuwa bankomat z id" },
					{ "/nearbyatms", "/nearbyatms", "Pobliskie bankomaty." },
					{ "/bigears", "/bigears [ID gracza]", "Podsłuch czatu pomiędzy graczami. (pm)" },
					{ "/bigearsf", "/bigearsf [factionid]", "Podsłuch czatu frakcji." },
					
					-- paynspray/*
					{ "/makepaynspray", "/addpaynspray", "Twarzy pay n spray." },
					{ "/nearbypaynsprays", "/nearbypaynsprays", "Pobliskie pay n spray." },
					{ "/delpaynspray", "/delpaynspray [id]", "Usuwa pay n spray" },
					
					-- phone/*
					{ "/addphone", "/addphone", "Tworzenie publicznego telefonu" },
					{ "/nearbyphones", "/nearbyphones", "Pobliskie publiczne telefony." },
					{ "/delphone", "/delphone [id]", "Usuwa publiczny telefon." },
					
					-- interiors/*
					{ "/enableallelevators", "/enableallelevators", "Włącza wszystkie windy." },
					
					{ "/addinterior", "/addinterior  [Interior ID] [TYP] [Koszt] [Nazwa]","Dodaje interior." },
					{ "/sellproperty", "/sellproperty","Sprzedaje interior." },
					{ "/delinterior", "/delproperty","Usuwa iterior." },
					{ "/getinteriorid", "/getinteriorid [id]","Pokazuje dany interior." },
					{ "/setinteriorid", "/setinteriorid [id]","Zmiana interioru." },
					{ "/getinteriorprice", "/getinteriorprice","Pokazuje cene interioru." },
					{ "/setinteriorprice", "/setinteriorprice [price]","Zmienia cenę interioru." },
					{ "/getinteriortype", "/getinteriortype","Pokazuje typ interioru." },
					{ "/setinteriortype", "/setinteriortype [type]","Zmienia typ interioru." },
					{ "/toggleinterior", "/toggleinterior [id]","Włącz/wyłącz interior." },
					{ "/enableallinteriors", "/enableallinteriors","Włącza wszystkie interiory" },
					{ "/setinteriorexit", "/setinteriorexit","Zmiana pozycji wyjścia z interioru." },
					{ "/setinteriorentrance", "/setinteriorentrance  [Interior ID]","Zmiana pozycji wejścia do interioru." },
					
					-- factions/*
					{ "/setfactionleader", "/setfactionleader [ID gracza] [factionid]", "Przyznaje graczowi lidera frakcji." },
					{ "/setfactionrank", "/setfactionrank [ID gracza] [rank]", "Przyznaje rangę graczowi w frakcji." },
					{ "/makefaction", "/makefaction [type] [name]", "Tworzenie frakcji." },
					{ "/renamefaction", "/renamefaction [id] [new name]", "Zmienia nazwę frakcji." },
					{ "/setfaction", "/setfaction [id] [factionid]", "Dodaje gracza do frakcji." },
					{ "/delfaction", "/delfaction [id]", "Usuwa frakcję." },
					
					-- fuelpoints/*
					{ "/addfuelpoint", "/addfuelpoint", "Tworzy nową stację benzynową." },
					{ "/nearbyfuelpoints", "/nearbyfuelpoints", "Pobliskie stacje." },
					{ "/delfuelpoint", "/delfuelpoint [id]", "Usuwa stację benzynową." },
					
					-- player/*
					{ "/ck", "/ck [ID gracza] [cause of death]", "Zabicie postaci." },
					{ "/unck", "/unck [ID gracza]", "odrodzenie postaci." },
					
					-- Weapons
					{ "/makegun", "/makegun", "Daje broń." },
					{ "/makeammo", "/makeammo", "Dodaje amunicję do broni." },
					
					-- Etc
					{ "/setmoney", "/setmoney [ID gracza] [money]", "Ustaia ilość pieniędzy graczowi." },
					{ "/givemoney", "/givemoney [ID gracza] [money]", "Dodaje graczowi pieniądze." },
					{ "/resetcharacter", "/resetcharacter [Firstname_Lastname]", "Pełny reste postaci." },
					{ "/setvehlimit", "/setvehlimit [ID gracza] [limit]", "Ustawia graczowi limit pojazdów." },
					{ "/adminstats", "Pokazuje statystyki adminów." }
				},
				-- level 5: Head Admins
				{
					-- player/*
					{ "/punkty", "/punkty [ID gracza] [points] [reason]", "Nagradza gracza punktami." },
					{ "/hideadmin", "/hideadmin", "Wydzialnoćś/niewidzialność statusu admina." },
					{ "/ho", "/ho [text]", "Wysyła wiadomość OOC jako ukryty admin." },
					{ "/hw", "/hw [ID gracza] [text]", "Wysyła ukrytą wiadomość jako ukryty admin." },
					{ "/makeadmin", "/makeadmin [ID gracza] [rank]", "Daje graczowi admina/gamemoda." },
					
					-- resource/*
					{ "/startres", "/startres [resource name]", "Startuje resource." },
					{ "/stopres", "/stopres [resource name]", "Stop resource." },
					{ "/restartres", "/restartres [resource name]", "Restart resource." },
					{ "/rescheck", "/rescheck", "Sprawdza skrypty i je włącza." },
					{ "/rcs", "/rcs", "sprawdza czy skrypt \"test-skryptow\" działa." }
				}
			}
			
			for level, levelcmds in pairs( commands ) do
				if #levelcmds == 0 then
					local row = guiGridListAddRow ( lists[level] )
					guiGridListSetItemText ( lists[level], row, 1, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 2, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 3, "Nia ma komend dla tego poziomu admina.", false, false)
				else
					for _, command in pairs( levelcmds ) do
						local row = guiGridListAddRow ( lists[level] )
						guiGridListSetItemText ( lists[level], row, 1, command[1], false, false)
						guiGridListSetItemText ( lists[level], row, 2, command[2], false, false)
						guiGridListSetItemText ( lists[level], row, 3, command[3], false, false)
					end
				end
			end
			
			addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
				if (button == "left") then
					if (state == "up") then
						guiSetVisible(myadminWindow, false)
						showCursor (false)
						guiSetInputEnabled(false)
						myadminWindow = nil
					end
				end
			end, false)
			
			guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
		else
			local visible = guiGetVisible (myadminWindow)
			if (visible == false) then
				guiSetVisible( myadminWindow, true)
				showCursor (true)
			else
				showCursor(false)
			end
		end
	end
end
addCommandHandler("ah", adminhelp)
