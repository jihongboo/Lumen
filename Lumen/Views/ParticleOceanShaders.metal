//
//  ParticleOceanShaders.metal
//  Lumen
//
//  Created by Codex on 2026/5/21.
//

#include <metal_stdlib>
using namespace metal;

struct ParticleOceanUniforms {
    float time;
    float2 viewportSize;
};

struct ParticleOceanVertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex ParticleOceanVertexOut particleOceanVertex(uint vertexID [[vertex_id]]) {
    float2 positions[3] = {
        float2(-1.0, -1.0),
        float2(3.0, -1.0),
        float2(-1.0, 3.0)
    };

    float2 position = positions[vertexID];
    ParticleOceanVertexOut out;
    out.position = float4(position, 0.0, 1.0);
    out.uv = position * 0.5 + 0.5;
    return out;
}

static float hash21(float2 p) {
    p = fract(p * float2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

static float waveHeight(float x, float z, float time) {
    float longSwell = sin(x * 0.42 + z * 0.34 - time * 1.05) * 0.92;
    float sideSwell = sin(x * 0.86 - z * 0.21 + time * 0.76) * 0.42;
    float ridge = sin(z * 0.58 + time * 0.58) * 0.3;
    return longSwell + sideSwell + ridge;
}

static float gridDot(float2 world, float time, float perspective, thread float &heightField, thread float &haloField) {
    float cellSize = 0.34;
    float2 grid = world / cellSize;
    float2 cell = floor(grid);
    float2 local = fract(grid) - 0.5;
    float2 center = (cell + 0.5) * cellSize;

    float height = waveHeight(center.x, center.y, time);
    float apparentLift = height * perspective * 0.38;
    float2 displaced = float2(local.x, local.y + apparentLift) * cellSize;
    heightField = height;

    float distanceToDot = length(displaced);
    float dotRadius = mix(0.028, 0.048, perspective);
    float haloRadius = dotRadius * 3.4;
    float pixelWidth = max(fwidth(distanceToDot), 0.0015);
    float dot = 1.0 - smoothstep(dotRadius - pixelWidth * 1.25, dotRadius + pixelWidth * 1.25, distanceToDot);
    float halo = 1.0 - smoothstep(dotRadius, haloRadius + pixelWidth * 2.2, distanceToDot);

    float cellFrequency = max(length(fwidth(grid)), 0.0001);
    float subpixelFade = 1.0 - smoothstep(0.55, 1.35, cellFrequency);
    float horizonFade = smoothstep(0.035, 0.13, perspective);

    float shimmerSeed = hash21(cell);
    float shimmer = 0.68 + 0.32 * sin(time * (1.2 + shimmerSeed) + shimmerSeed * 6.28318);
    float visibility = shimmer * subpixelFade * horizonFade;
    haloField = halo * visibility;
    return dot * visibility;
}

fragment float4 particleOceanFragment(
    ParticleOceanVertexOut in [[stage_in]],
    constant ParticleOceanUniforms &uniforms [[buffer(0)]]
) {
    float2 uv = in.uv;
    float aspect = max(uniforms.viewportSize.x / max(uniforms.viewportSize.y, 1.0), 1.0);
    float time = uniforms.time;

    float horizon = 0.62;
    float belowHorizon = step(uv.y, horizon);
    float perspective = saturate((horizon - uv.y) / horizon);
    float depth = 1.0 / max(perspective, 0.035);
    float worldZ = depth * 2.15 + time * 0.58;
    float worldX = (uv.x - 0.5) * aspect * depth * 1.45;

    float surface = waveHeight(worldX, worldZ, time);
    float projectedY = uv.y + surface * perspective * 0.12;
    float correctedPerspective = saturate((horizon - projectedY) / horizon);
    float correctedDepth = 1.0 / max(correctedPerspective, 0.035);
    float2 world = float2(
        (uv.x - 0.5) * aspect * correctedDepth * 1.45,
        correctedDepth * 2.15 + time * 0.58
    );

    float heightField = 0.0;
    float halos = 0.0;
    float dots = gridDot(world, time, correctedPerspective, heightField, halos) * belowHorizon;
    halos *= belowHorizon;
    float nearGlow = smoothstep(0.18, 1.0, correctedPerspective);
    float crestLight = smoothstep(-0.18, 1.1, heightField) * belowHorizon;

    float3 color = float3(0.002, 0.002, 0.002);
    color += float3(0.018, 0.018, 0.017) * nearGlow;
    color += float3(0.46, 0.46, 0.43) * halos * (0.18 + crestLight * 0.16);
    color += float3(0.88, 0.88, 0.84) * dots * (0.82 + crestLight * 0.42);
    color += float3(1.0, 0.99, 0.92) * pow(saturate(dots), 3.2) * (1.55 + crestLight * 0.9);

    float ridgeGlow = smoothstep(0.55, 0.02, abs(projectedY - horizon + 0.03));
    color += float3(0.1, 0.1, 0.095) * ridgeGlow * belowHorizon;

    float skyFade = smoothstep(horizon - 0.04, horizon + 0.18, uv.y);
    color = mix(color, float3(0.008, 0.008, 0.008), skyFade);

    float sideVignette = smoothstep(0.74, 0.18, abs(uv.x - 0.5));
    float bottomVignette = smoothstep(0.0, 0.18, uv.y);
    color *= 0.22 + sideVignette * 0.78;
    color *= 0.68 + bottomVignette * 0.32;

    return float4(color, 1.0);
}

static float noise21(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    float a = hash21(i);
    float b = hash21(i + float2(1.0, 0.0));
    float c = hash21(i + float2(0.0, 1.0));
    float d = hash21(i + float2(1.0, 1.0));
    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

static float fbm(float2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += noise21(p) * amplitude;
        p = p * 2.03 + 17.7;
        amplitude *= 0.5;
    }
    return value;
}

fragment float4 auroraVeilFragment(
    ParticleOceanVertexOut in [[stage_in]],
    constant ParticleOceanUniforms &uniforms [[buffer(0)]]
) {
    float2 uv = in.uv;
    float aspect = uniforms.viewportSize.x / max(uniforms.viewportSize.y, 1.0);
    float2 p = float2((uv.x - 0.5) * aspect, uv.y);
    float time = uniforms.time;

    float3 color = float3(0.003, 0.006, 0.014);
    float upperMask = smoothstep(0.08, 0.78, uv.y) * smoothstep(1.05, 0.56, uv.y);

    for (int i = 0; i < 5; i++) {
        float layer = float(i);
        float ribbonCenter = 0.34
            + 0.075 * sin(p.x * (2.0 + layer * 0.45) + time * (0.32 + layer * 0.05) + layer)
            + 0.055 * sin(p.x * (5.0 + layer) - time * 0.22 + layer * 1.7);
        float ribbon = exp(-pow((uv.y - ribbonCenter - layer * 0.048) * (10.5 + layer * 1.7), 2.0));
        float texture = fbm(float2(p.x * 2.0 + layer * 8.0, uv.y * 5.0 - time * 0.28));
        float glow = ribbon * texture * upperMask;
        float3 tint = mix(float3(0.0, 0.95, 0.62), float3(0.52, 0.36, 1.0), float(layer) / 4.0);
        color += tint * glow * (0.45 + layer * 0.12);
    }

    float starSeed = hash21(floor(float2(uv.x * aspect, uv.y) * float2(170.0, 110.0)));
    float stars = smoothstep(0.992, 1.0, starSeed) * smoothstep(0.5, 1.0, uv.y);
    color += float3(0.65, 0.78, 1.0) * stars * (0.35 + 0.65 * sin(time + starSeed * 6.28318));

    float vignette = smoothstep(0.9, 0.18, distance(uv, float2(0.5, 0.55)));
    color *= 0.45 + vignette * 0.8;
    return float4(color, 1.0);
}

fragment float4 starTunnelFragment(
    ParticleOceanVertexOut in [[stage_in]],
    constant ParticleOceanUniforms &uniforms [[buffer(0)]]
) {
    float2 uv = in.uv;
    float aspect = uniforms.viewportSize.x / max(uniforms.viewportSize.y, 1.0);
    float2 p = float2((uv.x - 0.5) * aspect, uv.y - 0.5);
    float time = uniforms.time * 0.62;

    float angle = atan2(p.y, p.x);
    float radius = length(p);
    float tunnel = 0.0;
    float glow = 0.0;

    for (int i = 0; i < 4; i++) {
        float depth = fract(time * (0.22 + float(i) * 0.05) + float(i) * 0.23);
        float scale = mix(9.0, 0.85, depth);
        float2 starSpace = float2(cos(angle), sin(angle)) * radius * scale;
        float2 grid = starSpace * 16.0;
        float2 cell = floor(grid);
        float2 local = fract(grid) - 0.5;
        float seed = hash21(cell + float(i) * 41.0);
        float active = smoothstep(0.88, 1.0, seed);
        float d = length(local);
        float pixel = max(fwidth(d), 0.001);
        float star = (1.0 - smoothstep(0.045 - pixel, 0.045 + pixel * 2.0, d)) * active;
        float fade = smoothstep(0.0, 0.24, depth) * smoothstep(1.0, 0.62, depth);
        tunnel += star * fade;
        glow += exp(-d * 11.0) * active * fade * 0.12;
    }

    float ring = sin(radius * 34.0 - time * 8.0 + sin(angle * 5.0) * 1.8) * 0.5 + 0.5;
    float3 color = float3(0.002, 0.003, 0.009);
    color += float3(0.14, 0.24, 0.52) * pow(1.0 - saturate(radius), 2.2);
    color += float3(0.32, 0.64, 1.0) * ring * smoothstep(0.12, 0.92, radius) * 0.08;
    color += float3(0.95, 0.98, 1.0) * tunnel;
    color += float3(0.35, 0.65, 1.0) * glow;

    float vignette = smoothstep(1.05, 0.18, radius);
    color *= 0.35 + vignette;
    return float4(color, 1.0);
}

fragment float4 chromaBloomFragment(
    ParticleOceanVertexOut in [[stage_in]],
    constant ParticleOceanUniforms &uniforms [[buffer(0)]]
) {
    float2 uv = in.uv;
    float aspect = uniforms.viewportSize.x / max(uniforms.viewportSize.y, 1.0);
    float2 p = float2((uv.x - 0.5) * aspect, uv.y - 0.5);
    float time = uniforms.time * 0.38;

    float field = fbm(p * 2.2 + float2(time, -time * 0.7));
    field += fbm(p * 4.0 + float2(-time * 0.4, time * 0.6)) * 0.55;
    float petals = sin(atan2(p.y, p.x) * 5.0 + field * 4.5 + time * 2.0) * 0.5 + 0.5;
    float pulse = sin(length(p) * 9.0 - time * 3.2 + field * 2.0) * 0.5 + 0.5;
    float bloom = smoothstep(0.18, 1.0, field * 0.72 + petals * 0.28);

    float3 teal = float3(0.0, 0.74, 0.72);
    float3 magenta = float3(0.92, 0.18, 0.72);
    float3 amber = float3(1.0, 0.62, 0.22);
    float3 color = mix(teal, magenta, smoothstep(0.1, 0.92, field));
    color = mix(color, amber, petals * pulse * 0.35);

    float centerGlow = exp(-dot(p, p) * 2.4);
    float edgeFade = smoothstep(0.98, 0.14, length(p));
    color *= bloom * 0.78 + centerGlow * 0.42;
    color += float3(0.95, 0.9, 1.0) * pow(saturate(bloom * pulse), 6.0) * 0.55;
    color *= edgeFade;
    color += float3(0.002, 0.002, 0.006);

    return float4(color, 1.0);
}

static float roundedBox(float2 p, float2 halfSize, float radius) {
    float2 q = abs(p) - halfSize + radius;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - radius;
}

static float diagonalPrismBand(float2 uv, float offset, float width, float feather) {
    float stripe = uv.x + uv.y * 0.76 + offset;
    float repeated = fract(stripe * 4.9) - 0.5;
    return 1.0 - smoothstep(width, width + feather, abs(repeated));
}

fragment float4 prismRefractionFragment(
    ParticleOceanVertexOut in [[stage_in]],
    constant ParticleOceanUniforms &uniforms [[buffer(0)]]
) {
    float2 uv = in.uv;
    float aspect = uniforms.viewportSize.x / max(uniforms.viewportSize.y, 1.0);
    float2 p = float2((uv.x - 0.5) * aspect, uv.y - 0.5);
    float time = uniforms.time * 0.28;

    float3 color = float3(0.028, 0.033, 0.047);
    float glassNoise = fbm(uv * 3.0 + float2(time * 0.2, -time * 0.12));
    color += float3(0.045, 0.05, 0.065) * glassNoise;

    float shadeBands = diagonalPrismBand(uv + float2(time * 0.016, -time * 0.012), 0.08, 0.1, 0.055);
    float sharpBands = diagonalPrismBand(uv + float2(time * 0.03, -time * 0.02), 0.36, 0.035, 0.022);
    color += float3(0.18, 0.19, 0.22) * shadeBands * 0.38;
    color -= float3(0.05, 0.055, 0.07) * (1.0 - shadeBands) * 0.45;
    color += float3(0.38, 0.4, 0.45) * sharpBands * 0.22;

    float2 windowCenter = float2(-0.2 * aspect, -0.02);
    float2 windowP = p - windowCenter;
    float windowDistance = roundedBox(windowP, float2(0.22, 0.17), 0.12);
    float innerGlass = 1.0 - smoothstep(-0.02, 0.08, windowDistance);
    float rim = 1.0 - smoothstep(0.0, 0.13, abs(windowDistance));
    float outerGlow = exp(-abs(windowDistance) * 7.5);

    float diagonalSlice = smoothstep(-0.08, 0.24, windowP.x + windowP.y * 1.15 + sin(time) * 0.04);
    float caustic = smoothstep(0.9, 0.12, abs(windowP.x + windowP.y * 1.45 - 0.06 * sin(time * 1.4)));
    caustic *= smoothstep(0.46, 0.06, length(windowP));

    color += float3(0.92, 0.94, 0.98) * outerGlow * 0.48;
    color += float3(1.0, 0.96, 0.92) * rim * 0.74;
    color += mix(float3(0.03, 0.18, 0.28), float3(0.72, 0.93, 1.0), diagonalSlice) * innerGlass * 0.86;
    color += float3(1.0, 0.98, 0.9) * caustic * 1.35;

    float dispersionR = diagonalPrismBand(uv + float2(0.016, -0.01) + time * 0.02, 0.28, 0.022, 0.025);
    float dispersionG = diagonalPrismBand(uv + float2(0.0, 0.0) + time * 0.018, 0.3, 0.024, 0.026);
    float dispersionB = diagonalPrismBand(uv + float2(-0.018, 0.012) + time * 0.016, 0.32, 0.026, 0.027);
    float dispersionMask = smoothstep(0.98, 0.1, length(windowP - float2(0.07, 0.04)));
    color += float3(dispersionR * 0.18, dispersionG * 0.14, dispersionB * 0.22) * dispersionMask;

    float sweep = smoothstep(0.045, 0.0, abs(uv.x + uv.y * 0.8 - 0.78 - sin(time * 0.7) * 0.08));
    color += float3(0.75, 0.82, 1.0) * sweep * 0.28;

    float vignette = smoothstep(0.94, 0.18, distance(uv, float2(0.46, 0.48)));
    color *= 0.38 + vignette * 0.82;
    color = pow(saturate(color), float3(0.9));
    return float4(color, 1.0);
}
