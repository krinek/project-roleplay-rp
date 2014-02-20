ciuchy = {
			{id=0,name="pizda",cost=100},
			{id=11,name="chuj",cost=200},
			{id=19,name="kurwa",cost=300,premium=true},
			{id=16,name="a a a a",cost=1234,premium=true},
		}
		
sizex,sizey = guiGetScreenSize()			
gui = {}
ORIG_SKIN = 0
function onClientResourceStart()
	gui.window = guiCreateWindow( 50, sizey/2-420/2, 240, 420, "Ubrania", false )
	gui.list = guiCreateGridList( 10, 25, 220, 300, false, gui.window )
	guiGridListAddColumn( gui.list, "ID", 0.15 )
	guiGridListAddColumn( gui.list, "Nazwa", 0.5 )
	guiGridListAddColumn( gui.list, "Cena", 0.2 )
	gui.lab = guiCreateLabel( 10, 330, 220, 20, "", false, gui.window )
	guiSetFont( gui.lab, "default-bold-small" )
	guiLabelSetHorizontalAlign( gui.lab, "center", false )
	guiLabelSetVerticalAlign( gui.lab, "center" )
	guiLabelSetColor( gui.lab, 255, 128, 128 )
	gui.buy = guiCreateButton( 10, 355, 220, 25, "Kup", false, gui.window )
	guiSetEnabled( gui.buy, false )
	gui.close = guiCreateButton( 10, 385, 220, 25, "Zamknij", false, gui.window )
	addEventHandler( "onClientGUIClick", gui.close,
		function()
			guiSetVisible( gui.window, false )
			showCursor( false )
			setCameraTarget( getLocalPlayer() )
			setPedSkin( getLocalPlayer(), ORIG_SKIN )
		end, false
	)
	addEventHandler( "onClientGUIClick", gui.buy,
		function()
			local row = guiGridListGetSelectedItem( gui.list )
			if row == -1 then return end
			local cost = tonumber(guiGridListGetItemText( gui.list, row, 3 ))
			local skin = tonumber(guiGridListGetItemText( gui.list, row, 1 ))
			if cost and skin then
				ORIG_SKIN = skin
				triggerServerEvent( "ciucholandKupCiuch", getLocalPlayer(), skin, cost )
				triggerEvent( "onClientGUIClick", gui.close )
			end
		end, false
	)
	addEventHandler( "onClientGUIClick", gui.list,
		function()
			local row = guiGridListGetSelectedItem( gui.list )
			if row == -1 then return guiSetEnabled( gui.buy, false ) end
			local cost = tonumber(guiGridListGetItemText( gui.list, row, 3 ))
			local skin = tonumber(guiGridListGetItemText( gui.list, row, 1 ))
			if cost and skin then
				setPedSkin( getLocalPlayer(), skin )
				if guiGridListGetItemData( gui.list, row, 1 ) then
					if not exports.premium:isPlayerPremium() then
						ciuchoError( "Tylko konta premium." )
						return guiSetEnabled( gui.buy, false )
					end
				end
				if exports.global:hasMoney(getLocalPlayer(),cost) then
					ciuchoError( "" )
					return guiSetEnabled( gui.buy, true )
				else
					ciuchoError( "Brak kasy." )
					return guiSetEnabled( gui.buy, false )
				end
			end
		end, false
	)
	
	guiSetVisible( gui.window, false )
end
addEventHandler( "onClientResourceStart", getRootElement(), onClientResourceStart )

function ciuchoError( err )
	guiSetText( gui.lab, err )
end

function openCiucholand()
	guiSetVisible( gui.window, true )
	showCursor( true )
	local x,y,z = getElementPosition(getLocalPlayer())
	local rot = getPedRotation(getLocalPlayer())
	local ex,ey = getPointFromDistanceRotation( x, y, 4, -rot )
	setCameraMatrix( ex, ey, z, x, y, z )
	ORIG_SKIN = getPedSkin( getLocalPlayer() )
	guiGridListClear( gui.list )
	for _,v in ipairs(ciuchy) do
		local row = guiGridListAddRow( gui.list )
		guiGridListSetItemText( gui.list, row, 1, v.id, false, false )
		guiGridListSetItemText( gui.list, row, 2, v.name, false, false )
		guiGridListSetItemText( gui.list, row, 3, v.cost, false, false )
		if v.premium then
			local p = exports.premium:isPlayerPremium()
			guiGridListSetItemData( gui.list, row, 1, true )
			guiGridListSetItemColor( gui.list, row, 1, (p and 128) or 255, (p and 255) or 128, 128 )
			guiGridListSetItemColor( gui.list, row, 2, (p and 128) or 255, (p and 255) or 128, 128 )
			guiGridListSetItemColor( gui.list, row, 3, (p and 128) or 255, (p and 255) or 128, 128 )
		end
	end
	guiSetEnabled( gui.buy, false )
	ciuchoError("")
end
addCommandHandler( "ciucholand", openCiucholand )








function getPointFromDistanceRotation(x, y, dist, angle)
 
    local a = math.rad(90 - angle);
 
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
 
    return x+dx, y+dy;
 
end