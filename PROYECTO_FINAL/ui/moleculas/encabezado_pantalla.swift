import SwiftUI

struct EncabezadoPantalla: View {
    var preheader: String? = nil
    let titulo: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let preheader {
                Text(preheader)
                    .font(.sistema_dato)
                    .foregroundStyle(Color.sistema_marron_tenue)
            }

            HStack(spacing: 10) {
                CuadradoIcono(lado: 14)
                Text(titulo.uppercased())
                    .font(.sistema_titulo(22))
                    .tracking(5)
                    .foregroundStyle(Color.sistema_marron)
            }

            LineaDivisora()
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        EncabezadoPantalla(
            preheader: "> SISTEMA R.O.M.A. / v0.1",
            titulo: "Terminal de emergencia"
        )
        EncabezadoPantalla(titulo: "Inventario")
    }
    .padding()
    .background(Color.sistema_arena)
}
