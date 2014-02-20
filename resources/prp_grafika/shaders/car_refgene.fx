// Author: Ren712 and robi

float brightnessFactor = 0.20;
float gShatt = 0;
//float bumpSize = 0.01;
float sNormZ = 3;
float sRefFl = 1;
float sRefFlan = 0.2;
float sMul= 1.1;  
float sPower : POWER = 1; // 1 - 5
float sNorFac = 1;
float sProjectedXsize = 0.45;
float sProjectedXvecMul = 0.6;
float sProjectedXoffset = -0.021;
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
	float2 TexCoord_dust : TEXCOORD5;

};


//------------------------------------------------------------------------------------------
// VertexShaderFunction
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;

    // Transform postion
	
	float4 worldPosition = mul ( VS.Position, gWorld );
	float4 viewPosition  = mul ( worldPosition, gView );
	float4 position = mul ( viewPosition, gProjection );
	PS.Position  = position;     
	float3 viewDirection = normalize(gCameraPosition - worldPosition);
	
    // Fake tangent and binormal
    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal =normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );

    // Transfer some stuff
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorldInverseTranspose) );
	PS.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
	PS.Binormal = normalize( mul(Binormal, (float3x3)gWorldInverseTranspose) );
	
	float3 Pw = mul(VS.Position, gWorldViewProjection).xyz;
	PS.View =normalize(viewDirection -Pw); 
	
	PS.TexCoord_dust = VS.TexCoord;
	 
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
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
	float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent, PS.Binormal, PS.Normal ) );
	float3 vNormalWorld = normalize( mul( mTangentToWorld, PS.Normal ));

	float fNdotV = saturate(dot( vNormalWorld, PS.View ));

    float4 envMap = tex2D(ReflectionSampler, PS.TexCoord);
    envMap = pow(envMap, sPower);
	envMap*=sMul;

    if (gCameraDirection.z < -0.5)
	{
		envMap.rgb*=(2*(1+gCameraDirection.z));
	}

    envMap.rgb *= brightnessFactor;
    envMap.rgb *= PS.Specular.a; 


	float4 maptex = tex2D(Sampler0,PS.TexCoord_dust.xy);
 
    float fEnvContribution = 1.0 - 0.5 *fNdotV; 
	float4 finalColor;
	float4 Color;
	
    if (gShatt ==0)
	{
      	if (PS.Diffuse.a <0.8) 
		{  

			finalColor = envMap* fEnvContribution*0.3; 
			Color = finalColor + PS.Diffuse * 0.5;
			Color += finalColor * PS.Diffuse * 0.4;
			Color.a = PS.Diffuse.a;
		}
		else
		{
		finalColor = maptex * PS.Diffuse;
		finalColor *= fEnvContribution;
		finalColor.a = 1.0;
		Color = finalColor + PS.Diffuse *0.1;
		Color.a = PS.Diffuse.a;
		}
    }
	else
	{
		finalColor = envMap * fEnvContribution*0.3; 
		Color = finalColor + PS.Diffuse * 0.6;
		Color += finalColor * PS.Diffuse * 0.5;
		Color.a = 0.30;
		Color += maptex * (PS.Diffuse/2.3);
	}
    return Color;
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique car_reflect_shield
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