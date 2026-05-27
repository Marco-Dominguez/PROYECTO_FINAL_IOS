import SwiftUI

struct MensajeEstado: View {
    enum Tono {
        case exito
        case error
        case neutro
    }

    let texto: String
    var tono: Tono = .neutro

    var body: some View {
        HStack(spacing: 10) {
            CuadradoIcono(lado: 8, color: color_indicador)
            Text(texto)
                .font(.sistema_dato)
                .tracking(2)
                .foregroundStyle(Color.sistema_marron)
            Spacer()
        }
        .padding(10)
        .background(Color.sistema_arena_clara)
        .overlay(Rectangle().stroke(color_indicador, lineWidth: 1))
    }

    private var color_indicador: Color {
        switch tono {
        case .exito:  return .sistema_marron
        case .error:  return .sistema_marron
        case .neutro: return .sistema_marron_tenue
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        MensajeEstado(texto: "VICTORIA: PROTOCOLO COMPLETADO", tono: .exito)
        MensajeEstado(texto: "CONTRASENA INCORRECTA", tono: .error)
        MensajeEstado(texto: "ESPERANDO ENTRADA", tono: .neutro)
    }
    .padding()
    .background(Color.sistema_arena)
}
