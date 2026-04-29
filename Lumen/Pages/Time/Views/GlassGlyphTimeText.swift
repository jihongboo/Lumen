//
//  GlassGlyphTimeText.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct GlassGlyphTimeText: View {
    let text: String
    let fontSize: CGFloat

    var body: some View {
        glassFill
            .mask(timeMask)
            .overlay {
                timeMask
                    .foregroundStyle(.white.opacity(0.2))
                    .blur(radius: 0.8)
                    .offset(x: -1, y: -1)
            }
            .overlay {
                timeMask
                    .strokeStyleOverlay(fontSize: fontSize)
            }
            .shadow(color: .white.opacity(0.46), radius: 18)
            .shadow(color: .black.opacity(0.28), radius: 14, x: 0, y: 10)
            .frame(maxWidth: .infinity)
            .accessibilityLabel(text)
    }

    private var timeMask: Text {
        Text(text)
            .font(.system(size: fontSize, weight: .thin, design: .rounded))
            .monospacedDigit()
    }

    private var glassFill: some View {
        ZStack {
            LinearGradient(
                colors: [
                    .white.opacity(0.92),
                    .white.opacity(0.38),
                    .cyan.opacity(0.14),
                    .white.opacity(0.72)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            LinearGradient(
                colors: [.clear, .white.opacity(0.8), .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blur(radius: 4)
            .offset(y: -fontSize * 0.18)
        }
        .frame(height: fontSize * 1.04)
    }
}

#Preview {
    GlassGlyphTimeText(text: "22:48", fontSize: 120)
        .padding()
        .background(.gray)
}
