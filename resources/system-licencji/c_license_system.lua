wLicense, licenseList, bAcceptLicense, bCancel = nil
local Adam = createPed(186, -2034.9501953125, -118.1201171875, 1035.171875)
setPedRotation(Adam, 268.74)
setElementDimension(Adam, 4)
setElementInterior(Adam, 3)
setElementData( Adam, "talk", 1, false )
setElementData( Adam, "name", "Adam Brzuzka", false )

LICEMCING = false

function doTimer(thePed)
	setElementPosition(thePed, 683.41015625, -467.6689453125, -21.351913452148)
	setPedRotation(thePed, 0)
end
setTimer(doTimer, 30000000000, 0, Johnson)

local localPlayer = getLocalPlayer()

function showLicenseWindow()
	triggerServerEvent("onLicenseServer", getLocalPlayer())
	
	local vehiclelicense = getElementData(getLocalPlayer(), "license.car")

	local width, height = 300, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wLicense= guiCreateWindow(x, y, width, height, "Osrodek Szkolenia Kierowców", false)
	
	licenseList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, wLicense)
	local column = guiGridListAddColumn(licenseList, "Licencja", 0.7)
	local column2 = guiGridListAddColumn(licenseList, "Koszt", 0.2)
	
	if (vehiclelicense~=1) then
		local row = guiGridListAddRow(licenseList)
		guiGridListSetItemText(licenseList, row, column, "Licencja Prawa Jazdy", false, false)
		guiGridListSetItemText(licenseList, row, column2, "450", true, false)
	end
				
	bAcceptLicense = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Kup licencje", true, wLicense)
	bCancel = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Zamknij okno", true, wLicense)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", bAcceptLicense, acceptLicense)
	addEventHandler("onClientGUIClick", bCancel, cancelLicense)
end
addEvent("onLicense", true)
addEventHandler("onLicense", getRootElement(), showLicenseWindow)

function acceptLicense(button, state)
	if (source==bAcceptLicense) and (button=="left") then
		local row, col = guiGridListGetSelectedItem(jobList)
		
		if (row==-1) or (col==-1) then
			outputChatBox("Zaznacz pierw licencje ", 255, 0, 0)
		else
			local license = 0
			local licensetext = guiGridListGetItemText(licenseList, guiGridListGetSelectedItem(licenseList), 1)
			local licensecost = tonumber(guiGridListGetItemText(licenseList, guiGridListGetSelectedItem(licenseList), 2))
			
			if (licensetext=="Licencja Prawa Jazdy") then
				license = 1
			end
			
			if (license>0) then
				if not exports.global:hasMoney( getLocalPlayer(), licensecost ) then
					outputChatBox("Nie stać cie na zakup praktyk na Prawo jazdy.", 255, 0, 0)
				else
					if (license == 1) then
						if getElementData(getLocalPlayer(), "license.car") < 0 then
							outputChatBox( "You need to wait another " .. -getElementData(getLocalPlayer(), "license.car") .. " hours before being able to obtain a " .. licensetext .. ".", 255, 0, 0 )
						elseif (getElementData(getLocalPlayer(),"license.car")==0) then
							triggerServerEvent("payFee", getLocalPlayer(), 100)
							createlicenseTestIntroWindow() -- take the drivers theory test.
							destroyElement(licenseList)
							destroyElement(bAcceptLicense)
							destroyElement(bCancel)
							destroyElement(wLicense)
							wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
							showCursor(false)
						elseif(getElementData(getLocalPlayer(),"license.car")==3) then
							initiateDrivingTest()
						end
					end
				end
			end
		end
	end
end

function cancelLicense(button, state)
	if (source==bCancel) and (button=="left") then
		destroyElement(licenseList)
		destroyElement(bAcceptLicense)
		destroyElement(bCancel)
		destroyElement(wLicense)
		wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
		showCursor(false)
	end
end

   ------------ TUTORIAL QUIZ SECTION - SCRIPTED BY PETER GIBBONS (AKA JASON MOORE), ADAPTED BY CHAMBERLAIN --------------
   
   
   
   
questions = { 

	{"Po , któej stronie ulicy nalezy sie poruszać?", "Lewa", "Prawa", "po środku", 2},
	{"Gdy ktoś udeży w twój pojazd , co zrobisz?", "Zatrzymam sie i wytłumaczę wytuacje.", "Pojade dalej.", "Wyjde z gry.", 1}, 
	{"Jaką prędkością należy poruszać sie w mieście?", "60.", "56.", "123.", 1},
	{"Kiedy sygnalizacja wzkazuje czerwone światło to...", "Zatrzymuję sie.", "Jade dalej.", "nie wiem co zrobie.", 1},
	{"Czy Kierowcy muszą ustąpić pierwszeństwa pieszym:", "Zawsze.", "Na własności prywatnej.", "Tylko w przejściu. ", 1},
	{"Podczas stłuczki wysiadasz z wozu i ....", "Wzywam pomoc drogową.", "bije poszkodowanego", "Krzycze na wszystkich." , 1},
	{"Pojazd uprzywilejowany jedzie za tobą na sygnale , co wtedy robisz?:", "Zwalniam i ustepuje drogi.", "GAZ DO DECHY.", "jade jak jechałem. ", 1},
	{"Na drodze jadą dwa pojazdy na dwóch pasach równocześnie kierowca jednego powinien:", "Udezyć w coś.", "Jechać dalej tak samo.", "Zjechać na prawy pas i ustąpić pasa.", 3},
	{"Niezaleznie od pogody światła muszą być:", "Wyłaczone.", "Właczone.", "wymontowane.", 2},
	{"Uzywanie kierunkowskazów jest:", "Wymagane", "Zalecane", "Niepotrzebne", 1}
}

guiIntroLabel1 = nil
guiIntroProceedButton = nil
guiIntroWindow = nil
guiQuestionLabel = nil
guiQuestionAnswer1Radio = nil
guiQuestionAnswer2Radio = nil
guiQuestionAnswer3Radio = nil
guiQuestionWindow = nil
guiFinalPassTextLabel = nil
guiFinalFailTextLabel = nil
guiFinalRegisterButton = nil
guiFinalCloseButton = nil
guiFinishWindow = nil

