import SwiftUI

struct RaizJuego: View {
    @Environment(GestorJuego.self) private var gestor

    var body: some View {
        switch gestor.fase {
        case .terminal:
            PlaceholderTerminal()
        case .jugando:
            TabPrincipal()
        }
    }
}

private struct PlaceholderTerminal: View {
    @Environment(GestorJuego.self) private var gestor

    var body: some View {
        VStack {
            Text("Terminal de Emergencia (placeholder)")
            Button("Iniciar Protocolo de Rescate") {
                gestor.iniciar_juego()
            }
        }
    }
}

private struct TabPrincipal: View {
    var body: some View {
        TabView {
            Text("Inventario").tabItem { Text("Inventario") }
            Text("Chat").tabItem { Text("Chat") }
            Text("Escáner AR").tabItem { Text("Escáner AR") }
            Text("Radar").tabItem { Text("Radar") }
        }
    }
}

#Preview("Terminal") {
    RaizJuego()
        .environment(ControladorAplicacion())
        .environment(GestorJuego())
}

#Preview("Jugando") {
    let gestor = GestorJuego()
    gestor.iniciar_juego()
    return RaizJuego()
        .environment(ControladorAplicacion())
        .environment(gestor)
}
