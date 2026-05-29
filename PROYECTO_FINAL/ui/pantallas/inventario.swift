import SwiftUI

struct Inventario: View {
    @Environment(GestorJuego.self) private var gestor
    @State private var respuesta: String = ""
    @State private var intento_fallido: Bool = false

    var body: some View {
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

                    VStack(alignment: .leading, spacing: 12) {
                        EtiquetaCorchete(texto: "/// ACERTIJOS ///")

                        ForEach(gestor.pistas_disponibles) { pista in
                            PanelAcertijo(
                                pista: pista,
                                estado: estado_acertijo(para: pista)
                            )
                        }
                    }

                    BarraPuntos()

                    MiniGaleriaFragmentos(
                        pistas: gestor.pistas_disponibles,
                        obtenidas: gestor.pistas_obtenidas
                    )

                    BarraPuntos()

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 12) {
                            EtiquetaCorchete(texto: "/// DESENCRIPTADOR ///")

                            if !todos_fragmentos_obtenidos {
                                MensajeEstado(
                                    texto: "AUN FALTAN FRAGMENTOS POR RECUPERAR",
                                    tono: .neutro
                                )
                            }

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
        .alerta_fragmento_obtenido(gestor: gestor)
    }

    private var todos_fragmentos_obtenidos: Bool {
        gestor.pistas_disponibles.allSatisfy { gestor.pistas_obtenidas.contains($0.id) }
    }

    private func estado_acertijo(para pista: Pista) -> PanelAcertijo.Estado {
        if gestor.pistas_obtenidas.contains(pista.id) {
            return .resuelto
        }

        if gestor.pista_actual_para_acertijo?.id == pista.id {
            return .actual
        }

        return .bloqueado
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
