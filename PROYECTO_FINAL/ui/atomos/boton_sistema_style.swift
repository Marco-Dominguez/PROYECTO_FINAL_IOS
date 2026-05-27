import SwiftUI

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

#Preview {
    VStack(spacing: 12) {
        Button("ACCION PRIMARIA") { }.buttonStyle(.sistema)
        Button("CONFIRMAR") { }.buttonStyle(.sistema)
    }
    .padding()
    .background(Color.sistema_arena)
}
