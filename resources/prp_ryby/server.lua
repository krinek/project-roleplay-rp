markery_ryby={"403.7336730957,-2086.9340820313,7.8300905227661" , 
"396.11712646484,-2087.2326660156,7.8359375" , 
"368.95776367188,-2086.4436035156,7.8359375",
"354.84902954102,-2087.970703125,7.8359375",
"374.82989501953,-2086.5729980469,7.8359375",
"391.11544799805,-2087.4682617188,7.8359375"}


function Check(funcname, ...)
    local arg = {...}
 
    if (type(funcname) ~= "string") then
        error("Argument type mismatch at 'Check' ('funcname'). Expected 'string', got '"..type(funcname).."'.", 2)
    end
    if (#arg % 3 > 0) then
        error("Argument number mismatch at 'Check'. Expected #arg % 3 to be 0, but it is "..(#arg % 3)..".", 2)
    end
 
    for i=1, #arg-2, 3 do
        if (type(arg[i]) ~= "string" and type(arg[i]) ~= "table") then
            error("Argument type mismatch at 'Check' (arg #"..i.."). Expected 'string' or 'table', got '"..type(arg[i]).."'.", 2)
        elseif (type(arg[i+2]) ~= "string") then
            error("Argument type mismatch at 'Check' (arg #"..(i+2).."). Expected 'string', got '"..type(arg[i+2]).."'.", 2)
        end
 
        if (type(arg[i]) == "table") then
            local aType = type(arg[i+1])
            for _, pType in next, arg[i] do
                if (aType == pType) then
                    aType = nil
                    break
                end
            end
            if (aType) then
                error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..table.concat(arg[i], "' or '").."', got '"..aType.."'.", 3)
            end
        elseif (type(arg[i+1]) ~= arg[i]) then
            error("Argument type mismatch at '"..funcname.."' ('"..arg[i+2].."'). Expected '"..arg[i].."', got '"..type(arg[i+1]).."'.", 3)
        end
    end
end
function string.explode(self, separator)
    Check("string.explode", "string", self, "ensemble", "string", separator, "separator")
 
    if (#self == 0) then return {} end
    if (#separator == 0) then return { self } end
 
    return loadstring("return {\""..self:gsub(separator, "\",\"").."\"}")()
end
bazaryby=createMarker(376.08239746094,-2068.5048828125,6.8359375,"cylinder",2,255,0,0)
setElementData(bazaryby,"ryby_marker2",true)
setElementData(bazaryby,"ryby_baza",true)
function bazaRyby()
for i,k in ipairs (markery_ryby) do
	local pozycja=string.explode(unpack(markery_ryby,i),",")
	local x = pozycja[1]
	local y = pozycja[2]
	local z = pozycja[3]
	local marker=createMarker(x,y,z-1,"cylinder",2,255,255,0)
	setElementData(marker,"ryby_marker",true)
	setElementData(marker,"ryby_enabled",true)
end
end
addEventHandler("onResourceStart",root,bazaRyby)

function rybyMark(element,dim)
if getElementType(element) == "player" then
	if getElementData(source,"ryby_marker")==true then
		if getElementData(source,"ryby_enabled") == true then
			triggerClientEvent(element,"rybyStart",element,source)
			setElementData(source,"ryby_enabled",false)
		else
			outputChatBox("[INFO] To łowisko już jest zajęte przez innego gracza. ",element )
		end
	end
	if getElementData(source,"ryby_marker2") == true then
		if getElementData(source,"ryby_baza") == true then
			triggerClientEvent(element,"sprzedajRyby",element)
		end
	end
end


end
addEventHandler("onMarkerHit",root,rybyMark)

function dodajRybyData()
setElementData(source,"ryby_zlowione",0)
end
addEventHandler("onPlayerJoin",root,dodajRybyData)

function givePlayerMoney(c)
	exports.global:giveMoney( source, c )
end
addEvent("givePlayerMoney", true)
addEventHandler("givePlayerMoney", getRootElement(), givePlayerMoney)