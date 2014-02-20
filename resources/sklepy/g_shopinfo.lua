--- clothe shop skins
blackMales = { 310, 311, 300, 301, 302, 296, 297, 268, 269, 270, 271, 272, 7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = {305, 306, 307, 308, 309, 312, 303, 299, 291, 292, 293, 294, 295, 1, 2, 23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 272 }
asianMales = {290, 49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294}
blackFemales = {304, 298, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256, 304 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}
local fittingskins = {[0] = {[0] = blackMales, [1] = whiteMales, [2] = asianMales}, [1] = {[0] = blackFemales, [1] = whiteFemales, [2] = asianFemales}}
-- Removed 9 as a black female
-- these are all the skins
skins = { 1, 2, 268, 269, 270, 271, 272, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 178, 179, 180, 181, 182, 183, 184, 185, 186, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 263, 264 }

g_shops = {
	{ -- 1
		name = "General Store",
		description = "This shop sells all kind of general purpose items.",
		image = "general.png",
		
		{
			name = "General Items",
			{ name = "Kwiatki", description = "Bukiet slodkich kwiatków.", price = 5, itemID = 115, itemValue = 14 },
--			{ name = "Ksiażka telefoniczna", description = "Duża książka, która zna numer do każdego.", price = 30, itemID = 7 },
			{ name = "Kość", description = "Czarna kość z białymi kropkami, idealna do gier.", price = 2, itemID = 10 },
			{ name = "Kij golfowy", description = "idealny kij golfowy do trafiania za pierwszym razem.", price = 60, itemID = 115, itemValue = 2 },
			{ name = "kij bejsbolowy", description = "Traf w dom i uciekaj z tym.", price = 60, itemID = 115, itemValue = 5 },
			{ name = "Łopata", description = "doskonałe nażędzie do kopania dziur.", price = 40, itemID = 115, itemValue = 6 },
			{ name = "Kij bilardowy", description = "Do gry w bilarda.", price = 35, itemID = 115, itemValue = 7 },
			{ name = "Trzcina", description = "Kij nigdy nie miał takiej klasy.", price = 65, itemID = 115, itemValue = 15 },
			{ name = "Gaśnica", description = "Używaj jej gdy pojawi się pożar", price = 50, itemID = 115, itemValue = 42 },
			{ name = "Sprej", description = "Do malowania tagow!", price = 50, itemID = 115, itemValue = 41 },
			{ name = "Spadochron", description = "Jeđli nie chcesy spađ na yiemie, lepiej kup jeden", price = 400, itemID = 115, itemValue = 46 },
			{ name = "Przewodnik po mieście", description = "Mały przewodnik po mieście w książeczce.", price = 15, itemID = 18 },
			{ name = "Plecak", description = "Plecak o rozsądnych wymiarach.", price = 30, itemID = 48 },
			{ name = "Wędka", description = "Wędka z włókna węglowego.", price = 300, itemID = 49 },
			{ name = "Maska", description = "Maska narciarska.", price = 20, itemID = 56 },
                        { name = "Sprzęt do nurkowania", description = "Sprzęt do nurkowania pod wodą.", price = 800, itemID = 120 },
			{ name = "Kalnister", description = "Mału metalowy kalnister.", price = 35, itemID = 57, itemValue = 0 },
			{ name = "Apteczka", description = "Apteczka pierwszej pomocy", price = 15, itemID = 70, itemValue = 3 },
			{ name = "Mini Notatnik", description = "Pusty notatnik, możesz napisać 5 notatek.", price = 10, itemID = 71, itemValue = 5 },
			{ name = "Notatnik", description = "Pusty notatnik, możesz napisać 50 notatek.", price = 15, itemID = 71, itemValue = 50 },
			{ name = "XXL Notatnik", description = "Pusty notatnik, możesz napisac 125 notatek.", price = 20, itemID = 71, itemValue = 125 },
			{ name = "Kask", description = "Kaska do używania podczas jazdy motocyklem.", price = 100, itemID = 90 },

			{ name = "Paczka papierosów", description = "To co chcesz palić...", price = 10, itemID = 105, itemValue = 20 },
			{ name = "Zapalniczka", description = "Aby zapalić swoje uzależnienie, prawdziwa Zippo!", price = 45, itemID = 107 },
			{ name = "Nóż", description = "Dobry pomocnik w kuchni.", price = 15, itemID = 115, itemValue = 4 },
			{ name = "Podkładka pod karty", description = "Chcesz zagrać?", price = 10, itemID = 77 },
		},
		{
			name = "Materiały eksploatacyjne",
			{ name = "Kanapka", description = "Smaczna kanapka z serem.", price = 6, itemID = 8 },
			{ name = "Oranżada", description = "Puszka Sprunka.", price = 3, itemID = 9 },
		}
	},
	{ -- 2
		name = "Broń i Amunicja",
		description = "Wszystkie Twoje bronie od roku 1914.",
		image = "gun.png",
		
		{
			name = "Broń i Amunicja",
			{ name = "Pistolet 9mm", description = "Srebrny, 9mm Pistolet.", price = 850, itemID = 115, itemValue = 22, license = true },
			{ name = "Magazynek 9mm", description = "Magazynek z 17 nabojami, compatible with an Colt-45 pistol.", price = 65, itemID = 116, itemValue = 22, ammo = 17, license = true },
			{ name = "Shotgun", description = "Srebrny shotgun.", price = 1049, itemID = 115, itemValue = 25, license = true },
			{ name = "10 Beanbag Rounds", description = "10rund w niższej cenie!.", price = 89, itemID = 116, itemValue = 25, ammo = 10, license = true },
			{ name = "Wiejska strzelba", description = "Wiejska strzelba", price = 1599, itemID = 115, itemValue = 33, license = true },
			{ name = "Magazynek do wiejskiej strzelby", description = "Magazynek do wiejskiej strzelby z 10 nabojami", price = 220, itemID = 116, itemValue = 33, ammo = 10, license = true },
		}
	},
	{ -- 3
		name = "Sklep z jedzeniem",
		description = "Najmniej zatrute jedzenie i napoje na świecie.",
		image = "food.png",
		
		{
			name = "Żywność",
			{ name = "Kanapka", description = "Mniam kanapka z serem", price = 5, itemID = 8 },
                        { name = "Kapusta", description = "Głow akapusty", price = 5, itemID = 102 },
			{ name = "Taco", description = "A świetne mexykańskie taco", price = 7, itemID = 11 },
			{ name = "Burger", description = "Podwójny cheeseburger z bekonem", price = 6, itemID = 12 },
			{ name = "Pączek", description = "Pączek z lukrem", price = 3, itemID = 13 },
			{ name = "Ciastko", description = "Luksusowe ciastko z czekoladą", price = 3, itemID = 14 },
			{ name = "Hotdog", description = "Niezły, smaczny hotdog!", price = 5, itemID = 1 },
			{ name = "Naleśnik", description = "Mniam, Naleśnik!!", price = 2, itemID = 108 },
		},
		{
			name = "Napoje",
			{ name = "Oranżada", description = "Zimna piszka Sprunka.", price = 5, itemID = 9 },
			{ name = "Woda", description = "Butelka wody mineralnej.", price = 3, itemID = 15 },
		}
	},
	{ -- 4
		name = "Sex Shop",
		description = "Wszystkie elementy potrzebne do idealnej nocy.",
		image = "sex.png",
		
		{
			name = "Sexy",
			{ name = "Długie, fioletowe Dildo", description = "Bardzo długie, fioletowe dildo", price = 20, itemID = 115, itemValue = 10 },
			{ name = "Krótkie Dildo", description = "Małe dildo.", price = 15, itemID = 115, itemValue = 11 },
			{ name = "wibrator", description = "Wibrator, co wiecej trzeba powiedzieć?", price = 25, itemID = 115, itemValue = 12 },
			{ name = "Kwiaty", description = "Bukiet dla ukochanej.", price = 5, itemID = 115, itemValue = 14 },
			{ name = "Kajdanki", description = "Para metalowych kajdanek.", price = 90, itemID = 45 },
			{ name = "Lina", description = "Długa lina.", price = 15, itemID = 46 },
			{ name = "Opaska", description = "Czarna opaska.", price = 15, itemID = 66 },
		},
		{
			name = "Odziez",
			{ name = "Skin 87", description = "Seksowne ubranie dla seksownego czlowieka.", price = 55, itemID = 16, itemValue = 87 },
			{ name = "Skin 178", description = "Seksowne ubranie dla seksownego czlowieka.", price = 55, itemID = 16, itemValue = 178 },
			{ name = "Skin 244", description = "Seksowne ubranie dla seksownego czlowieka.", price = 55, itemID = 16, itemValue = 244 },
			{ name = "Skin 246", description = "Seksowne ubranie dla seksownego czlowieka.", price = 55, itemID = 16, itemValue = 246 },
			{ name = "Skin 257", description = "Seksowne ubranie dla seksownego czlowieka.", price = 55, itemID = 16, itemValue = 257 },
		}
	},
	{ -- 5
		name = "Sklep odzieżowy",
		description = "Nie wyglądam grubo w tym!",
		image = "clothes.png",
		-- Items to be generated elsewhere.
		{
			name = "Odzież dla Ciebie"
		},
		{
			name = "Inne"
		}
	},
	{ -- 6
		name = "Sala gimnastyczna",
		description = "Najlepsze miejsce do zapoznawania sie ze sztukami walki.",
		image = "general.png",
		
		{
			name = "Sztuki walki",
			{ name = "Standardowa walka", description = "Standardowa do codziennej walki.", price = 10, itemID = 20 },
			{ name = "Box", description = "Mike Tyson, po narkotykach.", price = 50, itemID = 21 },
			{ name = "Kung Fu", description = "Wiem kung-fu, więc możesz.", price = 50, itemID = 22 },
			-- item ID 23 is just a greek book, anyhow :o
			{ name = "Grab & Kick", description = "Kopnij go w...!", price = 50, itemID = 24 },
			{ name = "Łokcie", description = "Możesz patrzeć z opuźnieniem, ale będziesz kopać w dupe!", price = 50, itemID = 25 },
		}
	},
	{ -- 7
		name = "Wspaniałe artykuły itp.",
		description = "Twój jeden i tylko przystanek na dostawy.",
		image = "general.png",
		
		{
			name = "Skrzynki i artykuły",
			{ name = "Małe pudło", description = "Pudło wypełnione towarem.", price = 15, itemID = 121, itemValue = 20 },
			{ name = "Srednie pudło", description = "Pudło wypełnione towarem.", price = 35, itemID = 121, itemValue = 50 },
			{ name = "Duże pudło", description = "Pudło wypełnione towarem.", price = 55, itemID = 121, itemValue = 100 },
			{ name = "Wielkie pudło", description = "Pudło wypełnione towarem.", price = 75, itemID = 121, itemValue = 140 },
		}
	},
	{ -- 8
		name = "Sklep elektroniczny",
		description = "Najnowsza technologia, niezwykle droga dla Ciebie.",
		image = "general.png",
		
		{
			name = "Fantazyjna elektronika",
			{ name = "Ghettoblaster", description = "Czarny ghettoblaster.", price = 250, itemID = 54 },
			{ name = "Kamera", description = "Mała, czarna analogowa kamera.", price = 75, itemID = 115, itemValue = 43 },
			{ name = "Telefon", description = "Stylowy, mały telefon.", price = 75, itemID = 2 },
			{ name = "Radio", description = "Czarne radio.", price = 50, itemID = 6 },
			{ name = "Słuchawki", description = "Słuchawki do użycia aby słuchać radia.", price = 225, itemID = 88 },
			{ name = "zegarek", description = "Zegarek nigdy nie był tak sexy!", price = 25, itemID = 17 },
			{ name = "Odtwarzacz", description = "Biały, Miły dla oka odtwarzacz MP3. Marki EyePod.", price = 120, itemID = 19 },
			{ name = "Zestaw chemika", description = "Mały zestaw chemika.", price = 2000, itemID = 44 },
			{ name = "Sejf", description = "Sejf do przechowywania itemów.", price = 300, itemID = 60 },
			{ name = "GPS", description = "GPS - nawigacja samochodowa.", price = 300, itemID = 67 },
			{ name = "Przenośny GPS", description = "Osobisty GPS, posiadający najnowsze mapy.", price = 800, itemID = 111 },
			{ name = "PDA", description = "PDA do czytania emaili i przeglądania internetu.", price = 1500, itemID = 96 },
			{ name = "Przenośne TV", description = "Przenośne TV do oglądania TV.", price = 750, itemID = 104 },
			{ name = "bramki-przejazdu Pass", description = "Do twojego samochodu. Automatycznie pobiera opłate po przejeżdzie prtzez bramke opłat.", price = 400, itemID = 118 },
		}
	},
	{ -- 9
		name = "Sklep monopolowy",
		description = "Wszystko od wódki po piwa i na odwrót.",
		image = "general.png",
		
		{
			name = "Alkohol",
			{ name = "Piwo Ziebrand", description = "Finezyjne piwo, Importowane z Holandii.", price = 10, itemID = 58 },
			{ name = "Wódka Bastradov", description = "Twój najlepszy przyjaciel - Wódka Bastradov.", price = 25, itemID = 62 },
			{ name = "Szkocka Whiskey", description = "Najlepsza Szkocka Whiskey, teraz ekskluzywnie produkowana z kukurydzy.", price = 15, itemID = 63 },
			{ name = "Oranżada", description = "Zimna puszka Sprunka.", price = 3, itemID = 9 },
		}
	},
	{ -- 10
		name = "Księgarnia",
		description = "Nowe rzeczy do nauki? Brzmi jak... zabawa?!",
		image = "general.png",
		
		{
			name = "Ksiązki",
			{ name = "Przewodnik miejski", description = "Mały przewodnik w książeczce.", price = 15, itemID = 18 },
			{ name = "Kodeks drogowy", description = "Kodeks drogowy w książce.", price = 10, itemID = 50 },
			{ name = "Chemia 101", description = "Ciężka książka na studia.", price = 20, itemID = 51 },
		}
	},
	{ -- 11
		name = "Kawiarnia",
		description = "Chcesz troche czekolady na krawędzi?",
		image = "food.png",
		
		{
			name = "Żywność",
			{ name = "Pączek", description = "Pączek polany cukrem", price = 3, itemID = 13 },
			{ name = "Ciastko", description = "Luksusowe ciastko z czekoladą", price = 3, itemID = 14 },
		},
		{
			name = "Napoje",
			{ name = "Kawa", description = "Mały kubek kawy.", price = 1, itemID = 83, itemValue = 2 },
			{ name = "Orenżada", description = "Zimna puszka Sprunka.", price = 3, itemID = 9, itemValue = 3 },
			{ name = "Woda", description = "Butelka mineralnej wody.", price = 1, itemID = 15, itemValue = 2 },
		}	
	},
	{ -- 12
		name = "Święty Grotto",
		description = "Ho-ho-ho, Wesołych świąt.",
		image = "general.png",
		
		{
			name = "Świąteczne przedmioty",
			{ name = "Prezent świąteczny", description = "CO jest w środku?", price = 0, itemID = 94 },
			{ name = "Eggnog", description = "Mniam Mniam!", price = 0, itemID = 91 },
			{ name = "Turkey", description = "Mniam Mniam!", price = 0, itemID = 92 },
			{ name = "Świąteczny puding", description = "Mniam Mniam!", price = 0, itemID = 93 },
		}
	},
	{ -- 13
		name = "Narkotyki",
		description = "Teraz wygląda... Niezbyt smacznie.",
		image = "general.png",
		
		{
			name  = "Narkotyki",
                        { name = "Cannabis Sativa", description = "chemikalia do tworzenia narkotykow", price = 550, itemID = 30 },
			{ name = "Alkoida Kokainy", description = "chemikalia do tworzenia narkotykow", price = 650, itemID = 31 },
			{ name = "Kwas lizerowy", description = "chemikalia do tworzenia narkotykow", price = 750, itemID = 32 },
			{ name = "Nieprzetwożone PCP", description = "chemikalia do tworzenia narkotykow", price = 1000, itemID = 33 },
		}
	},
	{ -- 14
		name = "One Stop Mod Shop",
		description = "Wszystkie części, które będziesz potrzebowac!",
		image = "general.png",
		
		-- items to be filled in later
		{
			name = "Vehicle Parts"
		}
	}
}

-- some initial updating once you start the resource
function loadLanguages( )
	local shop = g_shops[ 10 ]
	for i = 1, exports['system-jezykow']:getLanguageCount() do
		local ln = exports['system-jezykow']:getLanguageName(i)
		if ln then
			table.insert( shop[1], { name = ln .. " Dictionary", description = "A Dictionary, useful for learning " .. ln .. ".", price = 25, itemID = 69, itemValue = i } )
		end
	end
end

addEventHandler( "onResourceStart", resourceRoot, loadLanguages )
addEventHandler( "onClientResourceStart", resourceRoot, loadLanguages )

-- util

function getItemFromIndex( shop_type, index )
	local shop = g_shops[ shop_type ]
	if shop then
		for _, category in ipairs( shop ) do
			if index <= #category then
				return category[index]
			else
				index = index - #category
			end
		end
	end
end

--
local simplesmallcache = {}
function updateItems( shop_type, race, gender )
	if shop_type == 5 then -- clothes shop
		-- one simple small cache it is - prevents us from creating those tables again and again
		--[[
		local c = simplesmallcache[tostring(race) .. "|" .. tostring(gender)]
		if c then
			shop = c
			return
		end
		]]
		
		-- load the shop
		local shop = g_shops[shop_type]
		
		-- clear all items
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end
		
		-- uber complex logic to add skins
		local nat = {}
		local availableskins = fittingskins[gender][race]
		table.sort(availableskins)
		for k, v in ipairs(availableskins) do
			table.insert( shop[1], { name = "Skin " .. v, description = "MTA Skin #" .. v .. ".", price = 50, itemID = 16, itemValue = v, fitting = true } )
			nat[v] = true
		end
		
		local otherSkins = {}
		for gendr = 0, 1 do
			for rac = 0, 2 do
				if gendr ~= gender or rac ~= race then
					for k, v in pairs(fittingskins[gendr][rac]) do
						if not nat[v] then
							table.insert(otherSkins, v)
						end
					end
				end
			end
		end
		table.sort(otherSkins)
		
		for k, v in ipairs(otherSkins) do
			table.insert( shop[2], { name = "Skin " .. v, description = "MTA Skin #" .. v .." - to ubranie na ciebie NIE PASUJE.", price = 50, itemID = 16, itemValue = v } )
		end
		-- simplesmallcache[tostring(race) .. "|" .. tostring(gender)] = shop
	elseif shop_type == 14 then
		-- param (race)= vehicle model
		local c = simplesmallcache["vm"]
		if c then
			return
		end
		
		-- remove old data
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end
		
		for v = 1000, 1193 do
			if vehicle_upgrades[v-999] then
				local str = exports['system-przedmiotow']:getItemDescription( 114, v )
				
				local p = str:find("%(")
				local vehicleName = ""
				if p then
					vehicleName = str:sub(p+1, #str-1) .. " - "
					str = str:sub(1, p-2)
				end
				table.insert( shop[1], { name = vehicleName .. ( getVehicleUpgradeSlotName(v) or "Lights" ), description = str, price = vehicle_upgrades[v-999][2], itemID = 114, itemValue = v})
			end
		end
		
		simplesmallcache["vm"] = true
	end
end
