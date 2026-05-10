//
//  HomeDisplayPage.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

enum HomeDisplayPage: String, CaseIterable, Identifiable, Hashable {
    case time
    case liquidGlassTime

    var id: String { rawValue }

    var title: String {
        switch self {
        case .time: "Time"
        case .liquidGlassTime: "Liquid Glass"
        }
    }

    var symbol: String {
        switch self {
        case .time: "clock"
        case .liquidGlassTime: "sparkles"
        }
    }

    @ViewBuilder
    func content(isActive: Bool = true) -> some View {
        switch self {
        case .time:
            TimePage(isAnimating: isActive)
        case .liquidGlassTime:
            LiquidGlassTimePage(isAnimating: isActive)
        }
    }
}
