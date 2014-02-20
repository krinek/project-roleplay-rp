function renderIng( )
	local x, y, z = getCameraMatrix( )
	local dimension = getElementDimension( localPlayer )
	for key, pickup in ipairs ( getElementsByType( "pickup", resourceRoot ) ) do
		if getElementDimension( pickup ) == dimension then
			local px, py, pz = getElementPosition( pickup )
			local distance = getDistanceBetweenPoints3D( px, py, pz, x, y, z )
			if distance <= 10 then
				local text = getElementData( pickup, "message" )	
				if text and ( distance < 2 or isLineOfSightClear( x, y, z, px, py, pz + 0.7, true, true, true, true, false, false, true, localPlayer ) ) then
					local sx, sy = getScreenFromWorldPosition( px, py, pz + 0.7 )
					if sx and sy then
						local w = dxGetTextWidth( tostring( text ) )
						local h = ( text and 2 or 1 ) * dxGetFontHeight( )
						dxDrawRectangle( sx - w / 2 - 5, sy - h / 2 - 5, w + 10, h + 10, tocolor( 0, 0, 0, 200 ) )
						dxDrawText( tostring( text ), sx, sy, sx, sy, tocolor( 255, 255, 255, 255 ), 1, "default", "center", "center" )
					end
				end
			end
		end
	end
	for key, marker in ipairs ( getElementsByType( "marker", resourceRoot ) ) do
		if getElementDimension( marker ) == dimension then
			local px, py, pz = getElementPosition( marker )
			local distance = getDistanceBetweenPoints3D( px, py, pz, x, y, z )
			if distance <= 20 then
				local text = getElementData( marker, "message" )	
				if text and ( distance < 2 or isLineOfSightClear( x, y, z, px, py, pz + 1.7, true, true, true, true, false, false, true, localPlayer ) ) then
					local sx, sy = getScreenFromWorldPosition( px, py, pz + 1.7 )
					if sx and sy then
						local w = dxGetTextWidth( tostring( text ) )
						local h = ( text and 2 or 1 ) * dxGetFontHeight( )
						dxDrawRectangle( sx - w / 2 - 5, sy - h / 2 - 5, w + 10, h + 10, tocolor( 0, 0, 0, 200 ) )
						dxDrawText( tostring( text ), sx, sy, sx, sy, tocolor( 255, 255, 255, 255 ), 1, "default", "center", "center" )
					end
				end
			end
		end
	end
	for key, player in ipairs ( getElementsByType( "player", resourceRoot ) ) do
		if getElementDimension( player ) == dimension then
			local px, py, pz = getElementPosition( player )
			local distance = getDistanceBetweenPoints3D( px, py, pz, x, y, z )
			if distance <= 20 then
				local text = getElementData( player, "message" )	
				if text and ( distance < 2 or isLineOfSightClear( x, y, z, px, py, pz + 1.1, true, true, true, true, false, false, true, localPlayer ) ) then
					local sx, sy = getScreenFromWorldPosition( px, py, pz + 1.1 )
					if sx and sy then
						local w = dxGetTextWidth( tostring( text ) )
						local h = ( text and 2 or 1 ) * dxGetFontHeight( )
						dxDrawRectangle( sx - w / 2 - 5, sy - h / 2 - 5, w + 10, h + 10, tocolor( 0, 0, 0, 200 ) )
						dxDrawText( tostring( text ), sx, sy, sx, sy, tocolor( 255, 255, 255, 255 ), 1, "default", "center", "center" )
					end
				end
			end
		end
	end		
	for key, ped in ipairs ( getElementsByType( "ped", resourceRoot ) ) do
		if getElementDimension( ped ) == dimension then
			local px, py, pz = getElementPosition( ped )
			local distance = getDistanceBetweenPoints3D( px, py, pz, x, y, z )
			if distance <= 20 then
				local text = getElementData( ped, "message" )	
				if text and ( distance < 2 or isLineOfSightClear( x, y, z, px, py, pz + 1.1, true, true, true, true, false, false, true, localPlayer ) ) then
					local sx, sy = getScreenFromWorldPosition( px, py, pz + 1.1 )
					if sx and sy then
						local w = dxGetTextWidth( tostring( text ) )
						local h = ( text and 2 or 1 ) * dxGetFontHeight( )
						dxDrawRectangle( sx - w / 2 - 5, sy - h / 2 - 1, w + 10, h, tocolor( 0, 0, 0, 200 ) )
						dxDrawText( tostring( text ), sx, sy, sx, sy, tocolor( 255, 255, 255, 255 ), 1, "default", "center", "center" )
					end
				end
			end
		end
	end	
	for key, vehicle in ipairs ( getElementsByType( "vehicle", resourceRoot ) ) do
		if getElementDimension( vehicle ) == dimension then
			local px, py, pz = getElementPosition( vehicle )
			local distance = getDistanceBetweenPoints3D( px, py, pz, x, y, z )
			if distance <= 20 then
				local text = getElementData( vehicle, "message" )	
				if text and ( distance < 2 or isLineOfSightClear( x, y, z, px, py, pz + 1.1, true, true, true, true, false, false, true, localPlayer ) ) then
					local sx, sy = getScreenFromWorldPosition( px, py, pz + 1.1 )
					if sx and sy then
						local w = dxGetTextWidth( tostring( text ) )
						local h = ( text and 2 or 1 ) * dxGetFontHeight( )
						dxDrawRectangle( sx - w / 2 - 5, sy - h / 2 - 1, w + 10, h, tocolor( 0, 0, 0, 200 ) )
						dxDrawText( tostring( text ), sx, sy, sx, sy, tocolor( 255, 255, 255, 255 ), 1, "default", "center", "center" )
					end
				end
			end
		end
	end			
