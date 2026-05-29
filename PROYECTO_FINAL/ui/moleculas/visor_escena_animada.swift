import SwiftUI
import RealityKit
import mundo_virtual

struct VisorEscenaAnimada: View {
    let ruta_escena: String
    var tamano: CGFloat = 140
    var offset_y: Float = 0
    var distancia_z: Float = 1.5
    var en_loop: Bool = true
    var al_finalizar_animacion: (() -> Void)? = nil

    @State private var entidad: Entity? = nil
    @State private var estado: EstadoCarga = .cargando

    private enum EstadoCarga {
        case cargando
        case cargado
        case error(String)
    }

    var body: some View {
        ZStack {
            Color.sistema_marron_tenue.opacity(0.25)

            if let entidad {
                RealityView { contenido in
                    contenido.camera = .virtual
                    contenido.add(entidad)
                }
            }

            switch estado {
            case .cargando:
                Text("CARGANDO...")
                    .font(.sistema_dato)
                    .foregroundStyle(Color.sistema_marron_tenue)
            case .cargado:
                EmptyView()
            case .error(let detalle):
                VStack(spacing: 4) {
                    Text("MODELO NO DISPONIBLE")
                        .font(.sistema_dato)
                        .foregroundStyle(Color.sistema_marron_tenue)
                    Text(detalle)
                        .font(.sistema_dato)
                        .foregroundStyle(Color.sistema_marron_tenue)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 8)
            }
        }
        .frame(width: tamano, height: tamano)
        .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
        .task(id: id_carga) {
            await cargar()
        }
    }

    private var id_carga: String {
        "\(ruta_escena)#\(offset_y)#\(distancia_z)#\(en_loop)"
    }

    private func cargar() async {
        let id_actual = id_carga
        estado = .cargando
        entidad = nil

        do {
            let escena = try await Entity(named: ruta_escena, in: MundoVirtual)
            escena.position = SIMD3<Float>(0, offset_y, distancia_z)

            let resultado_animacion = buscar_animacion(en: escena)
            if let (anfitrion, animacion) = resultado_animacion {
                let recurso = en_loop ? animacion.repeat() : animacion
                anfitrion.playAnimation(recurso, transitionDuration: 0.2)
            }

            entidad = escena
            estado = .cargado

            if !en_loop, let animacion = resultado_animacion?.animacion {
                let nanosegundos = UInt64(animacion.definition.duration * 1_000_000_000)
                try? await Task.sleep(nanoseconds: nanosegundos)
                if !Task.isCancelled, id_carga == id_actual {
                    al_finalizar_animacion?()
                }
            }
        } catch {
            estado = .error(error.localizedDescription)
        }
    }

    private func buscar_animacion(en entidad: Entity) -> (anfitrion: Entity, animacion: AnimationResource)? {
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
    VisorEscenaAnimada(ruta_escena: "personajes/escenas/npc-estando")
        .padding()
        .background(Color.sistema_arena)
}
