import SwiftUI

struct ChatAgente: View {
    @State private var servicio_chat = ServicioChat()
    @State private var servicio_ia = ServicioIA()
    @State private var mensaje: String = ""

    private let remitente_yo: String = "yo"
    private let remitente_agente: String = "agente"

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                EncabezadoPantalla(
                    preheader: "> CANAL SEGURO  /  AGENTE R.O.M.A.",
                    titulo: "Comunicaciones"
                )

                BarraPuntos()

                PanelSistema {
                    VStack(alignment: .leading, spacing: 8) {
                        EtiquetaCorchete(texto: "/// AGENTE R.O.M.A. ///")
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
                                BloqueTransmision(
                                    etiqueta: etiqueta_para(remitente: msg.remitente),
                                    cuerpo: msg.texto
                                )
                            }
                        }

                        if servicio_ia.enviando {
                            MensajeEstado(
                                texto: "AGENTE PROCESANDO...",
                                tono: .neutro
                            )
                        }

                        if let error = servicio_ia.ultimo_error {
                            MensajeEstado(
                                texto: "ERROR IA: \(error)",
                                tono: .error
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

    private func enviar() async {
        let texto = mensaje.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { return }
        mensaje = ""

        servicio_chat.enviar_mensaje(texto: texto, remitente: remitente_yo)

        let cantidad_previa = max(0, servicio_ia.ventana_contexto - 1)
        let historial_previo = Array(servicio_chat.mensajes.suffix(cantidad_previa))
        let contexto: [MensajeIA] = historial_previo.map { msg in
            MensajeIA(
                rol: msg.remitente == remitente_yo ? "user" : "assistant",
                contenido: msg.texto
            )
        } + [MensajeIA(rol: "user", contenido: texto)]

        if let respuesta = await servicio_ia.generar_respuesta(historial: contexto) {
            servicio_chat.enviar_mensaje(texto: respuesta, remitente: remitente_agente)
        }
    }

    private func etiqueta_para(remitente: String) -> String {
        remitente == remitente_yo ? "/// TU MENSAJE ///" : "/// AGENTE R.O.M.A. ///"
    }
}

#Preview {
    ChatAgente()
}
