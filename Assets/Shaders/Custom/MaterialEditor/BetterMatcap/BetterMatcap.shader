// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BetterMatcap"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Toggle]_alpha_a("alpha_a", Int) = 1
		[Toggle]_alpha_b("alpha_b", Int) = 1
		_Matcap("Matcap", 2D) = "white" {}
		_AlphaMask("AlphaMask", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			float3 worldPos;
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
		uniform sampler2D _Matcap;
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
			SurfaceOutputStandard s11 = (SurfaceOutputStandard ) 0;
			s11.Albedo = float3( 0,0,0 );
			float3 ase_worldNormal = i.worldNormal;
			s11.Normal = ase_worldNormal;
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 temp_output_4_0_g3 = mul( UNITY_MATRIX_MV, ase_vertex4Pos );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float3 temp_output_5_0_g3 = mul( UNITY_MATRIX_MV, float4( ase_vertexNormal , 0.0 ) ).xyz;
			float4 break9_g3 = reflect( temp_output_4_0_g3 , float4( temp_output_5_0_g3 , 0.0 ) );
			float4 appendResult20_g3 = (float4(break9_g3.x , break9_g3.y , 0.0 , 0.0));
			s11.Emission = tex2D( _Matcap, (saturate( ( ( appendResult20_g3 / ( sqrt( ( pow( break9_g3.x , 2.0 ) + pow( break9_g3.y , 2.0 ) + pow( ( break9_g3.z + 1 ) , 2.0 ) ) ) * 2 ) ) + 0.5 ) )).xy ).rgb;
			s11.Metallic = _Metallic;
			s11.Smoothness = _Smoothness;
			s11.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi11 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g11 = UnityGlossyEnvironmentSetup( s11.Smoothness, data.worldViewDir, s11.Normal, float3(0,0,0));
			gi11 = UnityGlobalIllumination( data, s11.Occlusion, s11.Normal, g11 );
			#endif

			float3 surfResult11 = LightingStandard ( s11, viewDir, gi11 ).rgb;
			surfResult11 += s11.Emission;

			#ifdef UNITY_PASS_FORWARDADD//11
			surfResult11 -= s11.Emission;
			#endif//11
			c.rgb = surfResult11;
			c.a = 1;
			clip( ( 1.0 - saturate( ( ( _alpha_a * break14_g8.x ) + ( break14_g8.y * _alpha_b ) ) ) ) - _Cutoff );
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
0;1002;1953;386;1991.519;80.30154;1.488548;True;False
Node;AmplifyShaderEditor.FunctionNode;5;-1164.5,23.3;Float;True;BetterMatcap;-1;;3;b1839192452161548803429ef20292a1;0;0;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;8;-776.7387,-140.4233;Float;False;Property;_alpha_b;alpha_b;2;0;Create;True;0;0;False;1;Toggle;1;1;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;7;-775.7387,-210.4235;Float;False;Property;_alpha_a;alpha_a;1;0;Create;True;0;0;False;1;Toggle;1;1;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-846.9254,304.3387;Float;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;False;0;0;0.798;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-847.9254,221.3387;Float;False;Property;_Metallic;Metallic;5;0;Create;True;0;0;False;0;0;0.444;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-864.241,25.746;Float;True;Property;_Matcap;Matcap;3;0;Create;True;0;0;False;0;None;2ef5091b1025c6146b59e677f4b63512;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-921.7387,-393.4235;Float;True;Property;_AlphaMask;AlphaMask;4;0;Create;True;0;0;False;0;None;3007a6e28d4341c41aeed5fd01f3769c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomStandardSurface;11;-501.0043,43.99145;Float;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;9;-493.7408,-293.4235;Float;False;KKAlpha;-1;;8;9e81c0a0e663ece489146622c3f1b497;0;3;5;FLOAT4;0,0,0,0;False;3;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;-48.02165,-243.7631;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;BetterMatcap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;1;5;0
WireConnection;11;2;10;0
WireConnection;11;3;12;0
WireConnection;11;4;13;0
WireConnection;9;5;6;0
WireConnection;9;3;7;0
WireConnection;9;4;8;0
WireConnection;2;10;9;0
WireConnection;2;13;11;0
ASEEND*/
//CHKSM=CAE460304EFCAC0033640680BCCFDFBE1BC20AD6