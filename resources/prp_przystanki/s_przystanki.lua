function takePlayerMoney(c)
	exports.global:takeMoney( source, c )
end
addEvent("takePlayerMoney", true)
addEventHandler("takePlayerMoney", getRootElement(), takePlayerMoney)