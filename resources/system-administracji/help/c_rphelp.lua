myWindow = nil
pressed = false

function bindKeys()
	bindKey("F1", "down", F1RPhelp)
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

function resetState()
	pressed = false
end

function F1RPhelp( key, keyState )
	if not (pressed) then
		pressed = true
		setTimer(resetState, 200, 1)
		if ( myWindow == nil ) then		
			local xmlServerRules = xmlLoadFile( "help/serverrules.xml" )
			
			myWindow = guiCreateWindow ( 0.25, 0.25, 0.5, 0.5, "California-Gaming - Poradnik", true )
			local tabPanel = guiCreateTabPanel ( 0, 0.1, 1, 1, true, myWindow )
			
			local tabRules = guiCreateTab( "Regulamin", tabPanel )
			local memoRules = guiCreateMemo ( 0, 0.1, 1, 1, xmlNodeGetValue( xmlServerRules ), true, tabRules )
			guiMemoSetReadOnly(memoRules, true)
	
			
			showCursor( true )
			
			xmlUnloadFile( xmlServerRules )
			xmlUnloadFile( xmlExplained )
			xmlUnloadFile( xmlOverview )
		else
			destroyElement(myWindow)
			myWindow = nil
			showCursor(false)
		end
	end
end