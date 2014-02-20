local font = "default"
local fontColor = tocolor( 255, 255, 255, 255 )
local fontSize = 1.25
local bgColor = tocolor( 0, 0, 0, 192 )
local bgHeight = 30
local space = 200
local speed = 0.4

local sizex,sizey = guiGetScreenSize()
local fontHeight = dxGetFontHeight( fontSize, font )
local msgData = {}


addEvent( "newsAddNew", true )
addEventHandler( "newsAddNew", getRootElement(),
	function( msg )
		local elem = {}
		elem.x = sizex
		if #msgData > 0 then
			local lelem = msgData[#msgData]
			elem.x = lelem.x + lelem.len + space
		end
		elem.len = dxGetTextWidth( string.gsub(msg,"#%x%x%x%x%x%x",""), fontSize, font )
		elem.msg = msg
		table.insert( msgData, elem )
		table.insert( msgData, elem )
		table.insert( msgData, elem )
	end
)

addEventHandler( "onClientRender", getRootElement(),
	function()
		if #msgData >= 1 then
			dxDrawRectangle( 0, sizey-bgHeight, sizex, bgHeight, bgColor )
			local toDel = false
			for i,v in ipairs(msgData) do
				if v.x+v.len < 10 and i == 1 then
					toDel = true
				end
				dxDrawColorText( v.msg, v.x, (sizey-bgHeight)+(bgHeight/2-fontHeight/2), v.x+v.len, sizey, fontColor, fontSize )
				v.x = v.x - speed
			end
			if toDel then
				table.remove( msgData, 1 )
			end
		end
	end
)

function dxDrawColorText(str, ax, ay, bx, by, color, scale, font, alignX, alignY)
  bx, by, color, scale, font = bx or ax, by or ay, color or tocolor(255,255,255,255), scale or 1, font or "default"
  if alignX then
    if alignX == "center" then
      ax = ax + (bx - ax - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font))/2
    elseif alignX == "right" then
      ax = bx - dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
    end
  end
  if alignY then
    if alignY == "center" then
      ay = ay + (by - ay - dxGetFontHeight(scale, font))/2
    elseif alignY == "bottom" then
      ay = by - dxGetFontHeight(scale, font)
    end
  end
  local alpha = string.format("%08X", color):sub(1,2)
  local pat = "(.-)#(%x%x%x%x%x%x)"
  local s, e, cap, col = str:find(pat, 1)
  local last = 1
  while s do
    if cap == "" and col then color = tocolor(getColorFromString("#"..col..alpha)) end
    if s ~= 1 or cap ~= "" then
      local w = dxGetTextWidth(cap, scale, font)
      dxDrawText(cap, ax, ay, ax + w, by, color, scale, font)
      ax = ax + w
      color = tocolor(getColorFromString("#"..col..alpha))
    end
    last = e + 1
    s, e, cap, col = str:find(pat, last)
  end
  if last <= #str then
    cap = str:sub(last)
    dxDrawText(cap, ax, ay, ax + dxGetTextWidth(cap, scale, font), by, color, scale, font)
  end
end