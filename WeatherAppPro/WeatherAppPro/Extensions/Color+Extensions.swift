//
//  Color+Extensions.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


extension Color {
    // MARK: - Weather Condition Gradients
    
    /// Sunny/Clear day
    static let sunnyGradient = [Color(hex: "FFD34E"), Color(hex: "FF9900")]
    
    /// Cloudy/Overcast
    static let cloudyGradient = [Color(hex: "5D6D7E"), Color(hex: "34495E")]
    
    /// Rainy conditions
    static let rainyGradient = [Color(hex: "3A6EA5"), Color(hex: "004E92")]
    
    /// Snowy conditions
    static let snowyGradient = [Color(hex: "C9E4F7"), Color(hex: "7EBDE6")]
    
    /// Thunderstorm
    static let stormGradient = [Color(hex: "2C3E50"), Color(hex: "1C2833")]
    
    /// Misty/Foggy
    static let mistyGradient = [Color(hex: "B2BEB5"), Color(hex: "95A5A6")]
    
    /// Night clear
    static let nightGradient = [Color(hex: "1E3A5F"), Color(hex: "0F2544")]
    
    // MARK: - Dynamic Background
    static func weatherBackground(for condition: String) -> LinearGradient {
        let lowercased = condition.lowercased()
        let colors: [Color]
        
        // Match weather conditions (API returns descriptive strings)
        if lowercased.contains("clear") || lowercased.contains("sunny") {
            colors = sunnyGradient
        } else if lowercased.contains("rain") || lowercased.contains("drizzle") || lowercased.contains("shower") {
            colors = rainyGradient
        } else if lowercased.contains("cloud") || lowercased.contains("overcast") {
            colors = cloudyGradient
        } else if lowercased.contains("snow") || lowercased.contains("sleet") || lowercased.contains("ice") {
            colors = snowyGradient
        } else if lowercased.contains("thunder") || lowercased.contains("storm") {
            colors = stormGradient
        } else if lowercased.contains("mist") || lowercased.contains("fog") || lowercased.contains("haze") {
            colors = mistyGradient
        } else {
            // Default to cloudy for unknown conditions
            colors = cloudyGradient
        }
        
        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Hex Color Init
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
