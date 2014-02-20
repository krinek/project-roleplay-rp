root = getRootElement ()

local function onResourceStart ( resource )
  local players = getElementsByType ( "player" )
  for k, v in pairs ( players ) do
    setElementData ( v, "parachuting", false )
  end
end
addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), onResourceStart )

function requestAddspadochrony ()
	for key,player in ipairs(getElementsByType"player") do
		if player ~= source then
			triggerClientEvent ( player, "doAddspadochronyToPlayer", source )
		end
	end
end
addEvent ( "requestAddspadochrony", true )
addEventHandler ( "requestAddspadochrony", root, requestAddspadochrony )

function requestRemovespadochrony ()
	exports.global:takeWeapon ( source, 46 )
	for key,player in ipairs(getElementsByType"player") do
		if player ~= source then
			triggerClientEvent ( player, "doRemovespadochronyFromPlayer", source )
		end
	end
end
addEvent ( "requestRemovespadochrony", true )
addEventHandler ( "requestRemovespadochrony", root, requestRemovespadochrony )