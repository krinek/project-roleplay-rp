local licence=[[

====================================================================================================
(c) Daniex0r <daniex0r@gmail.com>
Wszelkie prawa zastrzezone. Nie masz prawa rozpowszechniać, oraz używać tego kodu bez mojej zgody

W celu zakupu całego gamemodu, pisz mail: kontakt@dgoj.netshock.pl

Napisano na potrzeby serwera Project-Roleplay (2012 - 2013) 
2013-

====================================================================================================

]]

radio = 0
lawVehicles = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [470]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true }

local totalStreams = 17 --Zaktualizuj liczbe jeżeli dodasz więcej radiostacji.
local theTimer
local customFont = dxCreateFont ("myriadproregular.ttf",20)
local streams = { }
--Wzór: źródła[następny nr stacji] = { "Link nadajnika", "Nazwa stacji" }
streams[1] = {"http://205.188.215.228:8002/", "Power 181"} --1-- Działa 15/10/2012
streams[2] = {"http://relay.181.fm:8014/", "80's Hairband FM"} --2-- Działa 15/10/2012
streams[3] = {"http://relay.181.fm:8068/", "Old School Rap"} --3-- Działa 15/10/2012
streams[4] = {"http://relay.181.fm:8770/", "Energy 98"}  --4-- Działa 15/10/2012
streams[5] = {"http://72.233.84.175:80", "Dubstep.FM"}  --5-- Działa 15/10/2012
streams[6] = {"http://204.45.73.122:8014", "Reggae 141"} --6-- Działa 15/10/2012
streams[7] = {"http://www.slamfm.nl/slamplayer/SLAMFM_MEDIAPLAYER.asx", "SlamFM"} --7-- Działa 15/10/2012
streams[8] = {"http://www.di.fm/mp3/hardcore.pls", "Hardcore"} --8-- Działa 15/10/2012
streams[9] = {"http://82.201.100.10:8000/WEB11", "538 HitZone"} --9-- Działa 15/10/2012
streams[10] = {"http://www.bbc.co.uk/radio/listen/live/r1.asx", "BBC Radio 1"} --10-- Działa 15/10/2012
streams[11] = {"http://205.188.215.229:8040/", "Hot 108 Jamz"} --11-- Działa 15/10/2012
streams[12] = {"http://media-ice.musicradio.com:80/CapitalMP3", "Capital FM"} --12-- Działa 15/10/2012
streams[13] = {"http://icy-e-02.sharp-stream.com:80/kerrang.mp3.m3u", "Kerrang"} --13--  Działa 15/10/2012
streams[14] = {"http://kiis-fm.akacast.akamaistream.net/7/572/19773/v1/auth.akacast.akamaistream.net/kiis-fm", "Kiis FM LA"} --14--  Działa 15/10/2012
streams[15] = {"http://www.fear.fm/streamrelay/playlist/harder.pls", "Fear FM - Harder"} --15-- Działa 17/10/2012
streams[16] = {"http://www.181.fm/stream/asx/181-xsoundtrax.asx", "181.FM Christmas Spirit"} -- Nie testowano
streams[17] = {"http://www.181.fm/stream/asx/181-xmix.asx", "181.FM Christmas Mix"} -- tak samo

local soundElement = nil
local soundElementsOutside = { }

function check(thePlayer)
	outputChatBox(getElementData(getLocalPlayer(), "streams"), 255, 0, 0)
end
addCommandHandler("checkme", check, false, false)

function setVolume(commandName, val)
	if tonumber(val) then
		val = tonumber(val)
		if exports.global:hasItem(getPedOccupiedVehicle(getLocalPlayer()), 204) then
			if (val >= 0 and val <= 100) then
				triggerServerEvent("car:radio:vol", getLocalPlayer(), val)
				return
				outputChatBox("Głośność ustawiona na " ..val.. ".", 255, 0, 0)
			else
				outputChatBox("Z systemem stereo - /setvol[1 - 100]", 255, 0, 0)
			end
		else
			if (val >= 0 and val <= 60) then
				triggerServerEvent("car:radio:vol", getLocalPlayer(), val)
				return
				outputChatBox("Głośność ustawiona na " ..val.. ".", 255, 0, 0)
			else
				outputChatBox("Bez systemu stereo - /setvol[1 - 60]", 255, 0, 0)
			end
		end
	else
		outputChatBox("Z systemem stereo[1 - 100] - Bez systemu stereo[1-60]", 255, 0, 0)
	end
