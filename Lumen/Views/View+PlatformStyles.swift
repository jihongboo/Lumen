//
//  View+PlatformStyles.swift
//  Lumen
//
//  Created by Codex on 2026/6/3.
//

import SwiftUI

extension View {
    @ViewBuilder
    func lumenGlassButtonStyle() -> some View {
        #if os(visionOS)
        self.buttonStyle(.bordered)
        #else
        self.buttonStyle(.glass)
        #endif
    }

    @ViewBuilder
    func lumenGlassProminentButtonStyle() -> some View {
        #if os(visionOS)
        self.buttonStyle(.borderedProminent)
        #else
        self.buttonStyle(.glassProminent)
        #endif
    }

    @ViewBuilder
    func lumenFocusSection() -> some View {
        #if os(tvOS)
        self.focusSection()
        #else
        self
        #endif
    }
}
