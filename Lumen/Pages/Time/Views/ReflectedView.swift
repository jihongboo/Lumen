//
//  ReflectedGlassTimeText.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

private let reflectedViewRippleBandCount = 6

struct ReflectedView<Content: View>: View {
    let fontSize: CGFloat
    let isAnimating: Bool
    @ViewBuilder let content: () -> Content
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: isAnimating ? 1.0 / 24.0 : Double.infinity)) { timeline in
            reflection(phase: timeline.date.timeIntervalSinceReferenceDate, height: fontSize * 0.64)
        }
    }
    
    private func reflection(phase: TimeInterval, height: CGFloat) -> some View {
        waterRippleReflection(phase: phase, height: height)
            .mask {
                LinearGradient(
                    colors: [.white.opacity(0.86), .white.opacity(0.34), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(height: height)
            .offset(y: -fontSize * 0.08)
    }
    
    private var reflectedContent: some View {
        content()
            .frame(height: fontSize * 1.06)
            .scaleEffect(x: 1, y: -0.58, anchor: .center)
            .blur(radius: 2.4)
            .frame(height: fontSize * 0.64)
    }
    
    private func waterRippleReflection(phase: TimeInterval, height: CGFloat) -> some View {
        ZStack {
            ForEach(0..<reflectedViewRippleBandCount, id: \.self) { band in
                reflectedContent
                    .scaleEffect(x: bandScale(for: band, phase: phase), y: 1, anchor: .center)
                    .offset(
                        x: bandOffset(for: band, phase: phase),
                        y: bandVerticalDrift(for: band, phase: phase)
                    )
                    .mask(alignment: .top) {
                        rippleBandMask(band: band, height: height)
                    }
            }
        }
    }
    
    private func rippleBandMask(band: Int, height: CGFloat) -> some View {
        let bandHeight = height / CGFloat(reflectedViewRippleBandCount)
        
        return VStack(spacing: 0) {
            Color.clear
                .frame(height: bandHeight * CGFloat(band))
            
            LinearGradient(
                colors: [.clear, .white, .white, .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: bandHeight + 2)
            
            Spacer(minLength: 0)
        }
        .frame(height: height)
    }
    
    private func bandOffset(for band: Int, phase: TimeInterval) -> CGFloat {
        let progress = CGFloat(band) / CGFloat(reflectedViewRippleBandCount - 1)
        let phase = CGFloat(phase)
        let wideWave = sin(phase * 1.05 + progress * 6.2)
        let fineWave = sin(phase * 2.4 + progress * 13.0) * 0.36
        
        return (wideWave + fineWave) * fontSize * (0.014 + progress * 0.042)
    }
    
    private func bandVerticalDrift(for band: Int, phase: TimeInterval) -> CGFloat {
        let progress = CGFloat(band) / CGFloat(reflectedViewRippleBandCount - 1)
        return sin(CGFloat(phase) * 1.55 + progress * 9.0) * fontSize * (0.0045 + progress * 0.0045)
    }
    
    private func bandScale(for band: Int, phase: TimeInterval) -> CGFloat {
        let progress = CGFloat(band) / CGFloat(reflectedViewRippleBandCount - 1)
        return 1 + sin(CGFloat(phase) * 1.25 + progress * 7.4) * (0.006 + progress * 0.0075)
    }
}

#Preview {
    ReflectedView(fontSize: 120, isAnimating: true) {
        GlassGlyphTimeText(text: "22:48", fontSize: 120)
    }
    .padding()
    .background(.black)
}
