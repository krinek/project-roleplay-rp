--[[
Polaczenie z baza danych

@author Daniex0r <daniex0r@gmail.com>
@copyright 2012-2013 Daniex0r <daniex0r@gmail.com>
@license GPLv2
@package project-roleplay-rp
@link https://github.com/Daniex0r/project-roleplay-rp
]]--

username = get( "username" ) or "uzytkownik"
password = get( "password" ) or "twojehaslo"
db = get( "database" ) or "nazwabazydanych"
host = get( "hostname" ) or "localhost" -- lub twoj hosting
port = tonumber( get( "port" ) ) or 3306

function getMySQLUsername()
	return username
end

function getMySQLPassword()
	return password
end

function getMySQLDBName()
	return db
end

function getMySQLHost()
	return host
end

function getMySQLPort()
	return port
end


function lazyQuery(message)
	local filename = "/lazyqueries.log"

	
	
	local file = createFileIfNotExists(filename)
	local size = fileGetSize(file)
	fileSetPos(file, size)
	fileWrite(file, message .. "\r\n")
	fileFlush(file)
	fileClose(file)
	
	return true
end

function createFileIfNotExists(filename)
	local file = fileOpen(filename)
	
	if not (file) then
		file = fileCreate(filename)
	end
	
	return file
end
