local files = {"pomoc/zasady.xml;Zasady gry","pomoc/kary.xml;Kary","pomoc/podstawy.xml;Podstawy RP", "pomoc/tips.xml;Porady","pomoc/animacje.xml;Animacje"}
local resX,resY = guiGetScreenSize()

function startup()
	window = guiCreateWindow(resX*1/10,resY*2/10,resX/10*8,resY/10*6,"Project-Roleplay - Pomoc",false)
	guiSetVisible(window,false)
	guiWindowSetMovable(window,false)
	guiWindowSetSizable(window,false)
	tPanel = guiCreateTabPanel(0,0.1,1,1,true,window)
	local t1=guiCreateTab("Project-Roleplay", tPanel)
	guiCreateStaticImage ( 0.02, 0.04, 0.94, 0.4, "img/prp.png", true, t1 )
	guiCreateLabel( 0.02, 0.70, 0.94, 0.20, "http://mtaroleplay.pl/\n\nAdres serwera: mtasa://mta.project-roleplay.pl/", true, t1)

	for k, v in ipairs(files) do
		local data = split(v,string.byte(";"))
		local node = xmlLoadFile(data[1])
		local text = xmlNodeGetValue(node)
		local tab = guiCreateTab(data[2],tPanel)
		local memo = guiCreateMemo(0.02,0.04,0.94,0.94,text,true,tab)
		guiMemoSetReadOnly(memo,true)
		xmlUnloadFile(node)
	end
end
addEventHandler("onClientResourceStart",getResourceRootElement(),startup)

function togglePrzewodnik()
	if (guiGetVisible(window)) then
		showCursor(false)
		guiSetVisible(window,false)
	else
		showCursor(true)
		guiSetVisible(window,true)
	end
end
bindKey("F1","down",togglePrzewodnik)

fileDelete("przewodnik.lua")
