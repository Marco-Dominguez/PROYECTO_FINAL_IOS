import SwiftUI


struct ChatView: View {
    @Environment(ControladorAplicacion.self) var controlador
    @State var entidad_ia = ServicioAgente()
    
    static let nombre = PantallasDisponibles.ataque
    
    @State var mensaje_a_enviar: String = ""
    
    var body: some View {
        VStack{
            Text("La respuesta del agente fue: \(entidad_ia.peticion?.respuesta ?? "Sin Respuesta")")
            
            TextField("Cuentame que enviar", text: $mensaje_a_enviar)
              
            Button{
                entidad_ia.crear_peticion(contexto: controlador.generar_contexto(), mensaje_del_usario: mensaje_a_enviar)
            } label: {
                Text("Pulsame para enviar cosas")
            }
            
        }
        .background(Color.red)
    }
}

#Preview {
    ChatView()
        .environment(ControladorAplicacion())
}


