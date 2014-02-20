local licence=[[

==============================================================================
Project-Roleplay (c) Daniex0r <daniex0r@gmail.com>
Wszelkie prawa zastrzezone.

2013-

]]


local pedTable = { }
local characterSelected, characterElementSelected
function Characters_showSelection()
	triggerEvent("onSapphireXMBShow", getLocalPlayer())
	showPlayerHudComponent("radar", false)
	
	
	
	guiSetInputEnabled(false)
	if not isCursorShowing ( ) then
		showCursor(false)
	end
	setElementDimension ( getLocalPlayer(), 1 )
	setElementInterior( getLocalPlayer(), 0 )
	local x = 825.55703125
	local y = -2049.3876953125
	local z = 12.8671875
	local characterList = getElementData(getLocalPlayer(), "account:characters")
	if (characterList) then
		-- Tworzymy pedy
		for _, v in ipairs(characterList) do
			local thePed = createPed( tonumber( v[9]), x, y, z)
			setPedRotation(thePed, 180)
			setElementDimension(thePed, 1)
			setElementInterior(thePed, 0)
			setElementData(thePed,"account:charselect:id", v[1], false)
			setElementData(thePed,"account:charselect:name", v[2]:gsub("_", " "), false)
			setElementData(thePed,"account:charselect:cked", v[3], false)
			setElementData(thePed,"account:charselect:lastarea", v[4], false)
			setElementData(thePed,"account:charselect:lastseen", v[10], false)
			setElementData(thePed,"account:charselect:age", v[5], false)
			setElementData(thePed,"account:charselect:weight", v[11], false)
			setElementData(thePed,"account:charselect:height", v[12], false)
			setElementData(thePed,"account:charselect:desc", v[13], false)
			setElementData(thePed,"account:charselect:age", v[5], false)
			setElementData(thePed,"account:charselect:gender", v[6], false)
			setElementData(thePed,"account:charselect:faction", v[7] or "", false)
			setElementData(thePed,"account:charselect:factionrank", v[8] or "", false)
			
			
			local randomAnimation = getRandomAnim( v[3] == 1 and 4 or 2 )
			setPedAnimation ( thePed , randomAnimation[1], randomAnimation[2], -1, true, false, false, false )
			
			x = x + 3
			if x > 849 then
				x = 825.55703125
				y = y + 3
			end
			
			table.insert(pedTable, thePed)
		end
		-- Zrobione!
		addEventHandler("onClientPreRender", getRootElement(), Characters_updateSelectionCamera)
	end
end

function Characters_characterSelectionVisisble()
	--addEventHandler("onClientClick", getRootElement(), Characters_onClientClick)
	local theElement = pedTable[1]
	characterSelected = getElementData(theElement,"account:charselect:id")			
			characterElementSelected = theElement			
			
			Characters_updateDetailScreen(theElement)
			
			local randomAnimation = nil
			for _, thePed in ipairs(pedTable) do
				local deceased = getElementData(thePed,"account:charselect:cked")
				if deceased ~= 1 then
					if thePed == theElement then
						randomAnimation = getRandomAnim( 1 )
					else
						randomAnimation = getRandomAnim( 2 )
					end
				else
					randomAnimation = getRandomAnim( 4 )
				end
				if randomAnimation then
					local anim1, anim2 = getPedAnimation(thePed)
					if randomAnimation[1] ~= anim1 or randomAnimation[2] ~= anim2 then
						setPedAnimation ( thePed , randomAnimation[1], randomAnimation[2], -1, true, false, false, false )
					end
				end
			end
end

local currposs = 10000
function Characters_updateSelectionCamera ()
	if (currposs > 10000) then -- Zrobione!
		removeEventHandler("onClientPreRender",getRootElement(),Characters_updateSelectionCamera)
		Characters_characterSelectionVisisble()
	end
	currposs = currposs + 140
	setCameraMatrix (826.013671875, -2052.3935546875, 12.920601844788, 0, currposs, 0)
end


function Characters_onClientClick(mouseButton, buttonState, alsoluteX, alsoluteY, worldX, worldY, worldZ, theElement)
	if (theElement) and (buttonState == "down") then
		if (getElementData(theElement,"account:charselect:id")) then
			
			characterSelected = getElementData(theElement,"account:charselect:id")			
			characterElementSelected = theElement			
			
			Characters_updateDetailScreen(theElement)
			
			local randomAnimation = nil
			for _, thePed in ipairs(pedTable) do
				local deceased = getElementData(thePed,"account:charselect:cked")
				if deceased ~= 1 then
					if thePed == theElement then
						randomAnimation = getRandomAnim( 1 )
					else
						randomAnimation = getRandomAnim( 2 )
					end
				else
					randomAnimation = getRandomAnim( 4 )
				end
				if randomAnimation then
					local anim1, anim2 = getPedAnimation(thePed)
					if randomAnimation[1] ~= anim1 or randomAnimation[2] ~= anim2 then
						setPedAnimation ( thePed , randomAnimation[1], randomAnimation[2], -1, true, false, false, false )
					end
				end
			end
			
		end
	end
