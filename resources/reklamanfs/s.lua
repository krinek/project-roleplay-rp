function redirectPlayerEv()
	redirectPlayer( source, "91.121.148.109", 22003 )
end

addEvent( "redirectPlayerEv", true )
addEventHandler( "redirectPlayerEv", getRootElement(), redirectPlayerEv )