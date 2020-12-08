// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.35 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.35;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1021,x:33274,y:32498,varname:node_1021,prsc:2|diff-9592-RGB,normal-4413-RGB;n:type:ShaderForge.SFN_Tex2d,id:9592,x:32419,y:32330,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_9592,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:4413,x:32419,y:32555,ptovrint:False,ptlb:NormalMap,ptin:_NormalMap,varname:node_4413,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:False;n:type:ShaderForge.SFN_Color,id:6042,x:32646,y:32970,ptovrint:False,ptlb:overcolor1,ptin:_overcolor1,varname:node_6042,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:7449,x:32238,y:32330,ptovrint:False,ptlb:overtex1,ptin:_overtex1,varname:node_7449,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Color,id:6470,x:32792,y:32970,ptovrint:False,ptlb:overcolor2,ptin:_overcolor2,varname:node_6470,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:6291,x:32238,y:32555,ptovrint:False,ptlb:overtex2,ptin:_overtex2,varname:node_6291,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Color,id:3033,x:32931,y:32970,ptovrint:False,ptlb:overcolor3,ptin:_overcolor3,varname:node_3033,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:5881,x:32238,y:32762,ptovrint:False,ptlb:overtex3,ptin:_overtex3,varname:node_5881,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:9939,x:32419,y:32762,ptovrint:False,ptlb:NormalMapDetail,ptin:_NormalMapDetail,varname:node_9939,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:5729,x:32075,y:32330,ptovrint:False,ptlb:DetailMask,ptin:_DetailMask,varname:node_5729,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:8739,x:32075,y:32555,ptovrint:False,ptlb:LineMask,ptin:_LineMask,varname:node_8739,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:982,x:32075,y:32762,ptovrint:False,ptlb:AlphaMask,ptin:_AlphaMask,varname:node_982,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Color,id:9494,x:32646,y:32783,ptovrint:False,ptlb:ShadowColor,ptin:_ShadowColor,varname:node_9494,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.628,c2:0.628,c3:0.628,c4:1;n:type:ShaderForge.SFN_Color,id:6149,x:32792,y:32783,ptovrint:False,ptlb:SpecularColor,ptin:_SpecularColor,varname:node_6149,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:0;n:type:ShaderForge.SFN_Slider,id:4708,x:31740,y:32327,ptovrint:False,ptlb:DetailNormalMapScale,ptin:_DetailNormalMapScale,varname:node_4708,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:1727,x:31740,y:32439,ptovrint:False,ptlb:SpeclarHeight,ptin:_SpeclarHeight,varname:node_1727,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.98,max:1;n:type:ShaderForge.SFN_Slider,id:400,x:31740,y:32555,ptovrint:False,ptlb:SpecularPower,ptin:_SpecularPower,varname:node_400,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:7652,x:31740,y:32664,ptovrint:False,ptlb:SpecularPowerNail,ptin:_SpecularPowerNail,varname:node_7652,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:7578,x:31740,y:32791,ptovrint:False,ptlb:ShadowExtend,ptin:_ShadowExtend,varname:node_7578,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:1;n:type:ShaderForge.SFN_Slider,id:7956,x:31740,y:32910,ptovrint:False,ptlb:rimpower,ptin:_rimpower,varname:node_7956,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Slider,id:7547,x:31740,y:33033,ptovrint:False,ptlb:rimV,ptin:_rimV,varname:node_7547,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:890,x:31740,y:33145,ptovrint:False,ptlb:nipsize,ptin:_nipsize,varname:node_890,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_ToggleProperty,id:7817,x:32089,y:33003,ptovrint:False,ptlb:alpha_a,ptin:_alpha_a,varname:node_7817,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True;n:type:ShaderForge.SFN_ToggleProperty,id:404,x:32238,y:33003,ptovrint:False,ptlb:alpha_b,ptin:_alpha_b,varname:node_404,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True;n:type:ShaderForge.SFN_ToggleProperty,id:2682,x:32394,y:33003,ptovrint:False,ptlb:linetexon,ptin:_linetexon,varname:node_2682,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:True;n:type:ShaderForge.SFN_ToggleProperty,id:2959,x:32089,y:33109,ptovrint:False,ptlb:notusetexspecular,ptin:_notusetexspecular,varname:node_2959,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False;n:type:ShaderForge.SFN_ToggleProperty,id:8656,x:32238,y:33109,ptovrint:False,ptlb:nip,ptin:_nip,varname:node_8656,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False;n:type:ShaderForge.SFN_Tex2d,id:4164,x:32075,y:32124,ptovrint:False,ptlb:liquidmask,ptin:_liquidmask,varname:node_4164,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:2123,x:32238,y:32124,ptovrint:False,ptlb:Texture2,ptin:_Texture2,varname:node_2123,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:7691,x:32419,y:32124,ptovrint:False,ptlb:Texture3,ptin:_Texture3,varname:node_7691,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:False;n:type:ShaderForge.SFN_Vector4Property,id:2803,x:32931,y:32783,ptovrint:False,ptlb:LiquidTiling,ptin:_LiquidTiling,varname:node_2803,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0,v2:0,v3:2,v4:0;n:type:ShaderForge.SFN_Slider,id:3487,x:31420,y:32323,ptovrint:False,ptlb:liquidftop,ptin:_liquidftop,varname:node_3487,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Slider,id:1157,x:31420,y:32440,ptovrint:False,ptlb:liquidfbot,ptin:_liquidfbot,varname:node_1157,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Slider,id:6072,x:31420,y:32551,ptovrint:False,ptlb:liquidbtop,ptin:_liquidbtop,varname:node_6072,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Slider,id:7684,x:31420,y:32670,ptovrint:False,ptlb:liquidbbot,ptin:_liquidbbot,varname:node_7684,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Slider,id:5877,x:31420,y:32791,ptovrint:False,ptlb:liquidface,ptin:_liquidface,varname:node_5877,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Slider,id:1365,x:31420,y:32909,ptovrint:False,ptlb:nip_specular,ptin:_nip_specular,varname:node_1365,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Slider,id:3608,x:31420,y:33028,ptovrint:False,ptlb:tex1mask,ptin:_tex1mask,varname:node_3608,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Slider,id:7479,x:31420,y:33145,ptovrint:False,ptlb:Cutoff,ptin:_Cutoff,varname:node_7479,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.5,max:1;n:type:ShaderForge.SFN_Tex2d,id:5927,x:32578,y:32124,ptovrint:False,ptlb:NormalMask,ptin:_NormalMask,varname:node_5927,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False;proporder:9592-6042-7449-6470-6291-3033-5881-4413-9939-5729-8739-982-9494-6149-4708-1727-400-7652-7578-7956-7547-890-7817-404-2682-2959-8656-4164-2123-7691-2803-3487-1157-6072-7684-5877-1365-3608-5927-7479;pass:END;sub:END;*/

