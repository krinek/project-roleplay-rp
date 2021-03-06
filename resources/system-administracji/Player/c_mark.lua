local marks = { }
local default = false
local localPlayer = getLocalPlayer( )

function saveMarks( )
	local xml = xmlCreateFile( "Player/mark.xml", "marks" )
	local function saveNode( data, name )
		if #data >= 5 then
			local xml = xmlCreateChild( xml, "mark" )
			if name then
				xmlNodeSetValue( xml, name )
			end
			xmlNodeSetAttribute( xml, "x", data[1] )
			xmlNodeSetAttribute( xml, "y", data[2] )
			xmlNodeSetAttribute( xml, "z", data[3] )
			xmlNodeSetAttribute( xml, "interior", data[4] )
			xmlNodeSetAttribute( xml, "dimension", data[5] )
		end
	end
	if default then
		saveNode( default )
	end
	for key, value in pairs( marks ) do
		saveNode( value, key )
	end
	xmlSaveFile( xml )
	xmlUnloadFile( xml )
end

addEventHandler( "onClientResourceStart", resourceRoot,
	function( )
		local xml = xmlLoadFile( "Player/mark.xml" )
		if xml then
			for key, value in ipairs( xmlNodeGetChildren( xml ) ) do
				local name = xmlNodeGetValue( value )
				if name and #name == 0 then
					name = false
				end
				
				local data = { tonumber( xmlNodeGetAttribute( value, "x" ) ), tonumber( xmlNodeGetAttribute( value, "y" ) ), tonumber( xmlNodeGetAttribute( value, "z" ) ), tonumber( xmlNodeGetAttribute( value, "interior" ) ), tonumber( xmlNodeGetAttribute( value, "dimension" ) ), name }
				if not name then
					default = data
				else
					marks[ name ] = data
				end
			end
			xmlUnloadFile( xml )
		end
	end
)

addCommandHandler( "mark",
	function( commandName, ... )
		if exports.global:isPlayerAdmin( localPlayer ) or (getElementData(localPlayer, "account:gmlevel") > 0 and getElementData(localPlayer, "account:gmduty")) then
			-- store the mark
			local name = ( ... ) and table.concat( { ... }, " " ):lower( )
			local x, y, z = getElementPosition( localPlayer )
			local interior = getElementInterior( localPlayer )
			local dimension = getElementDimension( localPlayer )
			local data = { x, y, z, interior, dimension, name }
			if not name then
				default = data
			else
				marks[ name ] = data
			end
			
			-- save in the xml
			saveMarks( )
			
			-- success message
			outputChatBox( "Mark " .. ( name and "'" .. name .. "' " or "" ) .. "zosta� zapisany.", 0, 255, 0 )
		end
	end
)

addCommandHandler( "tepmark",
	function( commandName, ... )
		if exports.global:isPlayerAdmin( localPlayer ) or (getElementData(localPlayer, "account:gmlevel") > 0 and getElementData(localPlayer, "account:gmduty")) then
			-- store the mark
			local name = ( ... ) and table.concat( { ... }, " " ):lower( )
			if not name then
				if default then
					triggerServerEvent( "gotoMark", localPlayer, unpack( default ) )
				else
					outputChatBox( "Muszisz najpierw ustali� /mark !", 255, 0, 0 )
				end
			else
				if marks[ name ] then
					triggerServerEvent( "gotoMark", localPlayer, unpack( marks[ name ] ) )
				else
					outputChatBox( "Musisz najpierw ustali� mark komenda /mark " .. name .. " :) !", 255, 0, 0 )
				end
			end
		end
	end
)

addCommandHandler( "marki",
	function( commandName )
		local count = 1
		if default then
			outputChatBox( "  #" .. count .. ": (domy�lnny)", 255, 255, 0 )
			count = count + 1
		end
		
		for key, value in pairs( marks ) do
			outputChatBox( "  #" .. count .. ": " .. key, 255, 255, 0 )
			count = count + 1
		end
	end
)

addCommandHandler( "usunmark",
	function( commandName, ... )
		if exports.global:isPlayerAdmin( localPlayer ) or (getElementData(localPlayer, "account:gmlevel") > 0 and getElementData(localPlayer, "account:gmduty")) then
			-- store the mark
			local name = ( ... ) and table.concat( { ... }, " " ):lower( )
			if not name then
				if default then
					default = false
					outputChatBox( "Domy�lnny mark zosta� usuni�ty.", 0, 255, 0 )
					saveMarks( )
				else
					outputChatBox( "Musisz ustali� mark przez /mark najpierw!", 255, 0, 0 )
				end
			else
				if marks[ name ] then
					marks[ name ] = nil
					outputChatBox( "Mark '" .. name .. "' poprawnie usuni�ty.", 0, 255, 0 )
					saveMarks( )
				else
					outputChatBox( "Musisz ustali� mark przez /mark " .. name .. " najpierw!", 255, 0, 0 )
				end
			end
		end
	end
)
