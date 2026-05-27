import SwiftUI

struct Onboarding: View {
    @Environment(PerfilUsuario.self) private var perfil
    @State private var nombre_input: String = ""

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 18) {
                EncabezadoPantalla(
                    preheader: "> SISTEMA R.O.M.A.  /  IDENTIFICACION",
                    titulo: "Registro de operador"
                )

                BarraPuntos()

                BloqueTransmision(
                    etiqueta: "/// IA-CJ ///",
                    cuerpo: "Detecto un nuevo operador. Antes de iniciar el protocolo necesito un identificador unico para vincular tu progreso a esta sesion. Tu progreso y conversaciones quedaran ligados a este nombre en este dispositivo."
                )

                PanelSistema {
                    VStack(alignment: .leading, spacing: 10) {
                        EtiquetaCorchete(texto: "/// IDENTIFICADOR ///")
                        CampoTextoSistema(
                            marcador: "Nombre del operador",
                            texto: $nombre_input
                        )
                        HStack {
                            Spacer()
                            Button("REGISTRAR Y CONTINUAR") {
                                perfil.establecer(nombre: nombre_input)
                            }
                            .buttonStyle(.sistema)
                            .disabled(
                                nombre_input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            )
                        }
                    }
                }

                BarraPuntos()

                Spacer()
            }
            .padding(24)
        }
    }
}

#Preview {
    Onboarding()
        .environment(PerfilUsuario())
}
