--[[
Polaczenie z baza danych

@author Daniex0r <daniex0r@gmail.com>
@copyright 2012-2013 Daniex0r <daniex0r@gmail.com>
@license GPLv2
@package project-roleplay-rp
@link https://github.com/Daniex0r/project-roleplay-rp
]]--

-- Ustawienia polaczenia
local hostname = get( "hostname" ) or "localhost" -- lub twoj hosting
local username = get( "username" ) or "uzytkownik"
local password = get( "password" ) or "twojehaslo"
local database = get( "database" ) or "nazwabazydanych"
local port = tonumber( get( "port" ) ) or 3306
local socket = get( "sock" ) or "/var/run/mysqld/mysqld.sock"

-- funckje globalne.
local MySQLConnection = nil
local resultPool = { }
local queryPool = { }
local sqllog = false
local countqueries = 0


function connectToDatabase(res)
	MySQLConnection = mysql_connect(hostname, username, password, database, port, socket)
	
	if (not MySQLConnection) then
		if (res == getThisResource()) then
			cancelEvent(true, "Cannot connect to the database.")
		end
		return nil
	end
	
	return nil
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), connectToDatabase, false)
	

function destroyDatabaseConnection()
	if (not MySQLConnection) then
		return nil
	end
	mysql_close(MySQLConnection)
	return nil
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), destroyDatabaseConnection, false)

function logSQLError(str)
	local message = str or 'N/A'
	outputDebugString("MYSQL ERROR "..mysql_errno(MySQLConnection) .. ": " .. mysql_error(MySQLConnection))
	exports['logs']:logMessage("MYSQL ERROR [QUERY] " .. message .. " [ERROR] " .. mysql_errno(MySQLConnection) .. ": " .. mysql_error(MySQLConnection), 24)
end

function getFreeResultPoolID()
	local size = #resultPool
	if (size == 0) then
		return 1 
	end
	for index, query in ipairs(resultPool) do
		if (query == nil) then
			return index
		end
	end
	return (size + 1)
end

------------ Eksportowane funkcje ---------------

function ping()
	if (mysql_ping(MySQLConnection) == false) then
		destroyDatabaseConnection()
		connectToDatabase(nil)
		if (mysql_ping(MySQLConnection) == false) then
			logSQLError()
			return false
		end
		return true
	end

	return true
end

function escape_string(str)
	if (ping()) then
		return mysql_escape_string(MySQLConnection, str)
	end
	return false
end

function query(str)
	if sqllog then
		exports['logs']:logMessage(str, 24)
	end
	countqueries = countqueries + 1
	
	if (ping()) then
		local result = mysql_query(MySQLConnection, str)
		if (not result) then
			logSQLError(str)
			return false
		end

		local resultid = getFreeResultPoolID()
		resultPool[resultid] = result
		queryPool[resultid] = str
		return resultid
	end
	return false
end

function unbuffered_query(str)
	if sqllog then
		exports['logs']:logMessage(str, 24)
	end
	countqueries = countqueries + 1
	
	if (ping()) then
		local result = mysql_unbuffered_query(MySQLConnection, str)
		if (not result) then
			logSQLError(str)
			return false
		end

		local resultid = getFreeResultPoolID()
		resultPool[resultid] = result
		queryPool[resultid] = str
		return resultid
	end
	return false
end

function query_free(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		free_result(queryresult)
		return true
	end
	return false
end

function rows_assoc(resultid)
	if (not resultPool[resultid]) then
		return false
	end
	return mysql_rows_assoc(resultPool[resultid])
end

function fetch_assoc(resultid)
	if (not resultPool[resultid]) then
		return false
	end
	return mysql_fetch_assoc(resultPool[resultid])
end

function free_result(resultid)
	if (not resultPool[resultid]) then
		return false
	end
	mysql_free_result(resultPool[resultid])
	table.remove(resultPool, resultid)
	table.remove(queryPool, resultid)
	return nil
end


function result(resultid, row_offset, field_offset)
	if (not resultPool[resultid]) then
		return false
	end
	return mysql_result(resultPool[resultid], row_offset, field_offset)
end

function num_rows(resultid)
	if (not resultPool[resultid]) then
		return false
	end
	return mysql_num_rows(resultPool[resultid])
	
end

function insert_id()
	return mysql_insert_id(MySQLConnection) or false
end

function query_fetch_assoc(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = fetch_assoc(queryresult)
		free_result(queryresult)
		return result
	end
	return false
end

function query_rows_assoc(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = rows_assoc(queryresult)
		free_result(queryresult)
		return result
	end
	return false
end

function query_insert_free(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = insert_id()
		free_result(queryresult)
		return result
	end
	return false
end

function escape_string(str)
	return mysql_escape_string(MySQLConnection, str)
end

function debugMode()
	if (sqllog) then
		sqllog = false
	else
		sqllog = true
	end
	return sqllog
end

function returnQueryStats()
	return countqueries
end

function getOpenQueryStr( resultid )
	if (not queryPool[resultid]) then
		return false
	end
	
	return queryPool[resultid]
end
