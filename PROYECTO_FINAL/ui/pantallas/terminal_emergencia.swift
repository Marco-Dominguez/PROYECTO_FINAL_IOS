import SwiftUI

struct TerminalEmergencia: View {
    @Environment(GestorJuego.self) private var gestor

    var body: some View {
        VStack {
            Text("TERMINAL DE EMERGENCIA")

            Text("Atencion: un companero ha quedado atrapado tras la propagacion de un virus en las instalaciones. Los sistemas de seguridad estan comprometidos y el acceso a la sala donde se encuentra esta bloqueado por un cifrado de 4 fragmentos.")

            Text("Tu mision: recorrer las estaciones marcadas, recuperar los 4 fragmentos del codigo y descifrar la contrasena maestra para liberarlo antes de que el virus complete su ciclo.")

            Button("Iniciar Protocolo de Rescate") {
                gestor.iniciar_juego()
            }
        }
    }
}

#Preview {
    TerminalEmergencia()
        .environment(GestorJuego())
}
