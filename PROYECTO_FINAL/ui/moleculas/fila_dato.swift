import SwiftUI

struct FilaDato: View {
    let etiqueta: String
    let valor: String
    var valor_tenue: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Text(etiqueta.uppercased())
                .font(.sistema_cuerpo)
                .tracking(2)
                .foregroundStyle(Color.sistema_marron_tenue)
            Spacer()
            Text(valor)
                .font(.sistema_dato)
                .foregroundStyle(valor_tenue ? Color.sistema_marron_tenue : Color.sistema_marron)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    VStack(spacing: 0) {
        FilaDato(etiqueta: "Latitud", valor: "31.7425448")
        LineaDivisora(color: .sistema_marron_tenue)
        FilaDato(etiqueta: "Longitud", valor: "-106.4320549")
        LineaDivisora(color: .sistema_marron_tenue)
        FilaDato(etiqueta: "Distancia", valor: "152.4 m")
        LineaDivisora(color: .sistema_marron_tenue)
        FilaDato(etiqueta: "Radio", valor: "20 m", valor_tenue: true)
    }
    .padding()
    .background(Color.sistema_arena)
}
