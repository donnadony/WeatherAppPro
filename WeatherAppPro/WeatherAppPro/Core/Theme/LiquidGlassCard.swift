//
//  LiquidGlassCard.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Reusable liquid glass card component with glassmorphism effect
struct LiquidGlassCard<Content: View>: View {
    
    // MARK: - Properties
    
    let content: Content
    var cornerRadius: CGFloat = 24
    
    // MARK: - Lifecycle
    
    init(cornerRadius: CGFloat = 24, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        content
            .padding()
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.4),
                                .white.opacity(0.1),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .ignoresSafeArea()
        
        LiquidGlassCard {
            VStack(spacing: 12) {
                Text("Liquid Glass")
                    .font(.title.bold())
                Text("Glassmorphism effect")
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}
