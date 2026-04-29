//
//  Text+StrokeStyleOverlay.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

extension Text {
    func strokeStyleOverlay(fontSize: CGFloat) -> some View {
        self
            .foregroundStyle(.clear)
            .overlay {
                self
                    .foregroundStyle(.white.opacity(0.42))
                    .blur(radius: max(0.35, fontSize * 0.004))
                    .offset(y: -fontSize * 0.008)
            }
    }
}
