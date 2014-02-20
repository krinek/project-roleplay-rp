// Author: Ren712 and robi

float brightnessFactor = 0.20;
float dirtTex = 1;
float bumpSize = 0.02;
float sNormZ = 3;
float sRefFl = 1;
float sRefFlan = 0.1;
float sAdd = 0.1;  
float sMul = 1.1; 
float sCutoff : CUTOFF = 0.16; // 0 - 1
float sPower : POWER = 2; // 1 - 5
float sNorFac = 1;
float sProjectedXsize = 0.45;
float sProjectedXvecMul = 0.6;
float sProjectedXoffset = -0.02;
float sProjectedYsize = 0.4;
float sProjectedYvecMul = 0.6;
float sProjectedYoffset = -0.2;
texture sReflectionTexture;
texture sRandomTexture;

#include "mta-helper.fx"


//------------------------------------------------------------------------------------------
// Samplers for the textures
//------------------------------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
	Texture = (gTexture0);
};

sampler3D RandomSampler = sampler_state
{
	Texture = (sRandomTexture); 
};

sampler2D ReflectionSampler = sampler_state
{
	Texture = (sReflectionTexture);	
	AddressU = Mirror;
	AddressV = Mirror;
};


//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION; 
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
	float3 View : TEXCOORD1;
};


//---------------------------------------------------------------------
// Structure of data sent to the pixel shader
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION;
    float4 Diffuse : COLOR0;
	float4 Specular : COLOR1;   
    float2 TexCoord : TEXCOORD0;
    float3 Tangent : TEXCOORD1;
    float3 Binormal : TEXCOORD2;
    float3 Normal : TEXCOORD3;
    float3 View : TEXCOORD4;
    float3 SparkleTex : TEXCOORD5;
	float2 TexCoord_dust : TEXCOORD6;

};


//------------------------------------------------------------------------------------------
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    // Transform postion
	
	float4 worldPosition = mul(VS.Position, gWorld);
	float4 viewPosition  = mul(worldPosition, gView);
	float4 position = mul(viewPosition, gProjection);
	PS.Position  = position;     
	float3 viewDirection = normalize(gCameraPosition - worldPosition);
	
    // Fake tangent and binormal
    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal = normalize(cross(Tangent, VS.Normal));
    Tangent = normalize( cross(Binormal, VS.Normal) );

    // Transfer some stuff
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorldInverseTranspose).xyz );
	PS.Tangent = normalize(mul(Tangent, (float3x3)gWorldInverseTranspose).xyz);
	PS.Binormal = normalize( mul(Binormal, (float3x3)gWorldInverseTranspose).xyz );
	
    PS.View = normalize(viewDirection); 
	
	PS.TexCoord_dust = VS.TexCoord;
	
    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 10.0;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 10.0;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 10.0;

	float4 eyeVector=mul(-VS.Position, gWorldViewProjection);
	float projectedX =(((eyeVector.x) /eyeVector.z*sProjectedXvecMul)*sProjectedXsize+0.5)+sProjectedXoffset;
	float projectedY =(((eyeVector.y) /eyeVector.z*sProjectedYvecMul)*sProjectedYsize+0.5)+sProjectedYoffset;
	if ((gCameraDirection.z > sRefFlan*3) && sRefFl==1) 
	{
		eyeVector=mul(-VS.Position, gWorldViewProjection);
		projectedY =(((eyeVector.y) /eyeVector.z*sProjectedYvecMul)*sProjectedYsize+0.5)-sProjectedYoffset; 
	}
	else if ((gCameraDirection.z > sRefFlan) && sRefFl==1) 
	{
		eyeVector=mul(-VS.Position, gWorldViewProjection);
		projectedY =(((eyeVector.y) /eyeVector.z*sProjectedYvecMul)*sProjectedYsize+0.5); 
	}
    // Calc and send reflection lookup coords to pixel shader
    float3 Nn = pow(normalize(VS.Normal),sNorFac);
    float3 Vn = float3(projectedX,projectedY,0);
    float3 vReflection = reflect(Vn,Nn);
    PS.TexCoord = vReflection.xy;
    // Calc lighting
    PS.Diffuse = MTACalcGTAVehicleDiffuse( PS.Normal, VS.Diffuse );
    PS.Specular.a = pow(VS.Normal.z,sNormZ);   
    return PS;
}


