﻿local myadminWindow = nil

function gmhelp (commandName)

	local sourcePlayer = getLocalPlayer()
	if exports.global:isPlayerGameMaster(sourcePlayer) or exports.global:isPlayerAdmin(sourcePlayer) then
		if (myadminWindow == nil) then
			guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
			myadminWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Index of GM commands", false)
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
			local lists = {}
			for level = 1, 5 do 
				local tab = guiCreateTab("Level " .. level, tabPanel)
				lists[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (lists[level], "Command", 0.15)
				guiGridListAddColumn (lists[level], "Syntax", 0.35)
				guiGridListAddColumn (lists[level], "Explanation", 1.3)
			end
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Zamknij", true, myadminWindow) -- close button
			
			local commands =
			{
				-- level -1: Trainee GM
				{
					-- player/*
					{ "/gmlounge", "/gmlounge", "Teleports you to the GM lounge." },
					{ "/g", "/g [Text]", "Czat GM-ów." },
				       { "/podglad", "/podglad [player]", "Podgląd gracza." },
					{ "/ar", "/ar [Report ID]", "Akceptacja zgłoszenia." },
					{ "/cr", "/cr [Report ID]", "Zamknięcie zgłoszenia." },
					{ "/dr", "/dr [Report ID]", "Anulowanie akceptacj zgłoszenia." },
					{ "/fr", "/fr [Report ID]", "Uznanie zgłoszneia na fałszywe." },
					{ "/gmduty", "/gmduty", "Włącza twój dyżur (wł/wył)." },
					{ "/goto", "/goto [player]", "Teleportuje sie do gracza." },
					{ "/gotoplace", "/gotoplace [LV/SF/LS/ASH/BANK/IGS/PC]", "Teleportuje cie do wybranego miasta." },
					{ "/resetcontract", "/resetcontract [Player]", "Resetuje limit 3 wypłat graczowi." }
				},
				-- level -2: Game Master
				{
					{ "/freeze", "/freeze [Player]", "Blokuje ruch gracza." },
					{ "/unfreeze", "/unfreeze [Player]", "Odblokowywuje gracza." },
					{ "/gethere", "/gethere [Player]", "Teleportuje gracza do ciebie." },
					{ "/togpm", "/togpm", "Wyłącza wiadomosci prywatne w twoim kierunku." }

					
				},
				-- level -3: Senior GameMaster
				{
					{ "/nearbyvehicles", "/nearbyvehicles", "Pobliskie pojazdy." },
					{ "/respawnveh", "/respawnveh [ID]", "Respawn pojazdu." },
				},
				{ -- level 4 gms
				   { ">>> ", "", "Wszystkie komendy z poziomów niżej" },
				},
				{ -- level 5 gms
					{ "/makeadmin", "/makeadmin [player] [rank]", "Nadanie rangi Supportera" },
				}
			
			}
			
			for level, levelcmds in pairs( commands ) do
				if #levelcmds == 0 then
					local row = guiGridListAddRow ( lists[level] )
					guiGridListSetItemText ( lists[level], row, 1, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 2, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 3, "Nia ma komend dla tego poziomu.", false, false)
				else
					for _, command in pairs( levelcmds ) do
						local row = guiGridListAddRow ( lists[level] )
						guiGridListSetItemText ( lists[level], row, 1, command[1], false, false)
						guiGridListSetItemText ( lists[level], row, 2, command[2], false, false)
						guiGridListSetItemText ( lists[level], row, 3, command[3], false, false)
					end
				end
			end
			
			addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
				if (button == "left") then
					if (state == "up") then
						guiSetVisible(myadminWindow, false)
						showCursor (false)
						guiSetInputEnabled(false)
						myadminWindow = nil
					end
				end
			end, false)
			
			guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
		else
			local visible = guiGetVisible (myadminWindow)
			if (visible == false) then
				guiSetVisible( myadminWindow, true)
				showCursor (true)
			else
				showCursor(false)
			end
		end
	end
end
addCommandHandler("gh", gmhelp)