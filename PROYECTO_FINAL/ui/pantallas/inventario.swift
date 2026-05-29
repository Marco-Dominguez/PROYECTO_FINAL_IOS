import SwiftUI

struct Inventario: View {
    @Environment(GestorJuego.self) private var gestor
    @State private var respuesta: String = ""
    @State private var intento_fallido: Bool = false

    var body: some View {
        @Bindable var gestor_bindable = gestor

        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    EncabezadoPantalla(
                        preheader: "> INVENTARIO  /  FRAGMENTOS RECUPERADOS",
                        titulo: "Inventario"
                    )

                    BarraPuntos()

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 8) {
                            EtiquetaCorchete(texto: "/// ERNESTO ATRAPADO ///")
                            HStack {
                                Spacer()
                                VisorNPC()
                                Spacer()
                            }
                        }
                    }

                    BarraPuntos()

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 0) {
                            EtiquetaCorchete(texto: "/// FRAGMENTOS ///")
                                .padding(.bottom, 8)

                            ForEach(gestor.pistas_disponibles) { pista in
                                FilaPistaInventario(
                                    identificador: pista.id,
                                    descripcion: pista.descripcion,
                                    obtenida: gestor.pistas_obtenidas.contains(pista.id)
                                )
                            }
                        }
                    }

                    BarraPuntos()

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 12) {
                            EtiquetaCorchete(texto: "/// DESENCRIPTADOR ///")

                            CampoTextoSistema(
                                marcador: "00000000",
                                texto: $respuesta,
                                usar_mono: true
                            )

                            HStack {
                                Spacer()
                                Button("VALIDAR") {
                                    let acierto = gestor.validar_respuesta(respuesta)
                                    intento_fallido = !acierto
                                }
                                .buttonStyle(.sistema)
                            }

                            if gestor.puzzle_resuelto {
                                MensajeEstado(
                                    texto: "VICTORIA: PROTOCOLO COMPLETADO",
                                    tono: .exito
                                )
                            } else if intento_fallido {
                                MensajeEstado(
                                    texto: "CONTRASENA INCORRECTA",
                                    tono: .error
                                )
                            }
                        }
                    }
                }
                .padding(24)
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
