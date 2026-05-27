import SwiftUI

struct CuadradoIcono: View {
    var lado: CGFloat = 12
    var color: Color = .sistema_marron

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: lado, height: lado)
    }
}

#Preview {
    HStack {
        CuadradoIcono()
        CuadradoIcono(lado: 8)
        CuadradoIcono(lado: 16, color: .sistema_marron_tenue)
    }
    .padding()
    .background(Color.sistema_arena)
}
