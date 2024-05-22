Shader "Custom/CrystalShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Refraction ("Refraction", Range(0, 1)) = 0.02
        _RimColor ("Rim Light Color", Color) = (1,1,1,1)
        _RimPower ("Rim Power", Range(1, 10)) = 3.0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Refraction;
            float4 _RimColor;
            float _RimPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, i.uv);

                float3 refractDir = refract(i.viewDir, i.normal, _Refraction);
                float2 refractUV = i.uv + refractDir.xy * _Refraction;
                fixed4 refractColor = tex2D(_MainTex, refractUV);

                float rim = 1.0 - saturate(dot(i.normal, i.viewDir));
                rim = pow(rim, _RimPower);
                fixed4 rimColor = rim * _RimColor;

                fixed4 finalColor = refractColor + rimColor;

                finalColor.a = texColor.a;

                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}