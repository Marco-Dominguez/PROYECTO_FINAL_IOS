import SwiftUI

struct LineaDivisora: View {
    var grosor: CGFloat = 1
    var color: Color = .sistema_marron

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: grosor)
    }
}

#Preview {
    VStack(spacing: 12) {
        LineaDivisora()
        LineaDivisora(grosor: 2)
        LineaDivisora(color: .sistema_marron_tenue)
    }
    .padding()
    .background(Color.sistema_arena)
}
