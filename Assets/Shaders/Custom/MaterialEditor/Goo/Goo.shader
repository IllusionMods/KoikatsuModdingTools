// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Goo"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_FresnelScale("FresnelScale", Range( 0 , 255)) = 0.1
		_FresnelPower("FresnelPower", Range( 0 , 5)) = 0.1
		_FresnelAlpha("FresnelAlpha", Range( 0 , 1)) = 0.1
		_Sh("Sh", Range( 0 , 1)) = 0.1
		_FresnelBias("FresnelBias", Range( 0 , 5)) = 0.1
		_Alpha("Alpha", Range( 0 , 1)) = 0.1
		_Albedo("Albedo", Color) = (1,1,1,0)
		_Matcap("Matcap", 2D) = "white" {}
		_MatcapAlpha("MatcapAlpha", Range( 0 , 1)) = 0
		[Toggle]_alpha_a("alpha_a", Int) = 1
		[Toggle]_alpha_b("alpha_b", Int) = 1
		_AlphaMask("AlphaMask", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform int _alpha_a;
		uniform sampler2D _AlphaMask;
		uniform float4 _AlphaMask_ST;
		uniform int _alpha_b;
		uniform float _Alpha;
		uniform float _FresnelAlpha;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _Albedo;
		uniform float _Sh;
		uniform sampler2D _Matcap;
		uniform float _MatcapAlpha;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_AlphaMask = i.uv_texcoord * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
			float4 break14_g8 = ( 1.0 - tex2D( _AlphaMask, uv_AlphaMask ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV3 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode3 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV3, _FresnelPower ) );
			float Fresnel67 = saturate( ( _FresnelAlpha * fresnelNode3 ) );
			float Alpha70 = ( ( 1.0 - saturate( ( ( _alpha_a * break14_g8.x ) + ( break14_g8.y * _alpha_b ) ) ) ) * saturate( ( _Alpha + Fresnel67 ) ) );
			float temp_output_71_0 = Alpha70;
			SurfaceOutputStandard s139 = (SurfaceOutputStandard ) 0;
			s139.Albedo = float3( 0,0,0 );
			s139.Normal = ase_worldNormal;
			float4 temp_cast_1 = (( ( 1.0 - Fresnel67 ) * _Sh )).xxxx;
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 temp_output_4_0_g1 = mul( UNITY_MATRIX_MV, ase_vertex4Pos );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3 temp_output_5_0_g1 = mul( UNITY_MATRIX_MV, float4( ase_vertexNormal , 0.0 ) ).xyz;
			float4 break9_g1 = reflect( temp_output_4_0_g1 , float4( temp_output_5_0_g1 , 0.0 ) );
			float4 appendResult20_g1 = (float4(break9_g1.x , break9_g1.y , 0.0 , 0.0));
			float4 blendOpSrc55 = ( ( _Albedo + Fresnel67 ) - temp_cast_1 );
			float4 blendOpDest55 = saturate( ( tex2D( _Matcap, (saturate( ( ( appendResult20_g1 / ( sqrt( ( pow( break9_g1.x , 2.0 ) + pow( break9_g1.y , 2.0 ) + pow( ( break9_g1.z + 1 ) , 2.0 ) ) ) * 2 ) ) + 0.5 ) )).xy ) * _MatcapAlpha ) );
			s139.Emission = saturate( ( saturate( ( blendOpSrc55 + blendOpDest55 ) )) ).rgb;
			s139.Metallic = _Metallic;
			s139.Smoothness = _Smoothness;
			s139.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi139 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g139 = UnityGlossyEnvironmentSetup( s139.Smoothness, data.worldViewDir, s139.Normal, float3(0,0,0));
			gi139 = UnityGlobalIllumination( data, s139.Occlusion, s139.Normal, g139 );
			#endif

			float3 surfResult139 = LightingStandard ( s139, viewDir, gi139 ).rgb;
			surfResult139 += s139.Emission;

			#ifdef UNITY_PASS_FORWARDADD//139
			surfResult139 -= s139.Emission;
			#endif//139
			c.rgb = surfResult139;
			c.a = temp_output_71_0;
			clip( temp_output_71_0 - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16800
460;181;1674;878;2888.598;568.0492;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;73;-2433.272,141.3394;Float;False;1230.962;388.9995;Fresnel;8;8;6;7;10;3;9;11;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2381.272,346.3389;Float;False;Property;_FresnelScale;FresnelScale;1;0;Create;True;0;0;False;0;0.1;1.2;0;255;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2383.272,415.3389;Float;False;Property;_FresnelPower;FresnelPower;2;0;Create;True;0;0;False;0;0.1;2.2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-2383.272,278.3391;Float;False;Property;_FresnelBias;FresnelBias;5;0;Create;True;0;0;False;0;0.1;0.01;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2111.271,191.3394;Float;False;Property;_FresnelAlpha;FresnelAlpha;3;0;Create;True;0;0;False;0;0.1;0.385;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;3;-2039.271,291.339;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1747.534,257.4057;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;11;-1607.448,258.0272;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;-1445.31,236.5338;Float;False;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;72;-2437.85,-521.7909;Float;False;1160.303;607.9714;Alpha;10;1;68;5;61;60;63;12;64;70;74;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;69;-823.826,198.4274;Float;False;67;Fresnel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;23;-1136.279,506.7563;Float;True;Property;_Matcap;Matcap;8;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;137;-1103.791,702.2886;Float;False;BetterMatcap;-1;;1;b1839192452161548803429ef20292a1;0;0;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;138;-854.4762,437.6002;Float;True;Property;_TextureSample0;Texture Sample 0;13;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;68;-2150.368,-28.81952;Float;False;67;Fresnel;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-2246.181,-104.8089;Float;False;Property;_Alpha;Alpha;6;0;Create;True;0;0;False;0;0.1;0.614;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-745.7488,334.5022;Float;False;Property;_Sh;Sh;4;0;Create;True;0;0;False;0;0.1;0.456;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-886.2613,28.76799;Float;False;Property;_Albedo;Albedo;7;0;Create;True;0;0;False;0;1,1,1,0;0.3215677,0.7545847,0.8970588,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;14;-629.0118,265.9857;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-838.2829,636.528;Float;False;Property;_MatcapAlpha;MatcapAlpha;9;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-1959.846,-65.38825;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;61;-2279.85,-227.7909;Float;False;Property;_alpha_b;alpha_b;11;0;Create;True;0;0;False;1;Toggle;1;1;0;1;INT;0
Node;AmplifyShaderEditor.SamplerNode;63;-2424.85,-480.7912;Float;True;Property;_AlphaMask;AlphaMask;12;0;Create;True;0;0;False;0;None;3007a6e28d4341c41aeed5fd01f3769c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;60;-2278.85,-297.7911;Float;False;Property;_alpha_a;alpha_a;10;0;Create;True;0;0;False;1;Toggle;1;1;0;1;INT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-453.8609,170.0424;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-470.3484,264.5602;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-496.9987,472.9344;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;12;-1841.248,-65.79075;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-315.4364,200.5497;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;74;-1996.852,-380.7912;Float;False;KKAlpha;-1;;8;9e81c0a0e663ece489146622c3f1b497;0;3;5;FLOAT4;0,0,0,0;False;3;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;53;-337.0405,483.8723;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1680.548,-115.9138;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;55;-145.822,333.8523;Float;True;LinearDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-1520.547,-80.6373;Float;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;69.54431,624.8761;Float;False;Property;_Smoothness;Smoothness;14;0;Create;True;0;0;False;0;0;0.668;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;13;152.2598,336.959;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;140;68.54431,541.876;Float;False;Property;_Metallic;Metallic;13;0;Create;True;0;0;False;0;0;0.574;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;71;-126.5466,197.3627;Float;False;70;Alpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;139;372.0443,292.3761;Float;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;709.3563,-2.73238;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Goo;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;0;False;-1;False;0;False;-1;0;False;-1;True;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;1;6;0
WireConnection;3;2;7;0
WireConnection;3;3;8;0
WireConnection;9;0;10;0
WireConnection;9;1;3;0
WireConnection;11;0;9;0
WireConnection;67;0;11;0
WireConnection;138;0;23;0
WireConnection;138;1;137;0
WireConnection;14;0;69;0
WireConnection;5;0;1;0
WireConnection;5;1;68;0
WireConnection;4;0;2;0
WireConnection;4;1;69;0
WireConnection;16;0;14;0
WireConnection;16;1;17;0
WireConnection;30;0;138;0
WireConnection;30;1;31;0
WireConnection;12;0;5;0
WireConnection;15;0;4;0
WireConnection;15;1;16;0
WireConnection;74;5;63;0
WireConnection;74;3;60;0
WireConnection;74;4;61;0
WireConnection;53;0;30;0
WireConnection;64;0;74;0
WireConnection;64;1;12;0
WireConnection;55;0;15;0
WireConnection;55;1;53;0
WireConnection;70;0;64;0
WireConnection;13;0;55;0
WireConnection;139;2;13;0
WireConnection;139;3;140;0
WireConnection;139;4;141;0
WireConnection;0;9;71;0
WireConnection;0;10;71;0
WireConnection;0;13;139;0
ASEEND*/
//CHKSM=E3141488AB8DFF2F2687319762AEB58616CEB507