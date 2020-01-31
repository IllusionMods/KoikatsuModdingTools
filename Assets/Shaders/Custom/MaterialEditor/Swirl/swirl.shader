// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "swirl"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Swirliness("Swirliness", Range( 0 , 1)) = 0
		_Speed("Speed", Float) = 1
		_Pivot("Pivot", Vector) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
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
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
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

		uniform sampler2D _Albedo;
		uniform float _Speed;
		uniform float3 _Pivot;
		uniform float _Swirliness;
		uniform int _alpha_a;
		uniform sampler2D _AlphaMask;
		uniform float4 _AlphaMask_ST;
		uniform int _alpha_b;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_AlphaMask = i.uv_texcoord * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
			float4 break14_g11 = ( 1.0 - tex2D( _AlphaMask, uv_AlphaMask ) );
			SurfaceOutputStandard s56 = (SurfaceOutputStandard ) 0;
			s56.Albedo = float3( 0,0,0 );
			float3 ase_worldNormal = i.worldNormal;
			s56.Normal = ase_worldNormal;
			s56.Emission = float3( 0,0,0 );
			s56.Metallic = _Metallic;
			s56.Smoothness = _Smoothness;
			s56.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi56 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g56 = UnityGlossyEnvironmentSetup( s56.Smoothness, data.worldViewDir, s56.Normal, float3(0,0,0));
			gi56 = UnityGlobalIllumination( data, s56.Occlusion, s56.Normal, g56 );
			#endif

			float3 surfResult56 = LightingStandard ( s56, viewDir, gi56 ).rgb;
			surfResult56 += s56.Emission;

			#ifdef UNITY_PASS_FORWARDADD//56
			surfResult56 -= s56.Emission;
			#endif//56
			c.rgb = surfResult56;
			c.a = 1;
			clip( ( 1.0 - saturate( ( ( _alpha_a * break14_g11.x ) + ( break14_g11.y * _alpha_b ) ) ) ) - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float mulTime15 = _Time.y * _Speed;
			float t46 = mulTime15;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float2 temp_output_32_0 = (_Pivot).xy;
			float cos42 = cos( t46 );
			float sin42 = sin( t46 );
			float2 rotator42 = mul( (ase_screenPos).xy - temp_output_32_0 , float2x2( cos42 , -sin42 , sin42 , cos42 )) + temp_output_32_0;
			float2 p37 = ( rotator42 - temp_output_32_0 );
			float dotResult8 = dot( p37 , p37 );
			float r28 = sqrt( dotResult8 );
			float2 break5 = p37;
			float a27 = ( atan2( break5.y , break5.x ) * 0.5 );
			float4 appendResult13 = (float4(( t46 - ( 1.0 / ( r28 + _Swirliness ) ) ) , ( ( a27 / UNITY_PI ) * _Pivot.z ) , 0.0 , 0.0));
			o.Emission = tex2D( _Albedo, appendResult13.xy ).rgb;
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
587;525;1674;878;4735.461;26.50941;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;16;-3724.315,-279.132;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;1;0.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-3539.705,-264.6695;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;57;-4606.028,306.2444;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;30;-4058.711,606.0747;Float;False;Property;_Pivot;Pivot;3;0;Create;True;0;0;False;0;0,0,0;0.5,0.5,8;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-3326.073,-241.5;Float;False;t;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;58;-4340.584,297.3546;Float;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;32;-3840.062,494.2851;Float;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-3823.244,344.8029;Float;False;46;t;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;42;-3538.373,261.2368;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;4;-3278.712,466.1597;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-3052.26,458.9321;Float;False;p;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-2897.512,-98.6452;Float;False;37;p;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;5;-2351.609,-159.0312;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DotProductOpNode;8;-2631.911,-45.8452;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2143.61,-63.03118;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SqrtOpNode;9;-2503.911,-45.8452;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;2;-2111.611,-159.0312;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;28;-2391.911,-61.84521;Float;False;r;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1986.21,-124.432;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1739.474,372.4586;Float;False;28;r;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1831.423,443.661;Float;False;Property;_Swirliness;Swirliness;1;0;Create;True;0;0;False;0;0;0.104;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1843.259,-128.5332;Float;False;a;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;11;-1745.467,602.454;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1573.04,358.1939;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-1745.781,529.249;Float;False;27;a;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1556.242,428.9893;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;12;-1557.24,535.7455;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1491.13,284.5394;Float;False;46;t;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;24;-1437.187,361.4886;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1294.24,326.813;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1411.095,619.4096;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-525.5436,527.9404;Float;False;Property;_Smoothness;Smoothness;6;0;Create;True;0;0;False;0;0;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;13;-1096.818,508.5379;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;59;-667.5162,-270.6294;Float;True;Property;_AlphaMask;AlphaMask;9;0;Create;True;0;0;False;0;None;3007a6e28d4341c41aeed5fd01f3769c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;61;-522.5162,-17.62912;Float;False;Property;_alpha_b;alpha_b;8;0;Create;True;0;0;False;1;Toggle;1;1;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-525.5436,453.9404;Float;False;Property;_Metallic;Metallic;5;0;Create;True;0;0;False;0;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;60;-521.5162,-87.62933;Float;False;Property;_alpha_a;alpha_a;7;0;Create;True;0;0;False;1;Toggle;1;1;0;1;INT;0
Node;AmplifyShaderEditor.CustomStandardSurface;56;-158.6914,354.4904;Float;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;34;-582.4968,95.41919;Float;True;Property;_Albedo;Albedo;4;0;Create;True;0;0;False;0;None;750b1bd7ba8bd28489650de6d0a95cc5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;62;-239.5182,-170.6294;Float;False;KKAlpha;-1;;11;9e81c0a0e663ece489146622c3f1b497;0;3;5;FLOAT4;0,0,0,0;False;3;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;116,28;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;swirl;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;16;0
WireConnection;46;0;15;0
WireConnection;58;0;57;0
WireConnection;32;0;30;0
WireConnection;42;0;58;0
WireConnection;42;1;32;0
WireConnection;42;2;48;0
WireConnection;4;0;42;0
WireConnection;4;1;32;0
WireConnection;37;0;4;0
WireConnection;5;0;38;0
WireConnection;8;0;38;0
WireConnection;8;1;38;0
WireConnection;9;0;8;0
WireConnection;2;0;5;1
WireConnection;2;1;5;0
WireConnection;28;0;9;0
WireConnection;6;0;2;0
WireConnection;6;1;7;0
WireConnection;27;0;6;0
WireConnection;22;0;29;0
WireConnection;22;1;14;0
WireConnection;12;0;26;0
WireConnection;12;1;11;0
WireConnection;24;0;23;0
WireConnection;24;1;22;0
WireConnection;19;0;45;0
WireConnection;19;1;24;0
WireConnection;33;0;12;0
WireConnection;33;1;30;3
WireConnection;13;0;19;0
WireConnection;13;1;33;0
WireConnection;56;3;54;0
WireConnection;56;4;55;0
WireConnection;34;1;13;0
WireConnection;62;5;59;0
WireConnection;62;3;60;0
WireConnection;62;4;61;0
WireConnection;0;2;34;0
WireConnection;0;10;62;0
WireConnection;0;13;56;0
ASEEND*/
//CHKSM=89107933FF539B7E7BD1AD114CE2516B23F3C27B