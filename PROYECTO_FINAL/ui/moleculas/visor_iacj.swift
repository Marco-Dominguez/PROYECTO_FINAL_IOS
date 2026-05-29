import SwiftUI

struct VisorIACJ: View {
    var procesando: Bool = false
    var estado_fijo: EstadoAnimacionIACJ? = nil
    var en_loop_estado_fijo: Bool = true
    var tamano: CGFloat = 140
    var offset_y: Float = 0
    var distancia_z: Float = 1.5

    @State private var maquina_estados = MaquinaEstadosVisorIACJ()

    var body: some View {
        VisorEscenaAnimada(
            ruta_escena: estado_actual.ruta,
            tamano: tamano,
            offset_y: offset_y,
            distancia_z: distancia_z,
            en_loop: en_loop_actual
        ) {
            guard estado_fijo == nil else { return }
            maquina_estados.actualizar(.animacion_finalizada)
        }
        .onAppear {
            guard estado_fijo == nil else { return }
            maquina_estados.actualizar(.aparecer)
            maquina_estados.actualizar(.procesando_cambio(procesando))
        }
        .onChange(of: procesando) {
            guard estado_fijo == nil else { return }
            maquina_estados.actualizar(.procesando_cambio(procesando))
        }
    }

    private var estado_actual: EstadoAnimacionIACJ {
        estado_fijo ?? maquina_estados.estado_actual
    }

    private var en_loop_actual: Bool {
        estado_fijo == nil ? estado_actual.en_loop : en_loop_estado_fijo
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
