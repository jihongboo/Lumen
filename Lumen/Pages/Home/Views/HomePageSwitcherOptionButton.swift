//
//  HomePageSwitcherOptionButton.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct HomePageSwitcherOptionButton: View {
    let page: HomeDisplayPage
    let isSelected: Bool
    let action: () -> Void
        
    var body: some View {
        Button(action: action) {
            Text(page.title)
                .font(.system(.callout, design: .rounded, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 15)
                .frame(height: 44)
                .foregroundStyle(isSelected ? .black : .white)
        }
        .tint(isSelected ? .white : .clear)
        .buttonStyle(.glassProminent)
    }
}

#Preview {
    HStack(spacing: 12) {
        HomePageSwitcherOptionButton(page: .time, isSelected: true) {
            
        }
        
        HomePageSwitcherOptionButton(page: .liquidGlassTime, isSelected: false) {
            
        }
    }
    .padding()
    .background(.black)
}
