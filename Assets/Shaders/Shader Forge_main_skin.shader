Shader "Shader Forge/main_skin" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" { }
        _overcolor1 ("Over Color1", Color) = (1,1,1,1)
        _overtex1 ("Over Tex1", 2D) = "black" { }
        _overcolor2 ("Over Color2", Color) = (1,1,1,1)
        _overtex2 ("Over Tex2", 2D) = "black" { }
        _overcolor3 ("Over Color3", Color) = (1,1,1,1)
        _overtex3 ("Over Tex3", 2D) = "black" { }
        _NormalMap ("Normal Map", 2D) = "bump" { }
        _NormalMapDetail ("Normal Map Detail", 2D) = "bump" { }
        _DetailMask ("Detail Mask", 2D) = "black" { }
        _LineMask ("Line Mask", 2D) = "black" { }
        _AlphaMask ("Alpha Mask", 2D) = "white" { }
        _ShadowColor ("Shadow Color", Color) = (0.628,0.628,0.628,1)
        _SpecularColor ("Specular Color", Color) = (1,1,1,0)
        _DetailNormalMapScale ("DetailNormalMapScale", Range(0, 1)) = 0
        _SpeclarHeight ("Speclar Height", Range(0, 1)) = 0.98
        _SpecularPower ("Specular Power", Range(0, 1)) = 0
        _SpecularPowerNail ("Specular Power Nail", Range(0, 1)) = 0
        _ShadowExtend ("Shadow Extend", Range(0, 1)) = 1
        _rimpower ("Rim Width", Range(0, 1)) = 0.5
        _rimV ("Rim Strength", Range(0, 1)) = 0
        _nipsize ("nipsize", Range(0, 1)) = 0.5
        [MaterialToggle] _alpha_a ("alpha_a", Float) = 1
        [MaterialToggle] _alpha_b ("alpha_b", Float) = 1
        [MaterialToggle] _linetexon ("Line Tex On", Float) = 1
        [MaterialToggle] _notusetexspecular ("not use tex specular", Float) = 0
        [MaterialToggle] _nip ("nip?", Float) = 0
        _liquidmask ("Liquid Mask", 2D) = "black" { }
        _Texture2 ("Liquid Tex", 2D) = "black" { }
        _Texture3 ("Liquid Normal", 2D) = "bump" { }
        _LiquidTiling ("Liquid Tiling (u/v/us/vs)", Vector) = (0,0,2,2)
        _liquidftop ("liquidftop", Range(0, 2)) = 0
        _liquidfbot ("liquidfbot", Range(0, 2)) = 0
        _liquidbtop ("liquidbtop", Range(0, 2)) = 0
        _liquidbbot ("liquidbbot", Range(0, 2)) = 0
        _liquidface ("liquidface", Range(0, 2)) = 0
        _nip_specular ("nip_specular", Range(0, 1)) = 0.5
        _tex1mask ("tex1 mask(1=yes)", Float) = 0
        _NormalMask ("NormalMask(G)", 2D) = "black" { }
        _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
    }
    SubShader {
        Tags {
            "QUEUE"="AlphaTest-100"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "OUTLINE"
            Tags {
                "QUEUE"="AlphaTest-100"
                "RenderType"="TransparentCutout"
                "SHADOWSUPPORT"="true"
            }
            LOD 600

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
                float2 in_TEXCOORD1 : TEXCOORD1;
                float2 in_TEXCOORD2 : TEXCOORD2;
                float2 in_TEXCOORD3 : TEXCOORD3;
                float4 in_COLOR0 : COLOR0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float2 vs_TEXCOORD1 : TEXCOORD1;
                float2 vs_TEXCOORD2 : TEXCOORD2;
                float2 vs_TEXCOORD3 : TEXCOORD3;
                float4 vs_TEXCOORD4 : TEXCOORD4;
                float4 vs_COLOR0 : COLOR0;
            };
            float _alpha_a;
            float _alpha_b;
            float _linewidthG;
            float _nip;
            float _nip_specular;
            float _nipsize;
            float _tex1mask;
            float3 u_xlatb2;
            float4 _AlphaMask_ST;
            float4 _ambientshadowG;
            float4 _DetailMask_ST;
            float4 _LineColorG;
            float4 _MainTex_ST;
            float4 _overcolor1;
            float4 _overcolor2;
            float4 _overcolor3;
            float4 _overtex1_ST;
            float4 _overtex2_ST;
            float4 _overtex3_ST;
            sampler2D _AlphaMask;
            sampler2D _DetailMask;
            sampler2D _MainTex;
            sampler2D _overtex1;
            sampler2D _overtex2;
            sampler2D _overtex3;
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float2 u_xlat3;
                u_xlat0 = unity_ObjectToWorld[1] * v.in_POSITION0.yyyy;
                u_xlat0 = unity_ObjectToWorld[0] * v.in_POSITION0.xxxx + u_xlat0;
                u_xlat0 = unity_ObjectToWorld[2] * v.in_POSITION0.zzzz + u_xlat0;
                u_xlat0 = unity_ObjectToWorld[3] * v.in_POSITION0.wwww + u_xlat0;
                u_xlat1.xyz = (-u_xlat0.xyz) + _WorldSpaceCameraPos.xyz;
                o.vs_TEXCOORD4 = u_xlat0;
                u_xlat0.x = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat0.x = sqrt(u_xlat0.x);
                u_xlat0.x = u_xlat0.x * 0.0999999866 + 0.300000012;
                u_xlat3.x = _linewidthG * 0.00499999989;
                u_xlat0.x = u_xlat0.x * u_xlat3.x;
                u_xlat3.xy = v.in_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat1 = textureLod(_DetailMask, u_xlat3.xy, 0.0);
                u_xlat3.x = (-u_xlat1.z) + 1.0;
                u_xlat0.x = u_xlat3.x * u_xlat0.x;
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
                o.vs_TEXCOORD1.xy = v.in_TEXCOORD1.xy;
                o.vs_TEXCOORD2.xy = v.in_TEXCOORD2.xy;
                o.vs_TEXCOORD3.xy = v.in_TEXCOORD3.xy;
                o.vs_COLOR0 = v.in_COLOR0;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                float3 u_xlat0;
                float4 u_xlat10_0;
                int u_xlatb0;
                float4 u_xlat1;
                float4 u_xlat10_1;
                float4 u_xlat2;
                float3 u_xlat3;
                float4 u_xlat4;
                float3 u_xlat5;
                float2 u_xlat6;
                float u_xlat7;
                float2 u_xlat12;
                float u_xlat18;
                float u_xlat16_18;
                int u_xlatb18;
                float u_xlat19;
                u_xlat0.xy = i.vs_TEXCOORD0.xy * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
                u_xlat10_0 = tex2D(_AlphaMask, u_xlat0.xy);
                u_xlat12.xy = (-vec2(_alpha_a, _alpha_b)) + vec2(1.0, 1.0);
                u_xlat0.xy = max(u_xlat12.xy, u_xlat10_0.xy);
                u_xlat0.x = min(u_xlat0.y, u_xlat0.x);
                u_xlat0.x = u_xlat0.x + -0.5;
                u_xlatb0 = u_xlat0.x<0.0;
                if(((int(u_xlatb0) * int(0xffffffffu)))!=0){discard;}
                u_xlat0.xy = i.vs_TEXCOORD1.xy + vec2(-0.5, -0.5);
                u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
                u_xlat0.x = sqrt(u_xlat0.x);
                u_xlat0.x = u_xlat0.x * 16.6666698 + -1.0;
                u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
                u_xlat6.xy = vec2(_nipsize) * vec2(-1.39999998, 0.699999988) + vec2(2.0, -0.5);
                u_xlat6.xy = i.vs_TEXCOORD1.xy * u_xlat6.xx + u_xlat6.yy;
                u_xlat6.xy = u_xlat6.xy + (-i.vs_TEXCOORD1.xy);
                u_xlat0.xy = u_xlat0.xx * u_xlat6.xy + i.vs_TEXCOORD1.xy;
                u_xlat12.xy = i.vs_TEXCOORD1.xy * i.vs_COLOR0.xx;
                u_xlat0.xy = u_xlat0.xy * i.vs_COLOR0.xx + (-u_xlat12.xy);
                u_xlat0.xy = vec2(vec2(_nip, _nip)) * u_xlat0.xy + u_xlat12.xy;
                u_xlat0.xy = u_xlat0.xy * _overtex1_ST.xy + _overtex1_ST.zw;
                u_xlat10_0 = tex2D(_overtex1, u_xlat0.xy);
                u_xlat1.x = u_xlat10_0.y * _nip_specular;
                u_xlat1.xyz = u_xlat1.xxx * vec3(0.330000013, 0.330000013, 0.330000013) + _overcolor1.xyz;
                u_xlat2 = u_xlat10_0 * _overcolor1;
                u_xlat0.xyz = u_xlat10_0.xxx * u_xlat1.xyz + (-u_xlat2.xyz);
                u_xlat18 = _tex1mask;
                u_xlat18 = clamp(u_xlat18, 0.0, 1.0);
                u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz + u_xlat2.xyz;
                u_xlat1.xy = i.vs_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                u_xlat10_1 = tex2D(_MainTex, u_xlat1.xy);
                u_xlat0.xyz = u_xlat0.xyz + (-u_xlat10_1.xyz);
                u_xlat0.xyz = u_xlat2.www * u_xlat0.xyz + u_xlat10_1.xyz;
                u_xlat1.xy = i.vs_TEXCOORD2.xy * i.vs_COLOR0.zz;
                u_xlat1.xy = u_xlat1.xy * _overtex2_ST.xy + _overtex2_ST.zw;
                u_xlat10_1 = tex2D(_overtex2, u_xlat1.xy);
                u_xlat1.xyz = _overcolor2.xyz * u_xlat10_1.xyz + (-u_xlat0.xyz);
                u_xlat18 = u_xlat10_1.w * _overcolor2.w;
                u_xlat0.xyz = vec3(u_xlat18) * u_xlat1.xyz + u_xlat0.xyz;
                u_xlat1.xy = i.vs_TEXCOORD3.xy * _overtex3_ST.xy + _overtex3_ST.zw;
                u_xlat10_1 = tex2D(_overtex3, u_xlat1.xy);
                u_xlat1.xyz = u_xlat10_1.xyz * _overcolor3.xyz + (-u_xlat0.xyz);
                u_xlat18 = u_xlat10_1.w * _overcolor3.w;
                u_xlat0.xyz = vec3(u_xlat18) * u_xlat1.xyz + u_xlat0.xyz;
                u_xlatb18 = u_xlat0.y>=u_xlat0.z;
                u_xlat18 = u_xlatb18 ? 1.0 : float(0.0);
                u_xlat1.xy = u_xlat0.zy;
                u_xlat2.xy = u_xlat0.yz + (-u_xlat1.xy);
                u_xlat1.z = float(-1.0);
                u_xlat1.w = float(0.666666687);
                u_xlat2.z = float(1.0);
                u_xlat2.w = float(-1.0);
                u_xlat1 = vec4(u_xlat18) * u_xlat2.xywz + u_xlat1.xywz;
                u_xlatb18 = u_xlat0.x>=u_xlat1.x;
                u_xlat18 = u_xlatb18 ? 1.0 : float(0.0);
                u_xlat2.z = u_xlat1.w;
                u_xlat1.w = u_xlat0.x;
                u_xlat0.xyz = u_xlat0.xyz * _LineColorG.xyz;
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
                u_xlat18 = u_xlat18 * 0.660000026;
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
                u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
                u_xlat1.xy = i.vs_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_1 = tex2D(_DetailMask, u_xlat1.xy);
                u_xlat16_18 = (-u_xlat10_1.y) + 1.0;
                u_xlat16_18 = u_xlat16_18 * 0.5 + 0.5;
                u_xlat1.xyz = (-u_xlat0.xyz) * vec3(u_xlat16_18) + vec3(1.0, 1.0, 1.0);
                u_xlat0.xyz = vec3(u_xlat16_18) * u_xlat0.xyz;
                u_xlat18 = _LineColorG.w + -0.5;
                u_xlat18 = (-u_xlat18) * 2.0 + 1.0;
                u_xlat1.xyz = (-vec3(u_xlat18)) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat18 = _LineColorG.w + _LineColorG.w;
                u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat18);
                u_xlatb18 = 0.5<_LineColorG.w;
                u_xlat0.xyz = (bool(u_xlatb18)) ? u_xlat1.xyz : u_xlat0.xyz;
                u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
                u_xlat1.xyz = _LightColor0.xyz * vec3(0.600000024, 0.600000024, 0.600000024) + vec3(0.400000006, 0.400000006, 0.400000006);
                SV_Target0.xyz = u_xlat0.xyz * u_xlat1.xyz;
                SV_Target0.w = 0.0;
                return SV_Target0;
            }
            #elif defined (SHADOWS_CUBE)
            struct VertexInput {
                float4 in_POSITION0 : POSITION0;
                float3 in_NORMAL0 : NORMAL0;
                float2 in_TEXCOORD0 : TEXCOORD0;
                float2 in_TEXCOORD1 : TEXCOORD1;
                float2 in_TEXCOORD2 : TEXCOORD2;
                float2 in_TEXCOORD3 : TEXCOORD3;
                float4 in_COLOR0 : COLOR0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float2 vs_TEXCOORD1 : TEXCOORD1;
                float2 vs_TEXCOORD2 : TEXCOORD2;
                float2 vs_TEXCOORD3 : TEXCOORD3;
                float4 vs_TEXCOORD4 : TEXCOORD4;
                float4 vs_COLOR0 : COLOR0;
            };
            float _alpha_a;
            float _alpha_b;
            float _linewidthG;
            float _nip;
            float _nip_specular;
            float _nipsize;
            float _tex1mask;
            float3 u_xlatb2;
            float4 _AlphaMask_ST;
            float4 _ambientshadowG;
            float4 _DetailMask_ST;
            float4 _LineColorG;
            float4 _MainTex_ST;
            float4 _overcolor1;
            float4 _overcolor2;
            float4 _overcolor3;
            float4 _overtex1_ST;
            float4 _overtex2_ST;
            float4 _overtex3_ST;
            sampler2D _AlphaMask;
            sampler2D _DetailMask;
            sampler2D _MainTex;
            sampler2D _overtex1;
            sampler2D _overtex2;
            sampler2D _overtex3;
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float2 u_xlat3;
                u_xlat0 = unity_ObjectToWorld[1] * v.in_POSITION0.yyyy;
                u_xlat0 = unity_ObjectToWorld[0] * v.in_POSITION0.xxxx + u_xlat0;
                u_xlat0 = unity_ObjectToWorld[2] * v.in_POSITION0.zzzz + u_xlat0;
                u_xlat0 = unity_ObjectToWorld[3] * v.in_POSITION0.wwww + u_xlat0;
                u_xlat1.xyz = (-u_xlat0.xyz) + _WorldSpaceCameraPos.xyz;
                o.vs_TEXCOORD4 = u_xlat0;
                u_xlat0.x = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat0.x = sqrt(u_xlat0.x);
                u_xlat0.x = u_xlat0.x * 0.0999999866 + 0.300000012;
                u_xlat3.x = _linewidthG * 0.00499999989;
                u_xlat0.x = u_xlat0.x * u_xlat3.x;
                u_xlat3.xy = v.in_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat1 = textureLod(_DetailMask, u_xlat3.xy, 0.0);
                u_xlat3.x = (-u_xlat1.z) + 1.0;
                u_xlat0.x = u_xlat3.x * u_xlat0.x;
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
                o.vs_TEXCOORD1.xy = v.in_TEXCOORD1.xy;
                o.vs_TEXCOORD2.xy = v.in_TEXCOORD2.xy;
                o.vs_TEXCOORD3.xy = v.in_TEXCOORD3.xy;
                o.vs_COLOR0 = v.in_COLOR0;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                float3 u_xlat0;
                float4 u_xlat10_0;
                int u_xlatb0;
                float4 u_xlat1;
                float4 u_xlat10_1;
                float4 u_xlat2;
                float3 u_xlat3;
                float4 u_xlat4;
                float3 u_xlat5;
                float2 u_xlat6;
                float u_xlat7;
                float2 u_xlat12;
                float u_xlat18;
                float u_xlat16_18;
                int u_xlatb18;
                float u_xlat19;
                u_xlat0.xy = i.vs_TEXCOORD0.xy * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
                u_xlat10_0 = tex2D(_AlphaMask, u_xlat0.xy);
                u_xlat12.xy = (-vec2(_alpha_a, _alpha_b)) + vec2(1.0, 1.0);
                u_xlat0.xy = max(u_xlat12.xy, u_xlat10_0.xy);
                u_xlat0.x = min(u_xlat0.y, u_xlat0.x);
                u_xlat0.x = u_xlat0.x + -0.5;
                u_xlatb0 = u_xlat0.x<0.0;
                if(((int(u_xlatb0) * int(0xffffffffu)))!=0){discard;}
                u_xlat0.xy = i.vs_TEXCOORD1.xy + vec2(-0.5, -0.5);
                u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
                u_xlat0.x = sqrt(u_xlat0.x);
                u_xlat0.x = u_xlat0.x * 16.6666698 + -1.0;
                u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
                u_xlat6.xy = vec2(_nipsize) * vec2(-1.39999998, 0.699999988) + vec2(2.0, -0.5);
                u_xlat6.xy = i.vs_TEXCOORD1.xy * u_xlat6.xx + u_xlat6.yy;
                u_xlat6.xy = u_xlat6.xy + (-i.vs_TEXCOORD1.xy);
                u_xlat0.xy = u_xlat0.xx * u_xlat6.xy + i.vs_TEXCOORD1.xy;
                u_xlat12.xy = i.vs_TEXCOORD1.xy * i.vs_COLOR0.xx;
                u_xlat0.xy = u_xlat0.xy * i.vs_COLOR0.xx + (-u_xlat12.xy);
                u_xlat0.xy = vec2(vec2(_nip, _nip)) * u_xlat0.xy + u_xlat12.xy;
                u_xlat0.xy = u_xlat0.xy * _overtex1_ST.xy + _overtex1_ST.zw;
                u_xlat10_0 = tex2D(_overtex1, u_xlat0.xy);
                u_xlat1.x = u_xlat10_0.y * _nip_specular;
                u_xlat1.xyz = u_xlat1.xxx * vec3(0.330000013, 0.330000013, 0.330000013) + _overcolor1.xyz;
                u_xlat2 = u_xlat10_0 * _overcolor1;
                u_xlat0.xyz = u_xlat10_0.xxx * u_xlat1.xyz + (-u_xlat2.xyz);
                u_xlat18 = _tex1mask;
                u_xlat18 = clamp(u_xlat18, 0.0, 1.0);
                u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz + u_xlat2.xyz;
                u_xlat1.xy = i.vs_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                u_xlat10_1 = tex2D(_MainTex, u_xlat1.xy);
                u_xlat0.xyz = u_xlat0.xyz + (-u_xlat10_1.xyz);
                u_xlat0.xyz = u_xlat2.www * u_xlat0.xyz + u_xlat10_1.xyz;
                u_xlat1.xy = i.vs_TEXCOORD2.xy * i.vs_COLOR0.zz;
                u_xlat1.xy = u_xlat1.xy * _overtex2_ST.xy + _overtex2_ST.zw;
                u_xlat10_1 = tex2D(_overtex2, u_xlat1.xy);
                u_xlat1.xyz = _overcolor2.xyz * u_xlat10_1.xyz + (-u_xlat0.xyz);
                u_xlat18 = u_xlat10_1.w * _overcolor2.w;
                u_xlat0.xyz = vec3(u_xlat18) * u_xlat1.xyz + u_xlat0.xyz;
                u_xlat1.xy = i.vs_TEXCOORD3.xy * _overtex3_ST.xy + _overtex3_ST.zw;
                u_xlat10_1 = tex2D(_overtex3, u_xlat1.xy);
                u_xlat1.xyz = u_xlat10_1.xyz * _overcolor3.xyz + (-u_xlat0.xyz);
                u_xlat18 = u_xlat10_1.w * _overcolor3.w;
                u_xlat0.xyz = vec3(u_xlat18) * u_xlat1.xyz + u_xlat0.xyz;
                u_xlatb18 = u_xlat0.y>=u_xlat0.z;
                u_xlat18 = u_xlatb18 ? 1.0 : float(0.0);
                u_xlat1.xy = u_xlat0.zy;
                u_xlat2.xy = u_xlat0.yz + (-u_xlat1.xy);
                u_xlat1.z = float(-1.0);
                u_xlat1.w = float(0.666666687);
                u_xlat2.z = float(1.0);
                u_xlat2.w = float(-1.0);
                u_xlat1 = vec4(u_xlat18) * u_xlat2.xywz + u_xlat1.xywz;
                u_xlatb18 = u_xlat0.x>=u_xlat1.x;
                u_xlat18 = u_xlatb18 ? 1.0 : float(0.0);
                u_xlat2.z = u_xlat1.w;
                u_xlat1.w = u_xlat0.x;
                u_xlat0.xyz = u_xlat0.xyz * _LineColorG.xyz;
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
                u_xlat18 = u_xlat18 * 0.660000026;
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
                u_xlat0.xyz = u_xlat0.xyz * u_xlat1.xyz;
                u_xlat1.xy = i.vs_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_1 = tex2D(_DetailMask, u_xlat1.xy);
                u_xlat16_18 = (-u_xlat10_1.y) + 1.0;
                u_xlat16_18 = u_xlat16_18 * 0.5 + 0.5;
                u_xlat1.xyz = (-u_xlat0.xyz) * vec3(u_xlat16_18) + vec3(1.0, 1.0, 1.0);
                u_xlat0.xyz = vec3(u_xlat16_18) * u_xlat0.xyz;
                u_xlat18 = _LineColorG.w + -0.5;
                u_xlat18 = (-u_xlat18) * 2.0 + 1.0;
                u_xlat1.xyz = (-vec3(u_xlat18)) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat18 = _LineColorG.w + _LineColorG.w;
                u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat18);
                u_xlatb18 = 0.5<_LineColorG.w;
                u_xlat0.xyz = (bool(u_xlatb18)) ? u_xlat1.xyz : u_xlat0.xyz;
                u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
                u_xlat1.xyz = _LightColor0.xyz * vec3(0.600000024, 0.600000024, 0.600000024) + vec3(0.400000006, 0.400000006, 0.400000006);
                SV_Target0.xyz = u_xlat0.xyz * u_xlat1.xyz;
                SV_Target0.w = 0.0;
                return SV_Target0;
            }
            #endif
            ENDCG
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LIGHTMODE"="FORWARDBASE"
                "QUEUE"="AlphaTest-100"
                "RenderType"="TransparentCutout"
                "SHADOWSUPPORT"="true"
            }
            LOD 600

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
                float2 in_TEXCOORD1 : TEXCOORD1;
                float2 in_TEXCOORD2 : TEXCOORD2;
                float2 in_TEXCOORD3 : TEXCOORD3;
                float4 in_COLOR0 : COLOR0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float2 vs_TEXCOORD1 : TEXCOORD1;
                float2 vs_TEXCOORD2 : TEXCOORD2;
                float2 vs_TEXCOORD3 : TEXCOORD3;
                float4 vs_TEXCOORD4 : TEXCOORD4;
                float3 vs_TEXCOORD5 : TEXCOORD5;
                float3 vs_TEXCOORD6 : TEXCOORD6;
                float3 vs_TEXCOORD7 : TEXCOORD7;
                float4 vs_COLOR0 : COLOR0;
                float4 vs_TEXCOORD8 : TEXCOORD8;
            };
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float3 u_xlat3;
                float u_xlat13;

                u_xlat0 = float4(mul(unity_ObjectToWorld, v.in_POSITION0).xyz, 0);
                u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
                o.vs_TEXCOORD4 = unity_ObjectToWorld[3] * v.in_POSITION0.wwww + u_xlat0;

                u_xlat0 = mul(unity_MatrixVP, u_xlat1);
                gl_Position = u_xlat0;

                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                o.vs_TEXCOORD1.xy = v.in_TEXCOORD1.xy;
                o.vs_TEXCOORD2.xy = v.in_TEXCOORD2.xy;
                o.vs_TEXCOORD3.xy = v.in_TEXCOORD3.xy;
                u_xlat1.x = dot(v.in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
                u_xlat1.y = dot(v.in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
                u_xlat1.z = dot(v.in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
                u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
                o.vs_TEXCOORD5.xyz = u_xlat1.xyz;
                u_xlat2.xyz = unity_ObjectToWorld[1].xyz * v.in_TANGENT0.yyy;
                u_xlat2.xyz = unity_ObjectToWorld[0].xyz * v.in_TANGENT0.xxx + u_xlat2.xyz;
                u_xlat2.xyz = unity_ObjectToWorld[2].xyz * v.in_TANGENT0.zzz + u_xlat2.xyz;
                u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
                o.vs_TEXCOORD6.xyz = u_xlat2.xyz;
                u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
                u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
                u_xlat1.xyz = u_xlat1.xyz * v.in_TANGENT0.www;
                u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                o.vs_TEXCOORD7.xyz = vec3(u_xlat13) * u_xlat1.xyz;
                o.vs_COLOR0 = v.in_COLOR0;
                u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
                u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
                o.vs_TEXCOORD8.zw = u_xlat0.zw;
                o.vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
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
                float2 in_TEXCOORD1 : TEXCOORD1;
                float2 in_TEXCOORD2 : TEXCOORD2;
                float2 in_TEXCOORD3 : TEXCOORD3;
                float4 in_COLOR0 : COLOR0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float2 vs_TEXCOORD1 : TEXCOORD1;
                float2 vs_TEXCOORD2 : TEXCOORD2;
                float2 vs_TEXCOORD3 : TEXCOORD3;
                float4 vs_TEXCOORD4 : TEXCOORD4;
                float3 vs_TEXCOORD5 : TEXCOORD5;
                float3 vs_TEXCOORD6 : TEXCOORD6;
                float3 vs_TEXCOORD7 : TEXCOORD7;
                float4 vs_COLOR0 : COLOR0;
                float4 vs_TEXCOORD8 : TEXCOORD8;
            };
            float _alpha_a;
            float _alpha_b;
            float _DetailNormalMapScale;
            float _FaceNormalG;
            float _FaceShadowG;
            float _linetexon;
            float _linewidthG;
            float _liquidbbot;
            float _liquidbtop;
            float _liquidface;
            float _liquidfbot;
            float _liquidftop;
            float _nip;
            float _nip_specular;
            float _nipsize;
            float _notusetexspecular;
            float _rimpower;
            float _rimV;
            float _ShadowExtend;
            float _SpeclarHeight;
            float _SpecularPower;
            float _SpecularPowerNail;
            float _tex1mask;
            float3 u_xlatb13;
            float4 _AlphaMask_ST;
            float4 _ambientshadowG;
            float4 _DetailMask_ST;
            float4 _LineColorG;
            float4 _LineMask_ST;
            float4 _liquidmask_ST;
            float4 _LiquidTiling;
            float4 _MainTex_ST;
            float4 _NormalMap_ST;
            float4 _NormalMapDetail_ST;
            float4 _NormalMask_ST;
            float4 _overcolor1;
            float4 _overcolor2;
            float4 _overcolor3;
            float4 _overtex1_ST;
            float4 _overtex2_ST;
            float4 _overtex3_ST;
            float4 _RampG_ST;
            float4 _SpecularColor;
            float4 _Texture2_ST;
            float4 _Texture3_ST;
            sampler2D _AlphaMask;
            sampler2D _DetailMask;
            sampler2D _LineMask;
            sampler2D _liquidmask;
            sampler2D _MainTex;
            sampler2D _NormalMap;
            sampler2D _NormalMapDetail;
            sampler2D _NormalMask;
            sampler2D _overtex1;
            sampler2D _overtex2;
            sampler2D _overtex3;
            sampler2D _RampG;
            sampler2D _ShadowMapTexture;
            sampler2D _Texture2;
            sampler2D _Texture3;
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float3 u_xlat3;
                float u_xlat13;

                u_xlat0 = float4(mul(unity_ObjectToWorld, v.in_POSITION0).xyz, 0);
                u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
                o.vs_TEXCOORD4 = unity_ObjectToWorld[3] * v.in_POSITION0.wwww + u_xlat0;

                u_xlat0 = mul(unity_MatrixVP, u_xlat1);
                gl_Position = u_xlat0;
                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                o.vs_TEXCOORD1.xy = v.in_TEXCOORD1.xy;
                o.vs_TEXCOORD2.xy = v.in_TEXCOORD2.xy;
                o.vs_TEXCOORD3.xy = v.in_TEXCOORD3.xy;
                u_xlat1.x = dot(v.in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
                u_xlat1.y = dot(v.in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
                u_xlat1.z = dot(v.in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
                u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                u_xlat1.xyz = vec3(u_xlat13) * u_xlat1.xyz;
                o.vs_TEXCOORD5.xyz = u_xlat1.xyz;
                u_xlat2.xyz = unity_ObjectToWorld[1].xyz * v.in_TANGENT0.yyy;
                u_xlat2.xyz = unity_ObjectToWorld[0].xyz * v.in_TANGENT0.xxx + u_xlat2.xyz;
                u_xlat2.xyz = unity_ObjectToWorld[2].xyz * v.in_TANGENT0.zzz + u_xlat2.xyz;
                u_xlat13 = dot(u_xlat2.xyz, u_xlat2.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
                o.vs_TEXCOORD6.xyz = u_xlat2.xyz;
                u_xlat3.xyz = u_xlat1.zxy * u_xlat2.yzx;
                u_xlat1.xyz = u_xlat1.yzx * u_xlat2.zxy + (-u_xlat3.xyz);
                u_xlat1.xyz = u_xlat1.xyz * v.in_TANGENT0.www;
                u_xlat13 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat13 = inversesqrt(u_xlat13);
                o.vs_TEXCOORD7.xyz = vec3(u_xlat13) * u_xlat1.xyz;
                o.vs_COLOR0 = v.in_COLOR0;
                u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
                u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
                o.vs_TEXCOORD8.zw = u_xlat0.zw;
                o.vs_TEXCOORD8.xy = u_xlat1.zz + u_xlat1.xw;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                float3 u_xlat0;
                float4 u_xlat10_0;
                int u_xlatb0;
                float4 u_xlat1;
                float4 u_xlat10_1;
                float4 u_xlat2;
                float4 u_xlat3;
                float4 u_xlat10_3;
                float4 u_xlat4;
                float2 u_xlat16_4;
                float3 u_xlat5;
                float3 u_xlat16_5;
                float4 u_xlat10_5;
                float4 u_xlat6;
                float4 u_xlat10_6;
                int u_xlatb6;
                float3 u_xlat7;
                float3 u_xlat16_7;
                float4 u_xlat8;
                float3 u_xlat16_8;
                float4 u_xlat10_8;
                float4 u_xlat9;
                float4 u_xlat10_9;
                float2 u_xlat10;
                float u_xlat11;
                float3 u_xlat13;
                float3 u_xlat14;
                float u_xlat16_14;
                float2 u_xlat20;
                float u_xlat16_24;
                float2 u_xlat25;
                float u_xlat26;
                float u_xlat30;
                float u_xlat16_30;
                int u_xlatb30;
                float u_xlat31;
                float u_xlat16_31;
                float u_xlat32;
                float u_xlat33;
                float u_xlat16_33;
                float u_xlat34;
                float u_xlat35;
                u_xlat0.xy = i.vs_TEXCOORD0.xy * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
                u_xlat10_0 = tex2D(_AlphaMask, u_xlat0.xy);
                u_xlat20.xy = (-vec2(_alpha_a, _alpha_b)) + vec2(1.0, 1.0);
                u_xlat0.xy = max(u_xlat20.xy, u_xlat10_0.xy);
                u_xlat0.x = min(u_xlat0.y, u_xlat0.x);
                u_xlat0.x = u_xlat0.x + -0.5;
                u_xlatb0 = u_xlat0.x<0.0;
                if(((int(u_xlatb0) * int(0xffffffffu)))!=0){discard;}
                u_xlat0.xy = i.vs_TEXCOORD1.xy + vec2(-0.5, -0.5);
                u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
                u_xlat0.x = sqrt(u_xlat0.x);
                u_xlat0.x = u_xlat0.x * 16.6666698 + -1.0;
                u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
                u_xlat10.xy = vec2(vec2(_nipsize, _nipsize)) * vec2(-1.39999998, 0.699999988) + vec2(2.0, -0.5);
                u_xlat10.xy = i.vs_TEXCOORD1.xy * u_xlat10.xx + u_xlat10.yy;
                u_xlat10.xy = u_xlat10.xy + (-i.vs_TEXCOORD1.xy);
                u_xlat0.xy = u_xlat0.xx * u_xlat10.xy + i.vs_TEXCOORD1.xy;
                u_xlat20.xy = i.vs_TEXCOORD1.xy * i.vs_COLOR0.xx;
                u_xlat0.xy = u_xlat0.xy * i.vs_COLOR0.xx + (-u_xlat20.xy);
                u_xlat0.xy = vec2(vec2(_nip, _nip)) * u_xlat0.xy + u_xlat20.xy;
                u_xlat0.xy = u_xlat0.xy * _overtex1_ST.xy + _overtex1_ST.zw;
                u_xlat10_0 = tex2D(_overtex1, u_xlat0.xy);
                u_xlat1.x = u_xlat10_0.y * _nip_specular;
                u_xlat1.xyz = u_xlat1.xxx * vec3(0.330000013, 0.330000013, 0.330000013) + _overcolor1.xyz;
                u_xlat2 = u_xlat10_0 * _overcolor1;
                u_xlat0.xyz = u_xlat10_0.xxx * u_xlat1.xyz + (-u_xlat2.xyz);
                u_xlat30 = _tex1mask;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat0.xyz = vec3(u_xlat30) * u_xlat0.xyz + u_xlat2.xyz;
                u_xlat1.xy = i.vs_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                u_xlat10_1 = tex2D(_MainTex, u_xlat1.xy);
                u_xlat0.xyz = u_xlat0.xyz + (-u_xlat10_1.xyz);
                u_xlat0.xyz = u_xlat2.www * u_xlat0.xyz + u_xlat10_1.xyz;
                u_xlat1.xy = i.vs_TEXCOORD2.xy * i.vs_COLOR0.zz;
                u_xlat1.xy = u_xlat1.xy * _overtex2_ST.xy + _overtex2_ST.zw;
                u_xlat10_1 = tex2D(_overtex2, u_xlat1.xy);
                u_xlat1.xyz = _overcolor2.xyz * u_xlat10_1.xyz + (-u_xlat0.xyz);
                u_xlat30 = u_xlat10_1.w * _overcolor2.w;
                u_xlat0.xyz = vec3(u_xlat30) * u_xlat1.xyz + u_xlat0.xyz;
                u_xlat1.xy = i.vs_TEXCOORD3.xy * _overtex3_ST.xy + _overtex3_ST.zw;
                u_xlat10_1 = tex2D(_overtex3, u_xlat1.xy);
                u_xlat1.xyz = u_xlat10_1.xyz * _overcolor3.xyz + (-u_xlat0.xyz);
                u_xlat30 = u_xlat10_1.w * _overcolor3.w;
                u_xlat0.xyz = vec3(u_xlat30) * u_xlat1.xyz + u_xlat0.xyz;
                u_xlatb30 = u_xlat0.y>=u_xlat0.z;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat1.xy = u_xlat0.zy;
                u_xlat2.xy = u_xlat0.yz + (-u_xlat1.xy);
                u_xlat1.z = float(-1.0);
                u_xlat1.w = float(0.666666687);
                u_xlat2.z = float(1.0);
                u_xlat2.w = float(-1.0);
                u_xlat1 = vec4(u_xlat30) * u_xlat2.xywz + u_xlat1.xywz;
                u_xlatb30 = u_xlat0.x>=u_xlat1.x;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat2.z = u_xlat1.w;
                u_xlat1.w = u_xlat0.x;
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
                u_xlat30 = u_xlat30 * 0.660000026;
                u_xlat1.xzw = abs(vec3(u_xlat11)) + vec3(-0.0799999982, -0.413333356, 0.25333333);
                u_xlat2.xyz = abs(vec3(u_xlat11)) + vec3(0.0, -0.333333343, 0.333333343);
                u_xlat2.xyz = fract(u_xlat2.xyz);
                u_xlat2.xyz = (-u_xlat2.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat2.xyz = abs(u_xlat2.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
                u_xlat2.xyz = u_xlat2.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat2.xyz = vec3(u_xlat30) * u_xlat2.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = fract(u_xlat1.xzw);
                u_xlat1.xyz = (-u_xlat1.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = abs(u_xlat1.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = u_xlat1.xyz * vec3(0.400000006, 0.400000006, 0.400000006) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz * vec3(0.970000029, 0.970000029, 0.970000029) + vec3(-1.0, -1.0, -1.0);
                u_xlat3.xy = i.vs_TEXCOORD0.xy * _NormalMapDetail_ST.xy + _NormalMapDetail_ST.zw;
                u_xlat10_3 = tex2D(_NormalMapDetail, u_xlat3.xy);
                u_xlat3.xy = u_xlat10_3.wy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
                u_xlat30 = dot(u_xlat3.xy, u_xlat3.xy);
                u_xlat30 = min(u_xlat30, 1.0);
                u_xlat30 = (-u_xlat30) + 1.0;
                u_xlat3.z = sqrt(u_xlat30);
                u_xlat4.xyz = u_xlat3.xyz * vec3(-1.0, -1.0, 1.0);
                u_xlat5.xy = i.vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
                u_xlat10_5 = tex2D(_NormalMap, u_xlat5.xy);
                u_xlat16_5.xz = u_xlat10_5.wy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
                u_xlat6.xy = u_xlat10_5.wy + u_xlat10_5.wy;
                u_xlat16_30 = dot(u_xlat16_5.xz, u_xlat16_5.xz);
                u_xlat16_30 = min(u_xlat16_30, 1.0);
                u_xlat16_30 = (-u_xlat16_30) + 1.0;
                u_xlat6.z = sqrt(u_xlat16_30);
                u_xlat5.xyz = u_xlat6.xyz + vec3(-1.0, -1.0, 1.0);
                u_xlat6.xyz = u_xlat6.xyz + vec3(-1.0, -1.0, 0.0);
                u_xlat30 = dot(u_xlat5.xyz, u_xlat4.xyz);
                u_xlat4.xyz = vec3(u_xlat30) * u_xlat5.xyz;
                u_xlat4.xyz = u_xlat4.xyz / u_xlat5.zzz;
                u_xlat3.xyz = (-u_xlat3.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat4.xyz;
                u_xlat3.xyz = (-u_xlat6.xyz) + u_xlat3.xyz;
                u_xlat3.xyz = vec3(_DetailNormalMapScale) * u_xlat3.xyz + u_xlat6.xyz;
                u_xlat4.xyz = u_xlat3.xyz + vec3(0.0, 0.0, 1.0);
                u_xlat5.xy = i.vs_TEXCOORD0.xy * _LiquidTiling.zw + _LiquidTiling.xy;
                u_xlat25.xy = u_xlat5.xy * _Texture3_ST.xy + _Texture3_ST.zw;
                u_xlat5.xy = u_xlat5.xy * _Texture2_ST.xy + _Texture2_ST.zw;
                u_xlat10_6 = tex2D(_Texture2, u_xlat5.xy);
                u_xlat10_5 = tex2D(_Texture3, u_xlat25.xy);
                u_xlat5.xy = u_xlat10_5.wy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
                u_xlat30 = dot(u_xlat5.xy, u_xlat5.xy);
                u_xlat30 = min(u_xlat30, 1.0);
                u_xlat30 = (-u_xlat30) + 1.0;
                u_xlat5.z = sqrt(u_xlat30);
                u_xlat7.xyz = u_xlat5.xyz * vec3(-1.0, -1.0, 1.0);
                u_xlat30 = dot(u_xlat4.xyz, u_xlat7.xyz);
                u_xlat4.xyw = vec3(u_xlat30) * u_xlat4.xyz;
                u_xlat4.xyz = u_xlat4.xyw / u_xlat4.zzz;
                u_xlat4.xyz = (-u_xlat5.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat4.xyz;
                u_xlat4.xyz = (-u_xlat3.xyz) + u_xlat4.xyz;
                u_xlat30 = _liquidftop + -1.0;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat30 = u_xlat30 * u_xlat10_6.y;
                u_xlat31 = _liquidftop;
                u_xlat31 = clamp(u_xlat31, 0.0, 1.0);
                u_xlat31 = u_xlat31 * u_xlat10_6.x;
                u_xlat30 = max(u_xlat30, u_xlat31);
                u_xlat5.xy = i.vs_TEXCOORD0.xy * _liquidmask_ST.xy + _liquidmask_ST.zw;
                u_xlat10_5 = tex2D(_liquidmask, u_xlat5.xy);
                u_xlat16_7.xyz = max(u_xlat10_5.zzy, u_xlat10_5.yxx);
                u_xlat16_7.xyz = u_xlat10_5.xyz + (-u_xlat16_7.xyz);
                u_xlat16_5.xy = min(u_xlat10_5.yz, u_xlat10_5.xy);
                u_xlat16_5.xy = u_xlat16_5.xy * vec2(1.11111104, 1.11111104) + vec2(-0.111111097, -0.111111097);
                u_xlat30 = min(u_xlat30, u_xlat16_7.x);
                u_xlat8 = vec4(_liquidfbot, _liquidbtop, _liquidbbot, _liquidface) + vec4(-1.0, -1.0, -1.0, -1.0);
                u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
                u_xlat8 = u_xlat10_6.yyyy * u_xlat8;
                u_xlat9 = vec4(_liquidfbot, _liquidbtop, _liquidbbot, _liquidface);
                u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
                u_xlat6 = u_xlat10_6.xxxx * u_xlat9;
                u_xlat6 = max(u_xlat6, u_xlat8);
                u_xlat25.xy = min(u_xlat16_7.yz, u_xlat6.xy);
                u_xlat5.xy = min(u_xlat16_5.xy, u_xlat6.zw);
                u_xlat30 = max(u_xlat30, u_xlat25.x);
                u_xlat30 = max(u_xlat25.y, u_xlat30);
                u_xlat30 = max(u_xlat5.x, u_xlat30);
                u_xlat30 = max(u_xlat5.y, u_xlat30);
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat3.xyz = vec3(u_xlat30) * u_xlat4.xyz + u_xlat3.xyz;
                u_xlat4.xyz = u_xlat3.yyy * i.vs_TEXCOORD7.xyz;
                u_xlat3.xyw = u_xlat3.xxx * i.vs_TEXCOORD6.xyz + u_xlat4.xyz;
                u_xlat31 = dot(i.vs_TEXCOORD5.xyz, i.vs_TEXCOORD5.xyz);
                u_xlat31 = inversesqrt(u_xlat31);
                u_xlat4.xyz = vec3(u_xlat31) * i.vs_TEXCOORD5.xyz;
                u_xlat31 = ((gl_FrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
                u_xlat4.xyz = vec3(u_xlat31) * u_xlat4.xyz;
                u_xlat3.xyz = u_xlat3.zzz * u_xlat4.xyz + u_xlat3.xyw;
                u_xlat31 = dot(u_xlat3.xyz, u_xlat3.xyz);
                u_xlat31 = inversesqrt(u_xlat31);
                u_xlat3.xyz = vec3(u_xlat31) * u_xlat3.xyz;
                u_xlat4.xyz = (-i.vs_TEXCOORD4.xyz) + _WorldSpaceCameraPos.xyz;
                u_xlat31 = dot(u_xlat4.xyz, u_xlat4.xyz);
                u_xlat31 = inversesqrt(u_xlat31);
                u_xlat5.xyz = u_xlat4.xyz * vec3(u_xlat31) + (-u_xlat3.xyz);
                u_xlat6.xy = i.vs_TEXCOORD0.xy * _NormalMask_ST.xy + _NormalMask_ST.zw;
                u_xlat10_6 = tex2D(_NormalMask, u_xlat6.xy);
                u_xlat6.xy = u_xlat10_6.yz * vec2(_FaceNormalG, _FaceShadowG);
                u_xlat5.xyz = u_xlat6.xxx * u_xlat5.xyz + u_xlat3.xyz;
                u_xlat32 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                u_xlat32 = inversesqrt(u_xlat32);
                u_xlat6.xzw = vec3(u_xlat32) * _WorldSpaceLightPos0.xyz;
                u_xlat32 = dot(u_xlat6.xzw, u_xlat5.xyz);
                u_xlat5.xyz = u_xlat4.xyz * vec3(u_xlat31) + u_xlat6.xzw;
                u_xlat4.xyz = vec3(u_xlat31) * u_xlat4.xyz;
                u_xlat31 = max(u_xlat32, 0.0);
                u_xlat6.xz = vec2(u_xlat31) * _RampG_ST.xy + _RampG_ST.zw;
                u_xlat31 = u_xlat31 + 0.5;
                u_xlat7.xyz = vec3(u_xlat31) * vec3(0.149999976, 0.199999988, 0.300000012) + vec3(0.850000024, 0.800000012, 0.699999988);
                u_xlat10_8 = tex2D(_RampG, u_xlat6.xz);
                u_xlat6.xz = i.vs_TEXCOORD8.xy / i.vs_TEXCOORD8.ww;
                u_xlat10_9 = tex2D(_ShadowMapTexture, u_xlat6.xz);
                u_xlat16_31 = u_xlat10_9.x * 2.0 + -1.0;
                u_xlat16_31 = clamp(u_xlat16_31, 0.0, 1.0);
                u_xlat31 = max(u_xlat6.y, u_xlat16_31);
                u_xlat31 = u_xlat31 * u_xlat10_8.x;
                u_xlat32 = _ShadowExtend * -1.20000005 + 1.0;
                u_xlat33 = (-u_xlat32) + 1.0;
                u_xlat6.xy = i.vs_TEXCOORD0.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_6 = tex2D(_LineMask, u_xlat6.xy);
                u_xlat6.xz = (-u_xlat10_6.zx) * vec2(_DetailNormalMapScale) + vec2(1.0, 1.0);
                u_xlat8.xy = i.vs_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_8 = tex2D(_DetailMask, u_xlat8.xy);
                u_xlat16_8.xyz = (-u_xlat10_8.ywz) + vec3(1.0, 1.0, 1.0);
                u_xlat34 = min(u_xlat6.x, u_xlat16_8.x);
                u_xlat35 = u_xlat6.z * 0.5 + 0.5;
                u_xlat32 = u_xlat34 * u_xlat33 + u_xlat32;
                u_xlat31 = u_xlat31 * u_xlat32;
                u_xlat33 = _SpeclarHeight + -1.0;
                u_xlat33 = u_xlat33 * 0.800000012;
                u_xlat9.x = dot(i.vs_TEXCOORD6.xyz, u_xlat4.xyz);
                u_xlat9.y = dot(i.vs_TEXCOORD7.xyz, u_xlat4.xyz);
                u_xlat4.x = dot(u_xlat3.xyz, u_xlat4.xyz);
                u_xlat4.x = max(u_xlat4.x, 0.0);
                u_xlat4.x = (-u_xlat4.x) + 1.0;
                u_xlat4.x = log2(u_xlat4.x);
                u_xlat14.xy = vec2(u_xlat33) * u_xlat9.xy + i.vs_TEXCOORD0.xy;
                u_xlat14.xy = u_xlat14.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_9 = tex2D(_DetailMask, u_xlat14.xy);
                u_xlat16_33 = u_xlat10_9.x * 1.66666698;
                u_xlat16_33 = clamp(u_xlat16_33, 0.0, 1.0);
                u_xlat16_14 = u_xlat16_33 * u_xlat16_33;
                u_xlat16_24 = (-u_xlat16_33) * u_xlat16_14 + u_xlat16_33;
                u_xlat16_33 = u_xlat16_33 * u_xlat16_14;
                u_xlat6.xzw = vec3(u_xlat16_33) * _SpecularColor.xyz;
                u_xlat33 = u_xlat10_8.w * _SpecularPower;
                u_xlat14.x = u_xlat16_8.y * _SpecularPowerNail;
                u_xlat33 = max(u_xlat33, u_xlat14.x);
                u_xlat14.x = u_xlat16_24 * u_xlat33;
                u_xlat6.xzw = vec3(u_xlat33) * u_xlat6.xzw;
                u_xlat33 = dot(_SpecularColor.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
                u_xlat33 = min(u_xlat33, u_xlat14.x);
                u_xlat33 = min(u_xlat31, u_xlat33);
                u_xlat33 = min(u_xlat10_8.w, u_xlat33);
                u_xlat1.xyz = vec3(u_xlat33) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat6.xzw;
                u_xlat33 = dot(u_xlat5.xyz, u_xlat5.xyz);
                u_xlat33 = inversesqrt(u_xlat33);
                u_xlat14.xyz = vec3(u_xlat33) * u_xlat5.xyz;
                u_xlat3.x = dot(u_xlat3.xyz, u_xlat14.xyz);
                u_xlat3.x = max(u_xlat3.x, 0.0);
                u_xlat3.x = log2(u_xlat3.x);
                u_xlat13.x = _SpecularPower * 256.0;
                u_xlat13.x = u_xlat3.x * u_xlat13.x;
                u_xlat3.x = u_xlat3.x * 256.0;
                u_xlat3.x = exp2(u_xlat3.x);
                u_xlat3.x = u_xlat3.x * 0.5;
                u_xlat13.x = exp2(u_xlat13.x);
                u_xlat13.x = u_xlat13.x * _SpecularPower;
                u_xlat13.x = u_xlat13.x * _SpecularColor.w;
                u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
                u_xlat13.xyz = _SpecularColor.xyz * u_xlat13.xxx + u_xlat0.xyz;
                u_xlat0.xyz = u_xlat0.xyz * _LineColorG.xyz;
                u_xlat13.xyz = (-u_xlat1.xyz) + u_xlat13.xyz;
                u_xlat1.xyz = vec3(_notusetexspecular) * u_xlat13.xyz + u_xlat1.xyz;
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlatb13.xyz = lessThan(vec4(0.555555582, 0.555555582, 0.555555582, 0.555555582), u_xlat2.xyzz).xyz;
                u_xlat14.xyz = u_xlat2.xyz * vec3(0.899999976, 0.899999976, 0.899999976) + vec3(-0.5, -0.5, -0.5);
                u_xlat14.xyz = (-u_xlat14.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat9 = (-_ambientshadowG.wxyz) + vec4(1.0, 1.0, 1.0, 1.0);
                u_xlat5.xyz = (-u_xlat9.xxx) * u_xlat9.yzw + vec3(1.0, 1.0, 1.0);
                u_xlat6.x = _ambientshadowG.w * 0.5 + 0.5;
                u_xlat26 = u_xlat6.x + u_xlat6.x;
                u_xlatb6 = 0.5<u_xlat6.x;
                u_xlat9.xyz = vec3(u_xlat26) * _ambientshadowG.xyz;
                u_xlat5.xyz = (bool(u_xlatb6)) ? u_xlat5.xyz : u_xlat9.xyz;
                u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
                u_xlat6.xzw = (-u_xlat5.xyz) + vec3(1.0, 1.0, 1.0);
                u_xlat2.xyz = u_xlat2.xyz * u_xlat5.xyz;
                u_xlat2.xyz = u_xlat2.xyz * vec3(1.79999995, 1.79999995, 1.79999995);
                u_xlat14.xyz = (-u_xlat14.xyz) * u_xlat6.xzw + vec3(1.0, 1.0, 1.0);
                {
                float4 hlslcc_movcTemp = u_xlat2;
                hlslcc_movcTemp.x = (u_xlatb13.x) ? u_xlat14.x : u_xlat2.x;
                hlslcc_movcTemp.y = (u_xlatb13.y) ? u_xlat14.y : u_xlat2.y;
                hlslcc_movcTemp.z = (u_xlatb13.z) ? u_xlat14.z : u_xlat2.z;
                u_xlat2 = hlslcc_movcTemp;
                }
                u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
                u_xlat13.xyz = u_xlat1.xyz * u_xlat2.xyz;
                u_xlat1.xyz = (-u_xlat1.xyz) * u_xlat2.xyz + u_xlat1.xyz;
                u_xlat1.xyz = vec3(u_xlat31) * u_xlat1.xyz + u_xlat13.xyz;
                u_xlat13.xyz = vec3(u_xlat30) * vec3(0.350000024, 0.45294112, 0.607352912) + vec3(0.5, 0.397058904, 0.242647097);
                u_xlat3.xyz = u_xlat13.xyz * u_xlat7.xyz + u_xlat3.xxx;
                u_xlat31 = _rimpower * 9.0 + 1.0;
                u_xlat31 = u_xlat4.x * u_xlat31;
                u_xlat31 = exp2(u_xlat31);
                u_xlat31 = u_xlat31 * 5.0 + -2.0;
                u_xlat16_4.xy = u_xlat16_8.xz * vec2(0.5, 2.5) + vec2(0.5, -1.5);
                u_xlat31 = min(u_xlat31, u_xlat16_4.y);
                u_xlat31 = clamp(u_xlat31, 0.0, 1.0);
                u_xlat31 = u_xlat16_8.x * u_xlat31;
                u_xlat3.xyz = vec3(u_xlat31) * vec3(_rimV) + u_xlat3.xyz;
                u_xlat3.xyz = (-u_xlat1.xyz) + u_xlat3.xyz;
                u_xlat1.xyz = vec3(u_xlat30) * u_xlat3.xyz + u_xlat1.xyz;
                u_xlat3.xyz = _LightColor0.xyz * vec3(0.600000024, 0.600000024, 0.600000024) + vec3(0.400000006, 0.400000006, 0.400000006);
                u_xlat14.xyz = max(u_xlat3.xyz, _ambientshadowG.xyz);
                u_xlat1.xyz = u_xlat1.xyz * u_xlat14.xyz;
                u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xyz;
                u_xlat14.xyz = (-u_xlat0.xyz) * u_xlat16_4.xxx + vec3(1.0, 1.0, 1.0);
                u_xlat0.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
                u_xlat30 = _LineColorG.w + -0.5;
                u_xlat30 = (-u_xlat30) * 2.0 + 1.0;
                u_xlat4.xyz = (-vec3(u_xlat30)) * u_xlat14.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat30 = _LineColorG.w + _LineColorG.w;
                u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat30);
                u_xlatb30 = 0.5<_LineColorG.w;
                u_xlat0.xyz = (bool(u_xlatb30)) ? u_xlat4.xyz : u_xlat0.xyz;
                u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
                u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz;
                u_xlat3.xyz = (-u_xlat2.xyz) + vec3(1.0, 1.0, 1.0);
                u_xlat2.xyz = vec3(u_xlat32) * u_xlat3.xyz + u_xlat2.xyz;
                u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz + (-u_xlat0.xyz);
                u_xlat30 = (-_linewidthG) + 1.0;
                u_xlat30 = u_xlat30 * 0.800000012 + 0.200000003;
                u_xlat30 = log2(u_xlat30);
                u_xlat30 = u_xlat30 * u_xlat10_6.y;
                u_xlat30 = exp2(u_xlat30);
                u_xlat30 = min(u_xlat35, u_xlat30);
                u_xlat30 = u_xlat30 + -1.0;
                u_xlat30 = _linetexon * u_xlat30 + 1.0;
                SV_Target0.xyz = vec3(u_xlat30) * u_xlat1.xyz + u_xlat0.xyz;
                SV_Target0.w = 1.0;
                return SV_Target0;
            }
            #elif defined (DIRECTIONAL) && defined (VERTEXLIGHT_ON)
            struct VertexInput {
                float4 in_POSITION0 : POSITION0;
                float3 in_NORMAL0 : NORMAL0;
                float4 in_TANGENT0 : TANGENT0;
                float2 in_TEXCOORD0 : TEXCOORD0;
                float2 in_TEXCOORD1 : TEXCOORD1;
                float2 in_TEXCOORD2 : TEXCOORD2;
                float2 in_TEXCOORD3 : TEXCOORD3;
                float4 in_COLOR0 : COLOR0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float2 vs_TEXCOORD1 : TEXCOORD1;
                float2 vs_TEXCOORD2 : TEXCOORD2;
                float2 vs_TEXCOORD3 : TEXCOORD3;
                float4 vs_TEXCOORD4 : TEXCOORD4;
                float3 vs_TEXCOORD5 : TEXCOORD5;
                float3 vs_TEXCOORD6 : TEXCOORD6;
                float3 vs_TEXCOORD7 : TEXCOORD7;
                float4 vs_COLOR0 : COLOR0;
            };
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float u_xlat9;

                u_xlat0 = float4(mul(unity_ObjectToWorld, v.in_POSITION0).xyz, 0);
                u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
                o.vs_TEXCOORD4 = unity_ObjectToWorld[3] * v.in_POSITION0.wwww + u_xlat0;

                u_xlat0 = mul(unity_MatrixVP, u_xlat1);
                gl_Position = u_xlat0;

                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                o.vs_TEXCOORD1.xy = v.in_TEXCOORD1.xy;
                o.vs_TEXCOORD2.xy = v.in_TEXCOORD2.xy;
                o.vs_TEXCOORD3.xy = v.in_TEXCOORD3.xy;
                u_xlat0.x = dot(v.in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
                u_xlat0.y = dot(v.in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
                u_xlat0.z = dot(v.in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
                u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                u_xlat0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
                o.vs_TEXCOORD5.xyz = u_xlat0.xyz;
                u_xlat1.xyz = unity_ObjectToWorld[1].xyz * v.in_TANGENT0.yyy;
                u_xlat1.xyz = unity_ObjectToWorld[0].xyz * v.in_TANGENT0.xxx + u_xlat1.xyz;
                u_xlat1.xyz = unity_ObjectToWorld[2].xyz * v.in_TANGENT0.zzz + u_xlat1.xyz;
                u_xlat9 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz;
                o.vs_TEXCOORD6.xyz = u_xlat1.xyz;
                u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
                u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
                u_xlat0.xyz = u_xlat0.xyz * v.in_TANGENT0.www;
                u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                o.vs_TEXCOORD7.xyz = vec3(u_xlat9) * u_xlat0.xyz;
                o.vs_COLOR0 = v.in_COLOR0;
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
                float2 in_TEXCOORD1 : TEXCOORD1;
                float2 in_TEXCOORD2 : TEXCOORD2;
                float2 in_TEXCOORD3 : TEXCOORD3;
                float4 in_COLOR0 : COLOR0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 vs_TEXCOORD0 : TEXCOORD0;
                float2 vs_TEXCOORD1 : TEXCOORD1;
                float2 vs_TEXCOORD2 : TEXCOORD2;
                float2 vs_TEXCOORD3 : TEXCOORD3;
                float4 vs_TEXCOORD4 : TEXCOORD4;
                float3 vs_TEXCOORD5 : TEXCOORD5;
                float3 vs_TEXCOORD6 : TEXCOORD6;
                float3 vs_TEXCOORD7 : TEXCOORD7;
                float4 vs_COLOR0 : COLOR0;
            };
            float _alpha_a;
            float _alpha_b;
            float _DetailNormalMapScale;
            float _FaceNormalG;
            float _FaceShadowG;
            float _linetexon;
            float _linewidthG;
            float _liquidbbot;
            float _liquidbtop;
            float _liquidface;
            float _liquidfbot;
            float _liquidftop;
            float _nip;
            float _nip_specular;
            float _nipsize;
            float _notusetexspecular;
            float _rimpower;
            float _rimV;
            float _ShadowExtend;
            float _SpeclarHeight;
            float _SpecularPower;
            float _SpecularPowerNail;
            float _tex1mask;
            float3 u_xlatb13;
            float4 _AlphaMask_ST;
            float4 _ambientshadowG;
            float4 _DetailMask_ST;
            float4 _LineColorG;
            float4 _LineMask_ST;
            float4 _liquidmask_ST;
            float4 _LiquidTiling;
            float4 _MainTex_ST;
            float4 _NormalMap_ST;
            float4 _NormalMapDetail_ST;
            float4 _NormalMask_ST;
            float4 _overcolor1;
            float4 _overcolor2;
            float4 _overcolor3;
            float4 _overtex1_ST;
            float4 _overtex2_ST;
            float4 _overtex3_ST;
            float4 _RampG_ST;
            float4 _SpecularColor;
            float4 _Texture2_ST;
            float4 _Texture3_ST;
            sampler2D _AlphaMask;
            sampler2D _DetailMask;
            sampler2D _LineMask;
            sampler2D _liquidmask;
            sampler2D _MainTex;
            sampler2D _NormalMap;
            sampler2D _NormalMapDetail;
            sampler2D _NormalMask;
            sampler2D _overtex1;
            sampler2D _overtex2;
            sampler2D _overtex3;
            sampler2D _RampG;
            sampler2D _Texture2;
            sampler2D _Texture3;
            VertexOutput vert(VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                float4 u_xlat0;
                float4 u_xlat1;
                float3 u_xlat2;
                float u_xlat9;

                u_xlat0 = float4(mul(unity_ObjectToWorld, v.in_POSITION0).xyz, 0);
                u_xlat1 = u_xlat0 + unity_ObjectToWorld[3];
                o.vs_TEXCOORD4 = unity_ObjectToWorld[3] * v.in_POSITION0.wwww + u_xlat0;

                u_xlat0 = mul(unity_MatrixVP, u_xlat1);
                gl_Position = u_xlat0;

                o.vs_TEXCOORD0.xy = v.in_TEXCOORD0.xy;
                o.vs_TEXCOORD1.xy = v.in_TEXCOORD1.xy;
                o.vs_TEXCOORD2.xy = v.in_TEXCOORD2.xy;
                o.vs_TEXCOORD3.xy = v.in_TEXCOORD3.xy;
                u_xlat0.x = dot(v.in_NORMAL0.xyz, unity_WorldToObject[0].xyz);
                u_xlat0.y = dot(v.in_NORMAL0.xyz, unity_WorldToObject[1].xyz);
                u_xlat0.z = dot(v.in_NORMAL0.xyz, unity_WorldToObject[2].xyz);
                u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                u_xlat0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
                o.vs_TEXCOORD5.xyz = u_xlat0.xyz;
                u_xlat1.xyz = unity_ObjectToWorld[1].xyz * v.in_TANGENT0.yyy;
                u_xlat1.xyz = unity_ObjectToWorld[0].xyz * v.in_TANGENT0.xxx + u_xlat1.xyz;
                u_xlat1.xyz = unity_ObjectToWorld[2].xyz * v.in_TANGENT0.zzz + u_xlat1.xyz;
                u_xlat9 = dot(u_xlat1.xyz, u_xlat1.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                u_xlat1.xyz = vec3(u_xlat9) * u_xlat1.xyz;
                o.vs_TEXCOORD6.xyz = u_xlat1.xyz;
                u_xlat2.xyz = u_xlat0.zxy * u_xlat1.yzx;
                u_xlat0.xyz = u_xlat0.yzx * u_xlat1.zxy + (-u_xlat2.xyz);
                u_xlat0.xyz = u_xlat0.xyz * v.in_TANGENT0.www;
                u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
                u_xlat9 = inversesqrt(u_xlat9);
                o.vs_TEXCOORD7.xyz = vec3(u_xlat9) * u_xlat0.xyz;
                o.vs_COLOR0 = v.in_COLOR0;
                return o;
            }
            float4 frag(VertexOutput i, fixed gl_FrontFacing : VFACE) : COLOR {
                float4 SV_Target0;
                float3 u_xlat0;
                float4 u_xlat10_0;
                int u_xlatb0;
                float4 u_xlat1;
                float4 u_xlat10_1;
                float4 u_xlat2;
                float4 u_xlat3;
                float4 u_xlat10_3;
                float4 u_xlat4;
                float2 u_xlat16_4;
                float3 u_xlat5;
                float3 u_xlat16_5;
                float4 u_xlat10_5;
                float4 u_xlat6;
                float4 u_xlat10_6;
                int u_xlatb6;
                float3 u_xlat7;
                float3 u_xlat16_7;
                float4 u_xlat8;
                float3 u_xlat16_8;
                float4 u_xlat10_8;
                float4 u_xlat9;
                float4 u_xlat10_9;
                float2 u_xlat10;
                float u_xlat11;
                float3 u_xlat13;
                float3 u_xlat14;
                float u_xlat16_14;
                float2 u_xlat20;
                float u_xlat16_24;
                float2 u_xlat25;
                float u_xlat26;
                float u_xlat30;
                float u_xlat16_30;
                int u_xlatb30;
                float u_xlat31;
                float u_xlat32;
                float u_xlat33;
                float u_xlat16_33;
                float u_xlat34;
                float u_xlat35;
                u_xlat0.xy = i.vs_TEXCOORD0.xy * _AlphaMask_ST.xy + _AlphaMask_ST.zw;
                u_xlat10_0 = tex2D(_AlphaMask, u_xlat0.xy);
                u_xlat20.xy = (-vec2(_alpha_a, _alpha_b)) + vec2(1.0, 1.0);
                u_xlat0.xy = max(u_xlat20.xy, u_xlat10_0.xy);
                u_xlat0.x = min(u_xlat0.y, u_xlat0.x);
                u_xlat0.x = u_xlat0.x + -0.5;
                u_xlatb0 = u_xlat0.x<0.0;
                if(((int(u_xlatb0) * int(0xffffffffu)))!=0){discard;}
                u_xlat0.xy = i.vs_TEXCOORD1.xy + vec2(-0.5, -0.5);
                u_xlat0.x = dot(u_xlat0.xy, u_xlat0.xy);
                u_xlat0.x = sqrt(u_xlat0.x);
                u_xlat0.x = u_xlat0.x * 16.6666698 + -1.0;
                u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
                u_xlat10.xy = vec2(vec2(_nipsize, _nipsize)) * vec2(-1.39999998, 0.699999988) + vec2(2.0, -0.5);
                u_xlat10.xy = i.vs_TEXCOORD1.xy * u_xlat10.xx + u_xlat10.yy;
                u_xlat10.xy = u_xlat10.xy + (-i.vs_TEXCOORD1.xy);
                u_xlat0.xy = u_xlat0.xx * u_xlat10.xy + i.vs_TEXCOORD1.xy;
                u_xlat20.xy = i.vs_TEXCOORD1.xy * i.vs_COLOR0.xx;
                u_xlat0.xy = u_xlat0.xy * i.vs_COLOR0.xx + (-u_xlat20.xy);
                u_xlat0.xy = vec2(vec2(_nip, _nip)) * u_xlat0.xy + u_xlat20.xy;
                u_xlat0.xy = u_xlat0.xy * _overtex1_ST.xy + _overtex1_ST.zw;
                u_xlat10_0 = tex2D(_overtex1, u_xlat0.xy);
                u_xlat1.x = u_xlat10_0.y * _nip_specular;
                u_xlat1.xyz = u_xlat1.xxx * vec3(0.330000013, 0.330000013, 0.330000013) + _overcolor1.xyz;
                u_xlat2 = u_xlat10_0 * _overcolor1;
                u_xlat0.xyz = u_xlat10_0.xxx * u_xlat1.xyz + (-u_xlat2.xyz);
                u_xlat30 = _tex1mask;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat0.xyz = vec3(u_xlat30) * u_xlat0.xyz + u_xlat2.xyz;
                u_xlat1.xy = i.vs_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                u_xlat10_1 = tex2D(_MainTex, u_xlat1.xy);
                u_xlat0.xyz = u_xlat0.xyz + (-u_xlat10_1.xyz);
                u_xlat0.xyz = u_xlat2.www * u_xlat0.xyz + u_xlat10_1.xyz;
                u_xlat1.xy = i.vs_TEXCOORD2.xy * i.vs_COLOR0.zz;
                u_xlat1.xy = u_xlat1.xy * _overtex2_ST.xy + _overtex2_ST.zw;
                u_xlat10_1 = tex2D(_overtex2, u_xlat1.xy);
                u_xlat1.xyz = _overcolor2.xyz * u_xlat10_1.xyz + (-u_xlat0.xyz);
                u_xlat30 = u_xlat10_1.w * _overcolor2.w;
                u_xlat0.xyz = vec3(u_xlat30) * u_xlat1.xyz + u_xlat0.xyz;
                u_xlat1.xy = i.vs_TEXCOORD3.xy * _overtex3_ST.xy + _overtex3_ST.zw;
                u_xlat10_1 = tex2D(_overtex3, u_xlat1.xy);
                u_xlat1.xyz = u_xlat10_1.xyz * _overcolor3.xyz + (-u_xlat0.xyz);
                u_xlat30 = u_xlat10_1.w * _overcolor3.w;
                u_xlat0.xyz = vec3(u_xlat30) * u_xlat1.xyz + u_xlat0.xyz;
                u_xlatb30 = u_xlat0.y>=u_xlat0.z;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat1.xy = u_xlat0.zy;
                u_xlat2.xy = u_xlat0.yz + (-u_xlat1.xy);
                u_xlat1.z = float(-1.0);
                u_xlat1.w = float(0.666666687);
                u_xlat2.z = float(1.0);
                u_xlat2.w = float(-1.0);
                u_xlat1 = vec4(u_xlat30) * u_xlat2.xywz + u_xlat1.xywz;
                u_xlatb30 = u_xlat0.x>=u_xlat1.x;
                u_xlat30 = u_xlatb30 ? 1.0 : float(0.0);
                u_xlat2.z = u_xlat1.w;
                u_xlat1.w = u_xlat0.x;
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
                u_xlat30 = u_xlat30 * 0.660000026;
                u_xlat1.xzw = abs(vec3(u_xlat11)) + vec3(-0.0799999982, -0.413333356, 0.25333333);
                u_xlat2.xyz = abs(vec3(u_xlat11)) + vec3(0.0, -0.333333343, 0.333333343);
                u_xlat2.xyz = fract(u_xlat2.xyz);
                u_xlat2.xyz = (-u_xlat2.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat2.xyz = abs(u_xlat2.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
                u_xlat2.xyz = u_xlat2.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat2.xyz = vec3(u_xlat30) * u_xlat2.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = fract(u_xlat1.xzw);
                u_xlat1.xyz = (-u_xlat1.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = abs(u_xlat1.xyz) * vec3(3.0, 3.0, 3.0) + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz + vec3(-1.0, -1.0, -1.0);
                u_xlat1.xyz = u_xlat1.xyz * vec3(0.400000006, 0.400000006, 0.400000006) + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = u_xlat1.xyz * vec3(0.970000029, 0.970000029, 0.970000029) + vec3(-1.0, -1.0, -1.0);
                u_xlat3.xy = i.vs_TEXCOORD0.xy * _NormalMapDetail_ST.xy + _NormalMapDetail_ST.zw;
                u_xlat10_3 = tex2D(_NormalMapDetail, u_xlat3.xy);
                u_xlat3.xy = u_xlat10_3.wy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
                u_xlat30 = dot(u_xlat3.xy, u_xlat3.xy);
                u_xlat30 = min(u_xlat30, 1.0);
                u_xlat30 = (-u_xlat30) + 1.0;
                u_xlat3.z = sqrt(u_xlat30);
                u_xlat4.xyz = u_xlat3.xyz * vec3(-1.0, -1.0, 1.0);
                u_xlat5.xy = i.vs_TEXCOORD0.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
                u_xlat10_5 = tex2D(_NormalMap, u_xlat5.xy);
                u_xlat16_5.xz = u_xlat10_5.wy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
                u_xlat6.xy = u_xlat10_5.wy + u_xlat10_5.wy;
                u_xlat16_30 = dot(u_xlat16_5.xz, u_xlat16_5.xz);
                u_xlat16_30 = min(u_xlat16_30, 1.0);
                u_xlat16_30 = (-u_xlat16_30) + 1.0;
                u_xlat6.z = sqrt(u_xlat16_30);
                u_xlat5.xyz = u_xlat6.xyz + vec3(-1.0, -1.0, 1.0);
                u_xlat6.xyz = u_xlat6.xyz + vec3(-1.0, -1.0, 0.0);
                u_xlat30 = dot(u_xlat5.xyz, u_xlat4.xyz);
                u_xlat4.xyz = vec3(u_xlat30) * u_xlat5.xyz;
                u_xlat4.xyz = u_xlat4.xyz / u_xlat5.zzz;
                u_xlat3.xyz = (-u_xlat3.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat4.xyz;
                u_xlat3.xyz = (-u_xlat6.xyz) + u_xlat3.xyz;
                u_xlat3.xyz = vec3(_DetailNormalMapScale) * u_xlat3.xyz + u_xlat6.xyz;
                u_xlat4.xyz = u_xlat3.xyz + vec3(0.0, 0.0, 1.0);
                u_xlat5.xy = i.vs_TEXCOORD0.xy * _LiquidTiling.zw + _LiquidTiling.xy;
                u_xlat25.xy = u_xlat5.xy * _Texture3_ST.xy + _Texture3_ST.zw;
                u_xlat5.xy = u_xlat5.xy * _Texture2_ST.xy + _Texture2_ST.zw;
                u_xlat10_6 = tex2D(_Texture2, u_xlat5.xy);
                u_xlat10_5 = tex2D(_Texture3, u_xlat25.xy);
                u_xlat5.xy = u_xlat10_5.wy * vec2(2.0, 2.0) + vec2(-1.0, -1.0);
                u_xlat30 = dot(u_xlat5.xy, u_xlat5.xy);
                u_xlat30 = min(u_xlat30, 1.0);
                u_xlat30 = (-u_xlat30) + 1.0;
                u_xlat5.z = sqrt(u_xlat30);
                u_xlat7.xyz = u_xlat5.xyz * vec3(-1.0, -1.0, 1.0);
                u_xlat30 = dot(u_xlat4.xyz, u_xlat7.xyz);
                u_xlat4.xyw = vec3(u_xlat30) * u_xlat4.xyz;
                u_xlat4.xyz = u_xlat4.xyw / u_xlat4.zzz;
                u_xlat4.xyz = (-u_xlat5.xyz) * vec3(-1.0, -1.0, 1.0) + u_xlat4.xyz;
                u_xlat4.xyz = (-u_xlat3.xyz) + u_xlat4.xyz;
                u_xlat30 = _liquidftop + -1.0;
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat30 = u_xlat30 * u_xlat10_6.y;
                u_xlat31 = _liquidftop;
                u_xlat31 = clamp(u_xlat31, 0.0, 1.0);
                u_xlat31 = u_xlat31 * u_xlat10_6.x;
                u_xlat30 = max(u_xlat30, u_xlat31);
                u_xlat5.xy = i.vs_TEXCOORD0.xy * _liquidmask_ST.xy + _liquidmask_ST.zw;
                u_xlat10_5 = tex2D(_liquidmask, u_xlat5.xy);
                u_xlat16_7.xyz = max(u_xlat10_5.zzy, u_xlat10_5.yxx);
                u_xlat16_7.xyz = u_xlat10_5.xyz + (-u_xlat16_7.xyz);
                u_xlat16_5.xy = min(u_xlat10_5.yz, u_xlat10_5.xy);
                u_xlat16_5.xy = u_xlat16_5.xy * vec2(1.11111104, 1.11111104) + vec2(-0.111111097, -0.111111097);
                u_xlat30 = min(u_xlat30, u_xlat16_7.x);
                u_xlat8 = vec4(_liquidfbot, _liquidbtop, _liquidbbot, _liquidface) + vec4(-1.0, -1.0, -1.0, -1.0);
                u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
                u_xlat8 = u_xlat10_6.yyyy * u_xlat8;
                u_xlat9 = vec4(_liquidfbot, _liquidbtop, _liquidbbot, _liquidface);
                u_xlat9 = clamp(u_xlat9, 0.0, 1.0);
                u_xlat6 = u_xlat10_6.xxxx * u_xlat9;
                u_xlat6 = max(u_xlat6, u_xlat8);
                u_xlat25.xy = min(u_xlat16_7.yz, u_xlat6.xy);
                u_xlat5.xy = min(u_xlat16_5.xy, u_xlat6.zw);
                u_xlat30 = max(u_xlat30, u_xlat25.x);
                u_xlat30 = max(u_xlat25.y, u_xlat30);
                u_xlat30 = max(u_xlat5.x, u_xlat30);
                u_xlat30 = max(u_xlat5.y, u_xlat30);
                u_xlat30 = clamp(u_xlat30, 0.0, 1.0);
                u_xlat3.xyz = vec3(u_xlat30) * u_xlat4.xyz + u_xlat3.xyz;
                u_xlat4.xyz = u_xlat3.yyy * i.vs_TEXCOORD7.xyz;
                u_xlat3.xyw = u_xlat3.xxx * i.vs_TEXCOORD6.xyz + u_xlat4.xyz;
                u_xlat31 = dot(i.vs_TEXCOORD5.xyz, i.vs_TEXCOORD5.xyz);
                u_xlat31 = inversesqrt(u_xlat31);
                u_xlat4.xyz = vec3(u_xlat31) * i.vs_TEXCOORD5.xyz;
                u_xlat31 = ((gl_FrontFacing ? 0xffffffffu : uint(0)) != uint(0)) ? 1.0 : -1.0;
                u_xlat4.xyz = vec3(u_xlat31) * u_xlat4.xyz;
                u_xlat3.xyz = u_xlat3.zzz * u_xlat4.xyz + u_xlat3.xyw;
                u_xlat31 = dot(u_xlat3.xyz, u_xlat3.xyz);
                u_xlat31 = inversesqrt(u_xlat31);
                u_xlat3.xyz = vec3(u_xlat31) * u_xlat3.xyz;
                u_xlat4.xyz = (-i.vs_TEXCOORD4.xyz) + _WorldSpaceCameraPos.xyz;
                u_xlat31 = dot(u_xlat4.xyz, u_xlat4.xyz);
                u_xlat31 = inversesqrt(u_xlat31);
                u_xlat5.xyz = u_xlat4.xyz * vec3(u_xlat31) + (-u_xlat3.xyz);
                u_xlat6.xy = i.vs_TEXCOORD0.xy * _NormalMask_ST.xy + _NormalMask_ST.zw;
                u_xlat10_6 = tex2D(_NormalMask, u_xlat6.xy);
                u_xlat6.xy = u_xlat10_6.yz * vec2(_FaceNormalG, _FaceShadowG);
                u_xlat5.xyz = u_xlat6.xxx * u_xlat5.xyz + u_xlat3.xyz;
                u_xlat32 = max(u_xlat6.y, 1.0);
                u_xlat33 = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                u_xlat33 = inversesqrt(u_xlat33);
                u_xlat6.xyz = vec3(u_xlat33) * _WorldSpaceLightPos0.xyz;
                u_xlat33 = dot(u_xlat6.xyz, u_xlat5.xyz);
                u_xlat5.xyz = u_xlat4.xyz * vec3(u_xlat31) + u_xlat6.xyz;
                u_xlat4.xyz = vec3(u_xlat31) * u_xlat4.xyz;
                u_xlat31 = max(u_xlat33, 0.0);
                u_xlat6.xy = vec2(u_xlat31) * _RampG_ST.xy + _RampG_ST.zw;
                u_xlat31 = u_xlat31 + 0.5;
                u_xlat7.xyz = vec3(u_xlat31) * vec3(0.149999976, 0.199999988, 0.300000012) + vec3(0.850000024, 0.800000012, 0.699999988);
                u_xlat10_6 = tex2D(_RampG, u_xlat6.xy);
                u_xlat31 = u_xlat32 * u_xlat10_6.x;
                u_xlat32 = _ShadowExtend * -1.20000005 + 1.0;
                u_xlat33 = (-u_xlat32) + 1.0;
                u_xlat6.xy = i.vs_TEXCOORD0.xy * _LineMask_ST.xy + _LineMask_ST.zw;
                u_xlat10_6 = tex2D(_LineMask, u_xlat6.xy);
                u_xlat6.xz = (-u_xlat10_6.zx) * vec2(_DetailNormalMapScale) + vec2(1.0, 1.0);
                u_xlat8.xy = i.vs_TEXCOORD0.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_8 = tex2D(_DetailMask, u_xlat8.xy);
                u_xlat16_8.xyz = (-u_xlat10_8.ywz) + vec3(1.0, 1.0, 1.0);
                u_xlat34 = min(u_xlat6.x, u_xlat16_8.x);
                u_xlat35 = u_xlat6.z * 0.5 + 0.5;
                u_xlat32 = u_xlat34 * u_xlat33 + u_xlat32;
                u_xlat31 = u_xlat31 * u_xlat32;
                u_xlat33 = _SpeclarHeight + -1.0;
                u_xlat33 = u_xlat33 * 0.800000012;
                u_xlat9.x = dot(i.vs_TEXCOORD6.xyz, u_xlat4.xyz);
                u_xlat9.y = dot(i.vs_TEXCOORD7.xyz, u_xlat4.xyz);
                u_xlat4.x = dot(u_xlat3.xyz, u_xlat4.xyz);
                u_xlat4.x = max(u_xlat4.x, 0.0);
                u_xlat4.x = (-u_xlat4.x) + 1.0;
                u_xlat4.x = log2(u_xlat4.x);
                u_xlat14.xy = vec2(u_xlat33) * u_xlat9.xy + i.vs_TEXCOORD0.xy;
                u_xlat14.xy = u_xlat14.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
                u_xlat10_9 = tex2D(_DetailMask, u_xlat14.xy);
                u_xlat16_33 = u_xlat10_9.x * 1.66666698;
                u_xlat16_33 = clamp(u_xlat16_33, 0.0, 1.0);
                u_xlat16_14 = u_xlat16_33 * u_xlat16_33;
                u_xlat16_24 = (-u_xlat16_33) * u_xlat16_14 + u_xlat16_33;
                u_xlat16_33 = u_xlat16_33 * u_xlat16_14;
                u_xlat6.xzw = vec3(u_xlat16_33) * _SpecularColor.xyz;
                u_xlat33 = u_xlat10_8.w * _SpecularPower;
                u_xlat14.x = u_xlat16_8.y * _SpecularPowerNail;
                u_xlat33 = max(u_xlat33, u_xlat14.x);
                u_xlat14.x = u_xlat16_24 * u_xlat33;
                u_xlat6.xzw = vec3(u_xlat33) * u_xlat6.xzw;
                u_xlat33 = dot(_SpecularColor.xyz, vec3(0.300000012, 0.589999974, 0.109999999));
                u_xlat33 = min(u_xlat33, u_xlat14.x);
                u_xlat33 = min(u_xlat31, u_xlat33);
                u_xlat33 = min(u_xlat10_8.w, u_xlat33);
                u_xlat1.xyz = vec3(u_xlat33) * u_xlat1.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat1.xyz = u_xlat0.xyz * u_xlat1.xyz + u_xlat6.xzw;
                u_xlat33 = dot(u_xlat5.xyz, u_xlat5.xyz);
                u_xlat33 = inversesqrt(u_xlat33);
                u_xlat14.xyz = vec3(u_xlat33) * u_xlat5.xyz;
                u_xlat3.x = dot(u_xlat3.xyz, u_xlat14.xyz);
                u_xlat3.x = max(u_xlat3.x, 0.0);
                u_xlat3.x = log2(u_xlat3.x);
                u_xlat13.x = _SpecularPower * 256.0;
                u_xlat13.x = u_xlat3.x * u_xlat13.x;
                u_xlat3.x = u_xlat3.x * 256.0;
                u_xlat3.x = exp2(u_xlat3.x);
                u_xlat3.x = u_xlat3.x * 0.5;
                u_xlat13.x = exp2(u_xlat13.x);
                u_xlat13.x = u_xlat13.x * _SpecularPower;
                u_xlat13.x = u_xlat13.x * _SpecularColor.w;
                u_xlat13.x = clamp(u_xlat13.x, 0.0, 1.0);
                u_xlat13.xyz = _SpecularColor.xyz * u_xlat13.xxx + u_xlat0.xyz;
                u_xlat0.xyz = u_xlat0.xyz * _LineColorG.xyz;
                u_xlat13.xyz = (-u_xlat1.xyz) + u_xlat13.xyz;
                u_xlat1.xyz = vec3(_notusetexspecular) * u_xlat13.xyz + u_xlat1.xyz;
                u_xlat1.xyz = clamp(u_xlat1.xyz, 0.0, 1.0);
                u_xlatb13.xyz = lessThan(vec4(0.555555582, 0.555555582, 0.555555582, 0.555555582), u_xlat2.xyzz).xyz;
                u_xlat14.xyz = u_xlat2.xyz * vec3(0.899999976, 0.899999976, 0.899999976) + vec3(-0.5, -0.5, -0.5);
                u_xlat14.xyz = (-u_xlat14.xyz) * vec3(2.0, 2.0, 2.0) + vec3(1.0, 1.0, 1.0);
                u_xlat9 = (-_ambientshadowG.wxyz) + vec4(1.0, 1.0, 1.0, 1.0);
                u_xlat5.xyz = (-u_xlat9.xxx) * u_xlat9.yzw + vec3(1.0, 1.0, 1.0);
                u_xlat6.x = _ambientshadowG.w * 0.5 + 0.5;
                u_xlat26 = u_xlat6.x + u_xlat6.x;
                u_xlatb6 = 0.5<u_xlat6.x;
                u_xlat9.xyz = vec3(u_xlat26) * _ambientshadowG.xyz;
                u_xlat5.xyz = (bool(u_xlatb6)) ? u_xlat5.xyz : u_xlat9.xyz;
                u_xlat5.xyz = clamp(u_xlat5.xyz, 0.0, 1.0);
                u_xlat6.xzw = (-u_xlat5.xyz) + vec3(1.0, 1.0, 1.0);
                u_xlat2.xyz = u_xlat2.xyz * u_xlat5.xyz;
                u_xlat2.xyz = u_xlat2.xyz * vec3(1.79999995, 1.79999995, 1.79999995);
                u_xlat14.xyz = (-u_xlat14.xyz) * u_xlat6.xzw + vec3(1.0, 1.0, 1.0);
                {
                float4 hlslcc_movcTemp = u_xlat2;
                hlslcc_movcTemp.x = (u_xlatb13.x) ? u_xlat14.x : u_xlat2.x;
                hlslcc_movcTemp.y = (u_xlatb13.y) ? u_xlat14.y : u_xlat2.y;
                hlslcc_movcTemp.z = (u_xlatb13.z) ? u_xlat14.z : u_xlat2.z;
                u_xlat2 = hlslcc_movcTemp;
                }
                u_xlat2.xyz = clamp(u_xlat2.xyz, 0.0, 1.0);
                u_xlat13.xyz = u_xlat1.xyz * u_xlat2.xyz;
                u_xlat1.xyz = (-u_xlat1.xyz) * u_xlat2.xyz + u_xlat1.xyz;
                u_xlat1.xyz = vec3(u_xlat31) * u_xlat1.xyz + u_xlat13.xyz;
                u_xlat13.xyz = vec3(u_xlat30) * vec3(0.350000024, 0.45294112, 0.607352912) + vec3(0.5, 0.397058904, 0.242647097);
                u_xlat3.xyz = u_xlat13.xyz * u_xlat7.xyz + u_xlat3.xxx;
                u_xlat31 = _rimpower * 9.0 + 1.0;
                u_xlat31 = u_xlat4.x * u_xlat31;
                u_xlat31 = exp2(u_xlat31);
                u_xlat31 = u_xlat31 * 5.0 + -2.0;
                u_xlat16_4.xy = u_xlat16_8.xz * vec2(0.5, 2.5) + vec2(0.5, -1.5);
                u_xlat31 = min(u_xlat31, u_xlat16_4.y);
                u_xlat31 = clamp(u_xlat31, 0.0, 1.0);
                u_xlat31 = u_xlat16_8.x * u_xlat31;
                u_xlat3.xyz = vec3(u_xlat31) * vec3(_rimV) + u_xlat3.xyz;
                u_xlat3.xyz = (-u_xlat1.xyz) + u_xlat3.xyz;
                u_xlat1.xyz = vec3(u_xlat30) * u_xlat3.xyz + u_xlat1.xyz;
                u_xlat3.xyz = _LightColor0.xyz * vec3(0.600000024, 0.600000024, 0.600000024) + vec3(0.400000006, 0.400000006, 0.400000006);
                u_xlat14.xyz = max(u_xlat3.xyz, _ambientshadowG.xyz);
                u_xlat1.xyz = u_xlat1.xyz * u_xlat14.xyz;
                u_xlat0.xyz = u_xlat0.xyz * u_xlat2.xyz;
                u_xlat14.xyz = (-u_xlat0.xyz) * u_xlat16_4.xxx + vec3(1.0, 1.0, 1.0);
                u_xlat0.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
                u_xlat30 = _LineColorG.w + -0.5;
                u_xlat30 = (-u_xlat30) * 2.0 + 1.0;
                u_xlat4.xyz = (-vec3(u_xlat30)) * u_xlat14.xyz + vec3(1.0, 1.0, 1.0);
                u_xlat30 = _LineColorG.w + _LineColorG.w;
                u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat30);
                u_xlatb30 = 0.5<_LineColorG.w;
                u_xlat0.xyz = (bool(u_xlatb30)) ? u_xlat4.xyz : u_xlat0.xyz;
                u_xlat0.xyz = clamp(u_xlat0.xyz, 0.0, 1.0);
                u_xlat0.xyz = u_xlat3.xyz * u_xlat0.xyz;
                u_xlat3.xyz = (-u_xlat2.xyz) + vec3(1.0, 1.0, 1.0);
                u_xlat2.xyz = vec3(u_xlat32) * u_xlat3.xyz + u_xlat2.xyz;
                u_xlat1.xyz = u_xlat1.xyz * u_xlat2.xyz + (-u_xlat0.xyz);
                u_xlat30 = (-_linewidthG) + 1.0;
                u_xlat30 = u_xlat30 * 0.800000012 + 0.200000003;
                u_xlat30 = log2(u_xlat30);
                u_xlat30 = u_xlat30 * u_xlat10_6.y;
                u_xlat30 = exp2(u_xlat30);
                u_xlat30 = min(u_xlat35, u_xlat30);
                u_xlat30 = u_xlat30 + -1.0;
                u_xlat30 = _linetexon * u_xlat30 + 1.0;
                SV_Target0.xyz = vec3(u_xlat30) * u_xlat1.xyz + u_xlat0.xyz;
                SV_Target0.w = 1.0;
                return SV_Target0;
            }
            #endif
            ENDCG
        }
        UsePass "VertexLit/SHADOWCASTER"
    }
}
