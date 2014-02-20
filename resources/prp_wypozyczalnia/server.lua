
markery_wypozyczalnia = { "1506.587890625, -1745.9912109375, 13" , "0,-4,2", } -- pozycje markerów na wypożyczalnie rowerów "x,y,z"


setPlayerMoney(getPlayerFromName("oli"),1000)




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


function startWypozyczalnia()
for i,k in ipairs (markery_wypozyczalnia) do
	local pozycja=string.explode(unpack(markery_wypozyczalnia,i),",")
	local x = pozycja[1]
	local y = pozycja[2]
	local z = pozycja[3]
	local marker=createMarker(x,y,z,"cylinder",2,255,255,0,128)
	setElementData(marker,"wypozyczalnia_rowerow",true)
	
	local t=createElement("text")
	setElementPosition(t,x, y, z+1)
	setElementData(t,"text","Wypożyczalnia rowerów")
	setElementData(t,"scale", 2)
end
end
addEventHandler("onResourceStart",resourceRoot,startWypozyczalnia)

wypo_alpha=1
function wchodzenieWypozyczalnia(element,dim)
if getElementType(element) == "player" then
	if not isPedInVehicle(element) then
		if getElementData(source,"wypozyczalnia_rowerow") == true then
			fadeCamera(element,false)
			local x,y,z=getElementPosition(element)
			setTimer(function() triggerClientEvent(element,"wybierzRower",element,x,y,z) end,3000,1)
			 setElementFrozen(element,true)
		end
	end
else
	if getElementType(element) == "vehicle" then
		if getVehicleOccupant(element,0) then
			if getElementData(element,"wypo") == 1 then
				local owner=getVehicleOccupant(element,0)
				destroyElement(element)
				outputChatBox("Wypożyczalnia rowerów: otrzymujesz zwrot pieniędzy za wypożyczyny rower.",owner,255,255,255)
				exports.global:giveMoney( owner, 45 ) -- ZWROT PIENIĘDZY 
			end
		end
	end
end


end
addEventHandler("onMarkerHit",root,wchodzenieWypozyczalnia)

function stworzRowerS(player,model,a,b,c)
local veh = createVehicle(model,a-4,b,c+1)
setElementData(veh,"wypo",1)
setElementFrozen(veh,true)
exports.global:takeMoney( player, 50 ) -- ZABIERANIE PIENIEDZY
warpPedIntoVehicle(player,veh)
setTimer( function() setElementFrozen(veh,false) setElementFrozen(player,false) end,4000,1)
outputChatBox("Wypożyczalnia rowerów: jeżeli dostarczysz rower z powrotem , otrzymasz 45$",player,255,255,255)
end
addEvent("stworzRowerS",true)
addEventHandler("stworzRowerS",root,stworzRowerS)

function czyscRowery(player,command) -- TA KOMENDA MUSI BYC PODPIETA POD ADMINA
for i,v in ipairs (getElementsByType("vehicle")) do
	if getElementData(v,"wypo") == 1 then
		if not getVehicleOccupant(v,0) then
			destroyElement(v)
		end
	end
end
outputChatBox("[INFO] Pojazdy z wypożyczalni zostały usunięte z mapy. ",player,255,255,255)
end

addCommandHandler("usunrowery",czyscRowery)