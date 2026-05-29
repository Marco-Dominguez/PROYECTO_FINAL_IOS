import SwiftUI

struct CampoTextoSistema: View {
    let marcador: String
    @Binding var texto: String
    var usar_mono: Bool = false
    var es_seguro: Bool = false

    var body: some View {
        campo
            .font(usar_mono ? .sistema_dato : .sistema_cuerpo)
            .tracking(usar_mono ? 1 : 0)
            .foregroundStyle(Color.sistema_marron)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color.sistema_arena_clara)
            .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
    }

    @ViewBuilder
    private var campo: some View {
        if es_seguro {
            SecureField(marcador, text: $texto)
        } else {
            TextField(marcador, text: $texto)
        }
    }
}

#Preview {
    @Previewable @State var texto = ""

    VStack(spacing: 12) {
        CampoTextoSistema(marcador: "Mensaje", texto: $texto)
        CampoTextoSistema(marcador: "00000000", texto: $texto, usar_mono: true)
        CampoTextoSistema(marcador: "Llave", texto: $texto, es_seguro: true)
    }
    .padding()
    .background(Color.sistema_arena)
}