end
addEventHandler( "onClientRender", getRootElement( ),renderIng)

--[[function renderPickup ( )
    local px, py, pz, tx, ty, tz, dist
    local px, py, pz = getCameraMatrix()
    for _, v in ipairs(getElementsByType("pickup")) do
         local tx, ty, tz = getElementPosition( v )
         local dist = math.sqrt( ( px - tx ) ^ 2 + ( py - ty ) ^ 2 + ( pz - tz ) ^ 2 )
         if dist < 30.0 then
            if isLineOfSightClear( px, py, pz, tx, ty, tz, true, false, false, true, false, false, false,localPlayer ) then
               local sx, sy, sz = getElementPosition( v )
               local x,y = getScreenFromWorldPosition( sx + 0.9, sy, sz + 0.7 ,100,false )
               if x and y then 
               local message = tostring(getElementData(v, "message"))
               if message ~= "false" then
				local distance = getDistanceBetweenPoints3D(px, py, pz, sx, sy, sz)
                dxDrawText(message, x, y+10, x, y, tocolor(245,245,245), 0.60 + ( 15 - dist ) * 0.02, "bankgothic" )
                else return end
                end
            end
         end
      end
end	
addEventHandler( "onClientRender",root,renderPickup) 

function renderMarker ( )
    local px, py, pz, tx, ty, tz, dist
    local px, py, pz = getCameraMatrix()
    for _, v in ipairs(getElementsByType("marker")) do
         local tx, ty, tz = getElementPosition( v )
         local dist = math.sqrt( ( px - tx ) ^ 2 + ( py - ty ) ^ 2 + ( pz - tz ) ^ 2 )
         if dist < 30.0 then
            if isLineOfSightClear( px, py, pz, tx, ty, tz, true, false, false, true, false, false, false,localPlayer ) then
               local sx, sy, sz = getElementPosition( v )
               local x,y = getScreenFromWorldPosition( sx + 0.9, sy, sz + 0.7 ,100,false )
               if x and y then 
               local message = tostring(getElementData(v, "message"))
               if message ~= "false" then
				local distance = getDistanceBetweenPoints3D(px, py, pz, sx, sy, sz)
                dxDrawText(message, x, y+10, x, y, tocolor(245,245,245), 0.60 + ( 15 - dist ) * 0.02, "bankgothic" )
                else return end
                end
            end
         end
      end
end	
addEventHandler( "onClientRender",root,renderMarker) 
]]