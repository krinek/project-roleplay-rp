local screenw,screenh= guiGetScreenSize()

local przecinekx,przecineky=screenw*725/800,109/600*screenh
local przecinekfs=screenh/600

if isPlayerHudComponentVisible("money") then
		 dxDrawText(",", przecinekx-2,przecineky+2,przecinekx,przecineky,tocolor(0,0,0),przecinekfs,"pricedown")
		 dxDrawText(",", przecinekx-2,przecineky-2,przecinekx,przecineky,tocolor(0,0,0),przecinekfs,"pricedown")
		 dxDrawText(",", przecinekx+2,przecineky+2,przecinekx,przecineky,tocolor(0,0,0),przecinekfs,"pricedown")
		 dxDrawText(",", przecinekx+2,przecineky-2,przecinekx,przecineky,tocolor(0,0,0),przecinekfs,"pricedown")
		 dxDrawText(",", przecinekx,przecineky,przecinekx,przecineky,tocolor(47, 90, 38),przecinekfs,"pricedown")
		-- glod/nasycenie
		
		if not isElementInWater(localPlayer) then
			-- 681/800
			-- tlo
			dxDrawRectangle(683/800*screenw, 75/600*screenh, 76/800*screenw, 11/600*screenh, tocolor(0,0,0,255))
			dxDrawRectangle(685/800*screenw, 77/600*screenh, 72/800*screenw, 7/600*screenh, tocolor(255,255,0,64))
		end
		
end