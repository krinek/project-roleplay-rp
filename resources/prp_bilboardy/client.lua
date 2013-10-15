--[[
Skrypt umozliwiajacy dodawanie wlasnych bilboardow

@author Daniex0r <daniex0r@gmail.com>
@author Karer <karer.programmer@gmail.com>
@copyright 2012-2013 Daniex0r <daniex0r@gmail.com>
@license GPLv2
@package project-roleplay-rp
@link https://github.com/Daniex0r/project-roleplay-rp
]]--

shader = dxCreateShader("shader.fx")


img = dxCreateTexture("1.png")
dxSetShaderValue(shader, "Tex0", img)
engineApplyShaderToWorldTexture( shader, "heat_02")