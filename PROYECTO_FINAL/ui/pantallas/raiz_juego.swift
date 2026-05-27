import SwiftUI

struct RaizJuego: View {
    @Environment(PerfilUsuario.self) private var perfil
    @Environment(GestorJuego.self) private var gestor

    var body: some View {
        Group {
            if perfil.nombre == nil {
                Onboarding()
            } else {
                switch gestor.fase {
                case .terminal:
                    TerminalEmergencia()
                case .jugando:
                    TabPrincipal()
                }
            }
        }
        .task(id: perfil.nombre) {
            if let nombre = perfil.nombre, gestor.usuario_actual != nombre {
                gestor.cargar_para(usuario: nombre)
            }
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

#Preview("Sin perfil") {
    RaizJuego()
        .environment(ControladorAplicacion())
        .environment(GestorJuego())
        .environment(PerfilUsuario())
}

#Preview("Terminal") {
    RaizJuego()
        .environment(ControladorAplicacion())
        .environment(GestorJuego())
        .environment({
            let p = PerfilUsuario()
            p.establecer(nombre: "operador_demo")
            return p
        }())
}

#Preview("Jugando") {
    RaizJuego()
        .environment(ControladorAplicacion())
        .environment({
            let g = GestorJuego()
            g.cargar_para(usuario: "operador_demo")
            g.iniciar_juego()
            return g
        }())
        .environment({
            let p = PerfilUsuario()
            p.establecer(nombre: "operador_demo")
            return p
        }())
}
