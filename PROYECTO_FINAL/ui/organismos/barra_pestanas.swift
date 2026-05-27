import SwiftUI

struct BarraPestanas: View {
    let titulos: [String]
    @Binding var indice_activo: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(titulos.enumerated()), id: \.offset) { indice, titulo in
                PestanaSistema(
                    titulo: titulo,
                    activa: indice == indice_activo
                ) {
                    indice_activo = indice
                }

                if indice < titulos.count - 1 {
                    LineaDivisora(eje: .vertical)
                }
            }
        }
        .frame(height: 44)
        .background(Color.sistema_arena)
        .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
    }
}

#Preview {
    @Previewable @State var activo = 1

    VStack(spacing: 0) {
        BarraPestanas(
            titulos: ["Inventario", "Chat", "Escaner AR", "Radar"],
            indice_activo: $activo
        )

        Spacer()

        Text("Pestana activa: \(activo)")
            .font(.sistema_cuerpo)
            .foregroundStyle(Color.sistema_marron)

        Spacer()
    }
    .background(Color.sistema_arena)
}