-- variable for the max number of possible questions
local NoQuestions = 10
local NoQuestionToAnswer = 7
local correctAnswers = 0
local passPercent = 80
		
selection = {}

-- functon makes the intro window for the quiz
function createlicenseTestIntroWindow()
	
	showCursor(true)
	
	outputChatBox("Zapłaciłeś 100 $ aby podjąć egzamin teoretyczny.", source, 255, 194, 14)
	
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Teoria" , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindow)
	
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, [[Będziesz teraz przystępować do egzaminu na prawo jazdy teorii. wyniki twojego testu muszą wynosić
minimalnie 80%

Powodzenia.]], true, guiIntroWindow)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1, "center", true )
	guiSetFont ( guiIntroLabel1,"default-bold-small")
	
	guiIntroProceedButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Startuj Test" , true ,guiIntroWindow)
	
	addEventHandler ( "onClientGUIClick", guiIntroProceedButton,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startLicenceTest()
			guiSetVisible(guiIntroWindow, false)
		
		end
	end, false)
	
end


-- function create the question window
function createLicenseQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindow = guiCreateWindow ( X , Y , Width , Height , "Pytanie "..number.." z "..NoQuestionToAnswer , false )
	
	guiQuestionLabel = guiCreateLabel(0.1, 0.2, 0.9, 0.2, selection[number][1], true, guiQuestionWindow)
	guiSetFont ( guiQuestionLabel,"default-bold-small")
	guiLabelSetHorizontalAlign ( guiQuestionLabel, "left", true)
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1Radio = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][2], true,guiQuestionWindow)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2Radio = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][3], true,guiQuestionWindow)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3Radio = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][4], true,guiQuestionWindow)
	end
	
	-- if there are more questions to go, then create a "next question" button
	if(number < NoQuestionToAnswer) then
		guiQuestionNextButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Następne pytanie" , true ,guiQuestionWindow)
		
		addEventHandler ( "onClientGUIClick", guiQuestionNextButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindow, false)
					createLicenseQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButton = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Zakończ" , true ,guiQuestionWindow)
		
		-- handler for when the player clicks submit
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create the finish window
					guiSetVisible(guiQuestionWindow, false)
					createTestFinishWindow()


				end
			end
		end, false)
	end
end


