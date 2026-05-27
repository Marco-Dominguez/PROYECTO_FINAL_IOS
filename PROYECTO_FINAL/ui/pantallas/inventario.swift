import SwiftUI

struct Inventario: View {
    @Environment(GestorJuego.self) private var gestor
    @State private var respuesta: String = ""
    @State private var intento_fallido: Bool = false

    var body: some View {
        @Bindable var gestor_bindable = gestor

        VStack {
            Text("INVENTARIO DE FRAGMENTOS")

            List(gestor.pistas_disponibles) { pista in
                HStack {
                    if gestor.pistas_obtenidas.contains(pista.id) {
                        Text(pista.letra)
                        Text(pista.descripcion)
                    } else {
                        Text("???")
                        Text("Fragmento bloqueado")
                    }
                }
            }

            Text("DESENCRIPTADOR")

            TextField("Contrasena maestra", text: $respuesta)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)

            Button("Validar") {
                let acierto = gestor.validar_respuesta(respuesta)
                intento_fallido = !acierto
            }

            if gestor.puzzle_resuelto {
                Text("VICTORIA: protocolo de rescate completado.")
            } else if intento_fallido {
                Text("Contrasena incorrecta. Intenta de nuevo.")
            }
        }
        .alert(
            "Fragmento obtenido",
            isPresented: Binding(
                get: { gestor_bindable.pista_recien_obtenida != nil },
                set: { nuevo in if !nuevo { gestor_bindable.descartar_popup() } }
            ),
            presenting: gestor_bindable.pista_recien_obtenida
        ) { _ in
            Button("OK", role: .cancel) { gestor_bindable.descartar_popup() }
        } message: { pista in
            Text("Has recuperado el fragmento: \(pista.letra) (valor \(pista.valor_romano))")
        }
    }
}

#Preview("Vacio") {
    Inventario()
        .environment(GestorJuego())
}

#Preview("Con pistas") {
    Inventario()
        .environment({
            let g = GestorJuego()
            g.iniciar_juego()
            g.desbloquear_pista(id: "X")
            g.desbloquear_pista(id: "L")
            g.descartar_popup()
            return g
        }())
}
