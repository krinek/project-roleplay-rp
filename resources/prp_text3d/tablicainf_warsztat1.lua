local tablice={
-- [WZÓR] [x,y,z,r,dimension,interior]

	{1861.8525390625, -1761.828125, 13.30,1,0,0,tablica=118, nazwa="(( tablica informacyjna ))\nWarsztat1" },	-- parking pomocy drogowej przy stacji dolnej

}


ib_win = guiCreateWindow(0.5703,0.2729,0.4016,0.5958,"Informacje.",true)
ib_memo = guiCreateMemo(0.0506,0.1049,0.8911,0.8462,"Treść itd itd itd",true,ib_win)
guiSetVisible(ib_win,false)

for i,v in ipairs(tablice) do
	v.cs=createColSphere(v[1],v[2],v[3],v[4])
	setElementInterior(v.cs,v[6])
	setElementDimension(v.cs,v[5])
	v.t3d=createElement("text")
	setElementPosition(v.t3d,v[1],v[2],v[3]+1)
	setElementData(v.t3d, "text", v.nazwa or "(( tablica\ninformacyjna ))")
	setElementInterior(v.t3d,v[6])
	setElementDimension(v.t3d,v[5])

end



addEventHandler("onClientColShapeHit", resourceRoot, function(el,md)
	if (not md) then return end
	if (el~=localPlayer) then return end

	guiSetVisible(ib_win,true)
	guiSetInputMode("no_binds_when_editing")

end)
addEventHandler("onClientColShapeLeave", resourceRoot, function(el,md)
	if (el~=localPlayer) then return end
	guiSetVisible(ib_win,false)

	
end)


fileDelete("tablicainf_warsztat1.lua")