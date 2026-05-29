import SwiftUI
import RealityKit
import mundo_virtual

struct VisorIACJ: View {
    var procesando: Bool = false
    var tamano: CGFloat = 140
    var offset_y: Float = 0.5
    var distancia_z: Float = 1.5

    @State private var entidad: Entity? = nil
    @State private var estado_animacion: EstadoAnimacion = .saludando

    enum EstadoAnimacion: Hashable {
        case saludando
        case estando
        case pensando

        var ruta: String {
            switch self {
            case .saludando: return "personajes/escenas/iacj-saludando"
            case .estando:   return "personajes/escenas/iacj-estando"
            case .pensando:  return "personajes/escenas/iacj-pensando"
            }
        }

        var en_loop: Bool {
            switch self {
            case .saludando: return false
            case .estando, .pensando: return true
            }
        }
    }

    var body: some View {
        ZStack {
            Color.sistema_marron_tenue.opacity(0.25)

            RealityView { contenido in
                contenido.camera = .virtual
                if let entidad {
                    contenido.add(entidad)
                }
            } update: { contenido in
                let actuales = Array(contenido.entities)
                let primera = actuales.first
                if primera !== entidad {
                    for e in actuales {
                        contenido.remove(e)
                    }
                    if let entidad {
                        contenido.add(entidad)
                    }
                }
            }
        }
        .frame(width: tamano, height: tamano)
        .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
        .task(id: estado_animacion) {
            await cargar_estado()
        }
        .onChange(of: procesando) {
            transicionar_por_procesando()
        }
        .onAppear {
            estado_animacion = .saludando
        }
    }

    private func transicionar_por_procesando() {
        guard estado_animacion != .saludando else { return }
        estado_animacion = procesando ? .pensando : .estando
    }

    private func cargar_estado() async {
        let estado_actual = estado_animacion
        let ruta = estado_actual.ruta

        do {
            let escena = try await Entity(named: ruta, in: MundoVirtual)

            let (anfitrion, animacion) = buscar_animacion(en: escena) ?? (escena, nil)
            if let animacion {
                if estado_actual.en_loop {
                    anfitrion.playAnimation(animacion.repeat(), transitionDuration: 0.2)
                } else {
                    anfitrion.playAnimation(animacion, transitionDuration: 0.2)
                }
                print("[VisorIACJ] reproduciendo \(ruta) loop=\(estado_actual.en_loop)")
            } else {
                print("[VisorIACJ] sin animaciones embebidas en \(ruta)")
            }

            let contenedor = Entity()
            contenedor.position = SIMD3<Float>(0, offset_y, distancia_z)
            contenedor.addChild(escena)
            entidad = contenedor

            if !estado_actual.en_loop, let animacion {
                let duracion = animacion.definition.duration
                try? await Task.sleep(nanoseconds: UInt64(duracion * 1_000_000_000))
                if !Task.isCancelled, estado_animacion == estado_actual {
                    estado_animacion = procesando ? .pensando : .estando
                }
            }
        } catch {
            print("[VisorIACJ] error al cargar \(ruta): \(error)")
        }
    }

    private func buscar_animacion(en entidad: Entity) -> (Entity, AnimationResource)? {
        if let primera = entidad.availableAnimations.first {
            return (entidad, primera)
        }
        for hijo in entidad.children {
            if let resultado = buscar_animacion(en: hijo) {
                return resultado
            }
        }
        return nil
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
