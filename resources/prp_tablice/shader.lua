txd = dxCreateTexture( "shader.png" );

if not txd then
	txd = nil;
	return false;
end

shader = dxCreateShader( "shader.fx" );
if not shader then
	destroyElement( txd );
	txd = nil;
	return false;
end
dxSetShaderValue( shader, "gTexture", txd );
engineApplyShaderToWorldTexture( shader, "plateback1" );
engineApplyShaderToWorldTexture( shader, "plateback3" );

fileDelete("shader.lua")