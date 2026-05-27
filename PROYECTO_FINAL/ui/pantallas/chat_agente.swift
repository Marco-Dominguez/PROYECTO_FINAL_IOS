import SwiftUI

struct ChatAgente: View {
    @Environment(ControladorAplicacion.self) private var controlador
    @State private var servicio = ServicioAgente()
    @State private var mensaje: String = ""

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                EncabezadoPantalla(
                    preheader: "> CANAL SEGURO  /  AGENTE R.O.M.A.",
                    titulo: "Comunicaciones"
                )

                BarraPuntos()

                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if let peticion = servicio.peticion {
                            BloqueTransmision(
                                etiqueta: "/// TU MENSAJE ///",
                                cuerpo: peticion.mensaje
                            )

                            BloqueTransmision(
                                etiqueta: "/// RESPUESTA DE R.O.M.A. ///",
                                cuerpo: cuerpo_respuesta(peticion.respuesta)
                            )

                            MensajeEstado(
                                texto: "STATUS: \(estado_legible(peticion.estado).uppercased())",
                                tono: peticion.estado == .resultado ? .exito : .neutro
                            )
                        } else {
                            MensajeEstado(
                                texto: "SIN TRANSMISIONES. ENVIA UN MENSAJE PARA INICIAR.",
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
                                let texto = mensaje.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !texto.isEmpty else { return }
                                servicio.crear_peticion(
                                    contexto: contexto_actual(),
                                    mensaje_del_usario: texto
                                )
                                mensaje = ""
                            }
                            .buttonStyle(.sistema)
                            .disabled(mensaje.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
            .padding(24)
        }
    }

    private func cuerpo_respuesta(_ respuesta: String?) -> String {
        guard let respuesta, !respuesta.isEmpty else {
            return "Esperando respuesta del agente..."
        }
        return respuesta
    }

    private func contexto_actual() -> Contexto {
        if let maquina = controlador.maquinas_de_estados.first {
            return maquina.generar_contexto_textual()
        }
        return Contexto(
            historia: "Agente de soporte del Protocolo R.O.M.A.",
            personalidad: "Tecnico, conciso, ayuda con acertijos.",
            estados_disponibles: [],
            estado_actual: "indeterminado",
            descripcion: "Sin maquina de estados activa."
        )
    }

    private func estado_legible(_ estado: EstadosPeticion) -> String {
        switch estado {
        case .creacion:      return "creacion"
        case .procesamiento: return "procesamiento"
        case .resultado:     return "resultado"
        }
    }
}

#Preview {
    ChatAgente()
        .environment(ControladorAplicacion())
}
