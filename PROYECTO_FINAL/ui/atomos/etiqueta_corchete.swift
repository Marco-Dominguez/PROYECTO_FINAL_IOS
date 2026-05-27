import SwiftUI

struct EtiquetaCorchete: View {
    let texto: String
    var color: Color = .sistema_marron

    var body: some View {
        HStack(spacing: 6) {
            Text("[")
                .font(.sistema_dato)
                .foregroundStyle(color)
            Text(texto)
                .font(.sistema_dato)
                .tracking(2)
                .foregroundStyle(color)
            Text("]")
                .font(.sistema_dato)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        EtiquetaCorchete(texto: "/// ALERTA ///")
        EtiquetaCorchete(texto: "/// OBJETIVO ///")
        EtiquetaCorchete(texto: "STATUS: OK", color: .sistema_marron_tenue)
    }
    .padding()
    .background(Color.sistema_arena)
}
