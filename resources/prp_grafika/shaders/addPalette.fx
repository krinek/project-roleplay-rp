//
// Shader - addPalette.fx
// 
#include "mta-helper.fx"
texture TEX0;
texture TEX1;
float isPaleteEnabled =0;
float4 gCol=float4(255,255,255,255);

sampler2D Sampler0 = sampler_state
{
    Texture = <TEX0>;
	AddressU = Mirror;
    AddressV = Mirror;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
};

sampler1D Sampler1 = sampler_state
{
    Texture = <TEX1>;
	AddressU = Mirror;
    AddressV = Mirror;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
};
//---------------------------------------------------------------------
// pixel shader
//---------------------------------------------------------------------

float4 PostProcessPS0(float2 TexCoord : TEXCOORD0) : COLOR0
{
float4 texel = tex2D(Sampler0, TexCoord);
float4 finalColor;
if (isPaleteEnabled ==1) {
finalColor.r = (tex1D(Sampler1, texel.r).r)*(gCol.r/255);
finalColor.g = (tex1D(Sampler1, texel.g).g)*(gCol.g/255);
finalColor.b = (tex1D(Sampler1, texel.b).b)*(gCol.g/255);
finalColor.a = texel.a*(gCol.a/255);
}
else
{
finalColor = texel;
}

return finalColor;		
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique addpalette_and_blur
{
    pass P1
    {
        PixelShader = compile ps_2_0 PostProcessPS0();
    }
}
