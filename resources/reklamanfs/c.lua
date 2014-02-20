sizex,sizey = guiGetScreenSize()

window = guiCreateWindow(sizex/2-620/2, sizey/2-453/2, 620, 453, "Need For Speed : San Andreas", false)
logo = guiCreateStaticImage(10, 26, 600, 80, "logo.png", false, window)
desc = guiCreateLabel(20, 116, 580, 139, "Need For Speed San Andreas to system wyścigow opartych na podstawie gier NFS Underground oraz Underground 2.\n\nZdobądź swoj pierwszy samochód i rozpocznij swoją karierę w świecie nielegalnych wyścigów!\nZdobywaj nowe części i kasę pokonując na wyścigach swoich rywali. Zwiększaj osiagi i zmieniaj wygląd swojego auta. Pnij się na szczyty, zdobądź sławę, reputację, zostań numerem 1!\n\nNie czekaj!", false, window)
guiLabelSetHorizontalAlign(desc, "center", true)
img = guiCreateStaticImage(10, 265, 600, 136, "raceh.jpg", false, window)
redirect = guiCreateButton(10, 411, 160, 30, "Przejdź na wyścigi", false, window)
close = guiCreateButton(450, 411, 160, 30, "Zamknij", false, window)    

guiSetVisible( window, false )

marker = getElementByID("nfswindow")


addEventHandler("onClientGUIClick", resourceRoot,
    function()
		if source == close then
			guiSetVisible( window, false )
			showCursor( false )
		elseif source == redirect then
			triggerServerEvent( "redirectPlayerEv", getLocalPlayer() )
		end
    end
)

addEventHandler("onClientMarkerHit", resourceRoot,
    function( elem, dim )
		if not dim then return end
		if elem ~= getLocalPlayer() then return end
		if source == marker then
			guiSetVisible( window, true )
			showCursor( true )
		end
    end
)