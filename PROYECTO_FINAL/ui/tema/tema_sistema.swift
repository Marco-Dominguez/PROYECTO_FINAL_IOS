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

struct PanelSistema: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.sistema_arena_clara)
            .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
    }
}

struct EncabezadoSistema: ViewModifier {
    let texto: String

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Rectangle()
                    .fill(Color.sistema_marron)
                    .frame(width: 10, height: 10)
                Text(texto.uppercased())
                    .font(.sistema_titulo(14))
                    .tracking(3)
                    .foregroundStyle(Color.sistema_marron)
            }
            Rectangle()
                .fill(Color.sistema_marron)
                .frame(height: 1)
            content
        }
    }
}

extension View {
    func panel_sistema() -> some View {
        modifier(PanelSistema())
    }

    func encabezado_sistema(_ titulo: String) -> some View {
        modifier(EncabezadoSistema(texto: titulo))
    }
}

struct BarraPuntos: View {
    var body: some View {
        GeometryReader { geo in
            let cantidad = max(8, Int(geo.size.width / 8))
            Text(String(repeating: "· ", count: cantidad))
                .font(.sistema_dato)
                .foregroundStyle(Color.sistema_marron_tenue)
                .lineLimit(1)
        }
        .frame(height: 12)
    }
}

struct BotonSistemaStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.sistema_cuerpo)
            .tracking(2)
            .foregroundStyle(configuration.isPressed ? Color.sistema_arena : Color.sistema_marron)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(configuration.isPressed ? Color.sistema_marron : Color.clear)
            .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
    }
}

extension ButtonStyle where Self == BotonSistemaStyle {
    static var sistema: BotonSistemaStyle { BotonSistemaStyle() }
}
