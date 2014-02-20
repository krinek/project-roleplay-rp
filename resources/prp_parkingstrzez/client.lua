function buildNotice()
    purpleLabel = guiCreateLabel(0.65, 0, 1, 1, "Parking Strzezony.", true)
    guiSetFont(purpleLabel, "sa-header")
    guiLabelSetColor(purpleLabel,255,102,0)
    guiSetVisible(purpleLabel,false)
end
addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource() ), buildNotice)
 
addEvent("zoneEnter", true)
addEventHandler("zoneEnter", getRootElement(),
    function()
        guiSetVisible(purpleLabel, true)
    end
)
addEvent("zoneExit", true)
addEventHandler("zoneExit", getRootElement(),
    function()
        guiSetVisible(purpleLabel, false)
    end
)