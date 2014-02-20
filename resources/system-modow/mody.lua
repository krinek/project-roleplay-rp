function modyfikacje()
			
	-- Skin policjatnki
	skin9 = engineLoadTXD("skiny/9/policjantka.txd")
	engineImportTXD(skin9, 9)		

	
end
addEventHandler("onClientResourceStart", getResourceRootElement(), modyfikacje)