Shader "Shader Forge/main_skin" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _overcolor1 ("overcolor1", Color) = (1,1,1,1)
        _overtex1 ("overtex1", 2D) = "black" {}
        _overcolor2 ("overcolor2", Color) = (1,1,1,1)
        _overtex2 ("overtex2", 2D) = "black" {}
        _overcolor3 ("overcolor3", Color) = (1,1,1,1)
        _overtex3 ("overtex3", 2D) = "black" {}
        _NormalMap ("NormalMap", 2D) = "bump" {}
        _NormalMapDetail ("NormalMapDetail", 2D) = "bump" {}
        _DetailMask ("DetailMask", 2D) = "black" {}
        _LineMask ("LineMask", 2D) = "black" {}
        _AlphaMask ("AlphaMask", 2D) = "white" {}
        _ShadowColor ("ShadowColor", Color) = (0.628,0.628,0.628,1)
        _SpecularColor ("SpecularColor", Color) = (1,1,1,0)
        _DetailNormalMapScale ("DetailNormalMapScale", Range(0, 1)) = 0
        _SpeclarHeight ("SpeclarHeight", Range(0, 1)) = 0.98
        _SpecularPower ("SpecularPower", Range(0, 1)) = 0
        _SpecularPowerNail ("SpecularPowerNail", Range(0, 1)) = 0
        _ShadowExtend ("ShadowExtend", Range(0, 1)) = 1
        _rimpower ("rimpower", Range(0, 1)) = 0.5
        _rimV ("rimV", Range(0, 1)) = 0
        _nipsize ("nipsize", Range(0, 1)) = 0.5
        [MaterialToggle] _alpha_a ("alpha_a", Float ) = 1
        [MaterialToggle] _alpha_b ("alpha_b", Float ) = 1
        [MaterialToggle] _linetexon ("linetexon", Float ) = 1
        [MaterialToggle] _notusetexspecular ("notusetexspecular", Float ) = 0
        [MaterialToggle] _nip ("nip", Float ) = 0
        _liquidmask ("liquidmask", 2D) = "black" {}
        _Texture2 ("Texture2", 2D) = "black" {}
        _Texture3 ("Texture3", 2D) = "bump" {}
        _LiquidTiling ("LiquidTiling", Vector) = (0,0,2,0)
        _liquidftop ("liquidftop", Range(0, 2)) = 0
        _liquidfbot ("liquidfbot", Range(0, 2)) = 0
        _liquidbtop ("liquidbtop", Range(0, 2)) = 0
        _liquidbbot ("liquidbbot", Range(0, 2)) = 0
        _liquidface ("liquidface", Range(0, 2)) = 0
        _nip_specular ("nip_specular", Range(0, 1)) = 0.5
        _tex1mask ("tex1mask", Range(0, 1)) = 0
        _NormalMask ("NormalMask", 2D) = "black" {}
        _Cutoff ("Cutoff", Range(0, 1)) = 0.5
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 _NormalMap_var = tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap));
                float3 normalLocal = _NormalMap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 diffuseColor = _MainTex_var.rgb;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float4 _NormalMap_var = tex2D(_NormalMap,TRANSFORM_TEX(i.uv0, _NormalMap));
                float3 normalLocal = _NormalMap_var.rgb;
                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 diffuseColor = _MainTex_var.rgb;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "PlaceholderShaderUI"
}