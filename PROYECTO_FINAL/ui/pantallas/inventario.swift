import SwiftUI

struct Inventario: View {
    @Environment(GestorJuego.self) private var gestor
    var al_ganar: (() -> Void)? = nil

    @State private var respuesta: String = ""
    @State private var mensaje_error_desencriptador: String? = nil
    private let alto_panel_superior: CGFloat = 220

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

                    FilaPanelesInventario(
                        proporcion_izquierda: 0.3,
                        espacio: 18,
                        alto: alto_panel_superior
                    ) {
                        panel_ernesto
                    } derecha: {
                        panel_desencriptador
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

                }
                .padding(24)
            }
        }
        .alerta_fragmento_obtenido(gestor: gestor)
    }

    private var todos_fragmentos_obtenidos: Bool {
        gestor.pistas_disponibles.allSatisfy { gestor.pistas_obtenidas.contains($0.id) }
    }

    private var panel_ernesto: some View {
        PanelSistema(altura: alto_panel_superior) {
            VStack(alignment: .leading, spacing: 8) {
                EtiquetaCorchete(texto: "/// ERNESTO ATRAPADO ///")
                HStack {
                    Spacer()
                    VisorNPC(tamano: 150)
                    Spacer()
                }
            }
        }
    }

    private var panel_desencriptador: some View {
        PanelSistema(altura: alto_panel_superior) {
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
                        validar_desencriptador()
                    }
                    .buttonStyle(.sistema)
                }

                if gestor.puzzle_resuelto {
                    MensajeEstado(
                        texto: "VICTORIA: PROTOCOLO COMPLETADO",
                        tono: .exito
                    )
                } else if let mensaje_error_desencriptador {
                    MensajeEstado(
                        texto: mensaje_error_desencriptador,
                        tono: .error
                    )
                }
            }
        }
    }

    private func validar_desencriptador() {
        guard todos_fragmentos_obtenidos else {
            mensaje_error_desencriptador = "ERROR DE DESENCRIPTACION, NO SE HAN RECOLECTADO TODOS LOS FRAGMENTOS"
            return
        }

        let acierto = gestor.validar_respuesta(respuesta)
        mensaje_error_desencriptador = acierto ? nil : "CONTRASENA INCORRECTA"

        if acierto {
            al_ganar?()
        }
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

private struct FilaPanelesInventario<Izquierda: View, Derecha: View>: View {
    let proporcion_izquierda: CGFloat
    let espacio: CGFloat
    let alto: CGFloat
    @ViewBuilder let izquierda: () -> Izquierda
    @ViewBuilder let derecha: () -> Derecha

    var body: some View {
        GeometryReader { geometria in
            let ancho_disponible = max(0, geometria.size.width - espacio)
            let ancho_izquierdo = ancho_disponible * proporcion_izquierda
            let ancho_derecho = ancho_disponible - ancho_izquierdo

            HStack(alignment: .top, spacing: espacio) {
                izquierda()
                    .frame(width: ancho_izquierdo, height: alto)
                derecha()
                    .frame(width: ancho_derecho, height: alto)
            }
        }
        .frame(height: alto)
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