-- funciton create the window that tells the
function createTestFinishWindow()

	local score = math.floor((correctAnswers/NoQuestionToAnswer)*100)

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "Koniec testu.", false )
	
	if(score >= passPercent) then
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
	
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "gratulcje zdałeś test!.", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "Twój wynik "..score.."%, zaś minimun to "..passPercent.."%. !" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center", true)
		
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Dalej" , true ,guiFinishWindow)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- set player date to say they have passed the theory.
				

				initiateDrivingTest()
				-- reset their correct answers
				correctAnswers = 0
				toggleAllControls ( true )
				triggerEvent("onClientPlayerWeaponCheck", source)
				--cleanup
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalPassTextLabel)
				destroyElement(guiFinalRegisterButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalPassTextLabel = nil
				guiFinalRegisterButton = nil
				guiFinishWindow = nil
				
				correctAnswers = 0
				selection = {}
				
				showCursor(false)
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
	
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "No cóż , mogło być lepiej.", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "Twój wynik "..math.ceil(score).."%, zaś minimun to "..passPercent.."%." ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center", true)
		
		guiFinalCloseButton = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Zamknij" , true ,guiFinishWindow)
		
		-- if player click the close button
		addEventHandler ( "onClientGUIClick", guiFinalCloseButton,  function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalFailTextLabel)
				destroyElement(guiFinalCloseButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalFailTextLabel = nil
				guiFinalCloseButton = nil
				guiFinishWindow = nil
				
				selection = {}
				correctAnswers = 0
				
				showCursor(false)
			end
		end, false)
	end
	
end
 
 -- function starts the quiz
 function startLicenceTest()
 
	-- choose a random set of questions
	chooseTestQuestions()
	-- create the question window with question number 1
	createLicenseQuestionWindow(1)
 
 end
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseTestQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(testQuestionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (testQuestionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questions[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function testQuestionAlreadyUsed(number)
 
	local same = 0
 
	-- loop through all the current selected questions
	for i, j in pairs(selection) do
		-- if a selected question is the same as the new question
		if(j[1] == questions[number][1]) then
			same = 1 -- set same to 1
		end
		
	end
	
	-- if same is 1, question already selected to return true
	if(same == 1) then
		return true
	else
		return false
	end
 end

---------------------------------------
------ Test Praktyczny Prawko ---------
---------------------------------------
 
testRoute = {
	{ 1263.9621582031, -1454.9920654297, 13.530010223389 },	-- Start, Parking Szkola 1
	{ 1268.6079101562, -1479.9012451172, 13.539012908936 },	-- Parking Szkola 2
	{ 1288.0932617188, -1479.6346435547, 13.539012908936 }, -- Parking Szkola 3
	{ 1269.4409179688, -1479.9500732422, 13.539012908936 }, -- Parking Szkola 4
	{ 1275.8410644531, -1467.9324951172, 13.539012908936 }, -- Parking Szkola 5
	{ 1282.7551269531, -1455.7655029297, 13.529010772705 }, -- Parking Szkola 6
	{ 1302.0930175781, -1456.6190185547, 13.529010772705 },	-- Parking Szkola 7
	{ 1302.0930175781, -1456.6190185547, 13.529010772705 }, -- Parking Szkola 8 
	{ 1298.7846679688, -1477.2850341797, 13.539012908936 }, -- Parking Szkola 9
	{ 1307.4565429688, -1475.1571044922, 13.539012908936 },	-- Parking Szkola 10
	{ 1311.5109863281, -1456.2801513672, 13.529010772705 },	-- Parking Szkola 11
	{ 1312.0219726562, -1467.0428466797, 13.539012908936 },	-- Parking Szkola 12
	{ 1306.3598632812, -1479.1131591797, 13.539012908936 },	-- Parking Szkola 13
	{ 1318.5391845703, -1481.1114501953, 13.542562484741 },	-- Parking Szkola 14 -- wyjazd na droge
	{ 1337.8896484375, -1483.884765625, 13.546875 },	-- Pierwszy na drodze
	{ 1346.9619140625, -1473.6484375, 13.14213180542 },	-- Drugi na drodze
	{ 1354.5302734375, -1422.0869140625, 13.150249481201 },	-- Trzeci na drodze
	{ 1355.1787109375, -1337.5234375, 13.152635574341 },	-- Czwarty na drodze
	{ 1350.6591796875, -1284.43359375, 13.142384529114 },	-- Piaty na drodze
	{ 1305.1103515625, -1278.2373046875, 13.143216133118 },	-- Szósty na drodze
	{ 1229.5595703125, -1278.4697265625, 13.143345832825 }, 	-- Mulholland parking [[Park backwards]]
	{ 1218.103515625, -1264.23046875, 13.596525192261 }, 	-- Mulholland parking [[Parked position]]
	{ 1218.908203125, -1168.1357421875, 22.624382019043 }, 	-- Mulholland parking [[Resume]]
	{ 1198.3974609375, -1141.66796875, 23.480579376221 }, 	-- Mulholland parking
	{ 1133.5107421875, -1141.7919921875, 23.416030883789 }, 	-- Mulholland parking
	{ 1092.9208984375, -1141.2421875, 23.416904449463 }, -- Mulholland parking
	{ 1084.9228515625, -1119.275390625, 23.752141952515 }, 			-- Mulholland parking, Turn to East Vinewood Blvd
	{ 1084.912109375, -1053.056640625, 30.969449996948 }, 	-- East Vinewood Blvd, turn to Sunset Blvd
	{ 1068.060546875, -1037.365234375, 31.723628997803 }, 	-- DRODZE!
	{ 976.2216796875, -1037.3212890625, 29.905565261841 }, 	-- Sunset Blvd
	{ 960.4091796875, -1055.99609375, 28.47975730896 }, 	-- Sunset Blvd
	{ 960.8330078125, -1131.4580078125, 23.472204208374 }, 	-- Sunset Blvd, Turn to St. Lawrence Blvd
	{ 947.568359375, -1138.740234375, 23.463848114014 }, 	-- St. Lawrence Blvd
	{ 940.8291015625, -1171.0830078125, 21.056158065796 }, 	-- St. Lawrence Blvd, turn to West Broadway
	{ 940.2529296875, -1301.9736328125, 13.556270599365 }, 	-- West Broadway
	{ 918.076171875, -1319.146484375, 13.233815193176 }, -- West Broadway
	{ 817.18359375, -1319.7080078125, 13.244825363159 }, 	-- Interstate 25
	{ 735.1640625, -1317.4970703125, 13.1550989151 }, 	-- Interstate 25
	{ 652.5498046875, -1317.3046875, 13.134889602661 }, 	-- Interstate 125
	{ 628.6611328125, -1347.029296875, 13.153239250183 }, 	-- Interstate 125
	{ 627.3046875, -1439.005859375, 13.822235107422 }, -- Interstate 125
	{ 626.81640625, -1572.359375, 15.237054824829 }, -- Interstate 125
	{ 662.9052734375, -1589.1259765625, 14.166621208191 }, 	-- Interstate 125
	{ 749.5234375, -1610.2890625, 12.456244468689 }, 		-- Interstate 125, turn to Saints Blvd
	{ 752.759765625, -1750.775390625, 12.445428848267 }, 	-- Saints Blvd, turn to St Anthony St.
	{ 730.7998046875, -1757.3818359375, 14.108450889587 }, 		-- St Anthony St, turn to Saints Blvd
	{ 448.4501953125, -1704.0927734375, 10.286143302917 }, 	-- Saints Blvd
	{ 275.470703125, -1682.8017578125, 7.7874979972839 }, 	-- Saints Blvd
	{ 166.404296875, -1572.4150390625, 12.179349899292 }, -- Saints Blvd, turn to Caesar Rd
	{ 164.662109375, -1553.19921875, 11.362063407898 }, 		-- mid turn
	{ 195.220703125, -1524.9306640625, 12.99263381958 }, 	-- Caesar Rd
	{ 279.9189453125, -1486.6875, 31.744359970093 }, 	-- Caesar Rd
	{ 311.43359375, -1478.8994140625, 33.120830535889 }, 	-- Caesar Rd, turn to Freedom St
	{ 383.22265625, -1419.8076171875, 33.876934051514 }, -- Freedom St
	{ 415.958984375, -1448.83984375, 30.723150253296 }, 	-- Freedom St, turn to Carson St
	{ 454.572265625, -1457.8427734375, 28.2718334198 }, 	-- Carson St
	{ 610.96875, -1408.36328125, 13.170495033264 }, 		-- Carson St, turn to Atlantica Ave
	{ 716.93359375, -1407.7041015625, 13.136788368225 }, -- Atlantica Ave
	{ 786.68359375, -1407.9580078125, 13.136933326721 }, 	-- Atlantica Ave, turn to Pilon St
	{ 794.1259765625, -1427.435546875, 13.148669242859 }, 	-- Pilon St
	{ 770.71875, -1572.1142578125, 13.146641731262 }, -- Pilon St
	{ 793.3515625, -1589.4521484375, 13.149803161621 },	-- St. Joseph St
	{ 827.056640625, -1608.234375, 13.144414901733 },	-- St. Joseph St
	{ 854.2919921875, -1600.01171875, 13.147015571594 },	-- St. Joseph St
	{ 918.5576171875, -1573.8876953125, 13.141946792603 },	-- St. Joseph St, turn to Fremont St
	{ 1023.6728515625, -1574.62890625, 13.14789390564 },	-- Fremont St, turn to Fame St
	{ 1065.662109375, -1574.2470703125, 13.137357711792 },	-- Fame St
	{ 1138.4462890625, -1574.30859375, 13.045930862427 },	-- Fame St, turn to Belview Rd
	{ 1285.68359375, -1573.9873046875, 13.142730712891 },	-- Belview Rd
	{ 1295.3564453125, -1595.3359375, 13.144201278687 },	-- Howard Blvd
	{ 1295.259765625, -1728.4638671875, 13.144244194031 },		-- Howard Blvd, turn to Carson St
	{ 1295.052734375, -1837.1923828125, 13.142651557922 },	-- Carson St
	{ 1303.6630859375, -1854.3037109375, 13.140624046326 },	-- Carson St
	{ 1314.5693359375, -1835.482421875, 13.14755821228 },	-- Majestic St
	{ 1314.5185546875, -1739.2158203125, 13.142502784729 },	-- Majestic St, turn to Park ave
	{ 1332.146484375, -1734.27734375, 13.142946243286 },		-- Park ave
	{ 1451.97265625, -1734.509765625, 13.147481918335 },	-- Park ave
	{ 1559.3623046875, -1734.7158203125, 13.14312171936 },		-- Park ave
	{ 1566.6083984375, -1756.4775390625, 13.147866249084 },	-- Park ave
	{ 1567.7734375, -1851.8681640625, 13.14736366272 },			-- Park ave
	{ 1554.78515625, -1869.625, 13.141596794128 },	-- Park ave
	{ 1485.93359375, -1870.18359375, 13.148474693298 },	-- Park ave, turn to Central ave
	{ 1398.2236328125, -1870.3017578125, 13.143708229065 },	-- Central ave
	{ 1392.025390625, -1847.923828125, 13.148904800415 },		-- Central ave, turn to Pasadena Blvd
	{ 1391.109375, -1746.216796875, 13.14231300354 },	-- Pasadena Blvd
	{ 1410.8818359375, -1735.3623046875, 13.152391433716 },	-- Pasadena Blvd
	{ 1431.2548828125, -1718.357421875, 13.144988059998 },	-- Pasadena Blvd
	{ 1431.314453125, -1715.3271484375, 13.151721954346 },	-- Pasadena Blvd
	{ 1432.208984375, -1607.4052734375, 13.142037391663 },		-- Pasadena Blvd
	{ 1447.712890625, -1503.140625, 13.145067214966 },	-- Pasadena Blvd, turn to Western Ave
	{ 1456.7197265625, -1444.96484375, 13.146527290344 },	-- Western Ave
	{ 1422.4306640625, -1428.9970703125, 13.143912315369 },		-- Western Ave
	{ 1374.78515625, -1393.4501953125, 13.205876350403 },		-- Western Ave, turn to Rodeo Drive
	{ 1360.8251953125, -1377.1298828125, 13.24107170105 },	-- Rodeo Drive
	{ 1360.46875, -1284.568359375, 13.114336967468 },	-- Rodeo Drive, turn to Panopticon Ave
	{ 1359.8779296875, -1220.7373046875, 14.730308532715 },	-- Panopticon Ave
	{ 1366.208984375, -1085.599609375, 24.346363067627 },	-- Panopticon Ave
	{ 1373.70703125, -995.8857421875, 28.471153259277 },		-- Panopticon Ave
	{ 1373.2421875, -934.1220703125, 33.94877243042 },	-- Panopticon Ave, turn to Beverly Ave
	{ 1357.7783203125, -970.4951171875, 32.403678894043 },	--  Beverly Ave
	{ 1351.8857421875, -1036.376953125, 25.963237762451 },		--  Beverly Ave, turn to San Andreas Blvd
	{ 1344.0087890625, -1099.052734375, 23.645042419434 },	-- San Andreas Blvd
	{ 1340.998046875, -1172.634765625, 23.375102996826 },	-- San Andreas Blvd, turn to Constitution Ave
	{ 1340.810546875, -1254.51953125, 13.147612571716 },	-- Constitution Ave
	{ 1340.4599609375, -1311.2802734375, 13.194432258606 },	-- DMV End road
	{ 1339.2783203125, -1427.1767578125, 13.147191047668 },	-- DMV End road [[PARK IT BACKWARDS]]
	{ 1322.185546875, -1450.57421875, 13.257716178894 },	-- DMV End road
}

testVehicle = { [436]=true } -- Previons need to be spawned at the start point.

local blip = nil
local marker = nil


local pacholki = {
	{1262.0278320312, -1453.4567871094, 13}, -- pacholek 1 start
	{1262.0561523438, -1454.8249511719, 13}, -- pacholek 2 start
	{1262.0502929688, -1455.9655761719, 13}, -- pacholek 3 start
	{1262.0747070312, -1457.2712402344, 13}, -- pacholek 4 start
	{1262.0659179688, -1458.8298339844, 13}, -- pacholek 5 start
	{1262.0688476562, -1460.4001464844, 13}, -- pacholek 6 start
	{1262.0922851562, -1462.3122558594, 13}, -- pacholek 7 start
	{1262.0981445312, -1463.8552246094, 13}, -- pacholek 8 start
	{1262.0795898438, -1465.1882324219, 13}, -- pacholek 9 start
	{1262.0786132812, -1466.8142089844, 13}, -- pacholek 10 start
	{1262.0883789062, -1468.1755371094, 13}, -- pacholek 11 start
	{1262.0795898438, -1469.8231201172, 13}, -- pacholek 12 start
	{1262.0795898438, -1471.2010498047, 13}, -- pacholek 13 start
	{1262.0942382812, -1472.6024169922, 13}, -- pacholek 14 start
	{1262.0893554688, -1473.9090576172, 13}, -- pacholek 15 start
	{1262.0874023438, -1475.2918701172, 13}, -- pacholek 16 start
	{1262.0893554688, -1476.9598388672, 13}, -- pacholek 17 start
	{1262.0893554688, -1478.1688232422, 13}, -- pacholek 18 start
	{1262.1088867188, -1479.5555419922, 13}, -- pacholek 19 start
	{1262.1157226562, -1480.8768310547, 13}, -- pacholek 20 start
	{1262.0961914062, -1482.2479248047, 13}, -- pacholek 21 start
	{1262.0811767578, -1482.8917236328, 13}, -- pacholek 22 start
	{1264.0512695312, -1482.8231201172, 13}, -- pacholek 23 start
	{1265.3012695312, -1482.8387451172, 13}, -- pacholek 24 start
	{1266.6206054688, -1482.7928466797, 13}, -- pacholek 25 start
	{1267.9829101562, -1482.7733154297, 13}, -- pacholek 26 start
	{1269.3657226562, -1482.7547607422, 13}, -- pacholek 27 start
	{1270.6450195312, -1482.7596435547, 13}, -- pacholek 28 start
	{1272.2602539062, -1482.7684326172, 13}, -- pacholek 29 start
	{1273.9213867188, -1482.7899169922, 13}, -- pacholek 30 start
	{1275.8452148438, -1482.7762451172, 13}, -- pacholek 31 start
	{1277.3842773438, -1482.7791748047, 13}, -- pacholek 32 start
	{1278.7416992188, -1482.7821044922, 13}, -- pacholek 33 start
	{1280.1333007812, -1482.7869873047, 13}, -- pacholek 34 start
	{1281.7270507812, -1482.8006591797, 13}, -- pacholek 35 start
	{1283.1108398438, -1482.8055419922, 13}, -- pacholek 36 start
	{1284.7202148438, -1482.8104248047, 13}, -- pacholek 37 start
	{1286.4174804688, -1482.7987060547, 13}, -- pacholek 38 start
	{1288.0317382812, -1482.7889404297, 13}, -- pacholek 39 start
	{1289.4360351562, -1482.7791748047, 13}, -- pacholek 40 start
	{1291.3178710938, -1482.7498779297, 13}, -- pacholek 41 start
	{1292.9702148438, -1482.7567138672, 13}, -- pacholek 42 start
	{1294.3608398438, -1482.7528076172, 13}, -- pacholek 43 start
	{1296.1733398438, -1482.7830810547, 13}, -- pacholek 44 start
	{1298.0629882812, -1482.7869873047, 13}, -- pacholek 45 start
	{1299.4516601562, -1482.8035888672, 13}, -- pacholek 46 start
	{1300.7983398438, -1482.8123779297, 13}, -- pacholek 47 start
	{1302.4575195312, -1482.7840576172, 13}, -- pacholek 48 start
	{1304.3608398438, -1482.7967529297, 13}, -- pacholek 49 start
	{1306.4799804688, -1482.7860107422, 13}, -- pacholek 50 start
	{1308.3706054688, -1482.7664794922, 13}, -- pacholek 51 start
	{1310.5053710938, -1482.7996826172, 13}, -- pacholek 52 start
	{1312.1206054688, -1482.7869873047, 13}, -- pacholek 53 start
	{1313.7514648438, -1482.7821044922, 13}, -- pacholek 54 start
	{1315.3344726562, -1482.8143310547, 13}, -- pacholek 55 start
	{1316.9458007812, -1482.8240966797, 13}, -- pacholek 56 start
	{1318.3858642578, -1482.7579345703, 13}, -- pacholek 57 start
	{1318.3673095703, -1478.9503173828, 13}, -- pacholek 58 start
	{1318.3302001953, -1477.5899658203, 13}, -- pacholek 59 start
	{1318.3536376953, -1476.1436767578, 13}, -- pacholek 60 start
	{1318.3360595703, -1474.2647705078, 13}, -- pacholek 61 start
	{1318.3194580078, -1472.6573486328, 13}, -- pacholek 62 start
	{1318.3009033203, -1470.4942626953, 13}, -- pacholek 61 start
	{1318.3468017578, -1468.8428955078, 13}, -- pacholek 62 start
	{1318.3468017578, -1467.1983642578, 13}, -- pacholek 63 start -- uwaga
	{1318.3468017578, -1465.8106689453, 13}, -- pacholek 64 start
	{1318.3468017578, -1464.4542236328, 13}, -- pacholek 65 start
	{1318.3360595703, -1463.1016845703, 13}, -- pacholek 66 start
	{1318.3575439453, -1461.4962158203, 13}, -- pacholek 67 start
	{1318.3321533203, -1460.0958251953, 13}, -- pacholek 68 start
	{1318.3223876953, -1458.7003173828, 13}, -- pacholek 69 start
	{1318.3204345703, -1456.7940673828, 13}, -- pacholek 70 start
	{1318.3321533203, -1455.1651611328, 13}, -- pacholek 71 start
	{1318.3624267578, -1453.3389892578, 13}, -- pacholek 72 start
	{1316.4962158203, -1453.3018798828, 13}, -- pacholek 73 start
	{1315.2872314453, -1453.3028564453, 13}, -- pacholek 74 start
	{1313.6866455078, -1453.3292236328, 13}, -- pacholek 75 start
	{1311.7628173828, -1453.3184814453, 13}, -- pacholek 76 start
	{1309.5753173828, -1453.3399658203, 13}, -- pacholek 77 start
	{1307.6729736328, -1453.3419189453, 13}, -- pacholek 78 start
	{1305.5743408203, -1453.3419189453, 13}, -- pacholek 79 start
	{1303.5870361328, -1453.3135986328, 13}, -- pacholek 80 start
	{1301.3155517578, -1453.3321533203, 13}, -- pacholek 81 start
	{1299.5303955078, -1453.3194580078, 13}, -- pacholek 82 start
	{1296.5098876953, -1453.3175048828, 13}, -- pacholek 83 start
	{1294.5880126953, -1453.3262939453, 13}, -- pacholek 84 start
	{1292.5050048828, -1453.3155517578, 13}, -- pacholek 85 start
	{1290.8878173828, -1453.3096923828, 13}, -- pacholek 86 start
	{1289.2598876953, -1453.3116455078, 13}, -- pacholek 87 start
	{1287.0108642578, -1453.3057861328, 13}, -- pacholek 88 start
	{1284.8809814453, -1453.3077392578, 13}, -- pacholek 89 start
	{1283.0391845703, -1453.2813720703, 13}, -- pacholek 90 start
	{1281.6563720703, -1453.2940673828, 13}, -- pacholek 91 start
	{1279.7569580078, -1453.3087158203, 13}, -- pacholek 92 start
	{1278.1495361328, -1453.3009033203, 13}, -- pacholek 93 start
	{1276.7423095703, -1453.2862548828, 13}, -- pacholek 94 start
	{1275.1143798828, -1453.3048095703, 13}, -- pacholek 95 start
	{1273.5186767578, -1453.2823486328, 13}, -- pacholek 96 start
------------------------KONIEC OTOCZKI KURWA JEGO MAC-----------------------------	
	{1266.3754882812, -1453.3269042969, 13}, -- pacholek 97 start
	{1266.3579101562, -1454.7028808594, 13}, -- pacholek 98 start
	{1266.3579101562, -1456.3151855469, 13}, -- pacholek 99 start
	{1266.3217773438, -1459.4372558594, 13}, -- pacholek 100 start -- We Are the champions my friend lo lo xD
	{1266.3422851562, -1461.0397949219, 13}, -- pacholek 101 start
	{1266.3432617188, -1462.4450683594, 13}, -- pacholek 101 start
	{1266.3549804688, -1464.0593261719, 13}, -- pacholek 102 start
	{1266.3510742188, -1468.4714355469, 13}, -- pacholek 103 start
	{1266.3813476562, -1470.3123779297, 13}, -- pacholek 104 start
	{1266.3774414062, -1472.4471435547, 13}, -- pacholek 105 start
	{1266.3452148438, -1474.6405029297, 13}, -- pacholek 106 start
	{1266.3422851562, -1476.2586669922, 13}, -- pacholek 107 start
	{1266.3706054688, -1476.9373779297, 13}, -- pacholek 108 start
	{1266.3159179688, -1457.9538574219, 13}, -- pacholek 109 start
	{1266.2700195312, -1466.8981933594, 13}, -- pacholek 110 start
	{1266.3569335938, -1466.0661621094, 13}, -- pacholek 111 start
	{1267.2934570312, -1476.8817138672, 13}, -- pacholek 112 start
	{1268.3950195312, -1476.8983154297, 13}, -- pacholek 113 start
	{1269.6264648438, -1476.8885498047, 13}, -- pacholek 114 start
	{1270.9389648438, -1476.8446044922, 13}, -- pacholek 115 start
	{1272.2856445312, -1476.8446044922, 13}, -- pacholek 116 start
	{1273.5874023438, -1475.9110107422, 13}, -- pacholek 117 start
	{1273.5698242188, -1474.6199951172, 13}, -- pacholek 118 start
	{1273.5454101562, -1473.2420654297, 13}, -- pacholek 119 start
	{1273.5327148438, -1471.6033935547, 13}, -- pacholek 120 start
	{1273.5180664062, -1470.0614013672, 13}, -- pacholek 121 start
	{1273.5190429688, -1468.7987060547, 13}, -- pacholek 122 start
	{1273.5356445312, -1467.4647216797, 13}, -- pacholek 123 start
	{1273.5092773438, -1465.5115966797, 13}, -- pacholek 124 start
	{1273.5336914062, -1464.0369873047, 13}, -- pacholek 125 start
	{1273.5219726562, -1462.6346435547, 13}, -- pacholek 126 start
	{1273.5395507812, -1461.1883544922, 13}, -- pacholek 127 start
	{1273.5434570312, -1459.5906982422, 13}, -- pacholek 128 start
	{1273.5385742188, -1457.9930419922, 13}, -- pacholek 129 start
	{1273.5363769531, -1456.3533935547, 13}, -- pacholek 130 start
	{1273.5705566406, -1454.8192138672, 13}, -- pacholek 131 start
	{1290.3862304688, -1481.8836669922, 13}, -- pacholek 132 start
	{1290.3598632812, -1480.9735107422, 13}, -- pacholek 133 start
	{1290.4038085938, -1479.6688232422, 13}, -- pacholek 134 start
	{1290.3901367188, -1478.2410888672, 13}, -- pacholek 135 start
	{1290.3393554688, -1476.8963623047, 13}, -- pacholek 136 start
	{1290.3803710938, -1475.0721435547, 13}, -- pacholek 137 start
	{1290.3735351562, -1473.5838623047, 13}, -- pacholek 138 start
	{1290.3872070312, -1471.9949951172, 13}, -- pacholek 139 start
	{1290.4204101562, -1469.5164794922, 13}, -- pacholek 140 start
	{1290.4204101562, -1468.1258544922, 13}, -- pacholek 141 start
	{1290.4008789062, -1466.6375732422, 13}, -- pacholek 142 start
	{1290.4184570312, -1464.5350341797, 13}, -- pacholek 143 start
	{1290.4096679688, -1463.1805419922, 13}, -- pacholek 144 start
	{1290.4008789062, -1461.8406982422, 13}, -- pacholek 145 start
	{1290.3940429688, -1460.4354248047, 13}, -- pacholek 146 start
	{1290.4233398438, -1459.0662841797, 13}, -- pacholek 147 start
	{1289.7016601562, -1458.6160888672, 13}, -- pacholek 148 start
	{1288.1079101562, -1458.6326904297, 13}, -- pacholek 149 start
	{1286.7944335938, -1458.6219482422, 13}, -- pacholek 150 start
	{1285.4672851562, -1458.6199951172, 13}, -- pacholek 151 start
	{1284.0922851562, -1458.5809326172, 13}, -- pacholek 152 start
	{1282.7016601562, -1458.5916748047, 13}, -- pacholek 153 start
	{1281.2192382812, -1458.6170654297, 13}, -- pacholek 154 start
	{1279.7719726562, -1458.6258544922, 13}, -- pacholek 155 start
	{1278.3715820312, -1458.5985107422, 13}, -- pacholek 156 start
	{1278.3305664062, -1459.9315185547, 13}, -- pacholek 157 start
	{1278.3198242188, -1461.8797607422, 13}, -- pacholek 158 start
	{1278.3364257812, -1463.7733154297, 13}, -- pacholek 159 start
	{1278.3364257812, -1465.1668701172, 13}, -- pacholek 160 start
	{1278.3510742188, -1466.7791748047, 13}, -- pacholek 161 start
	{1278.3510742188, -1468.4510498047, 13}, -- pacholek 162 start
	{1278.3471679688, -1470.3172607422, 13}, -- pacholek 163 start
	{1278.3471679688, -1472.1805419922, 13}, -- pacholek 164 start
	{1278.3403320312, -1474.1444091797, 13}, -- pacholek 165 start
	{1278.3315429688, -1475.5369873047, 13}, -- pacholek 166 start
	{1278.3442382812, -1476.8436279297, 13}, -- pacholek 167 start
	{1279.0610351562, -1476.6326904297, 13}, -- pacholek 168 start
	{1280.4311523438, -1476.6199951172, 13}, -- pacholek 169 start
	{1282.1948242188, -1476.6365966797, 13}, -- pacholek 170 start
	{1283.6606445312, -1476.6356201172, 13}, -- pacholek 171 start
	{1285.4506835938, -1476.5906982422, 13}, -- pacholek 172 start
	{1286.9790039062, -1476.6053466797, 13}, -- pacholek 173 start
	{1288.5034179688, -1476.6082763672, 13}, -- pacholek 174 start
	{1290.1333007812, -1476.6170654297, 13}, -- pacholek 175 start
	
	{1298.8823242188, -1462.6737060547, 13}, -- pacholek rondo 1
	{1297.8686523438, -1463.9832763672, 13}, -- pacholek rondo 2
	{1296.9790039062, -1465.4940185547, 13}, -- pacholek rondo 3
	{1296.1518554688, -1466.9666748047, 13}, -- pacholek rondo 4
	{1296.0981445312, -1468.7938232422, 13}, -- pacholek rondo 5
	{1296.8540039062, -1470.0936279297, 13}, -- pacholek rondo 6
	{1297.7055664062, -1471.5252685547, 13}, -- pacholek rondo 7
	{1298.8188476562, -1472.9305419922, 13}, -- pacholek rondo 8
	{1299.8608398438, -1473.3446044922, 13}, -- pacholek rondo 9
	{1300.7778320312, -1473.3533935547, 13}, -- pacholek rondo 10
	{1302.1127929688, -1473.3944091797, 13}, -- pacholek rondo 11
	{1302.9301757812, -1473.3504638672, 13}, -- pacholek rondo 11
	{1304.2836914062, -1473.1600341797, 13}, -- pacholek rondo 11
	{1305.3940429688, -1472.3211669922, 13}, -- pacholek rondo 11
	{1306.0502929688, -1471.3240966797, 13}, -- pacholek rondo 11
	{1306.8120117188, -1470.1063232422, 13}, -- pacholek rondo 11
	{1308.0053710938, -1467.9862060547, 13}, -- pacholek rondo 11
	{1307.5610351562, -1467.0057373047, 13}, -- pacholek rondo 11
	{1306.9516601562, -1465.9246826172, 13}, -- pacholek rondo 11
	{1305.9536132812, -1464.1717529297, 13}, -- pacholek rondo 11
	{1305.1372070312, -1462.8612060547, 13}, -- pacholek rondo 11
	{1304.0307617188, -1462.7449951172, 13}, -- pacholek rondo 11
	{1302.7924804688, -1462.7362060547, 13}, -- pacholek rondo 11
	{1301.6479492188, -1462.7283935547, 13}, -- pacholek rondo 11
	{1300.4086914062, -1462.7332763672, 13}, -- pacholek rondo 11
	
	
	
}
local pacholkiObj = {}

function initiateDrivingTest()
	if LICEMCING then return end
	triggerServerEvent("theoryComplete", getLocalPlayer())
	local x, y, z = testRoute[1][1], testRoute[1][2], testRoute[1][3]
	blip = createBlip(x, y, z, 0, 2, 0, 255, 0, 255)
	marker = createMarker(x, y, z, "checkpoint", 4, 0, 255, 0, 150) -- start marker.
	addEventHandler("onClientMarkerHit", marker, startDrivingTest)
	
	outputChatBox("#FF9933Jesteś teraz gotowy do podjęcia swojego egzaminu praktycznego z jazdy. Odbierz z komisariatu pojazd specjalny.", 255, 194, 14, true)
	
	for i,v in ipairs(pacholki) do
		local obj = createObject( 1238, v[1], v[2], v[3], 0, 0, 0 )
		setElementData( obj, "pacholek", true )
		setElementFrozen( obj, true )
		setObjectBreakable(obj, false)
		table.insert(pacholkiObj,obj)
	end
	
	triggerServerEvent("createPJCar", getLocalPlayer())
	
	LICEMCING = true
end

addEventHandler("onClientVehicleCollision", getRootElement(),
    function(collider,force, bodyPart, x, y, z, nx, ny, nz)
        if ( source == getPedOccupiedVehicle(getLocalPlayer()) ) then
			if collider then
				if getElementData(collider,"pacholek") then
					outputChatBox("widac uszkodzenia , to źle mówi o tobie.", 255, 194, 14)
					outputChatBox("Nie zaliczyłeś tego testu.", 255, 0, 0)
					
					if isElement( blip ) then
						destroyElement(blip)
					end
					if isElement( marker ) then
						destroyElement(marker)
					end
					blip = nil
					marker = nil					
					setElementData(getLocalPlayer(), "drivingTest.vehicle", nil)	-- cleanup data
					setElementData ( getLocalPlayer(), "drivingTest.marker", nil )
					setElementData ( getLocalPlayer(), "drivingTest.checkmarkers", nil )
					
					for i,v in ipairs(pacholkiObj) do
						destroyElement( v )
					end
					
					pacholkiObj = {}
					
					triggerServerEvent("destroyPJCar", getLocalPlayer())
					
					LICEMCING = false
				end
			end
        end
    end
)

function bartekDestroyPrawko()
	outputChatBox("Opuściłes swój samochód.", 255, 194, 14)
	outputChatBox("Nie zaliczyłeś tego testu.", 255, 0, 0)
	if isElement( blip ) then
		destroyElement(blip)
	end
	if isElement( marker ) then
		destroyElement(marker)
	end
	blip = nil
	marker = nil					
	setElementData(getLocalPlayer(), "drivingTest.vehicle", nil)	-- cleanup data
	setElementData ( getLocalPlayer(), "drivingTest.marker", nil )
	setElementData ( getLocalPlayer(), "drivingTest.checkmarkers", nil )
					
	for i,v in ipairs(pacholkiObj) do
		destroyElement( v )
	end
					
	pacholkiObj = {}
					
	LICEMCING = false
end
addEvent("bartekDestroyPrawko", true)
addEventHandler("bartekDestroyPrawko", getRootElement(), bartekDestroyPrawko)

--[[
addEventHandler("onClientColShapeHit", getRootElement(),
    function(collider)
		--outputChatBox(getElementType(collider))
        if ( collider == getPedOccupiedVehicle(getLocalPlayer()) ) then
			if getElementData( source, "pacholek", true ) then
					outputChatBox("widac uszkodzenia , to źle mówi o tobie.", 255, 194, 14)
					outputChatBox("Nie zaliczyłeś tego testu.", 255, 0, 0)
					
					if isElement( blip ) then
						destroyElement(blip)
					end
					if isElement( marker ) then
						destroyElement(marker)
					end
					blip = nil
					marker = nil					
					setElementData(getLocalPlayer(), "drivingTest.vehicle", nil)	-- cleanup data
					setElementData ( getLocalPlayer(), "drivingTest.marker", nil )
					setElementData ( getLocalPlayer(), "drivingTest.checkmarkers", nil )
					
					destroyElement( collider )
					
					for i,v in ipairs(pacholkiObj) do
						destroyElement( v )
					end
					
					pacholkiObj = {}
					
					for i,v in ipairs(pacholkiObjCS) do
						destroyElement( v )
					end
					
					pacholkiObjCS = {}

			end
        end
    end
)
--]]

function startDrivingTest(element)
	if element == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("#FF9933Musisz być w samochodzie specjalnym podczas przechodzenia przez punkty kontrolne.", 255, 0, 0, true ) -- Wrong car type.
		elseif not exports.global:hasMoney( getLocalPlayer(), 100 ) then
			outputChatBox("Masz niewystarczająca ilośc pieniędzy na zdanie testu", 255, 0, 0 )
		else
			destroyElement(blip)
			destroyElement(marker)
			
			outputChatBox("Zapłaciłeś 100 $ za egzamin praktyczny.", source, 255, 194, 14)
			triggerServerEvent("payFee", getLocalPlayer(), 100)
			
			local vehicle = getPedOccupiedVehicle ( getLocalPlayer() )
			setElementData(getLocalPlayer(), "drivingTest.marker", 2, false)

			local x1,y1,z1 = nil -- Setup the first checkpoint
			x1 = testRoute[2][1]
			y1 = testRoute[2][2]
			z1 = testRoute[2][3]
			setElementData(getLocalPlayer(), "drivingTest.checkmarkers", #testRoute, false)

			blip = createBlip(x1, y1 , z1, 0, 2, 255, 0, 255, 255)
			marker = createMarker( x1, y1,z1 , "checkpoint", 4, 255, 0, 255, 150)
				
			addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)
				
			outputChatBox("#FF9933Będziesz musiał ukończyć trasę bez uszkodzenia samochodu testowego. Powodzenia.", 255, 194, 14, true)
		end
	end
end

function UpdateCheckpoints(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("Kieruj pojazd testowy na punkty kontrolne.", 255, 0, 0) -- Wrong car type.
		else
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
				
			local m_number = getElementData(getLocalPlayer(), "drivingTest.marker")
			local max_number = getElementData(getLocalPlayer(), "drivingTest.checkmarkers")
			
			if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
				outputChatBox("#FF9933Zaparkuj pojazd w  #FF66CCin miejscu  #FF9933by zakończyć test.", 255, 194, 14, true)
				
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
					
				local x2, y2, z2 = nil
				x2 = testRoute[newnumber][1]
				y2 = testRoute[newnumber][2]
				z2 = testRoute[newnumber][3]
				
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				
				addEventHandler("onClientMarkerHit", marker, EndTest)
			else
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
						
				local x2, y2, z2 = nil
				x2 = testRoute[newnumber][1]
				y2 = testRoute[newnumber][2]
				z2 = testRoute[newnumber][3]
						
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)
			end
		end
	end
end

function EndTest(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("You must be in a DMV test car when passing through the check points.", 255, 0, 0)
		else
			local vehicleHealth = getElementHealth ( vehicle )
			if (vehicleHealth >= 800) then
				if not exports.global:hasMoney( getLocalPlayer(), 250 ) then
					outputChatBox("Nie stać cie by zakończyć test ponieważ uszkodziłeś zbyt auto, potrzebujesz $250.", 255, 0, 0)
				else
					----------
					-- PASS --
					----------
					outputChatBox("Po skontrolowaniu pojazdu nie widzimy żadnych uszkodzeń. Gratulacje", 255, 194, 14)
					triggerServerEvent("acceptLicense", getLocalPlayer(), 1, 250)
				end
			else
				----------
				-- Fail --
				----------
				outputChatBox("widac uszkodzenia , to źle mówi o tobie.", 255, 194, 14)
				outputChatBox("Nie zaliczyłeś tego testu.", 255, 0, 0)
			end
			
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
					
			setElementData(thePlayer, "drivingTest.vehicle", nil)
			
			setElementData(thePlayer, "drivingTest.vehicle", nil)	-- cleanup data
			setElementData ( thePlayer, "drivingTest.marker", nil )
			setElementData ( thePlayer, "drivingTest.checkmarkers", nil )
		end
	end
end

bindKey( "accelerate", "down",
	function( )
		local veh = getPedOccupiedVehicle( getLocalPlayer( ) )
		if veh and getVehicleOccupant( veh ) == getLocalPlayer( ) then
			if isElementFrozen( veh ) and getVehicleEngineState( veh ) then
				outputChatBox( "(( Hamulec ręczny jest zaciągnięty wpisz /reczny by go zwolnić. ))", 255, 194, 14 )
			elseif not getVehicleEngineState( veh ) then
				outputChatBox( "(( Uruchom silnik za pomocą klawisza J. ))", 255, 194, 14 )
			end
		end
	end
)


fileDelete("c_license_system.lua")