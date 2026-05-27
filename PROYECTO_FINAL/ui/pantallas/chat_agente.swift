import SwiftUI

struct ChatAgente: View {
    @State private var servicio_chat = ServicioChat()
    @State private var servicio_ia = ServicioIA()
    @State private var mensaje: String = ""

    private let remitente_yo: String = "yo"
    private let remitente_agente: String = "agente"
    private let remitente_rechazo: String = "sistema_rechazo"
    private let remitente_error: String = "sistema_error"

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                EncabezadoPantalla(
                    preheader: "> CANAL SEGURO  /  IA-CJ",
                    titulo: "Comunicaciones"
                )

                BarraPuntos()

                PanelSistema {
                    VStack(alignment: .leading, spacing: 8) {
                        EtiquetaCorchete(texto: "/// IA-CJ ///")
                        HStack {
                            Spacer()
                            VisorModelo3D()
                            Spacer()
                        }
                    }
                }

                BarraPuntos()

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        if servicio_chat.mensajes.isEmpty {
                            MensajeEstado(
                                texto: "SIN TRANSMISIONES. ENVIA UN MENSAJE PARA INICIAR.",
                                tono: .neutro
                            )
                        } else {
                            ForEach(servicio_chat.mensajes) { msg in
                                bloque_para(mensaje: msg)
                            }
                        }

                        if servicio_ia.enviando {
                            MensajeEstado(
                                texto: "IA-CJ PROCESANDO...",
                                tono: .neutro
                            )
                        }
                    }
                }

                BarraPuntos()

                PanelSistema {
                    VStack(alignment: .leading, spacing: 10) {
                        EtiquetaCorchete(texto: "/// ENTRADA ///")

                        CampoTextoSistema(
                            marcador: "Escribe tu mensaje",
                            texto: $mensaje
                        )

                        HStack {
                            Spacer()
                            Button("ENVIAR") {
                                Task { await enviar() }
                            }
                            .buttonStyle(.sistema)
                            .disabled(
                                mensaje.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                || servicio_ia.enviando
                            )
                        }
                    }
                }
            }
            .padding(24)
        }
        .task {
            servicio_chat.obtener_mensajes()
        }
    }

    @ViewBuilder
    private func bloque_para(mensaje msg: Mensaje) -> some View {
        switch msg.remitente {
        case remitente_yo:
            BloqueTransmision(etiqueta: "/// TU MENSAJE ///", cuerpo: msg.texto)
        case remitente_agente:
            BloqueTransmision(etiqueta: "/// IA-CJ ///", cuerpo: msg.texto)
        case remitente_rechazo:
            BloqueTransmision(etiqueta: "/// FUERA DE ALCANCE ///", cuerpo: msg.texto)
        case remitente_error:
            BloqueTransmision(etiqueta: "/// ERROR DE PROTOCOLO ///", cuerpo: msg.texto)
        default:
            BloqueTransmision(etiqueta: "/// \(msg.remitente.uppercased()) ///", cuerpo: msg.texto)
        }
    }

    private func enviar() async {
        let texto = mensaje.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { return }
        mensaje = ""

        servicio_chat.enviar_mensaje(texto: texto, remitente: remitente_yo)

        let cantidad_previa = max(0, servicio_ia.ventana_contexto - 1)
        let historial_previo = Array(servicio_chat.mensajes.suffix(cantidad_previa))
        let contexto: [MensajeIA] = historial_previo
            .compactMap { msg -> MensajeIA? in
                switch msg.remitente {
                case remitente_yo:
                    return MensajeIA(rol: "user", contenido: msg.texto)
                case remitente_agente:
                    return MensajeIA(rol: "assistant", contenido: msg.texto)
                default:
                    return nil
                }
            } + [MensajeIA(rol: "user", contenido: texto)]

        let resultado = await servicio_ia.generar_respuesta(historial: contexto)

        switch resultado {
        case .respuesta(let r):
            servicio_chat.enviar_mensaje(texto: r, remitente: remitente_agente)
        case .rechazo(let r):
            servicio_chat.enviar_mensaje(texto: r, remitente: remitente_rechazo)
        case .error(let e):
            servicio_chat.enviar_mensaje(
                texto: "Error de transmision con IA-CJ: \(e)",
                remitente: remitente_error
            )
        }
    }
}

#Preview {
    ChatAgente()
}
