--
-- c_sPanelLite.lua
--

local scx, scy = guiGetScreenSize()

-----------------------------------------------------------------------------------
-- Settings
-----------------------------------------------------------------------------------
Settings = {}
Settings.var = {}
-- Palette 0-off 1,2 
Settings.var.PaletteON = 0
Settings.var.PaletteR = 255
Settings.var.PaletteG = 255
Settings.var.PaletteB = 255
-- palette alpha - change that if you want (depends on effects applied)
Settings.var.PaletteA = 190 
-- Bloom
Settings.var.BloomON = 0
Settings.var.cutoff = 0.08
Settings.var.power = 1.88
Settings.var.bloom = 2.0
Settings.var.blendR = 204
Settings.var.blendG = 153
Settings.var.blendB = 130
Settings.var.blendA = 140
-- Carpaint 0-off 1,2 
Settings.var.CarPaintVers = 0
Settings.var.CarPaintRefW = 640
Settings.var.CarPaintRefH = 400
Settings.var.brightnessFactorPaint= 0.18
Settings.var.brightnessFactorWShield= 1.89
Settings.var.bumpSize =0.02 -- for car paint
Settings.var.bumpSizeWnd =0.01 -- for windshields
Settings.var.normal = 1.25 -- the lower , the more normalised 0-2
Settings.var.brightnessAdd =0.5 -- before bright pass
Settings.var.brightnessMul = 1.5 -- multiply after brightpass
Settings.var.brightpassCutoff = 0.16 -- 0-1
Settings.var.brightpassPower = 2 -- 1-5
Settings.var.reflectionFlip = 1 -- 0 or 1
Settings.var.reflectionFlipAngle =0.25 -- -1,1
Settings.var.dirtTexture = 1 -- 0 or 1
-- water
Settings.var.WaterVers=0

-- Apply carpaint texture list
			texturegrun = {
			"predator92body128", "monsterb92body256a", "monstera92body256a", "andromeda92wing","fcr90092body128",
			"hotknifebody128b", "hotknifebody128a", "rcbaron92texpage64", "rcgoblin92texpage128", "rcraider92texpage128", 
			"rctiger92body128","rhino92texpage256", "petrotr92interior128","artict1logos","rumpo92adverts256","dash92interior128",
			"coach92interior128","combinetexpage128","hotdog92body256",
			"raindance92body128", "cargobob92body256", "andromeda92body", "at400_92_256", "nevada92body256",
			"polmavbody128a" , "sparrow92body128" , "hunterbody8bit256a" , "seasparrow92floats64" , 
			"dodo92body8bit256" , "cropdustbody256", "beagle256", "hydrabody256", "rustler92body256", 
			"shamalbody256", "skimmer92body128", "stunt256", "maverick92body128", "leviathnbody8bit256" 
			               }


