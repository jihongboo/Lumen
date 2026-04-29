//
//  FlowingLightBands.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct FlowingLightBands: View {
    let time: TimeInterval
    let accent: Color

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height

            ZStack {
                band(width: width * 1.26, height: height * 0.18, opacity: 0.34)
                    .offset(
                        x: CGFloat(sin(time * 0.14)) * width * 0.3,
                        y: -height * 0.08 + CGFloat(cos(time * 0.1)) * height * 0.05
                    )
                    .rotationEffect(.degrees(-5 + sin(time * 0.12) * 4))

                band(width: width * 1.14, height: height * 0.14, opacity: 0.26)
                    .offset(
                        x: CGFloat(cos(time * 0.17 + 1.2)) * width * 0.34,
                        y: height * 0.12 + CGFloat(sin(time * 0.12)) * height * 0.05
                    )
                    .rotationEffect(.degrees(4 + cos(time * 0.14) * 3.5))

                band(width: width * 0.96, height: height * 0.1, opacity: 0.22)
                    .offset(
                        x: CGFloat(sin(time * 0.21 + 2.1)) * width * 0.38,
                        y: height * 0.28 + CGFloat(cos(time * 0.13 + 0.6)) * height * 0.04
                    )
                    .rotationEffect(.degrees(-2 + sin(time * 0.16) * 2.4))
            }
            .blendMode(.screen)
        }
    }

    private func band(width: CGFloat, height: CGFloat, opacity: Double) -> some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(opacity * 0.4),
                        accent.opacity(opacity),
                        .white.opacity(opacity * 0.6),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: height)
            .blur(radius: height * 0.34)
    }
}

#Preview {
    FlowingLightBands(time: 0, accent: .pink)
        .background(.black)
}
