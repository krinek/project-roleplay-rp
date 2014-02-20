function restartSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("PRZYKŁAD: /restartres [Nazwa zasobu]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				if getResourceState(theResource) == "running" then
					restartResource(theResource)
					outputChatBox("Skrypt " .. resourceName .. " zrestartowany.", thePlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " zrestartował skrypt '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("Skrypt " .. resourceName .. " włączony.", thePlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " włączył skrypt '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("Skrypt " .. resourceName .. " nie może zostać załadowany (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
				else
					outputChatBox("Skrypt " .. resourceName .. " nie może zostać włączony (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
				end
				
			else
				outputChatBox("Nie ma takiego skryptu.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restartres", restartSingleResource)
 
function stopSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("PRZYKŁAD: /stopres [Nazwa zasobu]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				if stopResource(theResource) then
					outputChatBox("Skrypt " .. resourceName .. " zatrzymany.", thePlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " zatrzymał skrypt '" .. resourceName .. "'.")
				else
					outputChatBox("Nie można wyłączyć skryptu " .. resourceName .. ".", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Nie ma takiego skryptu.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("stopres", stopSingleResource)
 
function startSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerScripter(thePlayer) or exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("PRZYKŁAD: /startres [Nazwa zasobu]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				if getResourceState(theResource) == "running" then
					outputChatBox("Skrypt " .. resourceName .. " jest włączony.", thePlayer, 0, 255, 0)
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("Skrypt " .. resourceName .. " został uruchomiony.", thePlayer, 0, 255, 0)
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " włączył skrypt '" .. resourceName .. "'.")
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("Skrypt " .. resourceName .. " nie może być załadowany (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
				else
					outputChatBox("Resource " .. resourceName .. " nie może wystartować (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Nie znaleziono zasobu.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("startres", startSingleResource)

function restartGateKeepers(thePlayer, commandName)
	if exports.global:isPlayerAdmin(thePlayer) then
		local theResource = getResourceFromName("gatekeepers-system")
		if theResource then
			if getResourceState(theResource) == "running" then
				restartResource(theResource)
				outputChatBox("Gatekeepers zostają restartowane.", thePlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " restartował gatekeepers.")
				--exports.logs:logMessage("[STEVIE] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." restarted the gatekeepers." , 25)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RESETSTEVIE")
			elseif getResourceState(theResource) == "loaded" then
				startResource(theResource)
				outputChatBox("Gatekeepers were started", thePlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the gatekeepers.")
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RESETSTEVIE")
			elseif getResourceState(theResource) == "failed to load" then
				outputChatBox("Gatekeepers could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restartgatekeepers", restartGateKeepers)