end
addCommandHandler("setvol", setVolume)

local textShowing = false
function showStation()
	local screenwidth, screenheight = guiGetScreenSize ()
	local width = 300
	local height = 100
	local x = (screenwidth - width)/2
	local y = screenheight - (screenheight/8 - (height/8)) 
	local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
	local streamID = getElementData(theVehicle, "vehicle:radio") or 0
	local streamTitle
	if streamID > 0 and streamID <= #streams then
		streamTitle = streams[streamID][2]
	else
		streamTitle = "Radio Wyłączone"
	end
	dxDrawText (streamTitle, 44, screenheight - 43, screenwidth, screenheight, tocolor ( 255, 255, 255, 255 ), 0.6, customFont )
end

function removeTheEvent()
	removeEventHandler("onClientRender", getRootElement(), showStation)
	textShowing = false
end

function saveRadio(station)	
	local radios = 0
	if (station == 0) then
		return
	end

	
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	
	if getVehicleType(vehicle) == "BMX" then	
	cancelEvent()
		outputChatBox("Ten pojazd nie posiada radia!", player, 255, 0, 0)
		return
	end
		
	if (vehicle) then
		if getVehicleOccupant(vehicle) == getLocalPlayer() or getVehicleOccupant(vehicle, 1) == getLocalPlayer() then
			if (station == 12) then	
				if (radio == 0) then
					radio = totalStreams + 1
				end
				
				if (streams[radio - 1]) then
					radio = radio - 1
				else
					radio = 0
				end
			elseif (station == 0) then
				if (streams[radio+1]) then
					radio = radio+1
				else
					radio = 0
				end
			end
			if not textShowing then
				addEventHandler("onClientRender", getRootElement(), showStation)
				theTimer = setTimer(removeTheEvent, 3000, 1)
				textShowing = true
			else
				removeEventHandler("onClientRender", getRootElement(), showStation)
				addEventHandler("onClientRender", getRootElement(), showStation)
				if isTimer(theTimer) then
					killTimer(theTimer)
				end
				theTimer = setTimer(removeTheEvent, 3000, 1)
			end
			triggerServerEvent("car:radio:sync", getLocalPlayer(), radio)
		end
		cancelEvent()
	end
end
addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)

addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(),
	function(theVehicle)
		stopStupidRadio()
		radio = getElementData(theVehicle, "vehicle:radio") or 0
		updateLoudness(theVehicle)
	end
)

addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(),
	function(theVehicle)
		stopStupidRadio()
		radio = getElementData(theVehicle, "vehicle:radio") or 0
		updateLoudness(theVehicle)
	end
)

function stopStupidRadio()
	removeEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
	setRadioChannel(0)
	addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
end

addEventHandler ( "onClientElementDataChange", getRootElement(),
	function ( dataName )
		if getElementType ( source ) == "vehicle" and dataName == "vehicle:radio" then
			local newStation =  getElementData(source, "vehicle:radio") or 0
			if (isElementStreamedIn (source)) then
				if newStation ~= 0 then
					stopSound(soundElementsOutside[source])
					local x, y, z = getElementPosition(source)
					newSoundElement = playSound3D(streams[newStation][1], x, y, z, true)
					soundElementsOutside[source] = newSoundElement
					updateLoudness(source)
					setElementDimension(newSoundElement, getElementDimension(source))
					setElementDimension(newSoundElement, getElementDimension(source))
				else
					if (soundElementsOutside[source]) then
						stopSound(soundElementsOutside[source])
						soundElementsOutside[source] = nil
					end
				end
			end
		elseif getElementType(source) == "vehicle" and dataName == "vehicle:windowstat" then
			if (isElementStreamedIn (source)) then
				if (soundElementsOutside[source]) then
					updateLoudness(source)
				end
			end
		elseif getElementType(source) == "vehicle" and dataName == "vehicle:radio:volume" then
			if (isElementStreamedIn (source)) then
				if (soundElementsOutside[source]) then
					updateLoudness(source)
				end
			end
		end
	end 
)

