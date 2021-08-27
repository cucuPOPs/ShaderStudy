Shader "CustomShader/MyShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {} //0

        //glow
        _GlowColor("Glow Color", Color) = (1,1,1,1) //1
        _GlowPower("Glow Power", Range(0,1)) = 0 //2
        //end glow

        //negative
        _NegativeAmount("Negative Amount", Range(0, 1)) = 0 //3
        //end negative

        //greyScale
        _GreyScaleAmount("GreyScale Amount",Range(0,1)) = 0 //4
        //end greyScale

        //gradient vertical & horizontal
        _GradBlend("Gradient Blend", Range(0,1)) = 1 //5
        _GradTopLeftCol("_GradTopLeftCol", Color) = (1,0,0,1) //6
        _GradTopRightCol("_GradTopRightCol", Color) = (1,0,0,1) //7
        _GradBottomLeftCol("_GradBottomLeftCol", Color) = (1,0,0,1) //8
        _GradBottomRightCol("_GradBottomRightCol", Color) = (1,0,0,1) //9
        _GradXStart("_GradXStart", Float)=0.5 //10
        _GradXEnd("_GradXEnd", Float)=0.8 //11
        _GradYStart("_GradYStart", Float)=0.5 //12
        _GradYEnd("_GradYEnd", Float)=0.8 //13
        _GradXOffset("_GradXOffset",Float)=0//14
        _GradYOffset("_GradYOffset",Float)=0//15
        //end gradient

        //gradient radical
        _GradRadicalBlend("Gradient Radical Blend", Range(0,1)) = 1 //16
        _GradRA("_GradA", Color) = (1,0,0,1) //17
        _GradRB("_GradB", Color) = (1,0,0,1) //18
        _GradRStart("_GradXStart", Range(0,1)) = 0.5 //19
        _GradREnd("_GradXEnd", Range(0,1)) = 0.8 //20
        _GradROffset("_gradOffset",Float) = 0 //21
        //end gradient


        //pixelate
        _PixelateSize("Pixelate size", Range(4,512)) = 32 //22
        //end pixelate

        //blur
        _BlurIntensity("Blur Intensity", Range(0,10)) = 10 //23
        //end blur

        //shadow
        _ShadowX("Shadow X Axis", Range(-0.5, 0.5)) = 0.1 //24
        _ShadowY("Shadow Y Axis", Range(-0.5, 0.5)) = 0.1 //25
        _ShadowAlpha("Shadow Alpha", Range(0, 1)) = 0.5 //26
        _ShadowColor("Shadow Color", Color) = (0, 0, 0, 1) //27
        //end shadow

        //outline
        _OutlineColor("_OutlineColor", Color) = (0,0,0,1) //28
        _OutlineWidth("_OutlineWidth", Range(0, 16)) = 1 //29
        [Toggle()]_Outline8Dir("use 8 dir?", Float) = 1 //30
        //end outline
        
        //wave
        _WaveAmount("Wave Amount", Range(0, 25)) = 7 //31
		_WaveSpeed("Wave Speed", Range(0, 25)) = 10 //32
		_WaveStrength("Wave Strength", Range(0, 25)) = 7.5 //33
		_WaveX("Wave X Axis", Range(0, 1)) = 0 //34
		_WaveY("Wave Y Axis", Range(0, 1)) = 0.5 //35
        //end wave
        
        //offset
        _OffsetUvX("X axis", Range(-1, 1)) = 0 //36
		_OffsetUvY("Y axis", Range(-1, 1)) = 0 //37
        //end offset
        
        //waveTest
        _SineSpeed("_SineSpeed", Float) = 0.2 //38
		_SineAmp("_SineAmp", Float) = 0.1 //39
		_SineFrequency("_SineFrequency", Float) = 1 //40
        //endwaveTest
        
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
            Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #pragma shader_feature GLOW_ON
            #pragma shader_feature NEGATIVE_ON
            #pragma shader_feature GREYSCALE_ON
            #pragma shader_feature GRADIENT_ON
            #pragma shader_feature RADIALGRADIENT_ON
            #pragma shader_feature PIXELATE_ON
            #pragma shader_feature BLUR_ON
            #pragma shader_feature SHADOW_ON
            #pragma shader_feature OUTLINE_ON
            #pragma shader_feature OUTBASE8DIR_ON
            #pragma shader_feature WAVEUV_ON
            #pragma shader_feature OFFSETUV_ON
            #pragma shader_feature SINEWAVE_ON
            
            #include "UnityCG.cginc"
            #include "MyShaderFunctions.cginc"

            #define  TAU 6.28318530717958 //2 pi
            
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

            //gradient vertical & horizontal변수
            #if GRADIENT_ON
            float _GradBlend;
            float4 _GradTopLeftCol, _GradTopRightCol, _GradBottomLeftCol, _GradBottomRightCol;
            float _GradXStart, _GradXEnd;
            float _GradYStart, _GradYEnd;
            float _GradXOffset, _GradYOffset;
            #endif

            //gradient radical 변수
            #if RADIALGRADIENT_ON
            float _GradRadicalBlend;
            float4 _GradRA, _GradRB;
            float _GradRStart, _GradREnd;
            float _GradROffset;
            #endif

            // pixelate 변수
            #if PIXELATE_ON
            float _PixelateSize;
            #endif

            //blur 변수
            #if BLUR_ON
            float _BlurIntensity;
            #endif


            //shadow 변수
            #if SHADOW_ON
            float _ShadowX, _ShadowY, _ShadowAlpha;
            float4 _ShadowColor;
            #endif

            //outline 변수
            #if OUTLINE_ON
            float4 _OutlineColor;
            float _OutlineAlpha, _OutlineGlow, _OutlineWidth;
            #endif
            //wave uv 변수
            #if WAVEUV_ON
			float _WaveAmount, _WaveSpeed, _WaveStrength, _WaveX, _WaveY;
			#endif

            //sine wave 변수
            #if SINEWAVE_ON
            float _SineSpeed;
            float _SineAmp;
            float _SineFrequency;
            #endif
            
            #if OFFSETUV_ON
            float _OffsetUvX,_OffsetUvY; 
            #endif
            
            Interpolators vert(MeshData v)
            {
                Interpolators o;
                o.vertex= UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                //return float4(i.uv,0,1); //for test
                #if PIXELATE_ON
                i.uv = floor(i.uv * _PixelateSize + 0.5) / _PixelateSize;
                #endif
                
                #if WAVEUV_ON
                float2 uvWave = i.uv-float2(_WaveX,_WaveY);
                float angWave = (uvWave * _WaveAmount) - (_Time.y *  _WaveSpeed);
				i.uv = i.uv + uvWave * sin(angWave) * (_WaveStrength / 1000.0);
				#endif
                #if SINEWAVE_ON
                i.uv.y += _SineAmp * sin(TAU * i.uv.x * _SineFrequency -(TAU*_Time.y*_SineSpeed));
                #endif
                
                #if OFFSETUV_ON
                i.uv +=float2(_OffsetUvX,_OffsetUvY);
                #endif

                float4 col = tex2D(_MainTex, i.uv);

                #if BLUR_ON
                col = Blur(i.uv, _MainTex, _BlurIntensity) * i.color;
                #endif

                #if NEGATIVE_ON
                col.rgb = lerp(col.rgb, 1 - col.rgb, _NegativeAmount);
                #endif

                #if GLOW_ON
                col.rgb += col.a * _GlowPower * _GlowColor;
                #endif

                #if GREYSCALE_ON
                col.rgb = lerp(col.rgb, (col.r + col.g + col.b) / 3, _GreyScaleAmount);
                #endif

                #if GRADIENT_ON
                float gardXlerpFactor = saturate(InverseLerp(_GradXStart + _GradXOffset, _GradXEnd + _GradXOffset,
                                                             i.uv.x));
                float gardYlerpFactor = saturate(InverseLerp(_GradYStart + _GradYOffset, _GradYEnd + _GradYOffset,
                                                             i.uv.y));
                float4 gradientResult = lerp(lerp(_GradBottomLeftCol, _GradBottomRightCol, gardXlerpFactor),
                                             lerp(_GradTopLeftCol, _GradTopRightCol, gardXlerpFactor), gardYlerpFactor);

                gradientResult = lerp(col, gradientResult, _GradBlend);
                col.rgb = gradientResult.rgb * col.a;
                col.a = col.a * gradientResult.a;
                #endif

                #if RADIALGRADIENT_ON
                float2 uvCenter = i.uv * 2 - 1; //중심
                float radicalDistance = length(uvCenter); //거리
                float gradlerpFactor = saturate(InverseLerp(_GradRStart + _GradROffset, _GradREnd + _GradROffset,
                                                            radicalDistance));
                float4 gradientRResult = lerp(_GradRA, _GradRB, gradlerpFactor);
                gradientRResult = lerp(col, gradientRResult, _GradRadicalBlend);
                col.rgb = gradientRResult.rgb * col.a;
                col.a = col.a * gradientRResult.a;
                #endif
                #if SHADOW_ON
                half shadowA = tex2D(_MainTex, i.uv + float2(_ShadowX, _ShadowY)).a;
                half preMultShadowMask = 1 - (saturate(shadowA - col.a) * (1 - col.a));
                col.rgb *= 1 - ((shadowA - col.a) * (1 - col.a));
                col.rgb += (_ShadowColor * shadowA) * (1 - col.a);
                col.a = max(shadowA * _ShadowAlpha * i.color.a, col.a);
                #endif

                #if OUTLINE_ON
                _OutlineWidth *= 0.01;
                float spriteLeft = tex2D(_MainTex, i.uv + float2(_OutlineWidth, 0)).a;
                float spriteRight = tex2D(_MainTex, i.uv + float2(-_OutlineWidth, 0)).a;
                float spriteBottom = tex2D(_MainTex, i.uv + float2(0, _OutlineWidth)).a;
                float spriteTop = tex2D(_MainTex, i.uv + float2(0, -_OutlineWidth)).a;
                float result = spriteLeft + spriteRight + spriteBottom + spriteTop;

                #if OUTBASE8DIR_ON
                float spriteTopLeft = tex2D(_MainTex, i.uv + float2(_OutlineWidth, _OutlineWidth)).a;
                float spriteTopRight = tex2D(_MainTex, i.uv + float2(-_OutlineWidth, _OutlineWidth)).a;
                float spriteBotLeft = tex2D(_MainTex, i.uv + float2(_OutlineWidth, -_OutlineWidth)).a;
                float spriteBotRight = tex2D(_MainTex, i.uv + float2(-_OutlineWidth, -_OutlineWidth)).a;
                result = result + spriteTopLeft + spriteTopRight + spriteBotLeft + spriteBotRight;
                #endif
                result = step(0.1, saturate(result));
                result *= (1 - col.a) * _OutlineColor.a;
                col = lerp(col, _OutlineColor, result);
                #endif
                
                
                
                col *= i.color;
                return col;
            }
            ENDCG
        }
    }
    CustomEditor "MyShader"
}