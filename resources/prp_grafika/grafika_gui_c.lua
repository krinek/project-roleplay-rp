GUISP = {}

local screenWidth, screenHeight = guiGetScreenSize()
local left = (screenWidth/2 - 321/2)+screenWidth/4
local top = (screenHeight/2 - 309/2)

GUISP.ShaderPanelWindow = guiCreateWindow(left,top,321,309,"Grafika - Opcje",false)
GUISP.fps = guiCreateLabel(13,21,296,20,"00 FPS",false,GUISP.ShaderPanelWindow)
guiLabelSetVerticalAlign(GUISP.fps,"center")
guiLabelSetHorizontalAlign(GUISP.fps,"center",false)
GUISP.label2 = guiCreateLabel(13,43,295,20,"Paleta Kolorow",false,GUISP.ShaderPanelWindow)
guiLabelSetVerticalAlign(GUISP.label2,"center")
guiLabelSetHorizontalAlign(GUISP.label2,"center",false)
GUISP.label3 = guiCreateLabel(13,93,295,20,"Shader Bloom",false,GUISP.ShaderPanelWindow)
guiLabelSetVerticalAlign(GUISP.label3,"center")
guiLabelSetHorizontalAlign(GUISP.label3,"center",false)
GUISP.label4 = guiCreateLabel(13,143,295,20,"Auta Shader",false,GUISP.ShaderPanelWindow)
guiLabelSetVerticalAlign(GUISP.label4,"center")
guiLabelSetHorizontalAlign(GUISP.label4,"center",false)
--GUISP.label5 = guiCreateLabel(13,193,295,20,"Water Shader",false,GUISP.ShaderPanelWindow)
--guiLabelSetVerticalAlign(GUISP.label5,"center")
guiLabelSetHorizontalAlign(GUISP.label5,"center",false)
GUISP.spl_save = guiCreateButton(15,258,139,36,"Zapisz",false,GUISP.ShaderPanelWindow)
GUISP.spl_close = guiCreateButton(169,258,139,36,"Zamknij",false,GUISP.ShaderPanelWindow)

GUISP.palette_choose = guiCreateComboBox(13,65,295,75,"-Wybierz-",false,GUISP.ShaderPanelWindow)
guiComboBoxAddItem ( GUISP.palette_choose, "off" )
guiComboBoxAddItem ( GUISP.palette_choose, "paleta 1" )
guiComboBoxAddItem ( GUISP.palette_choose, "paleta 2" )
GUISP.bloom_choose = guiCreateComboBox(13,115,295,60,"-Wybierz-",false,GUISP.ShaderPanelWindow)
guiComboBoxAddItem ( GUISP.bloom_choose, "Wylaczone" )
guiComboBoxAddItem ( GUISP.bloom_choose, "Wlaczone" )
GUISP.carpaint_choose = guiCreateComboBox(13,165,295,75,"-Wybierz-",false,GUISP.ShaderPanelWindow)
guiComboBoxAddItem ( GUISP.carpaint_choose, "Wylaczone" )
guiComboBoxAddItem ( GUISP.carpaint_choose, "Klasyczne" )
guiComboBoxAddItem ( GUISP.carpaint_choose, "Refleksyjne" )
--GUISP.water_choose = guiCreateComboBox(13,215,295,60,"-choose-",false,GUISP.ShaderPanelWindow)
--guiComboBoxAddItem ( GUISP.water_choose, "off" )
--guiComboBoxAddItem ( GUISP.water_choose, "classic" )

guiSetVisible(GUISP.ShaderPanelWindow, false)


function toggleShaDanLite()
if getElementData (getLocalPlayer(), "spl_logged")==true then
	local combo_palette=getElementData ( getLocalPlayer(), "spl_palette" )
	guiComboBoxSetSelected(GUISP.palette_choose, combo_palette) 
	local combo_bloom= getElementData ( getLocalPlayer(), "spl_bloom" )
	guiComboBoxSetSelected(GUISP.bloom_choose, combo_bloom)
	local combo_carpaint=getElementData ( getLocalPlayer(), "spl_carpaint" )
	guiComboBoxSetSelected(GUISP.carpaint_choose, combo_carpaint)
	local combo_water= getElementData ( getLocalPlayer(), "spl_water" )
	guiComboBoxSetSelected(GUISP.water_choose, combo_water)
end
	if (guiGetVisible(GUISP.ShaderPanelWindow)) then
		showCursor(false)
		guiSetVisible(GUISP.ShaderPanelWindow,false)
	else
		showCursor(true)
		guiSetVisible(GUISP.ShaderPanelWindow,true)
	end
end

bindKey("F4","down",toggleShaDanLite)
addCommandHandler("grafika",toggleShaDanLite)

