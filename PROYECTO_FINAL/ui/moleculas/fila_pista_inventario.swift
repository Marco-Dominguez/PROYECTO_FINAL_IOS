import SwiftUI

struct FilaPistaInventario: View {
    let identificador: String
    let descripcion: String
    let obtenida: Bool

    var body: some View {
        HStack(spacing: 12) {
            CuadradoIcono(
                lado: 10,
                color: obtenida ? .sistema_marron : .sistema_marron_tenue
            )

            Text(obtenida ? identificador : "???")
                .font(.sistema_dato)
                .tracking(2)
                .foregroundStyle(obtenida ? Color.sistema_marron : Color.sistema_marron_tenue)
                .frame(width: 48, alignment: .leading)

            Text(obtenida ? descripcion : "Fragmento bloqueado")
                .font(.sistema_cuerpo)
                .foregroundStyle(obtenida ? Color.sistema_marron : Color.sistema_marron_tenue)

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .overlay(
            LineaDivisora(color: .sistema_marron_tenue)
                .frame(maxHeight: .infinity, alignment: .bottom)
        )
    }
}

#Preview {
    VStack(spacing: 0) {
        FilaPistaInventario(identificador: "X", descripcion: "Fragmento decifrado: X", obtenida: true)
        FilaPistaInventario(identificador: "C", descripcion: "Fragmento decifrado: C", obtenida: false)
        FilaPistaInventario(identificador: "L", descripcion: "Fragmento decifrado: L", obtenida: true)
        FilaPistaInventario(identificador: "V", descripcion: "Fragmento decifrado: V", obtenida: false)
    }
    .padding()
    .background(Color.sistema_arena)
}
