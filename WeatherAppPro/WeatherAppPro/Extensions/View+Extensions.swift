//
//  View+Extensions.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import SwiftUI

extension View {
    /// Apply a glassmorphism card effect
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        self.liquidGlass(cornerRadius: cornerRadius)
    }
    
    /// Add a shimmer loading effect
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}

// MARK: - Shimmer Modifier
private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.3),
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: phase)
                    .mask(content)
            }
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 300
                }
            }
    }
}
