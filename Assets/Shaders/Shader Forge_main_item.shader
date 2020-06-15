// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shader Forge/main_item" {
    Properties {
        _AnotherRamp ("Another Ramp(LineR)", 2D) = "white" { }
        _MainTex ("MainTex", 2D) = "white" { }
        _NormalMap ("Normal Map", 2D) = "bump" { }
        _DetailMask ("Detail Mask", 2D) = "black" { }
        _LineMask ("Line Mask", 2D) = "black" { }
        _ShadowColor ("Shadow Color", Color) = (0.628,0.628,0.628,1)
        _SpecularPower ("Specular Power", Range(0, 1)) = 0
        _SpeclarHeight ("Speclar Height", Range(0, 1)) = 0.98
        _rimpower ("Rim Width", Range(0, 1)) = 0.5
        _rimV ("Rim Strength", Range(0, 1)) = 0.5
        _ShadowExtend ("Shadow Extend", Range(0, 1)) = 1
        _ShadowExtendAnother ("Shadow Extend Another", Range(0, 1)) = 1
        [MaterialToggle] _AnotherRampFull ("Another Ramp Full", Float) = 0
        [MaterialToggle] _DetailBLineG ("DetailB LineG", Float) = 0
        [MaterialToggle] _DetailRLineR ("DetailR LineR", Float) = 0
        [MaterialToggle] _notusetexspecular ("not use tex specular", Float) = 0
        _LineWidthS ("LineWidthS", Float) = 1
        _Clock ("Clock(xy/piv)(z/ang)(w/spd)", Vector) = (0,0,0,0)
        _ColorMask ("Color Mask", 2D) = "black" { }
        _Color ("Color", Color) = (1,0,0,1)
        _Color2 ("Color2", Color) = (0.1172419,0,1,1)
        _Color3 ("Color3", Color) = (0.5,0.5,0.5,1)
        _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
    }
    SubShader {
        Tags {
            "DisableBatching"="LodFading"
            "QUEUE"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "OUTLINE"
            Tags {
                "DisableBatching"="LodFading"
                "QUEUE"="AlphaTest"
                "RenderType"="TransparentCutout"
                "SHADOWSUPPORT"="true"
            }
            Cull Front
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile SHADOWS_DEPTH SHADOWS_CUBE
            #pragma exclude_renderers xbox360 ps3
            float4 vec4(float x,float y,float z,float w){ return float4(x,y,z,w); }
            float4 vec4(float x){ return float4(x,x,x,x); }
            float4 vec4(float2 x,float2 y){ return float4(float2(x.x,x.y),float2(y.x,y.y)); }
            float4 vec4(float3 x,float y){ return float4(float3(x.x,x.y,x.z),y); }
            float3 vec3(float x,float y,float z){ return float3(x,y,z); }
            float3 vec3(float x){ return float3(x,x,x); }
            float3 vec3(float2 x, float y){ return float3(float2(x.x,x.y),y); }
            float2 vec2(float x,float y){return float2(x,y);}
            float2 vec2(float x){return float2(x,x);}
            float vec(float x){return float(x);}
            float4 textureLod(sampler2D tex, float2 uv, float x){ return tex2Dlod(tex, float4(uv,x,0)); }
            #define gl_Position o.pos
            #define inversesqrt rsqrt
            #define fract frac
            float4 lessThan(float4 a, float4 b) { return float4(1, 1, 1, 1)-step(b, a); }
            #if defined (SHADOWS_DEPTH)
            struct VertexInput {
                float4 in_POSITION0 : POSITION0;
                float3 in_NORMAL0 : NORMAL0;
                float2 in_TEXCOORD0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float4 vs_TEXCOORD1 : TEXCOORD1;
            };
            float _AnotherRampFull;
            float _DetailRLineR;
            float _linewidthG;
            float _LineWidthS;
            float _ShadowExtendAnother;
            float3 u_xlatb2;
            float4 _ambientshadowG;
            float4 _Clock;
            float4 _Color;
            float4 _Color2;
            float4 _Color3;
            float4 _ColorMask_ST;
            float4 _DetailMask_ST;
            float4 _LineColorG;
            float4 _LineMask_ST;
            float4 _MainTex_ST;
            float4 _ShadowColor;
            float4 _TimeEditor;
            sampler2D _ColorMask;
            sampler2D _DetailMask;
            sampler2D _LineMask;
            sampler2D _MainTex;
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float2 u_xlat3;
                u_xlat0 = v.in_POSITION0.yyyy * unity_ObjectToWorld[1];
                u_xlat0 = unity_ObjectToWorld[0] * v.in_POSITION0.xxxx + u_xlat0;
                u_xlat0 = unity_ObjectToWorld[2] * v.in_POSITION0.zzzz + u_xlat0;
                u_xlat0 = unity_ObjectToWorld[3] * v.in_POSITION0.wwww + u_xlat0;
                u_xlat1.xyz = (-u_xlat0.xyz) + _WorldSpaceCameraPos.xyz;
                o.vs_TEXCOORD1 = u_xlat0;
                u_xlat0.x = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat0.x = sqrt(u_xlat0.x);
                u_xlat0.x = u_xlat0.x * 0.0999999866 + 0.300000012;
                u_xlat3.x = _linewidthG * 0.00499999989;
                u_xlat0.x = u_xlat0.x * u_xlat3.x;
                u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
                u_xlat3.xy = v.in_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat1 = textureLod(_DetailMask, u_xlat3.xy, 0.0);
                u_xlat3.x = (-u_xlat1.z) + 1.0;
                u_xlat0.x = u_xlat3.x * u_xlat0.x;
                u_xlat0.x = u_xlat0.x * _LineWidthS;
                u_xlat1.x = unity_WorldToObject[0].x;
                u_xlat1.y = unity_WorldToObject[1].x;
                u_xlat1.z = unity_WorldToObject[2].x;
                u_xlat3.x = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat3.x = sqrt(u_xlat3.x);
                u_xlat1.x = float(1.0) / u_xlat3.x;
                u_xlat2.x = unity_WorldToObject[0].y;
                u_xlat2.y = unity_WorldToObject[1].y;
                u_xlat2.z = unity_WorldToObject[2].y;
                u_xlat3.x = dot(u_xlat2.xyz, u_xlat2.xyz);
                u_xlat3.x = sqrt(u_xlat3.x);
                u_xlat1.y = float(1.0) / u_xlat3.x;
                u_xlat2.x = unity_WorldToObject[0].z;
                u_xlat2.y = unity_WorldToObject[1].z;
                u_xlat2.z = unity_WorldToObject[2].z;
                u_xlat3.x = dot(u_xlat2.xyz, u_xlat2.xyz);
                u_xlat3.x = sqrt(u_xlat3.x);
                u_xlat1.z = float(1.0) / u_xlat3.x;
                u_xlat0.xyz = u_xlat0.xxx / u_xlat1.xyz;
                u_xlat0.xyz = v.in_NORMAL0.xyz * u_xlat0.xyz + v.in_POSITION0.xyz;
                gl_Position = UnityObjectToClipPos(u_xlat0);
                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                float3 u_xlat0;
                float4 u_xlat10_0;
                float4 u_xlat1;
                float4 u_xlat10_1;
                float4 u_xlat2;
                float4 u_xlat10_2;
                float4 u_xlat3;
                float4 u_xlat10_3;
                float4 u_xlat4;
                float3 u_xlat5;
                float u_xlat7;
                float2 u_xlat8;
                float u_xlat18;
                float u_xlat16_18;
                int u_xlatb18;
                float u_xlat19;
                u_xlat0.xy = i.vs_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                u_xlat10_0 = tex2D(_MainTex, u_xlat0.xy);
                u_xlat16_18 = u_xlat10_0.w + u_xlat10_0.w;
                u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
                u_xlat18 = u_xlat16_18 + -0.5;
                u_xlatb18 = u_xlat18<0.0;
                if(((int(u_xlatb18) * int(0xffffffffu)))!=0){discard;}
                u_xlat1.xyz = _Color.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat2.xy = i.vs_TEXCOORD0.xy * _ColorMask_ST.xy + _ColorMask_ST.zw;
                u_xlat10_2 = tex2D(_ColorMask, u_xlat2.xy);
                u_xlat1.xyz = u_xlat10_2.xxx * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat3.xyz = (-u_xlat1.xyz) + _Color2.xyz;
                u_xlat1.xyz = u_xlat10_2.yyy * u_xlat3.xyz + u_xlat1.xyz;
                u_xlat2.xyw = (-u_xlat1.xyz) + _Color3.xyz;
                u_xlat1.xyz = u_xlat10_2.zzz * u_xlat2.xyw + u_xlat1.xyz;
                u_xlat0.xyz = u_xlat10_0.xyz * u_xlat1.xyz;
                u_xlat18 = _TimeEditor.y + _Time.y;
                u_xlat18 = u_xlat18 * _Clock.w;
                u_xlat18 = u_xlat18 * _Clock.z;
                u_xlat1.x = sin(u_xlat18);
                u_xlat2.x = cos(u_xlat18);
                u_xlat3.z = u_xlat1.x;
                u_xlat3.y = u_xlat2.x;
                u_xlat3.x = (-u_xlat1.x);
                u_xlat1.xy = i.vs_TEXCOORD0.xy + (-_Clock.xy);
                u_xlat2.x = dot(u_xlat1.xy, u_xlat3.yz);
                u_xlat2.y = dot(u_xlat1.xy, u_xlat3.xy);
                u_xlat1.xy = u_xlat2.xy + _Clock.xy;
                u_xlat1.xy = u_xlat1.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_1 = tex2D(_LineMask, u_xlat1.xy);
                u_xlat0.xyz = u_xlat10_1.zzz * (-u_xlat0.xyz) + u_xlat0.xyz;
                u_xlat1.xyw = u_xlat0.yzx * _ShadowColor.yzx;
                u_xlatb18 = u_xlat1.x>=u_xlat1.y;
                u_xlat18 = u_xlatb18 ? 1.0 : float(0.0);
                u_xlat2.xy = u_xlat1.yx;
                u_xlat3.xy = u_xlat0.yz * _ShadowColor.yz + (-u_xlat2.xy);
                u_xlat0.xyz = u_xlat0.xyz * _LineColorG.xyz;
                u_xlat2.z = float(-1.0);
                u_xlat2.w = float(0.666666687);
                u_xlat3.z = float(1.0);
                u_xlat3.w = float(-1.0);
                u_xlat2 = vec4(u_xlat18) * u_xlat3 + u_xlat2;
                u_xlatb18 = u_xlat1.w>=u_xlat2.x;
                u_xlat18 = u_xlatb18 ? 1.0 : float(0.0);
                u_xlat1.xyz = u_xlat2.xyw;
                u_xlat2.xyw = u_xlat1.wyx;
                u_xlat2 = (-u_xlat1) + u_xlat2;
                u_xlat1 = vec4(u_xlat18) * u_xlat2 + u_xlat1;
                u_xlat18 = min(u_xlat1.y, u_xlat1.w);
                u_xlat18 = (-u_xlat18) + u_xlat1.x;
                u_xlat2.x = u_xlat18 * 6.0 + 1.00000001e-10;
                u_xlat7 = (-u_xlat1.y) + u_xlat1.w;
                u_xlat7 = u_xlat7 / u_xlat2.x;
                u_xlat7 = u_xlat7 + u_xlat1.z;
                u_xlat1.x = u_xlat1.x + 1.00000001e-10;
                u_xlat18 = u_xlat18 / u_xlat1.x;
                u_xlat18 = u_xlat18 * 0.5;
                u_xlat1.xyz = abs(vec3(u_xlat7)) + vec3(0.0, -0.333333343, 0.333333343);
                u_xlat1.xyz = fract(u_xlat1.xyz);
                u_xlat1.xyz = (-u_xlat1.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = abs(u_xlat1.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = vec3(u_xlat18) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlatb2.xyz = lessThan(vec4(0.555555582, 0.555555582, 0.555555582, 0.0), u_xlat1.xyzx).xyz;
                u_xlat3.xyz = u_xlat1.xyz * vec3(0.899999976, 0.899999976, 0.899999976) + vec3(-0.5, -0.5, -0.5);
                u_xlat3.xyz = (-u_xlat3.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat4 = (-_ambientshadowG.wxyz) + vec4(1.0, 1.0, 1.0, 1.0);
                u_xlat4.xyz = (-u_xlat4.xxx) * u_xlat4.yzw + vec3(1.0, 1.0, 1.0);
                u_xlat18 = _ambientshadowG.w * 0.5 + 0.5;
                u_xlat19 = u_xlat18 + u_xlat18;
                u_xlatb18 = 0.5<u_xlat18;
                u_xlat5.xyz = vec3(u_xlat19) * _ambientshadowG.xyz;
                u_xlat4.xyz = (bool(u_xlatb18)) ? u_xlat4.xyz : u_xlat5.xyz;
                u_xlat4.xyz = clamp(u_xlat4.xyz, 0.0, 1.0);
                u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz * u_xlat4.xyz;
                u_xlat1.xyz = u_xlat1.xyz * vec3(1.79999995, 1.79999995, 1.79999995);
                u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
                {
                float4 hlslcc_movcTemp = u_xlat1;
                hlslcc_movcTemp.x = (u_xlatb2.x) ? u_xlat3.x : u_xlat1.x;
                hlslcc_movcTemp.y = (u_xlatb2.y) ? u_xlat3.y : u_xlat1.y;
                hlslcc_movcTemp.z = (u_xlatb2.z) ? u_xlat3.z : u_xlat1.z;
                u_xlat1 = hlslcc_movcTemp;
                }
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat2.xy = i.vs_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_2 = tex2D(_DetailMask, u_xlat2.xy);
                u_xlat8.xy = i.vs_TEXCOORD0.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_3 = tex2D(_LineMask, u_xlat8.xy);
                u_xlat16_18 = u_xlat10_2.x + (-u_xlat10_3.x);
                u_xlat18 = _DetailRLineR * u_xlat16_18 + u_xlat10_3.x;
                u_xlat19 = (-u_xlat18) + 1.0;
                u_xlat18 = _AnotherRampFull * u_xlat19 + u_xlat18;
                u_xlat19 = (-_ShadowExtendAnother) + 1.0;
                u_xlat18 = (-u_xlat18) + u_xlat19;
                u_xlat18 = u_xlat18 + 1.0;
                u_xlat18 = clamp(u_xlat18, 0.0, 1.0);
                u_xlat18 = u_xlat18 * 0.670000017 + 0.330000013;
                u_xlat1.xyz = vec3(u_xlat18) * u_xlat1.xyz;
                u_xlat2.xyz = (-u_xlat0.xyz) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
                u_xlat18 = _LineColorG.w + -0.5;
                u_xlat18 = (-u_xlat18) * 2.0 + 1.0;
                u_xlat1.xyz = (-vec3(u_xlat18)) * u_xlat2.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat18 = _LineColorG.w + _LineColorG.w;
                u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat18);
                u_xlatb18 = 0.5<_LineColorG.w;
                SV_Target0.xyz = (bool(u_xlatb18)) ? u_xlat1.xyz : u_xlat0.xyz;
                SV_Target0.xyz = clamp(SV_Target0.xyz, 0.0, 1.0);
                SV_Target0.w = 0.0;
                return SV_Target0;
            }
            #elif defined (SHADOWS_CUBE)
            struct VertexInput {
                float4 in_POSITION0 : POSITION0;
                float3 in_NORMAL0 : NORMAL0;
                float2 in_TEXCOORD0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float4 vs_TEXCOORD1 : TEXCOORD1;
            };
            float _AnotherRampFull;
            float _DetailRLineR;
            float _linewidthG;
            float _LineWidthS;
            float _ShadowExtendAnother;
            float3 u_xlatb2;
            float4 _ambientshadowG;
            float4 _Clock;
            float4 _Color;
            float4 _Color2;
            float4 _Color3;
            float4 _ColorMask_ST;
            float4 _DetailMask_ST;
            float4 _LineColorG;
            float4 _LineMask_ST;
            float4 _MainTex_ST;
            float4 _ShadowColor;
            float4 _TimeEditor;
            sampler2D _ColorMask;
            sampler2D _DetailMask;
            sampler2D _LineMask;
            sampler2D _MainTex;
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float2 u_xlat3;
                u_xlat0 = v.in_POSITION0.yyyy * unity_ObjectToWorld[1];
                u_xlat0 = unity_ObjectToWorld[0] * v.in_POSITION0.xxxx + u_xlat0;
                u_xlat0 = unity_ObjectToWorld[2] * v.in_POSITION0.zzzz + u_xlat0;
                u_xlat0 = unity_ObjectToWorld[3] * v.in_POSITION0.wwww + u_xlat0;
                u_xlat1.xyz = (-u_xlat0.xyz) + _WorldSpaceCameraPos.xyz;
                o.vs_TEXCOORD1 = u_xlat0;
                u_xlat0.x = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat0.x = sqrt(u_xlat0.x);
                u_xlat0.x = u_xlat0.x * 0.0999999866 + 0.300000012;
                u_xlat3.x = _linewidthG * 0.00499999989;
                u_xlat0.x = u_xlat0.x * u_xlat3.x;
                u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
                u_xlat3.xy = v.in_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat1 = textureLod(_DetailMask, u_xlat3.xy, 0.0);
                u_xlat3.x = (-u_xlat1.z) + 1.0;
                u_xlat0.x = u_xlat3.x * u_xlat0.x;
                u_xlat0.x = u_xlat0.x * _LineWidthS;
                u_xlat1.x = unity_WorldToObject[0].x;
                u_xlat1.y = unity_WorldToObject[1].x;
                u_xlat1.z = unity_WorldToObject[2].x;
                u_xlat3.x = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat3.x = sqrt(u_xlat3.x);
                u_xlat1.x = float(1.0) / u_xlat3.x;
                u_xlat2.x = unity_WorldToObject[0].y;
                u_xlat2.y = unity_WorldToObject[1].y;
                u_xlat2.z = unity_WorldToObject[2].y;
                u_xlat3.x = dot(u_xlat2.xyz, u_xlat2.xyz);
                u_xlat3.x = sqrt(u_xlat3.x);
                u_xlat1.y = float(1.0) / u_xlat3.x;
                u_xlat2.x = unity_WorldToObject[0].z;
                u_xlat2.y = unity_WorldToObject[1].z;
                u_xlat2.z = unity_WorldToObject[2].z;
                u_xlat3.x = dot(u_xlat2.xyz, u_xlat2.xyz);
                u_xlat3.x = sqrt(u_xlat3.x);
                u_xlat1.z = float(1.0) / u_xlat3.x;
                u_xlat0.xyz = u_xlat0.xxx / u_xlat1.xyz;
                u_xlat0.xyz = v.in_NORMAL0.xyz * u_xlat0.xyz + v.in_POSITION0.xyz;
                gl_Position = mul(unity_MatrixMVP, u_xlat0);
                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                float3 u_xlat0;
                float4 u_xlat10_0;
                float4 u_xlat1;
                float4 u_xlat10_1;
                float4 u_xlat2;
                float4 u_xlat10_2;
                float4 u_xlat3;
                float4 u_xlat10_3;
                float4 u_xlat4;
                float3 u_xlat5;
                float u_xlat7;
                float2 u_xlat8;
                float u_xlat18;
                float u_xlat16_18;
                int u_xlatb18;
                float u_xlat19;
                u_xlat0.xy = i.vs_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                u_xlat10_0 = tex2D(_MainTex, u_xlat0.xy);
                u_xlat16_18 = u_xlat10_0.w + u_xlat10_0.w;
                u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
                u_xlat18 = u_xlat16_18 + -0.5;
                u_xlatb18 = u_xlat18<0.0;
                if(((int(u_xlatb18) * int(0xffffffffu)))!=0){discard;}
                u_xlat1.xyz = _Color.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat2.xy = i.vs_TEXCOORD0.xy * _ColorMask_ST.xy + _ColorMask_ST.zw;
                u_xlat10_2 = tex2D(_ColorMask, u_xlat2.xy);
                u_xlat1.xyz = u_xlat10_2.xxx * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat3.xyz = (-u_xlat1.xyz) + _Color2.xyz;
                u_xlat1.xyz = u_xlat10_2.yyy * u_xlat3.xyz + u_xlat1.xyz;
                u_xlat2.xyw = (-u_xlat1.xyz) + _Color3.xyz;
                u_xlat1.xyz = u_xlat10_2.zzz * u_xlat2.xyw + u_xlat1.xyz;
                u_xlat0.xyz = u_xlat10_0.xyz * u_xlat1.xyz;
                u_xlat18 = _TimeEditor.y + _Time.y;
                u_xlat18 = u_xlat18 * _Clock.w;
                u_xlat18 = u_xlat18 * _Clock.z;
                u_xlat1.x = sin(u_xlat18);
                u_xlat2.x = cos(u_xlat18);
                u_xlat3.z = u_xlat1.x;
                u_xlat3.y = u_xlat2.x;
                u_xlat3.x = (-u_xlat1.x);
                u_xlat1.xy = i.vs_TEXCOORD0.xy + (-_Clock.xy);
                u_xlat2.x = dot(u_xlat1.xy, u_xlat3.yz);
                u_xlat2.y = dot(u_xlat1.xy, u_xlat3.xy);
                u_xlat1.xy = u_xlat2.xy + _Clock.xy;
                u_xlat1.xy = u_xlat1.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_1 = tex2D(_LineMask, u_xlat1.xy);
                u_xlat0.xyz = u_xlat10_1.zzz * (-u_xlat0.xyz) + u_xlat0.xyz;
                u_xlat1.xyw = u_xlat0.yzx * _ShadowColor.yzx;
                u_xlatb18 = u_xlat1.x>=u_xlat1.y;
                u_xlat18 = u_xlatb18 ? 1.0 : float(0.0);
                u_xlat2.xy = u_xlat1.yx;
                u_xlat3.xy = u_xlat0.yz * _ShadowColor.yz + (-u_xlat2.xy);
                u_xlat0.xyz = u_xlat0.xyz * _LineColorG.xyz;
                u_xlat2.z = float(-1.0);
                u_xlat2.w = float(0.666666687);
                u_xlat3.z = float(1.0);
                u_xlat3.w = float(-1.0);
                u_xlat2 = vec4(u_xlat18) * u_xlat3 + u_xlat2;
                u_xlatb18 = u_xlat1.w>=u_xlat2.x;
                u_xlat18 = u_xlatb18 ? 1.0 : float(0.0);
                u_xlat1.xyz = u_xlat2.xyw;
                u_xlat2.xyw = u_xlat1.wyx;
                u_xlat2 = (-u_xlat1) + u_xlat2;
                u_xlat1 = vec4(u_xlat18) * u_xlat2 + u_xlat1;
                u_xlat18 = min(u_xlat1.y, u_xlat1.w);
                u_xlat18 = (-u_xlat18) + u_xlat1.x;
                u_xlat2.x = u_xlat18 * 6.0 + 1.00000001e-10;
                u_xlat7 = (-u_xlat1.y) + u_xlat1.w;
                u_xlat7 = u_xlat7 / u_xlat2.x;
                u_xlat7 = u_xlat7 + u_xlat1.z;
                u_xlat1.x = u_xlat1.x + 1.00000001e-10;
                u_xlat18 = u_xlat18 / u_xlat1.x;
                u_xlat18 = u_xlat18 * 0.5;
                u_xlat1.xyz = abs(vec3(u_xlat7)) + vec3(0.0, -0.333333343, 0.333333343);
                u_xlat1.xyz = fract(u_xlat1.xyz);
                u_xlat1.xyz = (-u_xlat1.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = abs(u_xlat1.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = vec3(u_xlat18) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlatb2.xyz = lessThan(vec4(0.555555582, 0.555555582, 0.555555582, 0.0), u_xlat1.xyzx).xyz;
                u_xlat3.xyz = u_xlat1.xyz * vec3(0.899999976, 0.899999976, 0.899999976) + vec3(-0.5, -0.5, -0.5);
                u_xlat3.xyz = (-u_xlat3.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat4 = (-_ambientshadowG.wxyz) + vec4(1.0, 1.0, 1.0, 1.0);
                u_xlat4.xyz = (-u_xlat4.xxx) * u_xlat4.yzw + vec3(1.0, 1.0, 1.0);
                u_xlat18 = _ambientshadowG.w * 0.5 + 0.5;
                u_xlat19 = u_xlat18 + u_xlat18;
                u_xlatb18 = 0.5<u_xlat18;
                u_xlat5.xyz = vec3(u_xlat19) * _ambientshadowG.xyz;
                u_xlat4.xyz = (bool(u_xlatb18)) ? u_xlat4.xyz : u_xlat5.xyz;
                u_xlat4.xyz = clamp(u_xlat4.xyz, 0.0, 1.0);
                u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz * u_xlat4.xyz;
                u_xlat1.xyz = u_xlat1.xyz * vec3(1.79999995, 1.79999995, 1.79999995);
                u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
                {
                float4 hlslcc_movcTemp = u_xlat1;
                hlslcc_movcTemp.x = (u_xlatb2.x) ? u_xlat3.x : u_xlat1.x;
                hlslcc_movcTemp.y = (u_xlatb2.y) ? u_xlat3.y : u_xlat1.y;
                hlslcc_movcTemp.z = (u_xlatb2.z) ? u_xlat3.z : u_xlat1.z;
                u_xlat1 = hlslcc_movcTemp;
                }
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat2.xy = i.vs_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_2 = tex2D(_DetailMask, u_xlat2.xy);
                u_xlat8.xy = i.vs_TEXCOORD0.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_3 = tex2D(_LineMask, u_xlat8.xy);
                u_xlat16_18 = u_xlat10_2.x + (-u_xlat10_3.x);
                u_xlat18 = _DetailRLineR * u_xlat16_18 + u_xlat10_3.x;
                u_xlat19 = (-u_xlat18) + 1.0;
                u_xlat18 = _AnotherRampFull * u_xlat19 + u_xlat18;
                u_xlat19 = (-_ShadowExtendAnother) + 1.0;
                u_xlat18 = (-u_xlat18) + u_xlat19;
                u_xlat18 = u_xlat18 + 1.0;
                u_xlat18 = clamp(u_xlat18, 0.0, 1.0);
                u_xlat18 = u_xlat18 * 0.670000017 + 0.330000013;
                u_xlat1.xyz = vec3(u_xlat18) * u_xlat1.xyz;
                u_xlat2.xyz = (-u_xlat0.xyz) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
                u_xlat18 = _LineColorG.w + -0.5;
                u_xlat18 = (-u_xlat18) * 2.0 + 1.0;
                u_xlat1.xyz = (-vec3(u_xlat18)) * u_xlat2.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat18 = _LineColorG.w + _LineColorG.w;
                u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat18);
                u_xlatb18 = 0.5<_LineColorG.w;
                SV_Target0.xyz = (bool(u_xlatb18)) ? u_xlat1.xyz : u_xlat0.xyz;
                SV_Target0.xyz = clamp(SV_Target0.xyz, 0.0, 1.0);
                SV_Target0.w = 0.0;
                return SV_Target0;
            }
            #endif
            ENDCG
        }
        Pass {
            Name "FORWARD"
            Tags {
                "DisableBatching"="LodFading"
                "LIGHTMODE"="FORWARDBASE"
                "QUEUE"="AlphaTest"
                "RenderType"="TransparentCutout"
                "SHADOWSUPPORT"="true"
            }
            Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha

            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile DIRECTIONAL SHADOWS_SCREEN VERTEXLIGHT_ON
            #pragma exclude_renderers xbox360 ps3
            float4 vec4(float x,float y,float z,float w){ return float4(x,y,z,w); }
            float4 vec4(float x){ return float4(x,x,x,x); }
            float4 vec4(float2 x,float2 y){ return float4(float2(x.x,x.y),float2(y.x,y.y)); }
            float4 vec4(float3 x,float y){ return float4(float3(x.x,x.y,x.z),y); }
            float3 vec3(float x,float y,float z){ return float3(x,y,z); }
            float3 vec3(float x){ return float3(x,x,x); }
            float3 vec3(float2 x, float y){ return float3(float2(x.x,x.y),y); }
            float2 vec2(float x,float y){return float2(x,y);}
            float2 vec2(float x){return float2(x,x);}
            float vec(float x){return float(x);}
            float4 textureLod(sampler2D tex, float2 uv, float x){ return tex2Dlod(tex, float4(uv,x,0)); }
            #define gl_Position o.pos
            #define inversesqrt rsqrt
            #define fract frac
            float4 lessThan(float4 a, float4 b) { return float4(1, 1, 1, 1)-step(b, a); }
            #if defined (DIRECTIONAL) && defined (SHADOWS_SCREEN) && defined (VERTEXLIGHT_ON)
            struct VertexInput {
                float4 in_POSITION0 : POSITION0;
                float3 in_NORMAL0 : NORMAL0;
                float4 in_TANGENT0 : TANGENT0;
                float2 in_TEXCOORD0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float4 vs_TEXCOORD1 : TEXCOORD1;
                float3 vs_TEXCOORD2 : TEXCOORD2;
                float3 vs_TEXCOORD3 : TEXCOORD3;
                float3 vs_TEXCOORD4 : TEXCOORD4;
                float4 vs_TEXCOORD5 : TEXCOORD5;
            };
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float3 u_xlat3;
                float u_xlat13;
                u_xlat0 = mul(unity_ObjectToWorld, v.in_POSITION0);
                o.vs_TEXCOORD1 = u_xlat0;
                u_xlat0 = mul(unity_MatrixVP, u_xlat0);
                gl_Position = u_xlat0;
                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                u_xlat1.x = dot(v.in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
                u_xlat1.y = dot(v.in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
                u_xlat1.z = dot(v.in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
                u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
                o.vs_TEXCOORD2.xyz = u_xlat1.xyz;
                u_xlat2.xyz = v.in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
                u_xlat2.xyz = unity_ObjectToWorld[0].xyz * v.in_TANGENT0.xxx + u_xlat2.xyz;
                u_xlat2.xyz = unity_ObjectToWorld[2].xyz * v.in_TANGENT0.zzz + u_xlat2.xyz;
                u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
                o.vs_TEXCOORD3.xyz = u_xlat2.xyz;
                u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
                u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
                u_xlat1.xyz = u_xlat1.xyz * v.in_TANGENT0.www;
                u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                o.vs_TEXCOORD4.xyz = vec3(u_xlat13) * u_xlat1.xyz;
                u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
                u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
                o.vs_TEXCOORD5.zw = u_xlat0.zw;
                o.vs_TEXCOORD5.xy = u_xlat1.zz + u_xlat1.xw;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                return SV_Target0;
            }
            #elif defined (DIRECTIONAL) && defined (SHADOWS_SCREEN)
            struct VertexInput {
                float4 in_POSITION0 : POSITION0;
                float3 in_NORMAL0 : NORMAL0;
                float4 in_TANGENT0 : TANGENT0;
                float2 in_TEXCOORD0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float4 vs_TEXCOORD1 : TEXCOORD1;
                float3 vs_TEXCOORD2 : TEXCOORD2;
                float3 vs_TEXCOORD3 : TEXCOORD3;
                float3 vs_TEXCOORD4 : TEXCOORD4;
                float4 vs_TEXCOORD5 : TEXCOORD5;
            };
            float _AnotherRampFull;
            float _DetailBLineG;
            float _DetailRLineR;
            float _notusetexspecular;
            float _rimpower;
            float _rimV;
            float _ShadowExtend;
            float _ShadowExtendAnother;
            float _SpeclarHeight;
            float _SpecularPower;
            float3 u_xlatb2;
            float4 _ambientshadowG;
            float4 _AnotherRamp_ST;
            float4 _Clock;
            float4 _Color;
            float4 _Color2;
            float4 _Color3;
            float4 _ColorMask_ST;
            float4 _DetailMask_ST;
            float4 _LineColorG;
            float4 _LineMask_ST;
            float4 _MainTex_ST;
            float4 _NormalMap_ST;
            float4 _RampG_ST;
            float4 _ShadowColor;
            float4 _TimeEditor;
            sampler2D _AnotherRamp;
            sampler2D _ColorMask;
            sampler2D _DetailMask;
            sampler2D _LineMask;
            sampler2D _MainTex;
            sampler2D _NormalMap;
            sampler2D _RampG;
            sampler2D _ShadowMapTexture;
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float3 u_xlat3;
                float u_xlat13;
                u_xlat0 = mul(unity_ObjectToWorld, v.in_POSITION0);
                o.vs_TEXCOORD1 = u_xlat0;
                u_xlat0 = mul(unity_MatrixVP, u_xlat0);
                gl_Position = u_xlat0;
                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                u_xlat1.x = dot(v.in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
                u_xlat1.y = dot(v.in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
                u_xlat1.z = dot(v.in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
                u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
                o.vs_TEXCOORD2.xyz = u_xlat1.xyz;
                u_xlat2.xyz = v.in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
                u_xlat2.xyz = unity_ObjectToWorld[0].xyz * v.in_TANGENT0.xxx + u_xlat2.xyz;
                u_xlat2.xyz = unity_ObjectToWorld[2].xyz * v.in_TANGENT0.zzz + u_xlat2.xyz;
                u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
                o.vs_TEXCOORD3.xyz = u_xlat2.xyz;
                u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
                u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
                u_xlat1.xyz = u_xlat1.xyz * v.in_TANGENT0.www;
                u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                o.vs_TEXCOORD4.xyz = vec3(u_xlat13) * u_xlat1.xyz;
                u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
                u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
                o.vs_TEXCOORD5.zw = u_xlat0.zw;
                o.vs_TEXCOORD5.xy = u_xlat1.zz + u_xlat1.xw;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                float3 u_xlat0;
                float4 u_xlat10_0;
                float4 u_xlat1;
                float4 u_xlat10_1;
                float4 u_xlat2;
                float2 u_xlat16_2;
                float4 u_xlat10_2;
                float4 u_xlat3;
                float4 u_xlat10_3;
                float4 u_xlat4;
                float4 u_xlat5;
                float4 u_xlat10_5;
                float4 u_xlat6;
                float2 u_xlat16_6;
                float4 u_xlat10_6;
                float3 u_xlat7;
                float4 u_xlat10_7;
                float4 u_xlat8;
                float3 u_xlat9;
                float u_xlat11;
                float3 u_xlat17;
                float u_xlat30;
                float u_xlat16_30;
                int u_xlatb30;
                float u_xlat31;
                float u_xlat16_31;
                float u_xlat32;
                float u_xlat34;
                float u_xlat16_34;
                u_xlat0.xy = i.vs_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                u_xlat10_0 = tex2D(_MainTex, u_xlat0.xy);
                u_xlat16_30 = u_xlat10_0.w + u_xlat10_0.w;
                u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
                u_xlat1.x = u_xlat16_30 + -0.5;
                SV_Target0.w = u_xlat16_30 * 2.0 + -1.0;
                u_xlatb30 = u_xlat1.x<0.0;
                if(((int(u_xlatb30) * int(0xffffffffu)))!=0){discard;}
                u_xlat1.xyz = _Color.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat2.xy = i.vs_TEXCOORD0.xy * _ColorMask_ST.xy + _ColorMask_ST.zw;
                u_xlat10_2 = tex2D(_ColorMask, u_xlat2.xy);
                u_xlat1.xyz = u_xlat10_2.xxx * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat3.xyz = (-u_xlat1.xyz) + _Color2.xyz;
                u_xlat1.xyz = u_xlat10_2.yyy * u_xlat3.xyz + u_xlat1.xyz;
                u_xlat2.xyw = (-u_xlat1.xyz) + _Color3.xyz;
                u_xlat1.xyz = u_xlat10_2.zzz * u_xlat2.xyw + u_xlat1.xyz;
                u_xlat0.xyz = u_xlat10_0.xyz * u_xlat1.xyz;
                u_xlat30 = _TimeEditor.y + _Time.y;
                u_xlat30 = u_xlat30 * _Clock.w;
                u_xlat30 = u_xlat30 * _Clock.z;
                u_xlat1.x = sin(u_xlat30);
                u_xlat2.x = cos(u_xlat30);
                u_xlat3.z = u_xlat1.x;
                u_xlat3.y = u_xlat2.x;
                u_xlat3.x = (-u_xlat1.x);
                u_xlat1.xy = i.vs_TEXCOORD0.xy + (-_Clock.xy);
                u_xlat2.x = dot(u_xlat1.xy, u_xlat3.yz);
                u_xlat2.y = dot(u_xlat1.xy, u_xlat3.xy);
                u_xlat1.xy = u_xlat2.xy + _Clock.xy;
                u_xlat1.xy = u_xlat1.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_1 = tex2D(_LineMask, u_xlat1.xy);
                u_xlat0.xyz = u_xlat10_1.zzz * (-u_xlat0.xyz) + u_xlat0.xyz;
                u_xlat1.xyw = u_xlat0.yzx * _ShadowColor.yzx;
                u_xlat2.xy = u_xlat1.yx;
                u_xlat3.xy = u_xlat0.yz * _ShadowColor.yz + (-u_xlat2.xy);
                u_xlatb30 = u_xlat2.y>=u_xlat1.y;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat2.z = float(-1.0);
                u_xlat2.w = float(0.666666687);
                u_xlat3.z = float(1.0);
                u_xlat3.w = float(-1.0);
                u_xlat2 = vec4(u_xlat30) * u_xlat3 + u_xlat2;
                u_xlatb30 = u_xlat1.w>=u_xlat2.x;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat1.xyz = u_xlat2.xyw;
                u_xlat2.xyw = u_xlat1.wyx;
                u_xlat2 = (-u_xlat1) + u_xlat2;
                u_xlat1 = vec4(u_xlat30) * u_xlat2 + u_xlat1;
                u_xlat30 = min(u_xlat1.y, u_xlat1.w);
                u_xlat30 = (-u_xlat30) + u_xlat1.x;
                u_xlat2.x = u_xlat30 * 6.0 + 1.00000001e-10;
                u_xlat11 = (-u_xlat1.y) + u_xlat1.w;
                u_xlat11 = u_xlat11 / u_xlat2.x;
                u_xlat11 = u_xlat11 + u_xlat1.z;
                u_xlat1.x = u_xlat1.x + 1.00000001e-10;
                u_xlat30 = u_xlat30 / u_xlat1.x;
                u_xlat30 = u_xlat30 * 0.5;
                u_xlat1.xyz = abs(vec3(u_xlat11)) + vec3(0.0, -0.333333343, 0.333333343);
                u_xlat1.xyz = fract(u_xlat1.xyz);
                u_xlat1.xyz = (-u_xlat1.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = abs(u_xlat1.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = vec3(u_xlat30) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlatb2.xyz = lessThan(vec4(0.555555582, 0.555555582, 0.555555582, 0.0), u_xlat1.xyzx).xyz;
                u_xlat3.xyz = u_xlat1.xyz * vec3(0.899999976, 0.899999976, 0.899999976) + vec3(-0.5, -0.5, -0.5);
                u_xlat3.xyz = (-u_xlat3.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat4 = (-_ambientshadowG.wxyz) + vec4(1.0, 1.0, 1.0, 1.0);
                u_xlat4.xyz = (-u_xlat4.xxx) * u_xlat4.yzw + vec3(1.0, 1.0, 1.0);
                u_xlat30 = _ambientshadowG.w * 0.5 + 0.5;
                u_xlat31 = u_xlat30 + u_xlat30;
                u_xlatb30 = 0.5<u_xlat30;
                u_xlat5.xyz = vec3(u_xlat31) * _ambientshadowG.xyz;
                u_xlat4.xyz = (bool(u_xlatb30)) ? u_xlat4.xyz : u_xlat5.xyz;
                u_xlat4.xyz = clamp(u_xlat4.xyz, 0.0, 1.0);
                u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz * u_xlat4.xyz;
                u_xlat1.xyz = u_xlat1.xyz * vec3(1.79999995, 1.79999995, 1.79999995);
                u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
                {
                float4 hlslcc_movcTemp = u_xlat1;
                hlslcc_movcTemp.x = (u_xlatb2.x) ? u_xlat3.x : u_xlat1.x;
                hlslcc_movcTemp.y = (u_xlatb2.y) ? u_xlat3.y : u_xlat1.y;
                hlslcc_movcTemp.z = (u_xlatb2.z) ? u_xlat3.z : u_xlat1.z;
                u_xlat1 = hlslcc_movcTemp;
                }
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat30 = (-_ShadowExtendAnother) + 1.0;
                u_xlat2.xy = i.vs_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_2 = tex2D(_DetailMask, u_xlat2.xy);
                u_xlat3.xy = i.vs_TEXCOORD0.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_3 = tex2D(_LineMask, u_xlat3.xy);
                u_xlat16_31 = u_xlat10_2.x + (-u_xlat10_3.x);
                u_xlat31 = _DetailRLineR * u_xlat16_31 + u_xlat10_3.x;
                u_xlat32 = (-u_xlat31) + 1.0;
                u_xlat31 = _AnotherRampFull * u_xlat32 + u_xlat31;
                u_xlat30 = u_xlat30 + (-u_xlat31);
                u_xlat30 = u_xlat30 + 1.0;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat30 = u_xlat30 * 0.670000017 + 0.330000013;
                u_xlat3.xzw = vec3(u_xlat30) * u_xlat1.xyz;
                u_xlat1.xyz = (-u_xlat1.xyz) * vec3(u_xlat30) + vec3(1.0, 1.0, 1.0);
                u_xlat4.xyz = u_xlat0.xyz * u_xlat3.xzw;
                u_xlat5.xyz = (-u_xlat3.xzw) * u_xlat0.xyz + u_xlat0.xyz;
                u_xlat0.xyz = u_xlat0.xyz * _LineColorG.xyz;
                u_xlat6.xy = i.vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
                u_xlat10_6 = tex2D(_NormalMap, u_xlat6.xy);
                u_xlat16_6.xy = u_xlat10_6.wy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
                u_xlat7.xyz = u_xlat16_6.yyy * i.vs_TEXCOORD4.xyz;
                u_xlat7.xyz = u_xlat16_6.xxx * i.vs_TEXCOORD3.xyz + u_xlat7.xyz;
                u_xlat16_30 = dot(u_xlat16_6.xy, u_xlat16_6.xy);
                u_xlat16_30 = min(u_xlat16_30, 1.0);
                u_xlat16_30 = (-u_xlat16_30) + 1.0;
                u_xlat16_30 = sqrt(u_xlat16_30);
                u_xlat32 = dot(i.vs_TEXCOORD2.xyz, i.vs_TEXCOORD2.xyz);
                u_xlat32 = inversesqrt(u_xlat32);
                u_xlat6.xyz = vec3(u_xlat32) * i.vs_TEXCOORD2.xyz;
                u_xlat8.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : vec2(-1.0, 0.660000026);
                u_xlat6.xyz = u_xlat6.xyz * u_xlat8.xxx;
                u_xlat6.xyz = vec3(u_xlat16_30) * u_xlat6.xyz + u_xlat7.xyz;
                u_xlat30 = dot(u_xlat6.xyz, u_xlat6.xyz);
                u_xlat30 = inversesqrt(u_xlat30);
                u_xlat6.xyz = vec3(u_xlat30) * u_xlat6.xyz;
                u_xlat30 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                u_xlat30 = inversesqrt(u_xlat30);
                u_xlat7.xyz = vec3(u_xlat30) * _WorldSpaceLightPos0.xyz;
                u_xlat8.xzw = (-i.vs_TEXCOORD1.xyz) + _WorldSpaceCameraPos.xyz;
                u_xlat30 = dot(u_xlat8.xzw, u_xlat8.xzw);
                u_xlat30 = inversesqrt(u_xlat30);
                u_xlat9.xyz = u_xlat8.xzw * vec3(u_xlat30) + u_xlat7.xyz;
                u_xlat32 = dot(u_xlat7.xyz, u_xlat6.xyz);
                u_xlat7.xy = vec2(u_xlat32) * _RampG_ST.xy + _RampG_ST.zw;
                u_xlat10_7 = tex2D(_RampG, u_xlat7.xy);
                u_xlat17.xyz = vec3(u_xlat30) * u_xlat8.xzw;
                u_xlat30 = dot(u_xlat9.xyz, u_xlat9.xyz);
                u_xlat30 = inversesqrt(u_xlat30);
                u_xlat8.xzw = vec3(u_xlat30) * u_xlat9.xyz;
                u_xlat30 = dot(u_xlat6.xyz, u_xlat8.xzw);
                u_xlat32 = dot(u_xlat6.xyz, u_xlat17.xyz);
                u_xlat32 = max(u_xlat32, 0.0);
                u_xlat32 = (-u_xlat32) + 1.0;
                u_xlat32 = log2(u_xlat32);
                u_xlat30 = max(u_xlat30, 0.0);
                u_xlat6.xy = vec2(u_xlat30) * _AnotherRamp_ST.xy + _AnotherRamp_ST.zw;
                u_xlat30 = log2(u_xlat30);
                u_xlat10_6 = tex2D(_AnotherRamp, u_xlat6.xy);
                u_xlat16_34 = (-u_xlat10_7.x) + u_xlat10_6.x;
                u_xlat31 = u_xlat31 * u_xlat16_34 + u_xlat10_7.x;
                u_xlat6.xy = i.vs_TEXCOORD5.xy / i.vs_TEXCOORD5.ww;
                u_xlat10_6 = tex2D(_ShadowMapTexture, u_xlat6.xy);
                u_xlat31 = u_xlat31 * u_xlat10_6.x;
                u_xlat4.xyz = vec3(u_xlat31) * u_xlat5.xyz + u_xlat4.xyz;
                u_xlat5.x = dot(i.vs_TEXCOORD3.xyz, u_xlat17.xyz);
                u_xlat5.y = dot(i.vs_TEXCOORD4.xyz, u_xlat17.xyz);
                u_xlat31 = _SpeclarHeight + -1.0;
                u_xlat31 = u_xlat31 * 0.899999976;
                u_xlat5.xy = vec2(u_xlat31) * u_xlat5.xy + i.vs_TEXCOORD0.xy;
                u_xlat5.xy = u_xlat5.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_5 = tex2D(_DetailMask, u_xlat5.xy);
                u_xlat16_31 = u_xlat10_5.x * u_xlat10_5.x;
                u_xlat16_31 = min(u_xlat16_31, 1.0);
                u_xlat34 = _SpecularPower * 256.0;
                u_xlat30 = u_xlat30 * u_xlat34;
                u_xlat30 = exp2(u_xlat30);
                u_xlat30 = u_xlat30 * 5.0 + -4.0;
                u_xlat31 = u_xlat30 * _SpecularPower + u_xlat16_31;
                u_xlat31 = clamp(u_xlat31, 0.0, 1.0);
                u_xlat30 = u_xlat30 * _SpecularPower;
                u_xlat30 = u_xlat30;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat30 = u_xlat30 * u_xlat10_2.x + (-u_xlat31);
                u_xlat16_2.xy = (-u_xlat10_2.zy) + vec2(1.0, 1.0);
                u_xlat30 = _notusetexspecular * u_xlat30 + u_xlat31;
                u_xlat4.xyz = u_xlat4.xyz + vec3(u_xlat30);
                u_xlatb30 = _ambientshadowG.y>=_ambientshadowG.z;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat5.xy = _ambientshadowG.yz;
                u_xlat5.z = float(0.0);
                u_xlat5.w = float(-0.333333343);
                u_xlat6.xy = _ambientshadowG.zy;
                u_xlat6.z = float(-1.0);
                u_xlat6.w = float(0.666666687);
                u_xlat5 = u_xlat5 + (-u_xlat6);
                u_xlat5 = vec4(u_xlat30) * u_xlat5.xywz + u_xlat6.xywz;
                u_xlatb30 = _ambientshadowG.x>=u_xlat5.x;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat6.z = u_xlat5.w;
                u_xlat5.w = _ambientshadowG.x;
                u_xlat6.xyw = u_xlat5.wyx;
                u_xlat6 = (-u_xlat5) + u_xlat6;
                u_xlat5 = vec4(u_xlat30) * u_xlat6 + u_xlat5;
                u_xlat30 = min(u_xlat5.y, u_xlat5.w);
                u_xlat30 = (-u_xlat30) + u_xlat5.x;
                u_xlat30 = u_xlat30 * 6.0 + 1.00000001e-10;
                u_xlat31 = (-u_xlat5.y) + u_xlat5.w;
                u_xlat30 = u_xlat31 / u_xlat30;
                u_xlat30 = u_xlat30 + u_xlat5.z;
                u_xlat5.xyz = abs(vec3(u_xlat30)) + vec3(0.0, -0.333333343, 0.333333343);
                u_xlat5.xyz = fract(u_xlat5.xyz);
                u_xlat5.xyz = (-u_xlat5.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat5.xyz = abs(u_xlat5.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
                u_xlat5.xyz = u_xlat5.xyz * vec3(0.400000006, 0.400000006, 0.400000006) + vec3(0.300000012, 0.300000012, 0.300000012);
                u_xlat30 = _rimpower * 9.0 + 1.0;
                u_xlat30 = u_xlat32 * u_xlat30;
                u_xlat30 = exp2(u_xlat30);
                u_xlat30 = u_xlat30 * 2.5 + -0.5;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat30 = u_xlat30 * _rimV;
                u_xlat16_31 = u_xlat16_2.x * 9.99999809 + -8.99999809;
                u_xlat30 = u_xlat30 * u_xlat16_31;
                u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat30);
                u_xlat5.xyz = u_xlat16_2.yyy * u_xlat5.xyz;
                u_xlat5.xyz = max(u_xlat5.xyz, vec3(0.0, 0.0, 0.0));
                u_xlat5.xyz = min(u_xlat5.xyz, vec3(0.5, 0.5, 0.5));
                u_xlat4.xyz = u_xlat4.xyz + u_xlat5.xyz;
                u_xlat5.xyz = _LightColor0.xyz * vec3(0.600000024, 0.600000024, 0.600000024) + vec3(0.400000006, 0.400000006, 0.400000006);
                u_xlat5.xyz = max(u_xlat5.xyz, _ambientshadowG.xyz);
                u_xlat4.xyz = u_xlat4.xyz * u_xlat5.xyz;
                u_xlat30 = _ShadowExtend * -1.20000005 + 1.0;
                u_xlat31 = (-u_xlat30) + 1.0;
                u_xlat30 = u_xlat16_2.y * u_xlat31 + u_xlat30;
                u_xlat16_31 = (-u_xlat16_2.x) + 1.0;
                u_xlat16_31 = (-u_xlat10_3.y) + u_xlat16_31;
                u_xlat31 = _DetailBLineG * u_xlat16_31 + u_xlat10_3.y;
                u_xlat1.xyz = vec3(u_xlat30) * u_xlat1.xyz + u_xlat3.xzw;
                u_xlat1.xyz = u_xlat1.xyz * u_xlat4.xyz;
                u_xlat2.xyz = (-u_xlat0.xyz) * u_xlat3.xzw + vec3(1.0, 1.0, 1.0);
                u_xlat0.xyz = u_xlat3.xzw * u_xlat0.xyz;
                u_xlat30 = _LineColorG.w + -0.5;
                u_xlat30 = (-u_xlat30) * 2.0 + 1.0;
                u_xlat2.xyz = (-vec3(u_xlat30)) * u_xlat2.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat30 = _LineColorG.w + _LineColorG.w;
                u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat30);
                u_xlatb30 = 0.5<_LineColorG.w;
                u_xlat0.xyz = (bool(u_xlatb30)) ? u_xlat2.xyz : u_xlat0.xyz;
                u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
                u_xlat0.xyz = (-u_xlat1.xyz) * u_xlat8.yyy + u_xlat0.xyz;
                u_xlat1.xyz = u_xlat8.yyy * u_xlat1.xyz;
                SV_Target0.xyz = vec3(u_xlat31) * u_xlat0.xyz + u_xlat1.xyz;
                return SV_Target0;
            }
            #elif defined (DIRECTIONAL) && defined (VERTEXLIGHT_ON)
            struct VertexInput {
                float4 in_POSITION0 : POSITION0;
                float3 in_NORMAL0 : NORMAL0;
                float4 in_TANGENT0 : TANGENT0;
                float2 in_TEXCOORD0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float4 vs_TEXCOORD1 : TEXCOORD1;
                float3 vs_TEXCOORD2 : TEXCOORD2;
                float3 vs_TEXCOORD3 : TEXCOORD3;
                float3 vs_TEXCOORD4 : TEXCOORD4;
            };
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float u_xlat9;
                u_xlat0 = mul(unity_ObjectToWorld, v.in_POSITION0);
                o.vs_TEXCOORD1 = u_xlat0;
                u_xlat0 = mul(unity_MatrixVP, u_xlat0);
                gl_Position = u_xlat0;
                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                u_xlat0.x = dot(v.in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
                u_xlat0.y = dot(v.in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
                u_xlat0.z = dot(v.in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
                u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                u_xlat0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
                o.vs_TEXCOORD2.xyz = u_xlat0.xyz;
                u_xlat1.xyz = v.in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
                u_xlat1.xyz = unity_ObjectToWorld[0].xyz * v.in_TANGENT0.xxx + u_xlat1.xyz;
                u_xlat1.xyz = unity_ObjectToWorld[2].xyz * v.in_TANGENT0.zzz + u_xlat1.xyz;
                u_xlat9 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz;
                o.vs_TEXCOORD3.xyz = u_xlat1.xyz;
                u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
                u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
                u_xlat0.xyz = u_xlat0.xyz * v.in_TANGENT0.www;
                u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                o.vs_TEXCOORD4.xyz = vec3(u_xlat9) * u_xlat0.xyz;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                return SV_Target0;
            }
            #elif defined (DIRECTIONAL)
            struct VertexInput {
                float4 in_POSITION0 : POSITION0;
                float3 in_NORMAL0 : NORMAL0;
                float4 in_TANGENT0 : TANGENT0;
                float2 in_TEXCOORD0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float4 vs_TEXCOORD1 : TEXCOORD1;
                float3 vs_TEXCOORD2 : TEXCOORD2;
                float3 vs_TEXCOORD3 : TEXCOORD3;
                float3 vs_TEXCOORD4 : TEXCOORD4;
            };
            float _AnotherRampFull;
            float _DetailBLineG;
            float _DetailRLineR;
            float _notusetexspecular;
            float _rimpower;
            float _rimV;
            float _ShadowExtend;
            float _ShadowExtendAnother;
            float _SpeclarHeight;
            float _SpecularPower;
            float3 u_xlatb2;
            float4 _ambientshadowG;
            float4 _AnotherRamp_ST;
            float4 _Clock;
            float4 _Color;
            float4 _Color2;
            float4 _Color3;
            float4 _ColorMask_ST;
            float4 _DetailMask_ST;
            float4 _LineColorG;
            float4 _LineMask_ST;
            float4 _MainTex_ST;
            float4 _NormalMap_ST;
            float4 _RampG_ST;
            float4 _ShadowColor;
            float4 _TimeEditor;
            sampler2D _AnotherRamp;
            sampler2D _ColorMask;
            sampler2D _DetailMask;
            sampler2D _LineMask;
            sampler2D _MainTex;
            sampler2D _NormalMap;
            sampler2D _RampG;
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float u_xlat9;
                u_xlat0 = mul(unity_ObjectToWorld, v.in_POSITION0);
                o.vs_TEXCOORD1 = u_xlat0;
                u_xlat0 = mul(unity_MatrixVP, u_xlat0);
                gl_Position = u_xlat0;
                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                u_xlat0.x = dot(v.in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
                u_xlat0.y = dot(v.in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
                u_xlat0.z = dot(v.in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
                u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                u_xlat0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
                o.vs_TEXCOORD2.xyz = u_xlat0.xyz;
                u_xlat1.xyz = v.in_TANGENT0.yyy * unity_ObjectToWorld[1].xyz;
                u_xlat1.xyz = unity_ObjectToWorld[0].xyz * v.in_TANGENT0.xxx + u_xlat1.xyz;
                u_xlat1.xyz = unity_ObjectToWorld[2].xyz * v.in_TANGENT0.zzz + u_xlat1.xyz;
                u_xlat9 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz;
                o.vs_TEXCOORD3.xyz = u_xlat1.xyz;
                u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
                u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
                u_xlat0.xyz = u_xlat0.xyz * v.in_TANGENT0.www;
                u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                o.vs_TEXCOORD4.xyz = vec3(u_xlat9) * u_xlat0.xyz;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                float3 u_xlat0;
                float4 u_xlat10_0;
                float4 u_xlat1;
                float4 u_xlat10_1;
                float4 u_xlat2;
                float2 u_xlat16_2;
                float4 u_xlat10_2;
                float4 u_xlat3;
                float4 u_xlat10_3;
                float4 u_xlat4;
                float4 u_xlat5;
                float4 u_xlat10_5;
                float4 u_xlat6;
                float2 u_xlat16_6;
                float4 u_xlat10_6;
                float3 u_xlat7;
                float4 u_xlat10_7;
                float4 u_xlat8;
                float3 u_xlat9;
                float u_xlat11;
                float3 u_xlat17;
                float u_xlat30;
                float u_xlat16_30;
                int u_xlatb30;
                float u_xlat31;
                float u_xlat16_31;
                float u_xlat32;
                float u_xlat34;
                float u_xlat16_34;
                u_xlat0.xy = i.vs_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                u_xlat10_0 = tex2D(_MainTex, u_xlat0.xy);
                u_xlat16_30 = u_xlat10_0.w + u_xlat10_0.w;
                u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
                u_xlat1.x = u_xlat16_30 + -0.5;
                SV_Target0.w = u_xlat16_30 * 2.0 + -1.0;
                u_xlatb30 = u_xlat1.x<0.0;
                if(((int(u_xlatb30) * int(0xffffffffu)))!=0){discard;}
                u_xlat1.xyz = _Color.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat2.xy = i.vs_TEXCOORD0.xy * _ColorMask_ST.xy + _ColorMask_ST.zw;
                u_xlat10_2 = tex2D(_ColorMask, u_xlat2.xy);
                u_xlat1.xyz = u_xlat10_2.xxx * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat3.xyz = (-u_xlat1.xyz) + _Color2.xyz;
                u_xlat1.xyz = u_xlat10_2.yyy * u_xlat3.xyz + u_xlat1.xyz;
                u_xlat2.xyw = (-u_xlat1.xyz) + _Color3.xyz;
                u_xlat1.xyz = u_xlat10_2.zzz * u_xlat2.xyw + u_xlat1.xyz;
                u_xlat0.xyz = u_xlat10_0.xyz * u_xlat1.xyz;
                u_xlat30 = _TimeEditor.y + _Time.y;
                u_xlat30 = u_xlat30 * _Clock.w;
                u_xlat30 = u_xlat30 * _Clock.z;
                u_xlat1.x = sin(u_xlat30);
                u_xlat2.x = cos(u_xlat30);
                u_xlat3.z = u_xlat1.x;
                u_xlat3.y = u_xlat2.x;
                u_xlat3.x = (-u_xlat1.x);
                u_xlat1.xy = i.vs_TEXCOORD0.xy + (-_Clock.xy);
                u_xlat2.x = dot(u_xlat1.xy, u_xlat3.yz);
                u_xlat2.y = dot(u_xlat1.xy, u_xlat3.xy);
                u_xlat1.xy = u_xlat2.xy + _Clock.xy;
                u_xlat1.xy = u_xlat1.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_1 = tex2D(_LineMask, u_xlat1.xy);
                u_xlat0.xyz = u_xlat10_1.zzz * (-u_xlat0.xyz) + u_xlat0.xyz;
                u_xlat1.xyw = u_xlat0.yzx * _ShadowColor.yzx;
                u_xlat2.xy = u_xlat1.yx;
                u_xlat3.xy = u_xlat0.yz * _ShadowColor.yz + (-u_xlat2.xy);
                u_xlatb30 = u_xlat2.y>=u_xlat1.y;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat2.z = float(-1.0);
                u_xlat2.w = float(0.666666687);
                u_xlat3.z = float(1.0);
                u_xlat3.w = float(-1.0);
                u_xlat2 = vec4(u_xlat30) * u_xlat3 + u_xlat2;
                u_xlatb30 = u_xlat1.w>=u_xlat2.x;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat1.xyz = u_xlat2.xyw;
                u_xlat2.xyw = u_xlat1.wyx;
                u_xlat2 = (-u_xlat1) + u_xlat2;
                u_xlat1 = vec4(u_xlat30) * u_xlat2 + u_xlat1;
                u_xlat30 = min(u_xlat1.y, u_xlat1.w);
                u_xlat30 = (-u_xlat30) + u_xlat1.x;
                u_xlat2.x = u_xlat30 * 6.0 + 1.00000001e-10;
                u_xlat11 = (-u_xlat1.y) + u_xlat1.w;
                u_xlat11 = u_xlat11 / u_xlat2.x;
                u_xlat11 = u_xlat11 + u_xlat1.z;
                u_xlat1.x = u_xlat1.x + 1.00000001e-10;
                u_xlat30 = u_xlat30 / u_xlat1.x;
                u_xlat30 = u_xlat30 * 0.5;
                u_xlat1.xyz = abs(vec3(u_xlat11)) + vec3(0.0, -0.333333343, 0.333333343);
                u_xlat1.xyz = fract(u_xlat1.xyz);
                u_xlat1.xyz = (-u_xlat1.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = abs(u_xlat1.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = vec3(u_xlat30) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlatb2.xyz = lessThan(vec4(0.555555582, 0.555555582, 0.555555582, 0.0), u_xlat1.xyzx).xyz;
                u_xlat3.xyz = u_xlat1.xyz * vec3(0.899999976, 0.899999976, 0.899999976) + vec3(-0.5, -0.5, -0.5);
                u_xlat3.xyz = (-u_xlat3.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat4 = (-_ambientshadowG.wxyz) + vec4(1.0, 1.0, 1.0, 1.0);
                u_xlat4.xyz = (-u_xlat4.xxx) * u_xlat4.yzw + vec3(1.0, 1.0, 1.0);
                u_xlat30 = _ambientshadowG.w * 0.5 + 0.5;
                u_xlat31 = u_xlat30 + u_xlat30;
                u_xlatb30 = 0.5<u_xlat30;
                u_xlat5.xyz = vec3(u_xlat31) * _ambientshadowG.xyz;
                u_xlat4.xyz = (bool(u_xlatb30)) ? u_xlat4.xyz : u_xlat5.xyz;
                u_xlat4.xyz = clamp(u_xlat4.xyz, 0.0, 1.0);
                u_xlat5.xyz = (-u_xlat4.xyz) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz * u_xlat4.xyz;
                u_xlat1.xyz = u_xlat1.xyz * vec3(1.79999995, 1.79999995, 1.79999995);
                u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat5.xyz + vec3(1.0, 1.0, 1.0);
                {
                float4 hlslcc_movcTemp = u_xlat1;
                hlslcc_movcTemp.x = (u_xlatb2.x) ? u_xlat3.x : u_xlat1.x;
                hlslcc_movcTemp.y = (u_xlatb2.y) ? u_xlat3.y : u_xlat1.y;
                hlslcc_movcTemp.z = (u_xlatb2.z) ? u_xlat3.z : u_xlat1.z;
                u_xlat1 = hlslcc_movcTemp;
                }
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat30 = (-_ShadowExtendAnother) + 1.0;
                u_xlat2.xy = i.vs_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_2 = tex2D(_DetailMask, u_xlat2.xy);
                u_xlat3.xy = i.vs_TEXCOORD0.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_3 = tex2D(_LineMask, u_xlat3.xy);
                u_xlat16_31 = u_xlat10_2.x + (-u_xlat10_3.x);
                u_xlat31 = _DetailRLineR * u_xlat16_31 + u_xlat10_3.x;
                u_xlat32 = (-u_xlat31) + 1.0;
                u_xlat31 = _AnotherRampFull * u_xlat32 + u_xlat31;
                u_xlat30 = u_xlat30 + (-u_xlat31);
                u_xlat30 = u_xlat30 + 1.0;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat30 = u_xlat30 * 0.670000017 + 0.330000013;
                u_xlat3.xzw = vec3(u_xlat30) * u_xlat1.xyz;
                u_xlat1.xyz = (-u_xlat1.xyz) * vec3(u_xlat30) + vec3(1.0, 1.0, 1.0);
                u_xlat4.xyz = u_xlat0.xyz * u_xlat3.xzw;
                u_xlat5.xyz = (-u_xlat3.xzw) * u_xlat0.xyz + u_xlat0.xyz;
                u_xlat0.xyz = u_xlat0.xyz * _LineColorG.xyz;
                u_xlat6.xy = i.vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
                u_xlat10_6 = tex2D(_NormalMap, u_xlat6.xy);
                u_xlat16_6.xy = u_xlat10_6.wy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
                u_xlat7.xyz = u_xlat16_6.yyy * i.vs_TEXCOORD4.xyz;
                u_xlat7.xyz = u_xlat16_6.xxx * i.vs_TEXCOORD3.xyz + u_xlat7.xyz;
                u_xlat16_30 = dot(u_xlat16_6.xy, u_xlat16_6.xy);
                u_xlat16_30 = min(u_xlat16_30, 1.0);
                u_xlat16_30 = (-u_xlat16_30) + 1.0;
                u_xlat16_30 = sqrt(u_xlat16_30);
                u_xlat32 = dot(i.vs_TEXCOORD2.xyz, i.vs_TEXCOORD2.xyz);
                u_xlat32 = inversesqrt(u_xlat32);
                u_xlat6.xyz = vec3(u_xlat32) * i.vs_TEXCOORD2.xyz;
                u_xlat8.xy = (uint((gl_FrontFacing ? 0xffffffffu : uint(0))) != uint(0)) ? vec2(1.0, 1.0) : vec2(-1.0, 0.660000026);
                u_xlat6.xyz = u_xlat6.xyz * u_xlat8.xxx;
                u_xlat6.xyz = vec3(u_xlat16_30) * u_xlat6.xyz + u_xlat7.xyz;
                u_xlat30 = dot(u_xlat6.xyz, u_xlat6.xyz);
                u_xlat30 = inversesqrt(u_xlat30);
                u_xlat6.xyz = vec3(u_xlat30) * u_xlat6.xyz;
                u_xlat30 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                u_xlat30 = inversesqrt(u_xlat30);
                u_xlat7.xyz = vec3(u_xlat30) * _WorldSpaceLightPos0.xyz;
                u_xlat8.xzw = (-i.vs_TEXCOORD1.xyz) + _WorldSpaceCameraPos.xyz;
                u_xlat30 = dot(u_xlat8.xzw, u_xlat8.xzw);
                u_xlat30 = inversesqrt(u_xlat30);
                u_xlat9.xyz = u_xlat8.xzw * vec3(u_xlat30) + u_xlat7.xyz;
                u_xlat32 = dot(u_xlat7.xyz, u_xlat6.xyz);
                u_xlat7.xy = vec2(u_xlat32) * _RampG_ST.xy + _RampG_ST.zw;
                u_xlat10_7 = tex2D(_RampG, u_xlat7.xy);
                u_xlat17.xyz = vec3(u_xlat30) * u_xlat8.xzw;
                u_xlat30 = dot(u_xlat9.xyz, u_xlat9.xyz);
                u_xlat30 = inversesqrt(u_xlat30);
                u_xlat8.xzw = vec3(u_xlat30) * u_xlat9.xyz;
                u_xlat30 = dot(u_xlat6.xyz, u_xlat8.xzw);
                u_xlat32 = dot(u_xlat6.xyz, u_xlat17.xyz);
                u_xlat32 = max(u_xlat32, 0.0);
                u_xlat32 = (-u_xlat32) + 1.0;
                u_xlat32 = log2(u_xlat32);
                u_xlat30 = max(u_xlat30, 0.0);
                u_xlat6.xy = vec2(u_xlat30) * _AnotherRamp_ST.xy + _AnotherRamp_ST.zw;
                u_xlat30 = log2(u_xlat30);
                u_xlat10_6 = tex2D(_AnotherRamp, u_xlat6.xy);
                u_xlat16_34 = (-u_xlat10_7.x) + u_xlat10_6.x;
                u_xlat31 = u_xlat31 * u_xlat16_34 + u_xlat10_7.x;
                u_xlat4.xyz = vec3(u_xlat31) * u_xlat5.xyz + u_xlat4.xyz;
                u_xlat5.x = dot(i.vs_TEXCOORD3.xyz, u_xlat17.xyz);
                u_xlat5.y = dot(i.vs_TEXCOORD4.xyz, u_xlat17.xyz);
                u_xlat31 = _SpeclarHeight + -1.0;
                u_xlat31 = u_xlat31 * 0.899999976;
                u_xlat5.xy = vec2(u_xlat31) * u_xlat5.xy + i.vs_TEXCOORD0.xy;
                u_xlat5.xy = u_xlat5.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_5 = tex2D(_DetailMask, u_xlat5.xy);
                u_xlat16_31 = u_xlat10_5.x * u_xlat10_5.x;
                u_xlat16_31 = min(u_xlat16_31, 1.0);
                u_xlat34 = _SpecularPower * 256.0;
                u_xlat30 = u_xlat30 * u_xlat34;
                u_xlat30 = exp2(u_xlat30);
                u_xlat30 = u_xlat30 * 5.0 + -4.0;
                u_xlat31 = u_xlat30 * _SpecularPower + u_xlat16_31;
                u_xlat31 = clamp(u_xlat31, 0.0, 1.0);
                u_xlat30 = u_xlat30 * _SpecularPower;
                u_xlat30 = u_xlat30;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat30 = u_xlat30 * u_xlat10_2.x + (-u_xlat31);
                u_xlat16_2.xy = (-u_xlat10_2.zy) + vec2(1.0, 1.0);
                u_xlat30 = _notusetexspecular * u_xlat30 + u_xlat31;
                u_xlat4.xyz = u_xlat4.xyz + vec3(u_xlat30);
                u_xlatb30 = _ambientshadowG.y>=_ambientshadowG.z;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat5.xy = _ambientshadowG.yz;
                u_xlat5.z = float(0.0);
                u_xlat5.w = float(-0.333333343);
                u_xlat6.xy = _ambientshadowG.zy;
                u_xlat6.z = float(-1.0);
                u_xlat6.w = float(0.666666687);
                u_xlat5 = u_xlat5 + (-u_xlat6);
                u_xlat5 = vec4(u_xlat30) * u_xlat5.xywz + u_xlat6.xywz;
                u_xlatb30 = _ambientshadowG.x>=u_xlat5.x;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat6.z = u_xlat5.w;
                u_xlat5.w = _ambientshadowG.x;
                u_xlat6.xyw = u_xlat5.wyx;
                u_xlat6 = (-u_xlat5) + u_xlat6;
                u_xlat5 = vec4(u_xlat30) * u_xlat6 + u_xlat5;
                u_xlat30 = min(u_xlat5.y, u_xlat5.w);
                u_xlat30 = (-u_xlat30) + u_xlat5.x;
                u_xlat30 = u_xlat30 * 6.0 + 1.00000001e-10;
                u_xlat31 = (-u_xlat5.y) + u_xlat5.w;
                u_xlat30 = u_xlat31 / u_xlat30;
                u_xlat30 = u_xlat30 + u_xlat5.z;
                u_xlat5.xyz = abs(vec3(u_xlat30)) + vec3(0.0, -0.333333343, 0.333333343);
                u_xlat5.xyz = fract(u_xlat5.xyz);
                u_xlat5.xyz = (-u_xlat5.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat5.xyz = abs(u_xlat5.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
                u_xlat5.xyz = u_xlat5.xyz * vec3(0.400000006, 0.400000006, 0.400000006) + vec3(0.300000012, 0.300000012, 0.300000012);
                u_xlat30 = _rimpower * 9.0 + 1.0;
                u_xlat30 = u_xlat32 * u_xlat30;
                u_xlat30 = exp2(u_xlat30);
                u_xlat30 = u_xlat30 * 2.5 + -0.5;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat30 = u_xlat30 * _rimV;
                u_xlat16_31 = u_xlat16_2.x * 9.99999809 + -8.99999809;
                u_xlat30 = u_xlat30 * u_xlat16_31;
                u_xlat5.xyz = u_xlat5.xyz * vec3(u_xlat30);
                u_xlat5.xyz = u_xlat16_2.yyy * u_xlat5.xyz;
                u_xlat5.xyz = max(u_xlat5.xyz, vec3(0.0, 0.0, 0.0));
                u_xlat5.xyz = min(u_xlat5.xyz, vec3(0.5, 0.5, 0.5));
                u_xlat4.xyz = u_xlat4.xyz + u_xlat5.xyz;
                u_xlat5.xyz = _LightColor0.xyz * vec3(0.600000024, 0.600000024, 0.600000024) + vec3(0.400000006, 0.400000006, 0.400000006);
                u_xlat5.xyz = max(u_xlat5.xyz, _ambientshadowG.xyz);
                u_xlat4.xyz = u_xlat4.xyz * u_xlat5.xyz;
                u_xlat30 = _ShadowExtend * -1.20000005 + 1.0;
                u_xlat31 = (-u_xlat30) + 1.0;
                u_xlat30 = u_xlat16_2.y * u_xlat31 + u_xlat30;
                u_xlat16_31 = (-u_xlat16_2.x) + 1.0;
                u_xlat16_31 = (-u_xlat10_3.y) + u_xlat16_31;
                u_xlat31 = _DetailBLineG * u_xlat16_31 + u_xlat10_3.y;
                u_xlat1.xyz = vec3(u_xlat30) * u_xlat1.xyz + u_xlat3.xzw;
                u_xlat1.xyz = u_xlat1.xyz * u_xlat4.xyz;
                u_xlat2.xyz = (-u_xlat0.xyz) * u_xlat3.xzw + vec3(1.0, 1.0, 1.0);
                u_xlat0.xyz = u_xlat3.xzw * u_xlat0.xyz;
                u_xlat30 = _LineColorG.w + -0.5;
                u_xlat30 = (-u_xlat30) * 2.0 + 1.0;
                u_xlat2.xyz = (-vec3(u_xlat30)) * u_xlat2.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat30 = _LineColorG.w + _LineColorG.w;
                u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat30);
                u_xlatb30 = 0.5<_LineColorG.w;
                u_xlat0.xyz = (bool(u_xlatb30)) ? u_xlat2.xyz : u_xlat0.xyz;
                u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
                u_xlat0.xyz = (-u_xlat1.xyz) * u_xlat8.yyy + u_xlat0.xyz;
                u_xlat1.xyz = u_xlat8.yyy * u_xlat1.xyz;
                SV_Target0.xyz = vec3(u_xlat31) * u_xlat0.xyz + u_xlat1.xyz;
                return SV_Target0;
            }
            #endif
            ENDCG
        }
        UsePass "VertexLit/SHADOWCASTER"
    }
}
