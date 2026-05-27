import SwiftUI

struct PestanaSistema: View {
    let titulo: String
    let activa: Bool
    let accion: () -> Void

    var body: some View {
        Button(action: accion) {
            HStack(spacing: 8) {
                CuadradoIcono(
                    lado: 8,
                    color: activa ? .sistema_arena : .sistema_marron
                )
                Text(titulo.uppercased())
                    .font(.sistema_cuerpo)
                    .tracking(2)
                    .foregroundStyle(activa ? Color.sistema_arena : Color.sistema_marron)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(activa ? Color.sistema_marron : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 0) {
        PestanaSistema(titulo: "Inventario", activa: true) { }
        LineaDivisora(eje: .vertical).frame(height: 10)
        PestanaSistema(titulo: "Chat", activa: false) { }
        LineaDivisora(eje: .vertical).frame(height: 10)
        PestanaSistema(titulo: "Radar", activa: false) { }
    }
    .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
    .padding()
    .background(Color.sistema_arena)
}
