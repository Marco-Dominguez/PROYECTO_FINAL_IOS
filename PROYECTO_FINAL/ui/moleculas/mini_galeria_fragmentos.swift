import SwiftUI

struct MiniGaleriaFragmentos: View {
    let pistas: [Pista]
    let obtenidas: Set<String>

    var body: some View {
        PanelSistema {
            VStack(alignment: .leading, spacing: 12) {
                EtiquetaCorchete(texto: "/// GALERIA ///")

                LazyVGrid(columns: columnas, spacing: 10) {
                    ForEach(pistas) { pista in
                        celda(pista)
                    }
                }
            }
        }
    }

    private var columnas: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    }

    @ViewBuilder
    private func celda(_ pista: Pista) -> some View {
        let obtenida = obtenidas.contains(pista.id)

        VStack(spacing: 6) {
            ZStack {
                Color.sistema_marron_tenue.opacity(0.12)

                if obtenida {
                    Image(pista.nombre_imagen)
                        .resizable()
                        .scaledToFit()
                        .padding(6)
                } else {
                    Text("???")
                        .font(.sistema_dato)
                        .foregroundStyle(Color.sistema_marron_tenue)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .overlay(Rectangle().stroke(obtenida ? Color.sistema_marron : Color.sistema_marron_tenue, lineWidth: 1))

            Text(obtenida ? pista.objeto.uppercased() : "BLOQUEADO")
                .font(.sistema_dato)
                .foregroundStyle(obtenida ? Color.sistema_marron : Color.sistema_marron_tenue)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

#Preview {
    MiniGaleriaFragmentos(
        pistas: GestorJuego().pistas_disponibles,
        obtenidas: ["X", "C"]
    )
    .padding()
    .background(Color.sistema_arena)
}
