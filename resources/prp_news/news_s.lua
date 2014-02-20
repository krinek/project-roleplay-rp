local nicks = { "nick", "Imie_Nazwisko" }
local msg_format = "#FF8800LIVE (%s): #FFFFFF%s" -- [%s]: %s   -->   [nick]: msg
local removeColorCodingFromNick = true
local formatSpaceFromNick = true
local duplicates = 3

addCommandHandler( "news",
	function( source, _, f, ... )
		local nn = getPlayerName( source )
		local can = false
		for i,v in ipairs(nicks) do
			if v == nn then
				can = true
				break
			end
		end
		if not can then return end
		if not f then return end
		local msg = f .. " " .. table.concat({...}," ")
		if removeColorCodingFromNick then
			nn = string.gsub( nn, "#%x%x%x%x%x%x", "" ) 
		end
		if formatSpaceFromNick then
			nn = string.gsub( nn, "_", " " ) 
		end
		local fmsg = string.format( msg_format, nn, msg )
		for i=1,duplicates do
			triggerClientEvent( getRootElement(), "newsAddNew", getRootElement(), fmsg )
		end
	end
)