----------------------------------------------------------------
-- Bloom and palette
----------------------------------------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()

		-- Version check
		if getVersion ().sortable < "1.1.0" then
			outputChatBox( "Resource is not compatible with this client." )
			return
		end

		-- Create things
        myScreenSourceBloom = dxCreateScreenSource(scx/2, scy/2)
		myScreenSourcePalette = dxCreateScreenSource(scx, scy)
		myScreenSourceWaterRef =dxCreateScreenSource( 300, 200)
		myScreenSourceReflect = dxCreateScreenSource( Settings.var.CarPaintRefW, Settings.var.CarPaintRefH)
	    textureVol = dxCreateTexture ( "images/smallnoise3d.dds" )
		textureCube = dxCreateTexture ( "images/cube_env256.dds" )
		if Settings.var.PaletteON~=0 then palette = dxCreateTexture ( "images/enbpalette"..Settings.var.PaletteON..".png" ) end
		paletteShader,tecName = dxCreateShader( "shaders/addPalette.fx" )
		outputDebugString( "paletteShader is using technique " .. tostring(tecName) )

        blurHShader,tecName = dxCreateShader( "shaders/blurH.fx" )
		outputDebugString( "blurHShader is using technique " .. tostring(tecName) )

        blurVShader,tecName = dxCreateShader( "shaders/blurV.fx" )
		outputDebugString( "blurVShader is using technique " .. tostring(tecName) )

        brightPassShader,tecName = dxCreateShader( "shaders/brightPass.fx" )
		outputDebugString( "brightPassShader is using technique " .. tostring(tecName) )

        addBlendShader,tecName = dxCreateShader( "shaders/addBlend.fx" )
		outputDebugString( "addBlendShader is using technique " .. tostring(tecName) )
		
	    carGrunShader, tecName = dxCreateShader ( "shaders/car_refgrun.fx" )
		outputDebugString( "carGrunShader is using technique " .. tostring(tecName) )
		
	    carGeneShader, tecName = dxCreateShader ( "shaders/car_refgene.fx" )
		outputDebugString( "carGeneShader is using technique " .. tostring(tecName) )
		
	    carShatShader, tecName = dxCreateShader ( "shaders/car_refgene.fx" )
		outputDebugString( "carShatShader is using technique " .. tostring(tecName) )	
		
		carPaintShader, tecName = dxCreateShader ( "shaders/car_paint.fx" )
		outputDebugString( "carPaintShader is using technique " .. tostring(tecName) )
		
		waterClaShader, tecName =dxCreateShader ( "shaders/water.fx" )
        outputDebugString( "carGrunShader is using technique " .. tostring(tecName) )

		-- Check everything is ok
		bAllValid = myScreenSourceBloom and carShatShader and carGeneShader and carGrunShader and carPaintShader
		and myScreenSourcePalette and paletteShader and blurHShader and blurVShader and waterClaShader 
		and brightPassShader and addBlendShader and textureVol and textureCube

		if not bAllValid then
			outputChatBox( "Shader Panel LITE: Could not create some things. Please use debugscript 3" )
			else
			if Settings.var.PaletteON~=0 then dxSetShaderValue( paletteShader, "TEX1", palette ) end
		end
	end
)