function spl_save_func()
	local combo_palette = getElementData ( getLocalPlayer(), "spl_palette" )
	local combo_bloom = getElementData ( getLocalPlayer(), "spl_bloom" )
	local combo_carpaint = getElementData ( getLocalPlayer(), "spl_carpaint" )
	local combo_water = getElementData ( getLocalPlayer(), "spl_water" )
    triggerServerEvent ( "splSave", getLocalPlayer(),combo_water, combo_carpaint, combo_bloom, combo_palette )
end


function spl_choose_settings()

  local combo_palette=guiComboBoxGetSelected(GUISP.palette_choose)
  setElementData( getLocalPlayer(), "spl_palette",combo_palette )
  local combo_bloom=guiComboBoxGetSelected(GUISP.bloom_choose)
  setElementData( getLocalPlayer(), "spl_bloom",combo_bloom)
  local combo_carpaint=guiComboBoxGetSelected(GUISP.carpaint_choose)
  setElementData( getLocalPlayer(), "spl_carpaint",combo_carpaint )
  local combo_water=guiComboBoxGetSelected(GUISP.water_choose)
  setElementData( getLocalPlayer(), "spl_water",combo_water )
  
  Settings.var.PaletteON = getElementData ( getLocalPlayer(), "spl_palette" )
  Settings.var.BloomON = getElementData ( getLocalPlayer(), "spl_bloom" )
  Settings.var.CarPaintVers = getElementData ( getLocalPlayer(), "spl_carpaint" )
  Settings.var.WaterVers = getElementData ( getLocalPlayer(), "spl_water" )
  if (Settings.var.PaletteON)>0 then 
  palette = dxCreateTexture ( "images/enbpalette"..Settings.var.PaletteON..".png" )
  dxSetShaderValue( paletteShader, "TEX1", palette )
    end
  if Settings.var.CarPaintVers ==0 then carpaint_stopCla() carpaint_stopRef() end
  if Settings.var.CarPaintVers ==2 then carpaint_stopCla() carpaint_stopRef() carpaint_staRef() end
  if Settings.var.CarPaintVers ==1 then carpaint_stopCla() carpaint_stopRef() carpaint_staCla() end
  if Settings.var.WaterVers == 1 then water_stopCla() water_startCla() end	
  if Settings.var.WaterVers == 0 then water_stopCla()  end	
end

function spl_close_func()
  guiSetVisible(GUISP.ShaderPanelWindow, false)
  showCursor(false)
end

local frames,lastsec = 0,0
function fpscheck()
 if (guiGetVisible(GUISP.ShaderPanelWindow)) then
 local frameticks=getTickCount()
 frames=frames+1
 if frameticks-1000>lastsec then
  local prog=(frameticks-lastsec)
  lastsec=frameticks
  fps=frames/(prog/1000)
  frames=fps*((prog-1000)/1000)
  local fps_out=math.floor(fps)
  local frame_string=tostring(fps_out)
  frame_string='FPS: '..frame_string..' '
  guiSetText ( GUISP.fps,frame_string)
 end
 end
end

addEvent ( "onClientPlayerLogin", true )

addEventHandler ( "onClientPlayerLogin", root, 
    function()
  if getElementData (getLocalPlayer(), "spl_logged")==true then
  outputChatBox('Grafika: Ustawiania zostaly przywrocone!')
  Settings.var.PaletteON = getElementData ( getLocalPlayer(), "spl_palette" )
  Settings.var.BloomON = getElementData ( getLocalPlayer(), "spl_bloom" )
  Settings.var.CarPaintVers = getElementData ( getLocalPlayer(), "spl_carpaint" )
  Settings.var.WaterVers = getElementData ( getLocalPlayer(), "spl_water" )
  if (Settings.var.PaletteON)>0 then 
  palette = dxCreateTexture ( "images/enbpalette"..Settings.var.PaletteON..".png" )
  dxSetShaderValue( paletteShader, "TEX1", palette )
    end
  if Settings.var.CarPaintVers <=0 then carpaint_stopCla() carpaint_stopRef() end
  if Settings.var.CarPaintVers ==2 then carpaint_stopCla() carpaint_stopRef() carpaint_staRef() end
  if Settings.var.CarPaintVers ==1 then carpaint_stopCla() carpaint_stopRef() carpaint_staCla() end
  if Settings.var.WaterVers == 1 then water_stopCla() water_startCla() end	
  if Settings.var.WaterVers <= 0 then water_stopCla()  end		
        end
    end
)

addEventHandler ( "onClientRender", root, fpscheck)
addEventHandler("onClientGUIComboBoxAccepted", GUISP.ShaderPanelWindow, spl_choose_settings)
addEventHandler("onClientGUIClick", GUISP.spl_save, spl_save_func)
addEventHandler("onClientGUIClick", GUISP.spl_close, spl_close_func)