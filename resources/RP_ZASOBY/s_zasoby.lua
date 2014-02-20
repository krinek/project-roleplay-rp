addEvent( "onClientSend",true )
 
local serverDisplay,serverText
 
addEventHandler( "onClientSend",getRootElement(),
    function()
        textDisplayRemoveObserver( serverDisplay, source )
    end
)
 
addEventHandler( "onPlayerJoin",getRootElement(),
    function( )
       fadeCamera(source, true)
       serverDisplay = textCreateDisplay( )
        textDisplayAddObserver ( serverDisplay, source )
        serverText = textCreateTextItem ( "Trwa pobieranie zasobow, prosze czekac!", 0.5, 0.3,2,255,255,255,255,2,"center","top",200 )  
        textDisplayAddText ( serverDisplay, serverText )        
    end
)