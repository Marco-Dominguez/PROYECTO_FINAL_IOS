import SwiftUI

struct BarraPuntos: View {
    var color: Color = .sistema_marron_tenue

    var body: some View {
        GeometryReader { geo in
            let cantidad = max(8, Int(geo.size.width / 8))
            Text(String(repeating: "· ", count: cantidad))
                .font(.sistema_dato)
                .foregroundStyle(color)
                .lineLimit(1)
        }
        .frame(height: 12)
    }
}

#Preview {
    VStack {
        BarraPuntos()
        BarraPuntos(color: .sistema_marron)
    }
    .padding()
    .background(Color.sistema_arena)
}