addEventHandler( "onClientPreRender", getRootElement(),
	function()
		if soundElementsOutside ~= nil then
			for element, sound in pairs(soundElementsOutside) do
				if (isElement(sound) and isElement(element)) then
					local x, y, z = getElementPosition(element)
					setElementPosition(sound, x, y, z)
					setElementInterior(sound, getElementInterior(element))
					getElementDimension(sound, getElementDimension(element))
				end
			end
		end
	end	
)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function()	
		local vehicles = getElementsByType("vehicle")
		for _, theVehicle in ipairs(vehicles) do
			if (isElementStreamedIn(theVehicle)) then
				spawnSound(theVehicle)
			end
		end
	end
)

addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()),
	function()	
		local vehicles = getElementsByType("vehicle")
		for _, theVehicle in ipairs(vehicles) do
			if (isElementStreamedIn(theVehicle)) then
				spawnSound(theVehicle)
			end
		end
	end
)

function spawnSound(theVehicle)
	local newSoundElement = nil
    if getElementType( theVehicle ) == "vehicle" then
		local radioStation = getElementData(theVehicle, "vehicle:radio") or 0
		if radioStation ~= 0 then
			if (soundElementsOutside[theVehicle]) then
				stopSound(soundElementsOutside[theVehicle])
			end
			local x, y, z = getElementPosition(theVehicle)
			newSoundElement = playSound3D(streams[radioStation][1], x, y, z, true)
			soundElementsOutside[theVehicle] = newSoundElement
			setElementDimension(newSoundElement, getElementDimension(theVehicle))
			setElementDimension(newSoundElement, getElementDimension(theVehicle))
			updateLoudness(theVehicle)
		end
    end
end

function updateLoudness(theVehicle)
	local windowState = getElementData(theVehicle, "vehicle:windowstat") or 1
	local carVolume = getElementData(theVehicle, "vehicle:radio:volume") or 60
	
	carVolume = carVolume / 100
	
	--  gracz w środku
	if (getPedOccupiedVehicle( getLocalPlayer() ) == theVehicle) then
		setSoundMinDistance(soundElementsOutside[theVehicle], 40)
		setSoundMaxDistance(soundElementsOutside[theVehicle], 80)
		setSoundVolume(soundElementsOutside[theVehicle], 1*carVolume)
	elseif (windowState == 1) then -- okna otwarte, gracz na zewnatrz
		setSoundMinDistance(soundElementsOutside[theVehicle], 10)
		setSoundMaxDistance(soundElementsOutside[theVehicle], 20)
		setSoundVolume(soundElementsOutside[theVehicle], 0.5*carVolume)
	elseif (getPedOccupiedVehicle( getLocalPlayer() ) ~= theVehicle) and (getPedOccupiedVehicle( getLocalPlayer() ))then
		local derp = getPedOccupiedVehicle( getLocalPlayer())
		local wstate = getElementData(derp, "vehicle:windowstat") or 1
		if wstate == 0 then
			setSoundMinDistance(soundElementsOutside[theVehicle], 3)
			setSoundMaxDistance(soundElementsOutside[theVehicle], 10)
			setSoundVolume(soundElementsOutside[theVehicle], 0.1)
		end
	else -- na zewnątrz z zamkniętymi oknami
		setSoundMinDistance(soundElementsOutside[theVehicle], 3)
		setSoundMaxDistance(soundElementsOutside[theVehicle], 10)
		setSoundVolume(soundElementsOutside[theVehicle], 0.1*carVolume)
	end

end

addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
		spawnSound(source)
    end
)

addEventHandler( "onClientElementStreamOut", getRootElement( ),
    function ( )
		local newSoundElement = nil
        if getElementType( source ) == "vehicle" then
			if (soundElementsOutside[source]) then
				stopSound(soundElementsOutside[source])
				soundElementsOutside[source] = nil
			end
        end
    end
)