local TITLE = "BAN"
local REASON = "Ruska pala zostala zbanowana za walenie konia!"

function renderujOkienko()
	local sizex,sizey = guiGetScreenSize()
	dxDrawRectangle( 30, sizey-sizey/3, 240, 160, tocolor(0,0,0,160) )
	dxDrawRectangle( 30, sizey-sizey/3, 240, 30, tocolor(255,0,0,96) )
	dxDrawText( TITLE, 30, sizey-sizey/3, 270, sizey-sizey/3+30, tocolor(255,255,255,255), 1.5, "default-bold", "center", "center" )
end

addEventHandler( "onClientRender", getRootElement(), renderujOkienko )