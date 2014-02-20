function cwyplata(faction, pay, profit, interest, donatormoney, tax, incomeTax, vtax, ptax, rent, grossincome)
	--[[
	-- output payslip
	outputChatBox("-------------------------- WYPŁATA --------------------------", 255, 194, 14)
		
	-- state earnings/money from faction
	if not (faction) then
		if (pay + tax > 0) then
			outputChatBox("    Korzyść państwa: #00FF00$" .. exports.global:formatMoney(pay+tax), 255, 194, 14, true)
		end
	else
		if (pay + tax > 0) then
			outputChatBox("    Wypłata: #00FF00$" .. exports.global:formatMoney(pay+tax), 255, 194, 14, true)
		end
	end
	
	-- business profit
	if (profit > 0) then
		outputChatBox("    Zysk firmy: #00FF00$" .. exports.global:formatMoney(profit), 255, 194, 14, true)
	end
	
	-- bank interest
	if (interest > 0) then
		outputChatBox("    Odsetki bankowe: #00FF00$" .. exports.global:formatMoney(interest) .. " (0.4%)",255, 194, 14, true)
	end
	
	-- donator money (nonRP)
	if (donatormoney > 0) then
		outputChatBox("    Pieniądze Sponsora: #00FF00$" .. exports.global:formatMoney(donatormoney), 255, 194, 14, true)
	end
	
	-- Above all the + stuff
	-- Now the - stuff below
	
	-- income tax
	if (tax > 0) then
		outputChatBox("    Podatek dochodowy z " .. (incomeTax*100) .. "%: #FF0000$" .. exports.global:formatMoney(tax), 255, 194, 14, true)
	end
	
	if (vtax > 0) then
		outputChatBox("    Podatek pojazdów: #FF0000$" .. exports.global:formatMoney(vtax), 255, 194, 14, true)
	end
	
	if (ptax > 0) then
		outputChatBox("    Wydatki majątkowe: #FF0000$" .. exports.global:formatMoney(ptax), 255, 194, 14, true )
	end
	
	if (rent > 0) then
		outputChatBox("    Mieszkanie do wynajęcia: #FF0000$" .. exports.global:formatMoney(rent), 255, 194, 14, true)
	end
	

	
	outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	
	if grossincome == 0 then
		outputChatBox("  Wypłata: $0",255, 194, 14, true)
	elseif (grossincome > 0) then
		outputChatBox("  Twoja wypłata: #00FF00$" .. exports.global:formatMoney(grossincome),255, 194, 14, true)
		outputChatBox("  Informacja: Przekazane na konto bankowe.", 255, 194, 14)
	else
		outputChatBox("  Twoja wypłata: #FF0000$" .. exports.global:formatMoney(grossincome), 255, 194, 14, true)
		outputChatBox("  Unformacja: Pobierając z twojego konta bankowego.", 255, 194, 14)
	end
	
	
	if (pay + tax == 0) then
		if not (faction) then
			outputChatBox("    Rząd nie może zapłacić zasiłków państwowych.", 255, 0, 0)
		else
			outputChatBox("    Twój pracodawca nie może ci zapłacić z przyczyn braku funduszy.", 255, 0, 0)
		end
	end
	
	if (rent == -1) then
		outputChatBox("    Zostałeś wyrzucony z mieszkania, ponieważ nie masz jak zapłacić za czynsz.", 255, 0, 0)
	end
	
	outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	-- end of output payslip
	--]]
	
	if (rent == -1) then
		outputChatBox("------------------------------------------------------------------", 255, 194, 14)
		outputChatBox("    Zostałeś wyrzucony z mieszkania, ponieważ nie masz jak zapłacić za czynsz.", 255, 0, 0)
		outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	end
	
	triggerEvent("updateWaves", getLocalPlayer())
end
addEvent("cwyplata", true)
addEventHandler("cwyplata", getRootElement(), cwyplata)