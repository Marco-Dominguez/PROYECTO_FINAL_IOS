import SwiftUI

struct BarraProgresoSistema: View {
    var progreso: Double
    var alto: CGFloat = 6

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: alto)
                    .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))

                Rectangle()
                    .fill(Color.sistema_marron)
                    .frame(width: geo.size.width * max(0, min(1, progreso)), height: alto)
            }
        }
        .frame(height: alto)
    }
}

#Preview {
    VStack(spacing: 12) {
        BarraProgresoSistema(progreso: 0.0)
        BarraProgresoSistema(progreso: 0.3)
        BarraProgresoSistema(progreso: 0.7)
        BarraProgresoSistema(progreso: 1.0)
    }
    .padding()
    .background(Color.sistema_arena)
}
