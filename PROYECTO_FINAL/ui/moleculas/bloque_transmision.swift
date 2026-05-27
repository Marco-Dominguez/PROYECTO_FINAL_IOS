import SwiftUI

struct BloqueTransmision: View {
    let etiqueta: String
    let cuerpo: String

    var body: some View {
        PanelSistema {
            VStack(alignment: .leading, spacing: 8) {
                EtiquetaCorchete(texto: etiqueta)

                Text(cuerpo)
                    .font(.sistema_cuerpo)
                    .foregroundStyle(Color.sistema_marron)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        BloqueTransmision(
            etiqueta: "/// ALERTA ///",
            cuerpo: "Un companero ha quedado atrapado tras la propagacion de un virus."
        )
        BloqueTransmision(
            etiqueta: "/// OBJETIVO ///",
            cuerpo: "Recupera los 4 fragmentos del codigo."
        )
    }
    .padding()
    .background(Color.sistema_arena)
}