end

-- ================================================================= TWORZENIE WYBORU POSTACI ==========================================================
local cFadeOutTime = nil
function Characters_createDetailScreen()

	
	local width, height = guiGetScreenSize()
	local sw,sh = guiGetScreenSize()

	
		imienazwisko = guiCreateLabel(15/30, 9/30, 14/30, 6/30, "",true)
		guiSetFont(imienazwisko, "sa-gothic")
		
		klawisze = guiCreateStaticImage(sw-187,sh-53,182,48,"files/klawisze.png",false)

	wybor = bindKey ( "enter", "up", Characters_selectCharacter, false )
	return true
end

function Characters_updateDetailScreen(thePed)
	if Characters_createDetailScreen() then
		
		guiSetText (imienazwisko, " " .. getElementData(thePed,"account:charselect:name") )
			
		if getElementData(thePed, "account:charselect:cked") == 1 then
			unbindKey ( "enter", "up", Characters_selectCharacter, false )
		else
			bindKey ( "enter", "up", Characters_selectCharacter, true )
		end
	end
end

function Characters_deactivateGUI()
	if isElement(wybor) then
		guiSetEnabled(imienazwisko, false )
	end
	removeEventHandler("onClientClick", getRootElement(), Characters_onClientClick)
end

function Characters_selectCharacter()
	if (characterSelected ~= nil) then
		Characters_deactivateGUI()
		local randomAnimation = getRandomAnim(3)
		setPedAnimation ( characterElementSelected, randomAnimation[1], randomAnimation[2], -1, true, false, false, false )
		cFadeOutTime = 254
		addEventHandler("onClientRender", getRootElement(), Characters_FadeOut) stopSound( __)
		triggerServerEvent("accounts:characters:spawn", getLocalPlayer(), characterSelected)
	end 
end

function Characters_FadeOut()
	cFadeOutTime = cFadeOutTime -3
	if (cFadeOutTime <= 0) then
		removeEventHandler("onClientRender", getRootElement(), Characters_FadeOut)
	else
		for _, thePed in ipairs(pedTable) do
			if thePed ~= characterElementSelected then
				setElementAlpha(thePed, cFadeOutTime)
			end
		end
	end
end

function characters_destroyDetailScreen()
	if (Characters_selectCharacter) then
		destroyElement(imienazwisko)
		destroyElement(klawisze)
		unbindKey ( "enter", "up", Characters_selectCharacter )
	end
	for _, thePed in ipairs(pedTable) do
		destroyElement(thePed)
	end
	pedTable = { }
	cFadeOutTime = 0
end
-- ================================================================= ZAMYKANIE WYBORU POSTACI ==========================================================


-- ================================================================= MUZYKA ==========================================================


--------------------------------------
cur_vol = 1
o_ile_sciszaj = 0.007
local _this_ = 0
--------------------------------------
function updateSoundVol()
	_this_ = setTimer(scisz, 50, 0)
end


function scisz()
	if isElement(G_SOUND_1) then
						if isTimer(_this_) and cur_vol <= 0 then
							killTimer(_this_)
							stopSound(G_SOUND_1)
						else isElement(G_SOUND_1)  
							cur_vol = cur_vol-o_ile_sciszaj
							setSoundVolume(G_SOUND_1,cur_vol)
						end
	end
end

-- ================================================================= KONIEC MUZYKI ==========================================================


-- ================================================================= SPAWN POSTACI ==========================================================


function characters_onSpawn(fixedName, adminLevel, gmLevel, factionID, factionRank)
	clearChat()
	showChat(true)
	showCursor(false)
	--characters_onSpawn("Grasz obecnie jako '" .. fixedName .. "'.", 0, 255, 0)
	--characters_onSpawn("Potrzebna pomoc? wpisz /?", 255, 194, 14)
	exports.info:showBox ("info","Grasz obecnie jako '" .. fixedName .. "'.Zapraszamy do odwiedzenia naszego forum project-roleplay.pl")
	outputChatBox(" ")
	characters_destroyDetailScreen()
	setElementData(getLocalPlayer(), "adminlevel", adminLevel, false)
	setElementData(getLocalPlayer(), "account:gmlevel", gmLevel, false)
	setElementData(getLocalPlayer(), "faction", factionID, false)
	setElementData(getLocalPlayer(), "factionrank", factionrank, false)
	updateSoundVol()
	options_enable()
	showPlayerHudComponent("weapon", true)
	showPlayerHudComponent("ammo", true)
	showPlayerHudComponent("vehicle_name", false)
	showPlayerHudComponent("money", true)
	showPlayerHudComponent("clock", false)
	showPlayerHudComponent("health", true)
	showPlayerHudComponent("armour", true)
	showPlayerHudComponent("breath", true)
	showPlayerHudComponent("area_name", true)
	showPlayerHudComponent("radar", true)

end
addEventHandler("accounts:characters:spawn", getRootElement(), characters_onSpawn)

-- ================================================================= KONIEC SPAWNU ==========================================================


fileDelete("c_characters.lua")