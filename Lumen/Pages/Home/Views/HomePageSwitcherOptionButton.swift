//
//  HomePageSwitcherOptionButton.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct HomePageSwitcherOptionButton: View {
    let background: Background
    @Binding var selection: Background
    private var isSelected: Bool {
        background == selection
    }
    
    var body: some View {
        Button {
            selection = background
        } label: {
            Text(background.title)
                .font(.system(.callout, design: .rounded, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 15)
                .frame(height: 44)
                .foregroundStyle(isSelected ? .black : .white)
        }
        .tint(isSelected ? .white : .clear)
        .buttonStyle(.glassProminent)
        .animation(.smooth, value: selection)
    }
}

#Preview {
    @Previewable @State var selection = Background.meshGradient
    HStack {
        HomePageSwitcherOptionButton(background: .meshGradient, selection: $selection)
        HomePageSwitcherOptionButton(background: .smoke, selection: $selection)
    }
    .padding()
}
