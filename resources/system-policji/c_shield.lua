txd = engineLoadTXD ( "riot_shield.txd" )
engineImportTXD ( txd, 1631)
dff = engineLoadDFF ( "riot_shield.dff", 1631 )
col = engineLoadCOL("riot_shield.col")
engineReplaceCOL(col, 1631)
engineReplaceModel(dff, 1631)


fileDelete("c_shield.lua")