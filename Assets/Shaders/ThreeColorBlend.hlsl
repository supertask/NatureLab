void Unity_Blend_Overlay_float4(float4 Base, float4 Blend, float Opacity, out float4 Out)
{
	float4 result1 = 1.0 - 2.0 * (1.0 - Base) * (1.0 - Blend);
	float4 result2 = 2.0 * Base * Blend;
	float4 zeroOrOne = step(Base, 0.5);
	Out = result2 * zeroOrOne + (1 - zeroOrOne) * result1;
	Out = lerp(Base, Out, Opacity);
}

void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
{
	Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
}

void Blend(float4 a, float4 b, float Alpha, float2 alphaRange, out float4 Out) {
	float4 inAlpha = float4(Alpha, 0.0, 0.0, 0.0);
	float4 outAlpha = float4(0.0,   0.0, 0.0, 0.0);
	Unity_Remap_float4(inAlpha, alphaRange, float2(0.0, 1.0), outAlpha);
	//Unity_Blend_Overlay_float4(a, b, outAlpha.x, Out);
	Out = lerp(a, b, outAlpha.x);
}

void ThreeColorBlend_float(float4 A, float4 B, float4 C, float Alpha, out float4 Out)
{
	if (Alpha < 0.3) {
		Blend(A, B, Alpha, float2(0, 0.3), Out);
		//Out = A;
	}
	else if (Alpha > 0.6) {
		Out = C;
		//float4 xxx;
		//Blend(A, B, Alpha, float2(0.6, 1.0), Out);
	}
	else {
		Blend(B, C, Alpha, float2(0.3, 0.6), Out);
		//Out = B;
	}
}
