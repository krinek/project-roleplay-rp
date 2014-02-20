local t
local D=6
local I=3

t=createElement("text")
setElementPosition(t,1884.81, -1761.54, 17.255006790161)
setElementData(t,"text","Warsztat")
setElementData(t,"scale", 2)

t=createElement("text")
setElementPosition(t,1310.61, -1370.10, 18.60)
setElementData(t,"text","Urząd Miasta Los Santos")
setElementData(t,"scale", 3)


t=createElement("text")
setElementPosition(t,1866.4453125, -1761.2646484375, 25.754707336426)
setElementData(t,"text","Warsztat u Zbysia Polinskiego")
setElementData(t,"scale", 3)

t=createElement("text")
setElementPosition(t,1554.697265625, -1675.716796875, 21.064041137695)
setElementData(t,"text","Los Santos Police Department")
setElementData(t,"scale", 3)

t=createElement("text")
setElementPosition(t,1778.791015625, -1705.115234375, 19.847383499146)
setElementData(t,"text","Warsztat 2")
setElementData(t,"scale", 3)

t=createElement("text")
setElementPosition(t,357.65234375, 181.9072265625, 1011.3889770508)
setElementInterior(t,I)
setElementDimension(t,D)
setElementData(t,"text","Zasiłki dla bezrobotnych")
setElementData(t,"scale", 2)

t=createElement("text")
setElementPosition(t,357.787109375, 187.6494140625, 1011.3889770508)
setElementInterior(t,I)
setElementDimension(t,D)
setElementData(t,"text","Prace dorywcze wypłata")
setElementData(t,"scale", 2)

--[[t=createElement("text")
setElementPosition(t,1847.181640625, -1761.54, 17.255006790161)
setElementData(t,"text","Lakiernia")
setElementData(t,"scale", 2)--]]

fileDelete("texty.lua")