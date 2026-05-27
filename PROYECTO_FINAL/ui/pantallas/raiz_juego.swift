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
    var body: some View {
        TabView {
            Inventario().tabItem { Text("Inventario") }
            ChatAgente().tabItem { Text("Chat") }
            EscanerAR().tabItem { Text("Escaner AR") }
            Radar().tabItem { Text("Radar") }
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
