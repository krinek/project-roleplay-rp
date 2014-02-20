local wersje = { }

function setPlayerVersion(player, version)
	wersje[player] = version
end

function getPlayerVersion(player)
	return wersje[player]
end