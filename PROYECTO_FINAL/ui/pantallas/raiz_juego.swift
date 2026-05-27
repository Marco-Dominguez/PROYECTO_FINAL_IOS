import SwiftUI

struct RaizJuego: View {
    @Environment(GestorJuego.self) private var gestor

    var body: some View {
        switch gestor.fase {
        case .terminal:
            TerminalEmergencia()
        case .jugando:
            TabPrincipal()
        }
    }
}

private struct TabPrincipal: View {
    @State private var indice_activo: Int = 0

    private let titulos: [String] = ["Inventario", "Chat", "Escaner AR", "Radar"]

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            VStack(spacing: 0) {
                contenido_activo
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                BarraPestanas(
                    titulos: titulos,
                    indice_activo: $indice_activo
                )
            }
        }
    }

    @ViewBuilder
    private var contenido_activo: some View {
        switch indice_activo {
        case 0: Inventario()
        case 1: ChatAgente()
        case 2: EscanerAR()
        case 3: Radar()
        default: EmptyView()
        }
    }
}

#Preview("Terminal") {
    RaizJuego()
        .environment(ControladorAplicacion())
        .environment(GestorJuego())
}

#Preview("Jugando") {
    RaizJuego()
        .environment(ControladorAplicacion())
        .environment({
            let g = GestorJuego()
            g.iniciar_juego()
            return g
        }())
}
