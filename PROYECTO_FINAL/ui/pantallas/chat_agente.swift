import SwiftUI

struct ChatAgente: View {
    @Environment(ControladorAplicacion.self) private var controlador
    @State private var servicio = ServicioAgente()
    @State private var mensaje: String = ""

    var body: some View {
        VStack {
            Text("CANAL CON EL AGENTE")

            List {
                if let peticion = servicio.peticion {
                    Section("Tu mensaje") {
                        Text(peticion.mensaje)
                    }
                    Section("Respuesta del agente") {
                        if let respuesta = peticion.respuesta, !respuesta.isEmpty {
                            Text(respuesta)
                        } else {
                            Text("Esperando respuesta...")
                        }
                        Text("Estado: \(estado_legible(peticion.estado))")
                    }
                } else {
                    Text("Aun no has enviado ningun mensaje.")
                }
            }

            TextField("Escribe tu mensaje", text: $mensaje, axis: .vertical)
                .autocorrectionDisabled(true)

            Button("Enviar") {
                let texto = mensaje.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !texto.isEmpty else { return }
                servicio.crear_peticion(contexto: contexto_actual(), mensaje_del_usario: texto)
                mensaje = ""
            }
            .disabled(mensaje.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
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
