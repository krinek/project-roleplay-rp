// Author: robi
// from mta wiki

float sBloom : BLOOM = 1;
texture sTex0 : TEX0;
float2 sTex0Size : TEX0SIZE;
static const float Weights[13] = {	0.002216, 0.008764, 0.026995, 0.064759, 0.120985, 0.176033, 0.199471, 
									0.176033, 0.120985, 0.064759, 0.026995, 0.008764, 0.002216};

#include "mta-helper.fx"


//---------------------------------------------------------------------
// Sampler for the main texture
//---------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture = (sTex0);
	AddressU = Clamp;
    AddressV = Clamp;
};


//---------------------------------------------------------------------
// Structure of data sent to the pixel shader
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION0;
    float4 Diffuse : COLOR0;
    float2 TexCoord: TEXCOORD0;
};


//------------------------------------------------------------------------------------------
// PixelShaderFunction
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float4 Color = 0;

    float2 coord;
    coord.y = PS.TexCoord.y;

    for(int i = 0; i < 13; ++i)
    {
        coord.x = PS.TexCoord.x + (i-6)/sTex0Size.x;
        Color += tex2D(Sampler0, coord.xy) * Weights[i] * sBloom;
    }

    Color = Color * PS.Diffuse;
    Color.a = 1;
    return Color;  
}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique blurh
{
    pass P0
    {
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {
    }
}