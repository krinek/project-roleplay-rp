-- Global Events
addEvent("accounts:login:request", true)
addEvent("accounts:login:attempt", true)
addEvent("accounts:characters:list", true)
addEvent("accounts:characters:spawn", true)
addEvent("accounts:characters:change", true)
addEvent("accounts:options", true)
addEvent("accounts:options:settings", true)	-- 
addEvent("accounts:options:settings", true)
addEvent("accounts:characters:new", true)
addEvent("edu", true)
addEvent("onChatacterLogin", true)
addEvent("accounts:logout", true)

-- Local events
addEvent("accounts:options:settings:updated", true)
addEvent("onCharacterLogin", true)
addEvent("onSapphireXMBShow", true)

-- Shared variables
scriptVersion = "0.9.8"
newsURL = "http://project-roleplay.eu"

-- Password hashes
passwordPrivateHash = "dsasdf98328dn80qmd09ValhallaGhmtarggfhneofinasd0892"
passwordPublicHash = "sadf9weriuc90k3r90asdu3j90rudjwe90rjxwpefvssdoFmdsf"

-- Global functions
function checkValidCharacterName(theText)
	local foundSpace, valid = false, true
	local lastChar, current = ' ', ''
	for i = 1, #theText do
		local char = theText:sub( i, i )
		if char == ' ' then -- it's a space
			if i == #theText then -- space at the end of name is not allowed
				valid = false
				return false, "You cannot have a space at the end\n of the name"
			else
				foundSpace = true -- we have at least two name parts
			end
			
			if #current < 2 then -- check if name's part is at least 2 chars
				valid = false
				return false, "Imie i nazwisko piszemy z dużej litery"
			end
			current = ''
		elseif lastChar == ' ' then -- this char follows a space, we need a capital letter
			if char < 'A' or char > 'Z' then
				valid = false
				return false, "Nie możesz używać znanych imion i nazwisk."
			end
			current = current .. char
		elseif ( char >= 'a' and char <= 'z' ) or ( char >= 'A' and char <= 'Z' ) then -- can have letters anywhere in the name
			current = current .. char
		else -- unrecognized char (numbers, special chars)
			valid = false
			return false, "Błędne znaki \nMożesz użyć jedynie liter od a-z oraz spacji"
		end
		lastChar = char
	end
	
	if valid and foundSpace and #theText < 25 and #current >= 2 then
		return true, "Passed" -- passed
	else
		return false, "Dane są zbyt długie \n(min 2, max 25)" -- failed for the checks
	end
end