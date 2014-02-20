function showClientImage()

   guiCreateStaticImage( 9, 965, 280, 45, "img/cg.png", false )
end
addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource() ), showClientImage )