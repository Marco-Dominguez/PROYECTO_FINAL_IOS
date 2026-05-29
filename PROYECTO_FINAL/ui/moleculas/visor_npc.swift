import SwiftUI
import RealityKit
import mundo_virtual

struct VisorNPC: View {
    var tamano: CGFloat = 200
    var offset_y: Float = -0.5
    var distancia_z: Float = 1.5

    @State private var entidad: Entity? = nil

    private let ruta_escena: String = "personajes/escenas/npc-estando"

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

            barrotes
        }
        .frame(width: tamano, height: tamano)
        .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
        .task {
            await cargar()
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

    private func cargar() async {
        guard entidad == nil else { return }
        do {
            let escena = try await Entity(named: ruta_escena, in: MundoVirtual)

            let (anfitrion, animacion) = buscar_animacion(en: escena) ?? (escena, nil)
            if let animacion {
                anfitrion.playAnimation(animacion.repeat(), transitionDuration: 0.2)
                print("[VisorNPC] reproduciendo \(ruta_escena)")
            } else {
                print("[VisorNPC] sin animaciones en \(ruta_escena)")
            }

            let contenedor = Entity()
            contenedor.position = SIMD3<Float>(0, offset_y, distancia_z)
            contenedor.addChild(escena)
            entidad = contenedor
        } catch {
            print("[VisorNPC] error al cargar \(ruta_escena): \(error)")
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

#Preview {
    VisorNPC()
        .padding()
        .background(Color.sistema_arena)
}
