import SwiftUI

struct ChatAgente: View {
    @Environment(PerfilUsuario.self) private var perfil
    @Environment(GestorJuego.self) private var gestor
    @State private var servicio_chat = ServicioChat()
    @State private var servicio_ia = ServicioIA()
    @State private var mensaje: String = ""

    private let remitente_yo: String = "yo"
    private let remitente_agente: String = "agente"
    private let remitente_rechazo: String = "sistema_rechazo"
    private let remitente_error: String = "sistema_error"
    private let id_indicador_procesando: String = "__procesando__"

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
                            VisorIACJ(procesando: servicio_ia.enviando)
                            Spacer()
                        }
                    }
                }

                BarraPuntos()

                ScrollViewReader { proxy in
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
                                        .id(msg.id)
                                }
                            }

                            if servicio_ia.enviando {
                                MensajeEstado(
                                    texto: "IA-CJ PROCESANDO...",
                                    tono: .neutro
                                )
                                .id(id_indicador_procesando)
                            }
                        }
                    }
                    .onChange(of: servicio_chat.mensajes.count) {
                        bajar_scroll(proxy: proxy)
                    }
                    .onChange(of: servicio_ia.enviando) {
                        bajar_scroll(proxy: proxy)
                    }
                    .onAppear {
                        bajar_scroll(proxy: proxy)
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
                                || perfil.nombre == nil
                            )
                        }
                    }
                }
            }
            .padding(24)
        }
        .task(id: perfil.nombre) {
            if let usuario = perfil.nombre {
                servicio_chat.obtener_mensajes(usuario: usuario)
            }
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

    private func bajar_scroll(proxy: ScrollViewProxy) {
        let id_destino: String? = servicio_ia.enviando
            ? id_indicador_procesando
            : servicio_chat.mensajes.last?.id

        guard let id_destino else { return }
        withAnimation(.easeOut(duration: 0.2)) {
            proxy.scrollTo(id_destino, anchor: .bottom)
        }
    }

    private func estado_juego_actual() -> EstadoJuegoIA {
        let desbloqueadas = gestor.pistas_disponibles
            .map { $0.id }
            .filter { gestor.pistas_obtenidas.contains($0) }
        let bloqueadas = gestor.pistas_disponibles
            .map { $0.id }
            .filter { !gestor.pistas_obtenidas.contains($0) }
        return EstadoJuegoIA(
            pistas_desbloqueadas: desbloqueadas,
            pistas_bloqueadas: bloqueadas,
            puzzle_resuelto: gestor.puzzle_resuelto
        )
    }

    private func enviar() async {
        guard let usuario = perfil.nombre else { return }
        let texto = mensaje.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty else { return }
        mensaje = ""

        servicio_chat.enviar_mensaje(texto: texto, remitente: remitente_yo, usuario: usuario)

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

        let resultado = await servicio_ia.generar_respuesta(
            historial: contexto,
            estado_juego: estado_juego_actual()
        )

        switch resultado {
        case .respuesta(let r):
            servicio_chat.enviar_mensaje(texto: r, remitente: remitente_agente, usuario: usuario)
        case .rechazo(let r):
            servicio_chat.enviar_mensaje(texto: r, remitente: remitente_rechazo, usuario: usuario)
        case .error(let e):
            servicio_chat.enviar_mensaje(
                texto: "Error de transmision con IA-CJ: \(e)",
                remitente: remitente_error,
                usuario: usuario
            )
        }
    }
}

#Preview {
    ChatAgente()
        .environment(GestorJuego())
        .environment({
            let p = PerfilUsuario()
            p.establecer(nombre: "operador_demo")
            return p
        }())
}
