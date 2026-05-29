import SwiftUI

struct VisorNPC: View {
    var tamano: CGFloat = 200
    var offset_y: Float = 0
    var distancia_z: Float = 1.5

    private let ruta_escena: String = "personajes/escenas/npc-estando"

    var body: some View {
        VisorEscenaAnimada(
            ruta_escena: ruta_escena,
            tamano: tamano,
            offset_y: offset_y,
            distancia_z: distancia_z,
            en_loop: true
        )
        .overlay(barrotes)
    }

    private var barrotes: some View {
        HStack(spacing: 0) {
            Spacer()
            LineaDivisora(eje: .vertical, grosor: 2, color: .sistema_marron)
            Spacer()
            LineaDivisora(eje: .vertical, grosor: 2, color: .sistema_marron)
            Spacer()
            LineaDivisora(eje: .vertical, grosor: 2, color: .sistema_marron)
            Spacer()
        }
    }
}

#Preview {
    VisorNPC()
        .padding()
        .background(Color.sistema_arena)
}
