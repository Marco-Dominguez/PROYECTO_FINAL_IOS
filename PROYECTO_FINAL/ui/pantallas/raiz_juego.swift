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
            Text("Escaner AR").tabItem { Text("Escaner AR") }
            PestanaDebugPistas().tabItem { Text("Debug") }
        }
    }
}

private struct PestanaDebugPistas: View {
    @Environment(GestorJuego.self) private var gestor

    var body: some View {
        VStack {
            Text("DEBUG: desbloquear pistas manualmente")
            ForEach(gestor.pistas_disponibles) { pista in
                Button("Desbloquear \(pista.letra)") {
                    gestor.desbloquear_pista(id: pista.id)
                }
            }
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
