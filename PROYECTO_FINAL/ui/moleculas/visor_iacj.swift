import SwiftUI

struct VisorIACJ: View {
    var procesando: Bool = false
    var tamano: CGFloat = 140
    var offset_y: Float = 0
    var distancia_z: Float = 1.5

    @State private var maquina_estados = MaquinaEstadosVisorIACJ()

    var body: some View {
        VisorEscenaAnimada(
            ruta_escena: maquina_estados.estado_actual.ruta,
            tamano: tamano,
            offset_y: offset_y,
            distancia_z: distancia_z,
            en_loop: maquina_estados.estado_actual.en_loop
        ) {
            maquina_estados.actualizar(.animacion_finalizada)
        }
        .onAppear {
            maquina_estados.actualizar(.aparecer)
            maquina_estados.actualizar(.procesando_cambio(procesando))
        }
        .onChange(of: procesando) {
            maquina_estados.actualizar(.procesando_cambio(procesando))
        }
    }
}

#Preview("Estando") {
    VisorIACJ(procesando: false)
        .padding()
        .background(Color.sistema_arena)
}

#Preview("Pensando") {
    VisorIACJ(procesando: true)
        .padding()
        .background(Color.sistema_arena)
}
