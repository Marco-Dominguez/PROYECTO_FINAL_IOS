import SwiftUI

struct TerminalEmergencia: View {
    @Environment(GestorJuego.self) private var gestor

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                encabezado

                BarraPuntos()

                transmision(
                    etiqueta: "/// ALERTA ///",
                    cuerpo: "Atencion: un companero ha quedado atrapado tras la propagacion de un virus en las instalaciones. Los sistemas de seguridad estan comprometidos y el acceso a la sala donde se encuentra esta bloqueado por un cifrado de 4 fragmentos."
                )

                transmision(
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

                pie_terminal
            }
            .padding(24)
        }
    }

    private var encabezado: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("> SISTEMA R.O.M.A.  /  v0.1  /  EMERGENCIA")
                .font(.sistema_dato)
                .foregroundStyle(Color.sistema_marron_tenue)

            HStack(spacing: 10) {
                Rectangle()
                    .fill(Color.sistema_marron)
                    .frame(width: 14, height: 14)
                Text("TERMINAL DE EMERGENCIA")
                    .font(.sistema_titulo(22))
                    .tracking(5)
                    .foregroundStyle(Color.sistema_marron)
            }

            Rectangle()
                .fill(Color.sistema_marron)
                .frame(height: 1)
        }
    }

    private func transmision(etiqueta: String, cuerpo: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("[")
                    .font(.sistema_dato)
                    .foregroundStyle(Color.sistema_marron)
                Text(etiqueta)
                    .font(.sistema_dato)
                    .tracking(2)
                    .foregroundStyle(Color.sistema_marron)
                Text("]")
                    .font(.sistema_dato)
                    .foregroundStyle(Color.sistema_marron)
                Spacer()
            }

            Text(cuerpo)
                .font(.sistema_cuerpo)
                .foregroundStyle(Color.sistema_marron)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .panel_sistema()
    }

    private var pie_terminal: some View {
        HStack {
            Text(":-: :-: :-: :-: :-: :-: :-:")
                .font(.sistema_dato)
                .foregroundStyle(Color.sistema_marron_tenue)
            Spacer()
            Text("EOF")
                .font(.sistema_dato)
                .foregroundStyle(Color.sistema_marron_tenue)
        }
    }
}

#Preview {
    TerminalEmergencia()
        .environment(GestorJuego())
}
