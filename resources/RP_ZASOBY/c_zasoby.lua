local timer = setTimer( checkTransfer 1000, 0 )

 function checkTransfer( )
 	if not isTransferBoxActive( ) then
		triggerServerEvent( "onClientSend", getLocalPlayer() )
		killTimer( timer )
	end 
end