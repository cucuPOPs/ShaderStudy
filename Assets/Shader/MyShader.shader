Shader "CustomShader/MyShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} //0

        //glow
        _GlowColor("Glow Color", Color) = (1,1,1,1)//1
        _GlowPower("Glow Power", Range(0,1)) = 1//2
        //end glow

        //negative
        _NegativeAmount("Negative Amount", Range(0, 1)) = 1 //3
        //end negative

        //greyScale
        _GreyScaleAmount("GreyScale Amount",Range(0,1))=1//4
        //end greyScale

    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        Pass
        {
            Cull Off
            Blend One OneMinusSrcAlpha // Premultiplied transparency

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature GLOW_ON
            #pragma shader_feature NEGATIVE_ON
            #pragma shader_feature GREYSCALE_ON

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            //negative 변수
            #if NEGATIVE_ON
            float _NegativeAmount;
            #endif

            //glow 변수
            #if GLOW_ON
            float4 _GlowColor;
            float _GlowPower;
            #endif

            //greyScale 변수
            #if GREYSCALE_ON
            float _GreyScaleAmount;
            #endif

            Interpolators vert(MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                //return float4(i.uv,0,1); //for test

                float4 col = tex2D(_MainTex, i.uv);

                #if NEGATIVE_ON
                col.rgb = lerp(col.rgb, 1 - col.rgb, _NegativeAmount);
                #endif

                #if GLOW_ON
                col.rgb += col.a * _GlowPower * _GlowColor;
                #endif

                #if GREYSCALE_ON
                col.rgb = lerp(col.rgb, (col.r + col.g + col.b) / 3, _GreyScaleAmount);
                #endif

                col.rgb *= col.a;
                col *= i.color;
                return col;
            }
            ENDCG
        }
    }
    CustomEditor "MyShader"
}