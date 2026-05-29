import SwiftUI

struct PanelAcertijo: View {
    enum Estado: Equatable {
        case resuelto
        case actual
        case bloqueado
    }

    let pista: Pista
    let estado: Estado

    var body: some View {
        PanelSistema {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    EtiquetaCorchete(texto: etiqueta)
                    Spacer()
                    Text(estado_texto)
                        .font(.sistema_dato)
                        .foregroundStyle(Color.sistema_marron_tenue)
                }

                if estado == .bloqueado {
                    MensajeEstado(texto: "ACERTIJO BLOQUEADO", tono: .neutro)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        FilaDato(etiqueta: "Edificio", valor: pista.edificio_destino)
                        LineaDivisora(color: .sistema_marron_tenue)
                        Text(pista.acertijo)
                            .font(.sistema_cuerpo)
                            .foregroundStyle(Color.sistema_marron)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                        MensajeEstado(texto: pista.pista_objeto.uppercased(), tono: estado == .resuelto ? .exito : .neutro)
                    }
                }
            }
        }
    }

    private var etiqueta: String {
        switch estado {
        case .resuelto, .actual:
            return "/// \(pista.id)  /  \(pista.objeto.uppercased()) ///"
        case .bloqueado:
            return "/// ??? ///"
        }
    }

    private var estado_texto: String {
        switch estado {
        case .resuelto: return "RESUELTO"
        case .actual: return "ACTUAL"
        case .bloqueado: return "BLOQUEADO"
        }
    }
}

#Preview {
    let pista = Pista(
        id: "X",
        letra: "X",
        valor_romano: 10,
        descripcion: "Fragmento descifrado: X",
        edificio_destino: "R",
        objeto: "lata",
        acertijo: "Donde empieza el rescate, busca una senal pequena.",
        pista_objeto: "Busca una lata.",
        nombre_imagen: "X",
        latitud: 31.743685,
        longitud: -106.431380,
        siguiente_id: "C"
    )

    VStack(spacing: 12) {
        PanelAcertijo(pista: pista, estado: .actual)
        PanelAcertijo(pista: pista, estado: .bloqueado)
    }
    .padding()
    .background(Color.sistema_arena)
}
