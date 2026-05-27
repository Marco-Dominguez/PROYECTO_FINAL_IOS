import SwiftUI

struct TerminalEmergencia: View {
    @Environment(GestorJuego.self) private var gestor

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                EncabezadoPantalla(
                    preheader: "> SISTEMA R.O.M.A.  /  v0.1  /  EMERGENCIA",
                    titulo: "Terminal de emergencia"
                )

                BarraPuntos()

                BloqueTransmision(
                    etiqueta: "/// ALERTA ///",
                    cuerpo: "Atencion: un companero ha quedado atrapado tras la propagacion de un virus en las instalaciones. Los sistemas de seguridad estan comprometidos y el acceso a la sala donde se encuentra esta bloqueado por un cifrado de 4 fragmentos."
                )

                BloqueTransmision(
                    etiqueta: "/// OBJETIVO ///",
                    cuerpo: "Tu mision: recorrer las estaciones marcadas, recuperar los 4 fragmentos del codigo y descifrar la contrasena maestra para liberarlo antes de que el virus complete su ciclo."
                )

                BarraPuntos()

                Spacer()

                HStack {
                    Spacer()
                    Button("INICIAR PROTOCOLO DE RESCATE") {
                        gestor.iniciar_juego()
                    }
                    .buttonStyle(.sistema)
                }
            }
            .padding(24)
        }
    }
}

#Preview {
    TerminalEmergencia()
        .environment(GestorJuego())
}