//------------------------------------------------------------------------------------------
// PixelShaderFunction
//  1. Read from PS structure
//  2. Process
//  3. Return pixel color
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    float microflakePerturbation = 1.00;
    float normalPerturbation = 1.00;
    float microflakePerturbationA = 0.10;


    float4 base = gMaterialAmbient;
	
    float4 paintColorMid;
    float4 paintColor2;
    float4 paintColor0;
    float4 flakeLayerColor;

    paintColorMid = base;
    paintColor2.r = (base.r + base.g/2 + base.b/2)/2;
    paintColor2.g = (base.r/2 + base.g + base.b/2)/2;
    paintColor2.b = (base.r/2 + base.g/2 + base.b)/2;

    paintColor0.r = (base.r + base.g/2 + base.b/2)/2;
    paintColor0.g = (base.r/2 + base.g + base.b/2)/2;
    paintColor0.b = (base.r/2 + base.g/2 + base.b)/2;

    flakeLayerColor.rgb = float3(0.12,0.1,0.08);


    float3 vFlakesNormal = tex3D(RandomSampler, PS.SparkleTex).rgb;

    vFlakesNormal = 2 * vFlakesNormal - 1.0;


    float3 vNp1 = microflakePerturbationA * vFlakesNormal + normalPerturbation * PS.Normal ;

    float3 vNp2 = microflakePerturbation * ( vFlakesNormal + PS.Normal ) ;


	float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent,PS.Binormal, PS.Normal ) );
	float3 vNormalWorld = normalize( mul( mTangentToWorld, PS.Normal ));
       
	
	float fNdotV = saturate(dot( vNormalWorld, PS.View ));
	
	float2 vReflection = PS.TexCoord + vNp2.xy*bumpSize;
	
    float4 envMap = tex2D( ReflectionSampler, vReflection );
	float lum = (envMap.r + envMap.g + envMap.b)/3;
    float adj = saturate( lum - sCutoff );
    adj = adj / (1.01 - sCutoff);
    envMap+=sAdd;
    envMap = (envMap * adj);
    envMap = pow(envMap, sPower);
	envMap*=sMul;
    if (gCameraDirection.z < -0.5)
	{
		envMap.rgb*=(1+gCameraDirection.z)*2;
	}


    envMap.rgb *= brightnessFactor;
    envMap.rgb *= PS.Specular.a;   


    float3 vNp1World = normalize( mul( mTangentToWorld, vNp1) );
    float fFresnel1 = saturate( dot( vNp1World, PS.View ));


    float3 vNp2World = normalize( mul( mTangentToWorld, vNp2 ));
    float fFresnel2 = saturate( dot( vNp2World, PS.View ));
    float fFresnel3 = saturate( dot( PS.Normal, PS.View));
	
    float fFresnel1Sq = fFresnel1 * fFresnel1;

	float4 paintColor = 1 * fFresnel1 * paintColor0 +
		1 * fFresnel1Sq * paintColorMid +
		1 * fFresnel1Sq * fFresnel1Sq * paintColor2 +
		1 * pow( fFresnel2, 512 ) * flakeLayerColor;
 
    float fEnvContribution = 1.0 - 0.5 * fNdotV;
    paintColor+= envMap * fEnvContribution;
    paintColor.a = 1.0;

    float4 Color = paintColor + PS.Diffuse * 0.5 + paintColor * PS.Diffuse * 1.5;
	if (dirtTex==1) 
	{
		float4 maptex = tex2D(Sampler0,PS.TexCoord_dust.xy);
		Color *= maptex; 
	}
    Color.a = PS.Diffuse.a;
    return Color;

}


//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique car_reflect_paint
{
    pass P0
    {
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

technique fallback
{
    pass P0
    {
    }
}