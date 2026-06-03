//
//  SWArtisticBackgrounds.metal
//  Lumen
//
//  Created by Codex on 2026/6/3.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

static float swArtHash(float2 p) {
    p = fract(p * float2(127.1, 311.7));
    p += dot(p, p + 37.19);
    return fract(p.x * p.y);
}

static float swArtNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    float2 u = f * f * (3.0 - 2.0 * f);
    float a = swArtHash(i);
    float b = swArtHash(i + float2(1.0, 0.0));
    float c = swArtHash(i + float2(0.0, 1.0));
    float d = swArtHash(i + float2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

static float swArtFBM(float2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 5; i++) {
        v += a * swArtNoise(p);
        p = p * 2.02 + float2(11.7, 7.3);
        a *= 0.5;
    }
    return v;
}

static float2 swArtRotate(float2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return float2(c * p.x - s * p.y, s * p.x + c * p.y);
}

[[ stitchable ]] half4 swAuroraVeil(float2 position,
                                    half4 color,
                                    float4 boundingRect,
                                    float time,
                                    float speed,
                                    float scale,
                                    float intensity,
                                    half4 base,
                                    half4 ribbon1,
                                    half4 ribbon2,
                                    half4 glow) {
    float2 size = boundingRect.zw;
    float2 uv = position / max(size, float2(1.0));
    float aspect = size.x / max(size.y, 1.0);
    float t = time * speed;

    float2 p = (uv - 0.5) * float2(aspect, 1.0) * max(scale, 0.001);
    float horizon = smoothstep(1.08, -0.18, uv.y);
    float curtain = 0.0;

    for (int i = 0; i < 4; i++) {
        float fi = float(i);
        float lane = 0.18 + fi * 0.13;
        float wave = sin((p.x * (2.2 + fi * 0.42)) + t * (1.2 + fi * 0.18) + fi);
        float warp = swArtFBM(p * (1.45 + fi * 0.22) + float2(t * 0.25, fi * 2.7));
        float ridge = 1.0 - smoothstep(0.0, 0.34, abs(uv.y - lane - wave * 0.055 - warp * 0.20));
        curtain += ridge * (0.46 - fi * 0.055);
    }

    float verticalGlow = pow(max(1.0 - uv.y, 0.0), 1.8) * 0.28;
    float stars = step(0.992, swArtHash(floor(uv * size.y * 0.36))) * smoothstep(0.92, 0.2, uv.y) * 0.26;
    float mist = swArtFBM(float2(p.x * 1.1, uv.y * 3.2) + float2(0.0, t * 0.18)) * 0.18;

    float3 b = float3(base.rgb);
    float3 r1 = float3(ribbon1.rgb);
    float3 r2 = float3(ribbon2.rgb);
    float3 g = float3(glow.rgb);

    float3 col = b;
    col = mix(col, r1, clamp(curtain * horizon * intensity, 0.0, 1.0));
    col += r2 * clamp(curtain * curtain * 0.62 * intensity, 0.0, 1.0);
    col += g * (verticalGlow + mist + stars);
    col *= 1.0 - length(p) * 0.12;

    return half4(half3(clamp(col, 0.0, 1.35)), 1.0h);
}

[[ stitchable ]] half4 swKaleidoscopeBloom(float2 position,
                                           half4 color,
                                           float4 boundingRect,
                                           float time,
                                           float speed,
                                           float petals,
                                           float bloom,
                                           half4 background,
                                           half4 petal1,
                                           half4 petal2,
                                           half4 highlight) {
    float2 size = boundingRect.zw;
    float2 p = (position * 2.0 - size) / max(max(size.x, size.y), 1.0);
    float t = time * speed;

    p = swArtRotate(p, sin(t * 0.3) * 0.24);
    float radius = length(p);
    float angle = atan2(p.y, p.x);
    float count = max(petals, 3.0);
    float folded = abs(fract(angle / 6.2831853 * count + 0.5) - 0.5) * 2.0;
    float lace = sin((1.0 - folded) * 3.1415926 + radius * 10.5 - t * 2.0);
    float veins = swArtFBM(float2(folded * 4.0, radius * 7.0) + float2(t * 0.25, -t * 0.18));
    float flower = smoothstep(1.45, 0.02, radius) * smoothstep(-0.55, 0.92, lace + veins * 0.65);
    float core = exp(-radius * radius * 5.0);
    float ring = smoothstep(0.014, 0.0, abs(radius - 1.02 - sin(t + folded * 5.0) * 0.055));
    float vignette = smoothstep(1.85, 0.26, radius);

    float3 bg = float3(background.rgb);
    float3 p1 = float3(petal1.rgb);
    float3 p2 = float3(petal2.rgb);
    float3 hi = float3(highlight.rgb);

    float3 col = bg;
    col = mix(col, p1, clamp(flower * bloom, 0.0, 1.0));
    col += p2 * clamp((flower * veins + ring * 0.42) * bloom, 0.0, 1.0);
    col += hi * (core * 0.72 + pow(max(flower, 0.0), 4.0) * 0.28);
    col *= vignette;

    return half4(half3(clamp(col, 0.0, 1.4)), 1.0h);
}

[[ stitchable ]] half4 swSilkVortex(float2 position,
                                    half4 color,
                                    float4 boundingRect,
                                    float time,
                                    float speed,
                                    float swirl,
                                    float contrast,
                                    half4 shadow,
                                    half4 silk1,
                                    half4 silk2,
                                    half4 glint) {
    float2 size = boundingRect.zw;
    float2 p = (position * 2.0 - size) / max(min(size.x, size.y), 1.0);
    float t = time * speed;

    float radius = length(p);
    float angle = atan2(p.y, p.x);
    float twist = angle + radius * (3.4 + swirl * 2.2) - t * 1.7;
    float2 q = float2(cos(twist), sin(twist)) * radius;
    q += float2(swArtFBM(p * 2.2 + t * 0.3), swArtFBM(p * 2.0 - t * 0.24)) * 0.34;

    float folds = sin(q.x * 8.0 + q.y * 3.2 + t * 1.6);
    folds += sin(q.y * 10.0 - q.x * 2.4 - t * 1.2) * 0.55;
    folds += swArtFBM(q * 3.0 + float2(t, -t) * 0.2) * 1.15;
    folds = folds * 0.5 + 0.5;
    folds = pow(clamp(folds, 0.0, 1.0), max(contrast, 0.001));

    float3 sh = float3(shadow.rgb);
    float3 s1 = float3(silk1.rgb);
    float3 s2 = float3(silk2.rgb);
    float3 gi = float3(glint.rgb);

    float3 col = mix(sh, s1, folds);
    col = mix(col, s2, smoothstep(0.42, 0.92, swArtFBM(q * 1.6 - t * 0.18)));
    col += gi * pow(folds, 8.0) * 0.34;
    col *= smoothstep(1.35, 0.12, radius);
    col += sh * pow(radius, 2.0) * 0.22;

    return half4(half3(clamp(col, 0.0, 1.35)), 1.0h);
}
