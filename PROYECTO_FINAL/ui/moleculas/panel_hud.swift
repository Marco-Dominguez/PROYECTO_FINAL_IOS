import SwiftUI

struct PanelHUD<Contenido: View>: View {
    let contenido: Contenido
    var opacidad_fondo: Double = 0.88

    init(opacidad_fondo: Double = 0.88, @ViewBuilder contenido: () -> Contenido) {
        self.opacidad_fondo = opacidad_fondo
        self.contenido = contenido()
    }

    var body: some View {
        contenido
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.sistema_arena.opacity(opacidad_fondo))
            .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.black, .gray],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        VStack {
            PanelHUD {
                Text("HUD superior — fondo arena translúcido")
                    .font(.sistema_cuerpo)
                    .foregroundStyle(Color.sistema_marron)
            }
            Spacer()
            PanelHUD {
                Text("HUD inferior")
                    .font(.sistema_cuerpo)
                    .foregroundStyle(Color.sistema_marron)
            }
        }
        .padding()
    }
}
