//
//  AppTheme.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

/// App theme constants and styles
struct AppTheme {
    // MARK: - Colors
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.purple
        static let accent = Color.cyan
        
        // Dynamic colors
        static let cardBackground = Color(uiColor: .systemBackground)
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 60, weight: .bold, design: .rounded)
        static let title = Font.system(size: 28, weight: .bold)
        static let headline = Font.system(size: 17, weight: .semibold)
        static let body = Font.system(size: 15, weight: .regular)
        static let caption = Font.system(size: 13, weight: .regular)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
}
