local TITLE = "BAN"
local REASON = "Ruska pala zostala zbanowana za walenie konia!"
local TIMER = false

function renderujOkienko()
	local sizex,sizey = guiGetScreenSize()
	dxDrawRectangle( 30, sizey-sizey/3, 240, 160, tocolor(0,0,0,160) )
	dxDrawRectangle( 30, sizey-sizey/3, 240, 25, tocolor(0,0,0,96) )
	dxDrawText( TITLE, 30, sizey-sizey/3, 270, sizey-sizey/3+30, tocolor(255,0,0,255), 1.2, "default-bold", "center", "center" )
	dxDrawText( REASON, 40, sizey-sizey/3+40, 260, sizey-sizey/3+160, tocolor(255,255,255,255), 1, "default-bold", "left", "top", false, true )
end

function renderujOkienkoStop()
	removeEventHandler( "onClientRender", getRootElement(), renderujOkienko )
end

function doOkienkoBan( t, r )
	if isTimer(TIMER) then
		killTimer(TIMER) 
	else
		addEventHandler( "onClientRender", getRootElement(), renderujOkienko )
	end
	TIMER = setTimer( renderujOkienkoStop, 10000, 1 )
	TITLE = t
	REASON = r
end

addEvent( "doOkienkoBan", true )
addEventHandler( "doOkienkoBan", getRootElement(), doOkienkoBan )