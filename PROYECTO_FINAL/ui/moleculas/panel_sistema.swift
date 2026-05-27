import SwiftUI

struct PanelSistema<Contenido: View>: View {
    let contenido: Contenido

    init(@ViewBuilder contenido: () -> Contenido) {
        self.contenido = contenido()
    }

    var body: some View {
        contenido
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.sistema_arena_clara)
            .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
    }
}

#Preview {
    PanelSistema {
        Text("Contenido dentro del panel")
            .font(.sistema_cuerpo)
            .foregroundStyle(Color.sistema_marron)
    }
    .padding()
    .background(Color.sistema_arena)
}
