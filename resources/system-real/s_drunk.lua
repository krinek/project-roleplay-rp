addEvent("setDrunkness", true)
addEventHandler("setDrunkness", getRootElement(),
	function( level )
		exports['antyczit']:changeProtectedElementDataEx( source, "alcohollevel", level or 0, false )
	end
)