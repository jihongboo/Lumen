//
//  HorizonMist.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct HorizonMist: View {
    let time: TimeInterval
    let color: Color

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height

            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                color.opacity(0.04),
                                color.opacity(0.15),
                                color.opacity(0.04),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 2)
                    .blur(radius: 1.5)
                    .offset(y: height * 0.56)

                Ellipse()
                    .fill(color.opacity(0.11))
                    .frame(width: width * 0.42, height: height * 0.08)
                    .blur(radius: 26)
                    .offset(
                        x: CGFloat(cos(time * 0.11)) * width * 0.12,
                        y: height * 0.61 + CGFloat(sin(time * 0.09)) * height * 0.02
                    )

                ForEach(0..<5, id: \.self) { index in
                    Capsule()
                        .fill(color.opacity(0.1))
                        .frame(width: width * (0.48 + CGFloat(index) * 0.12), height: 20 + CGFloat(index) * 6)
                        .blur(radius: 18 + CGFloat(index) * 5)
                        .offset(
                            x: CGFloat(sin(time * (0.08 + Double(index) * 0.014) + Double(index))) * width * 0.18,
                            y: height * (0.55 + CGFloat(index) * 0.018) + CGFloat(cos(time * 0.07 + Double(index))) * height * 0.025
                        )
                }
            }
        }
    }
}

#Preview {
    HorizonMist(time: 0, color: .white)
        .background(.black)
}
