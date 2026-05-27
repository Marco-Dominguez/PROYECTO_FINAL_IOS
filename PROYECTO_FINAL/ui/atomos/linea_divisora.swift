import SwiftUI

struct LineaDivisora: View {
    var eje: Axis = .horizontal
    var grosor: CGFloat = 1
    var color: Color = .sistema_marron

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(
                width: eje == .vertical ? grosor : nil,
                height: eje == .horizontal ? grosor : nil
            )
    }
}

#Preview {
    VStack(spacing: 12) {
        LineaDivisora()
        LineaDivisora(grosor: 2)
        LineaDivisora(color: .sistema_marron_tenue)

        HStack(spacing: 12) {
            Text("Izquierda").font(.sistema_cuerpo)
            LineaDivisora(eje: .vertical)
                .frame(height: 10)
            Text("Derecha").font(.sistema_cuerpo)
        }
        .foregroundStyle(Color.sistema_marron)
    }
    .padding()
    .background(Color.sistema_arena)
}
