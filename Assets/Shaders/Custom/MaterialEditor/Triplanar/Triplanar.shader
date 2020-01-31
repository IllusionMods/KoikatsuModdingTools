// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Triplanar"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Toggle]_alpha_a("alpha_a", Int) = 1
		_Pow("Pow", Vector) = (1,1,1,0)
		[Toggle]_alpha_b("alpha_b", Int) = 1
		_Alpha("Alpha", Vector) = (0,0,0,0)
		_Clip("Clip", Vector) = (0,0,0,0)
		_AlphaMask("AlphaMask", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_TextureX("TextureX", 2D) = "white" {}
		_TextureY("TextureY", 2D) = "white" {}
		_TextureZ("TextureZ", 2D) = "white" {}
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
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
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

		uniform int _alpha_a;
		uniform sampler2D _AlphaMask;
		uniform float4 _AlphaMask_ST;
		uniform int _alpha_b;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _TextureX;
		uniform float4 _TextureX_ST;
		uniform float3 _Clip;
		uniform float3 _Pow;
		uniform float3 _Alpha;
		uniform sampler2D _TextureY;
		uniform float4 _TextureY_ST;
		uniform sampler2D _TextureZ;
		uniform float4 _TextureZ_ST;
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
			SurfaceOutputStandard s50 = (SurfaceOutputStandard ) 0;
			s50.Albedo = float3( 0,0,0 );
			float3 ase_worldNormal = i.worldNormal;
			s50.Normal = ase_worldNormal;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float2 uv_TextureX = i.uv_texcoord * _TextureX_ST.xy + _TextureX_ST.zw;
			float3 temp_output_37_0 = pow( abs( ase_worldNormal ) , _Pow );
			float3 break46 = ( max( step( _Clip , temp_output_37_0 ) , step( _Clip , temp_output_37_0 ) ) * temp_output_37_0 * _Alpha );
			float4 lerpResult43 = lerp( tex2D( _Albedo, uv_Albedo ) , tex2D( _TextureX, uv_TextureX ) , break46.x);
			float2 uv_TextureY = i.uv_texcoord * _TextureY_ST.xy + _TextureY_ST.zw;
			float4 lerpResult44 = lerp( lerpResult43 , tex2D( _TextureY, uv_TextureY ) , break46.y);
			float2 uv_TextureZ = i.uv_texcoord * _TextureZ_ST.xy + _TextureZ_ST.zw;
			float4 lerpResult45 = lerp( lerpResult44 , tex2D( _TextureZ, uv_TextureZ ) , break46.z);
			s50.Emission = lerpResult45.rgb;
			s50.Metallic = _Metallic;
			s50.Smoothness = _Smoothness;
			s50.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi50 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g50 = UnityGlossyEnvironmentSetup( s50.Smoothness, data.worldViewDir, s50.Normal, float3(0,0,0));
			gi50 = UnityGlobalIllumination( data, s50.Occlusion, s50.Normal, g50 );
			#endif

			float3 surfResult50 = LightingStandard ( s50, viewDir, gi50 ).rgb;
			surfResult50 += s50.Emission;

			#ifdef UNITY_PASS_FORWARDADD//50
			surfResult50 -= s50.Emission;
			#endif//50
			c.rgb = surfResult50;
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
0;1002;1953;386;820.8758;-144.6132;1;True;False
Node;AmplifyShaderEditor.WorldNormalVector;4;-2557.44,0.8897715;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;38;-2353.091,127.2722;Float;False;Property;_Pow;Pow;2;0;Create;True;0;0;False;0;1,1,1;10,1.83,10;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.AbsOpNode;28;-2325.346,36.0934;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;37;-2168.705,53.09333;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;20;-2156.049,-124.935;Float;False;Property;_Clip;Clip;5;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;18;-1926.095,-111.1591;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;27;-1926.094,-13.66746;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;35;-1813.615,125.0778;Float;False;Property;_Alpha;Alpha;4;0;Create;True;0;0;False;0;0,0,0;1,0.61,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMaxOpNode;24;-1748.066,-81.48775;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1586.933,27.6608;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;46;-1406.901,24.73309;Float;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;40;-1106.319,-385.5121;Float;True;Property;_TextureX;TextureX;8;0;Create;True;0;0;False;0;None;0854ff93270f95c47af1e2b81f9a5173;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;49;-1153.946,-112.6498;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;39;-1107.379,-581.5553;Float;True;Property;_Albedo;Albedo;7;0;Create;True;0;0;False;0;5af85f8fc569c5744bbb32b76979d049;5af85f8fc569c5744bbb32b76979d049;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;48;-742.073,86.23949;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;-1098.395,-91.36066;Float;True;Property;_TextureY;TextureY;9;0;Create;True;0;0;False;0;None;654737ef2143f6f4192416e28b9f14a9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;43;-664.7452,-286.124;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;47;-1129.928,393.1412;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;44;-413.4647,-98.50797;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;42;-1090.128,167.746;Float;True;Property;_TextureZ;TextureZ;10;0;Create;True;0;0;False;0;None;b1e76344d55d05740b72828d7a26d275;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IntNode;53;-90.87634,-76.64476;Float;False;Property;_alpha_b;alpha_b;3;0;Create;True;0;0;False;1;Toggle;1;1;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-239.9269,355.6551;Float;False;Property;_Metallic;Metallic;11;0;Create;True;0;0;False;0;0;0.574;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-238.9269,438.6552;Float;False;Property;_Smoothness;Smoothness;12;0;Create;True;0;0;False;0;0;0.668;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;52;-89.87634,-146.6449;Float;False;Property;_alpha_a;alpha_a;1;0;Create;True;0;0;False;1;Toggle;1;1;0;1;INT;0
Node;AmplifyShaderEditor.SamplerNode;51;-235.8763,-329.6452;Float;True;Property;_AlphaMask;AlphaMask;6;0;Create;True;0;0;False;0;None;3007a6e28d4341c41aeed5fd01f3769c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;45;-212.0004,94.20601;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;54;192.1215,-229.6449;Float;False;KKAlpha;-1;;8;9e81c0a0e663ece489146622c3f1b497;0;3;5;FLOAT4;0,0,0,0;False;3;INT;0;False;4;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;50;119.1672,149.3454;Float;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;3;477.1611,-229.9526;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;Triplanar;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;4;0
WireConnection;37;0;28;0
WireConnection;37;1;38;0
WireConnection;18;0;20;0
WireConnection;18;1;37;0
WireConnection;27;0;20;0
WireConnection;27;1;37;0
WireConnection;24;0;18;0
WireConnection;24;1;27;0
WireConnection;36;0;24;0
WireConnection;36;1;37;0
WireConnection;36;2;35;0
WireConnection;46;0;36;0
WireConnection;49;0;46;0
WireConnection;48;0;46;1
WireConnection;43;0;39;0
WireConnection;43;1;40;0
WireConnection;43;2;49;0
WireConnection;47;0;46;2
WireConnection;44;0;43;0
WireConnection;44;1;41;0
WireConnection;44;2;48;0
WireConnection;45;0;44;0
WireConnection;45;1;42;0
WireConnection;45;2;47;0
WireConnection;54;5;51;0
WireConnection;54;3;52;0
WireConnection;54;4;53;0
WireConnection;50;2;45;0
WireConnection;50;3;61;0
WireConnection;50;4;62;0
WireConnection;3;10;54;0
WireConnection;3;13;50;0
ASEEND*/
//CHKSM=3FAB2114E7ABEA136983B44A84EE7F6B21BA1358