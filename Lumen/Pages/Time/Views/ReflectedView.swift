//
//  ReflectedGlassTimeText.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct ReflectedView<Content: View>: View {
    let fontSize: CGFloat
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        content()
            .frame(height: fontSize * 1.06)
            .scaleEffect(x: 1, y: -0.52, anchor: .center)
            .blur(radius: 3.5)
            .mask {
                LinearGradient(
                    colors: [.white.opacity(0.72), .white.opacity(0.22), .clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(height: fontSize * 0.58)
            .offset(y: -fontSize * 0.08)
    }
}

#Preview {
    ReflectedView(fontSize: 120) {
        GlassGlyphTimeText(text: "22:48", fontSize: 120)
    }
    .padding()
    .background(.black)
}
