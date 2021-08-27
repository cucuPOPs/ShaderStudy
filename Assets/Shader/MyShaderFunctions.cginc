float InverseLerp(float a, float b, float v)
{
    return (v - a) / (b - a);
    //lerp(a,b,t)=result
    //inverseLerp(a,b,result)=t
}

float4 Blur(float2 uv, sampler2D source, half Intensity)
{
    float step = 0.00390625f * Intensity; // step = 1 / 256 * Intensity;
    float4 result = float4 (0, 0, 0, 0);
    float2 texCoord = float2(0, 0);
	
    texCoord = uv + float2(-step, -step);
    result += tex2D(source, texCoord); //1
	
    texCoord = uv + float2(-step, 0);
    result += 2.0 * tex2D(source, texCoord);//2
	
    texCoord = uv + float2(-step, step);
    result += tex2D(source, texCoord);//1
	
    texCoord = uv + float2(0, -step);
    result += 2.0 * tex2D(source, texCoord);//2
	
    texCoord = uv;
    result += 4.0 * tex2D(source, texCoord);//4
	
    texCoord = uv + float2(0, step);
    result += 2.0 * tex2D(source, texCoord);//2
	
    texCoord = uv + float2(step, -step);
    result += tex2D(source, texCoord);//1
	
    texCoord = uv + float2(step, 0);
    result += 2.0 * tex2D(source, texCoord);//2
	
    texCoord = uv + float2(step, -step);
    result += tex2D(source, texCoord);//1
    
    result = result * 0.0625f;//result = result / 16;
    return result;
}