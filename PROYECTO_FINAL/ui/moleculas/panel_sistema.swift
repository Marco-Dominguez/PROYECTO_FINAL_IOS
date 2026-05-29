import SwiftUI

struct PanelSistema<Contenido: View>: View {
    let contenido: Contenido
    var altura: CGFloat? = nil

    init(altura: CGFloat? = nil, @ViewBuilder contenido: () -> Contenido) {
        self.altura = altura
        self.contenido = contenido()
    }

    var body: some View {
        contenido
            .padding(12)
            .frame(
                maxWidth: .infinity,
                minHeight: altura,
                maxHeight: altura,
                alignment: .topLeading
            )
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
