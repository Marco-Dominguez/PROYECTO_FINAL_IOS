import SwiftUI

extension Color {
    static let sistema_arena = Color(red: 0.83, green: 0.81, blue: 0.76)
    static let sistema_arena_clara = Color(red: 0.91, green: 0.88, blue: 0.82)
    static let sistema_marron = Color(red: 0.27, green: 0.27, blue: 0.25)
    static let sistema_marron_tenue = Color(red: 0.66, green: 0.64, blue: 0.59)
}

extension Font {
    static func sistema_titulo(_ tamano: CGFloat = 22) -> Font {
        .system(size: tamano, weight: .light, design: .default)
    }

    static let sistema_cuerpo: Font = .system(size: 14, weight: .light, design: .default)
    static let sistema_dato: Font = .system(size: 12, weight: .light, design: .monospaced)
}
