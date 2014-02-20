local sizex,sizey = guiGetScreenSize()
local cdenabled = false
local cdtick = 0
local cdicons = {}
cdicons[1] = {
				file="cd/cd_3.png",
				dt=0,
				sound=43,
				did=false
			}
cdicons[2] = {
				file="cd/cd_2.png",
				dt=1200,
				sound=43,
				did=false
			}
cdicons[3] = {
				file="cd/cd_1.png",
				dt=2400,
				sound=44,
				did=false
			}
cdicons[4] = {
				file="cd/cd_go.png",
				dt=3600,
				sound=45,
				did=false
			}
			

function startCoundownRace()
	cdenabled = true
	cdtick = getTickCount()
	setTimer( stopCountdownRace, 5100, 1 )
	for i,v in ipairs(cdicons) do
		v.did = false
	end
end

addEvent( "startCoundownRace", true )
addEventHandler( "startCoundownRace", getRootElement(), startCoundownRace )

function stopCountdownRace()
	cdenabled = false
	cdtick = 0
end


addEventHandler( "onClientRender", getRootElement(),
	function ()
     	if not cdenabled then return end
		
		local dt = getTickCount()-cdtick
		for i,v in ipairs(cdicons) do
			local dt2 = dt-v.dt
			if dt2 >= 0 and dt2 <= 1500 then
				if not v.did then
					playSoundFrontEnd( v.sound )
					v.did = true
				end
				local p = dt2/1500
				local px = (sizex/2-300)
				local py = (sizey/2-200)
				local sx = 600
				local sy = 400
				local alpha = 255-(255*p)
				dxDrawImage( px+3, py+3, sx, sy, v.file, 0, 0, 0, tocolor(0,0,0,alpha) )
				dxDrawImage( px, py, sx, sy, v.file, 0, 0, 0, tocolor(220,220,255,alpha) )
			end
		end
		
	end
)