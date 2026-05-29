import SwiftUI

struct VisorNPC: View {
    let estado: EstadoAnimacionNPC
    let tamano: CGFloat
    let offset_y: Float
    let distancia_z: Float
    let mostrar_barrotes: Bool

    @State private var maquina_estados: MaquinaEstadosVisorNPC

    init(
        estado: EstadoAnimacionNPC = .estando,
        tamano: CGFloat = 200,
        offset_y: Float = 0,
        distancia_z: Float = 1.5,
        mostrar_barrotes: Bool = true
    ) {
        self.estado = estado
        self.tamano = tamano
        self.offset_y = offset_y
        self.distancia_z = distancia_z
        self.mostrar_barrotes = mostrar_barrotes
        _maquina_estados = State(initialValue: MaquinaEstadosVisorNPC(estado_inicial: estado))
    }

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
        .overlay {
            if mostrar_barrotes {
                barrotes
            }
        }
        .onAppear {
            maquina_estados.actualizar(.cambiar_estado(estado))
        }
        .onChange(of: estado) {
            maquina_estados.actualizar(.cambiar_estado(estado))
        }
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
    VStack(spacing: 12) {
        VisorNPC()
        VisorNPC(estado: .negando, mostrar_barrotes: false)
        VisorNPC(estado: .viendo_lados, mostrar_barrotes: false)
    }
    .padding()
    .background(Color.sistema_arena)
}