-----------------------------------------------------------------------------------
-- Carpaint and water
-----------------------------------------------------------------------------------

	function carpaint_staCla()
			dxSetShaderValue ( carPaintShader, "sRandomTexture", textureVol );
			dxSetShaderValue ( carPaintShader, "sReflectionTexture", textureCube );
			engineApplyShaderToWorldTexture ( carPaintShader, "vehiclegrunge256" )
			engineApplyShaderToWorldTexture ( carPaintShader, "?emap*" )
			 for _,addList in ipairs(texturegrun) do
			  engineApplyShaderToWorldTexture (carPaintShader, addList )
		     end
	end		
	
    function carpaint_stopCla()
	  if carPaintShader then
	         engineRemoveShaderFromWorldTexture( carPaintShader, "vehiclegrunge256" )
	         engineRemoveShaderFromWorldTexture( carPaintShader, "?emap*" )
			 for _,addList in ipairs(texturegrun) do
			     engineRemoveShaderFromWorldTexture(carPaintShader, addList )
		     end
	   end
	end
	
	function carpaint_staRef()
		
			--Set for carreflect
			dxSetShaderValue ( carGrunShader, "sCutoff",Settings.var.brightpassCutoff)
			dxSetShaderValue ( carGrunShader, "sPower", Settings.var.brightpassPower)			
			dxSetShaderValue ( carGrunShader, "sAdd", Settings.var.brightnessAdd)
			dxSetShaderValue ( carGrunShader, "sMul", Settings.var.brightnessMul)
			dxSetShaderValue ( carGrunShader, "sRefFl", Settings.var.reflectionFlip)
			dxSetShaderValue ( carGrunShader, "sRefFlan", Settings.var.reflectionFlipAngle)
			dxSetShaderValue ( carGrunShader, "sNorFac", Settings.var.normal)
		    dxSetShaderValue ( carGrunShader, "brightnessFactor",Settings.var.brightnessFactorPaint)  
			
			dxSetShaderValue ( carGeneShader, "sCutoff",Settings.var.brightpassCutoff)
			dxSetShaderValue ( carGeneShader, "sPower", Settings.var.brightpassPower)	
			dxSetShaderValue ( carGeneShader, "sAdd", Settings.var.brightnessAdd)
			dxSetShaderValue ( carGeneShader, "sMul", Settings.var.brightnessMul)
			dxSetShaderValue ( carGeneShader, "sRefFl", Settings.var.reflectionFlip)
			dxSetShaderValue ( carGeneShader, "sRefFlan", Settings.var.reflectionFlipAngle)
			dxSetShaderValue ( carGeneShader, "sNorFac", Settings.var.normal)
            dxSetShaderValue ( carGeneShader, "brightnessFactor",Settings.var.brightnessFactorWShield) 
			
		    dxSetShaderValue ( carShatShader, "sCutoff",Settings.var.brightpassCutoff)
			dxSetShaderValue ( carShatShader, "sPower", Settings.var.brightpassPower)	
			dxSetShaderValue ( carShatShader, "sAdd", Settings.var.brightnessAdd)
			dxSetShaderValue ( carShatShader, "sMul", Settings.var.brightnessMul)
			dxSetShaderValue ( carShatShader, "sRefFl", Settings.var.reflectionFlip)
			dxSetShaderValue ( carShatShader, "sRefFlan", Settings.var.reflectionFlipAngle)
			dxSetShaderValue ( carShatShader, "sNorFac", Settings.var.normal)
			dxSetShaderValue ( carShatShader, "brightnessFactor",Settings.var.brightnessFactorWShield) 		
			
			dxSetShaderValue ( carGrunShader, "dirtTex",Settings.var.dirtTexture)
		    dxSetShaderValue ( carGrunShader, "bumpSize",Settings.var.bumpSize)
			dxSetShaderValue ( carGrunShader, "bumpSize",Settings.var.bumpSizeWnd)
			
			dxSetShaderValue ( carGrunShader, "sRandomTexture", textureVol );
			dxSetShaderValue ( carGrunShader, "sReflectionTexture", myScreenSourceReflect );
			dxSetShaderValue ( carGeneShader, "gShatt", 0 );
			dxSetShaderValue ( carGeneShader, "sRandomTexture", textureVol );
			dxSetShaderValue ( carGeneShader, "sReflectionTexture", myScreenSourceReflect );
			dxSetShaderValue ( carShatShader, "gShatt", 1 );
            dxSetShaderValue ( carShatShader, "sRandomTexture", textureVol );
			dxSetShaderValue ( carShatShader, "sReflectionTexture", myScreenSourceReflect );			
			-- Apply to world texture
			engineApplyShaderToWorldTexture ( carGrunShader, "vehiclegrunge256" )
			engineApplyShaderToWorldTexture ( carGrunShader, "?emap*" )
			engineApplyShaderToWorldTexture ( carGeneShader, "vehiclegeneric256" )
			engineApplyShaderToWorldTexture ( carShatShader, "vehicleshatter128" )
	        engineApplyShaderToWorldTexture ( carGeneShader, "hotdog92glass128" )
			engineApplyShaderToWorldTexture ( carGeneShader, "okoshko" )
			
			for _,addList in ipairs(texturegrun) do
			engineApplyShaderToWorldTexture (carGrunShader, addList )
		    end	
	end

    function carpaint_stopRef()
	if carGrunShader and carGeneShader and carShatShader then
			engineRemoveShaderFromWorldTexture ( carGrunShader, "vehiclegrunge256" )
			engineRemoveShaderFromWorldTexture ( carGrunShader, "?emap*" )
			engineRemoveShaderFromWorldTexture ( carGeneShader, "vehiclegeneric256" )
			engineRemoveShaderFromWorldTexture ( carShatShader, "vehicleshatter128" )
	        engineRemoveShaderFromWorldTexture ( carGeneShader, "hotdog92glass128" )
			engineRemoveShaderFromWorldTexture ( carGeneShader, "okoshko" )
		 for _,addList in ipairs(texturegrun) do
			engineRemoveShaderFromWorldTexture(carGrunShader, addList )
		end
	  end
	end


    function water_startCla()
			dxSetShaderValue ( waterClaShader, "sRandomTexture", textureVol )
			dxSetShaderValue ( waterClaShader, "sReflectionTexture", textureCube )
			engineApplyShaderToWorldTexture ( waterClaShader, "waterclear256" )

			setTimer(	function()
							if waterClaShader then
								local r,g,b,a = getWaterColor()
								dxSetShaderValue ( waterClaShader, "sWaterColor", r/255, g/255, b/255, a/255 );
							end
						end
						,100,0 )

    end

	function water_stopCla()
	if waterClaShader then
	       engineRemoveShaderFromWorldTexture(waterClaShader, "waterclear256" )
	end
	end

