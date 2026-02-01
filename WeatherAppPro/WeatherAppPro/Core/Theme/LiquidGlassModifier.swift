//
//  LiquidGlassModifier.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// ViewModifier for applying liquid glass effect
struct LiquidGlassModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 15, y: 8)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
    }
}

extension View {
    /// Apply liquid glass effect to any view
    func liquidGlass(cornerRadius: CGFloat = 20) -> some View {
        self.modifier(LiquidGlassModifier(cornerRadius: cornerRadius))
    }
}
