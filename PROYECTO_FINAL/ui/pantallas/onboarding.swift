import SwiftUI

struct Onboarding: View {
    @Environment(PerfilUsuario.self) private var perfil
    @State private var nombre_input: String = ""
    @State private var llave_input: String = ""

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
                    cuerpo: "Detecto un nuevo operador. Antes de iniciar el protocolo necesito tu nombre y una llave de identificacion. El par separa tu progreso y tus comunicaciones de otros operadores con el mismo nombre."
                )

                PanelSistema {
                    VStack(alignment: .leading, spacing: 10) {
                        EtiquetaCorchete(texto: "/// IDENTIFICADOR ///")
                        CampoTextoSistema(
                            marcador: "Nombre del operador",
                            texto: $nombre_input
                        )
                        CampoTextoSistema(
                            marcador: "Llave de identificacion",
                            texto: $llave_input,
                            usar_mono: true,
                            es_seguro: true
                        )
                        HStack {
                            Spacer()
                            Button("REGISTRAR Y CONTINUAR") {
                                perfil.establecer(nombre: nombre_input, llave: llave_input)
                            }
                            .buttonStyle(.sistema)
                            .disabled(
                                nombre_input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                || llave_input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
