// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Space"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_FlowMap("FlowMap", 2D) = "white" {}
		_DistortScale("DistortScale", Range( -2 , 2)) = 0
		_DistortSinSpeed("DistortSinSpeed", Range( 0 , 2)) = 1
		_TexPan("TexPan", Vector) = (1,1,0,0)
		_DistortPan("DistortPan", Vector) = (1,1,0,0)
		_Tile("Tile", Vector) = (3,3,0,0)
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[Toggle]_alpha_a("alpha_a", Int) = 1
		[Toggle]_alpha_b("alpha_b", Int) = 1
		_AlphaMask("AlphaMask", 2D) = "white" {}
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
			float4 screenPos;
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
		uniform sampler2D _Albedo;
		uniform float2 _TexPan;
		uniform float2 _Tile;
		uniform sampler2D _FlowMap;
		uniform float _DistortSinSpeed;
		uniform float2 _DistortPan;
		uniform float _DistortScale;
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
			SurfaceOutputStandard s180 = (SurfaceOutputStandard ) 0;
			s180.Albedo = float3( 0,0,0 );
			float3 ase_worldNormal = i.worldNormal;
			s180.Normal = ase_worldNormal;
			float temp_output_33_0_g2 = _Tile.x;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 temp_output_100_0 = (ase_screenPosNorm).xy;
			float2 break35_g2 = temp_output_100_0;
			float temp_output_34_0_g2 = _Tile.y;
			float4 appendResult30_g2 = (float4(( temp_output_33_0_g2 * fmod( break35_g2.x , ( 1.0 / temp_output_33_0_g2 ) ) ) , ( temp_output_34_0_g2 * fmod( break35_g2.y , ( 1.0 / temp_output_34_0_g2 ) ) ) , 0.0 , 0.0));
			float4 temp_output_170_0 = appendResult30_g2;
			float mulTime138 = _Time.y * _DistortSinSpeed;
			float2 panner127 = ( mulTime138 * _DistortPan + temp_output_100_0);
			float4 lerpResult176 = lerp( temp_output_170_0 , ( temp_output_170_0 + tex2D( _FlowMap, panner127 ) ) , ( sin( mulTime138 ) * _DistortScale ));
			float2 panner178 = ( 1.0 * _Time.y * _TexPan + lerpResult176.xy);
			float4 tex2DNode46 = tex2D( _Albedo, panner178 );
			float4 lerpResult108 = lerp( tex2DNode46 , float4( 0,0,0,0 ) , ( 1.0 - tex2DNode46.a ));
			s180.Emission = lerpResult108.rgb;
			s180.Metallic = _Metallic;
			s180.Smoothness = _Smoothness;
			s180.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi180 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g180 = UnityGlossyEnvironmentSetup( s180.Smoothness, data.worldViewDir, s180.Normal, float3(0,0,0));
			gi180 = UnityGlobalIllumination( data, s180.Occlusion, s180.Normal, g180 );
			#endif

			float3 surfResult180 = LightingStandard ( s180, viewDir, gi180 ).rgb;
			surfResult180 += s180.Emission;

			#ifdef UNITY_PASS_FORWARDADD//180
			surfResult180 -= s180.Emission;
			#endif//180
			c.rgb = surfResult180;
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
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
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
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
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
0;1002;1953;386;2035.765;515.892;1.260425;True;False
Node;AmplifyShaderEditor.RangedFloatNode;140;-3278.366,-16.3328;Float;False;Property;_DistortSinSpeed;DistortSinSpeed;4;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;123;-3959.574,-320.9514;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;138;-2983.366,-13.33279;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;174;-3281.535,-165.965;Float;False;Property;_DistortPan;DistortPan;6;0;Create;True;0;0;False;0;1,1;-0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;100;-3733.163,-328.2495;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;127;-2775.966,-228.5771;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;173;-2693.031,-474.088;Float;False;Property;_Tile;Tile;7;0;Create;True;0;0;False;0;3,3;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;137;-2631.366,130.6673;Float;False;Property;_DistortScale;DistortScale;3;0;Create;True;0;0;False;0;0;0.2;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;170;-2470.631,-402.1578;Float;False;UVTile;-1;;2;7508548c0ab7a1f4d9549849a3fc02ad;0;3;33;FLOAT;1;False;34;FLOAT;1;False;12;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SinOpNode;139;-2491.366,10.66722;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;124;-2572.767,-256.2155;Float;True;Property;_FlowMap;FlowMap;2;0;Create;True;0;0;False;0;c252f6de490c4124190812e5fcf6ca53;c252f6de490c4124190812e5fcf6ca53;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;-2297.366,36.66721;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;177;-2217.547,-284.2269;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;176;-2017.547,-317.2269;Float;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;179;-1984.632,-27.24416;Float;False;Property;_TexPan;TexPan;5;0;Create;True;0;0;False;0;1,1;0.1,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;178;-1804.063,-194.8562;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;46;-1569.034,-319.9286;Float;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;None;9553dfbc4d5da3b41a35ec4dded20307;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;109;-1247.702,-220.8456;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;-854.1064,-229.5829;Float;False;Property;_Metallic;Metallic;8;0;Create;True;0;0;False;0;0;0.136;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-854.1064,-155.5829;Float;False;Property;_Smoothness;Smoothness;9;0;Create;True;0;0;False;0;0;0.7882353;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;184;-854.5962,-743.3551;Float;True;Property;_AlphaMask;AlphaMask;12;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;185;-708.5962,-560.355;Float;False;Property;_alpha_a;alpha_a;10;0;Create;True;0;0;False;1;Toggle;1;0;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;186;-709.5962,-490.3547;Float;False;Property;_alpha_b;alpha_b;11;0;Create;True;0;0;False;1;Toggle;1;0;0;1;INT;0
Node;AmplifyShaderEditor.LerpOp;108;-1027.702,-331.8455;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;180;-487.2545,-329.033;Float;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;187;-426.5981,-643.3551;Float;False;KKAlpha;-1;;8;9e81c0a0e663ece489146622c3f1b497;0;3;5;FLOAT4;0,0,0,0;False;3;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;-171.4001,-559.6999;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Space;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;138;0;140;0
WireConnection;100;0;123;0
WireConnection;127;0;100;0
WireConnection;127;2;174;0
WireConnection;127;1;138;0
WireConnection;170;33;173;1
WireConnection;170;34;173;2
WireConnection;170;12;100;0
WireConnection;139;0;138;0
WireConnection;124;1;127;0
WireConnection;136;0;139;0
WireConnection;136;1;137;0
WireConnection;177;0;170;0
WireConnection;177;1;124;0
WireConnection;176;0;170;0
WireConnection;176;1;177;0
WireConnection;176;2;136;0
WireConnection;178;0;176;0
WireConnection;178;2;179;0
WireConnection;46;1;178;0
WireConnection;109;0;46;4
WireConnection;108;0;46;0
WireConnection;108;2;109;0
WireConnection;180;2;108;0
WireConnection;180;3;181;0
WireConnection;180;4;182;0
WireConnection;187;5;184;0
WireConnection;187;3;185;0
WireConnection;187;4;186;0
WireConnection;2;10;187;0
WireConnection;2;13;180;0
ASEEND*/
//CHKSM=BA94FA9ABD63FF679AD88365DB4D37F795561147