-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------
addEventHandler( "onClientHUDRender", root,
    function()
		if not Settings.var then
			return
		end
        if bAllValid then
			-- Reset render target pool
			RTPool.frameStart()
			-- Update screen
			dxUpdateScreenSource( myScreenSourceBloom )
			-- Start with screen
			local current = myScreenSourceBloom
			-- Apply all the effects, bouncing from one render target to another
			if Settings.var.BloomON==1 then
			current = applyBrightPass( current, Settings.var.cutoff, Settings.var.power )
			current = applyDownsample( current )
			current = applyDownsample( current )
			current = applyPalette(current)
			current = applyGBlurH( current, Settings.var.bloom )
			current = applyGBlurV( current, Settings.var.bloom )
			end
			-- When we're done, turn the render target back to default
			dxSetRenderTarget()
			-- Apply palette
              if (Settings.var.PaletteON)>0 then 
			  dxUpdateScreenSource( myScreenSourcePalette )
			  dxSetShaderValue( paletteShader,"isPaleteEnabled",1)
			  dxSetShaderValue( paletteShader, "gCol", Settings.var.PaletteR,Settings.var.PaletteG,Settings.var.PaletteB,Settings.var.PaletteA )
              dxSetShaderValue( paletteShader, "TEX0", myScreenSourcePalette )
			  dxDrawImage( 0, 0, scx, scy, paletteShader, 0, 0, 0)
			end	
			-- Get carpaint reflection
		   if Settings.var.CarPaintVers==2 then
		      if myScreenSourceReflect then
               dxUpdateScreenSource( myScreenSourceReflect)
              end
           end
			-- Mix result onto the screen using 'add' rather than 'alpha blend'
			  if current and Settings.var.BloomON==1 then
			   dxSetShaderValue( addBlendShader, "TEX0", current )
			   local col2 = tocolor(Settings.var.blendR, Settings.var.blendG, Settings.var.blendB, Settings.var.blendA)
			   dxDrawImage( 0, 0, scx, scy, addBlendShader, 0,0,0, col2 ) 
			  end
	    end
       
    end
)

-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------
function applyPalette( Src)
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT )
	dxSetShaderValue( paletteShader, "TEX0", Src )
	dxDrawImage( 0, 0, mx, my, paletteShader )
	return newRT
end

function applyDownsample( Src, amount )
	if not Src then return nil end
	amount = amount or 2
	local mx,my = dxGetMaterialSize( Src )
	mx = mx / amount
	my = my / amount
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT )
	dxDrawImage( 0, 0, mx, my, Src )
	return newRT
end

function applyGBlurH( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShader, "TEX0", Src )
	dxSetShaderValue( blurHShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurHShader, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx, my, blurHShader )
	return newRT
end

function applyGBlurV( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShader, "TEX0", Src )
	dxSetShaderValue( blurVShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurVShader, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx,my, blurVShader )
	return newRT
end

function applyBrightPass( Src, cutoff, power )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( brightPassShader, "TEX0", Src )
	dxSetShaderValue( brightPassShader, "CUTOFF", cutoff )
	dxSetShaderValue( brightPassShader, "POWER", power )
	dxDrawImage( 0, 0, mx,my, brightPassShader )
	return newRT
end


-----------------------------------------------------------------------------------
-- Pool of render targets
-----------------------------------------------------------------------------------
RTPool = {}
RTPool.list = {}

function RTPool.frameStart()
	for rt,info in pairs(RTPool.list) do
		info.bInUse = false
	end
end

function RTPool.GetUnused( mx, my )
	-- Find unused existing
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	-- Add new
	local rt = dxCreateRenderTarget( mx, my )
	if rt then
		outputDebugString( "creating new RT " .. tostring(mx) .. " x " .. tostring(mx) )
		RTPool.list[rt] = { bInUse = true, mx = mx, my = my }
	end
	return rt
end
