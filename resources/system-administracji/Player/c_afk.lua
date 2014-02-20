local afkCount = 0
local lx,ly,lz = 0,0,0

setTimer (
	function ()
		if getElementData(getLocalPlayer(),"afk") == false then
			local hp = getElementHealth (getLocalPlayer())
			if hp > 0 then
				if isPedOnGround (getLocalPlayer()) then
					local cx,cy,cz = getCameraMatrix ()
					if cx == lx and cy == ly and cz == lz then
						afkCount = afkCount+1
						if afkCount >= 12 then
							setElementData (getLocalPlayer(),"afk",true)
							afkCount = 0
						end
					else
						afkCount = 0
					end
					lx,ly,lz = cx,cy,cz
				end
			end
		else
			local cx,cy,cz = getCameraMatrix ()
			if cx ~= lx or cy ~= ly or cz ~= lz then
				setElementData (getLocalPlayer(),"afk",false)
				afkCount = 0
				lx,ly,lz = cx,cy,cz
			end
		end
	end
,2500,0)

addEventHandler( "onClientMinimize", getRootElement(),
	function ()
		local cx,cy,cz = getCameraMatrix ()
		lx,ly,lz = cx,cy,cz
		afkCount = 0
		setElementData (getLocalPlayer(),"afk",true)
	end
)

addEventHandler("onClientKey", root, 
	function ()
		if getElementData(getLocalPlayer(),"afk") == true then
			local cx,cy,cz = getCameraMatrix ()
			lx,ly,lz = cx,cy,cz
			afkCount = 0
			setElementData (getLocalPlayer(),"afk",false)
		end
	end
)

if getElementData (i,"afk") then
												if progress < 1 then
													local by = posY-5
													local scale = interpolateBetween (
														1,0,0,
														0,0,0,
														progress,"OutQuad"
													)
													local width,height = 256*scale,128*scale
													local ix,iy = sx-width/2,by-height
													dxDrawImage (ix,iy,width,height,"afk.png",0,0,0,tocolor(255,255,255,textalpha))
												end
											end