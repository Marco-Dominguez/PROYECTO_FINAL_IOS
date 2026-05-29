import SwiftUI
import RealityKit
import mundo_virtual

struct VisorModelo3D: View {
    var personaje: PersonajeModelo = CatalogoPersonajes.personaje_a
    var indice_animacion: Int = 0
    var tamano: CGFloat = 140

    @State private var entidad: Entity? = nil
    @State private var estado: EstadoCarga = .cargando
    @State private var ultimo_id_cargado: String = ""

    enum EstadoCarga {
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
                } update: { _ in }
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
        "\(personaje.id)#\(indice_animacion)"
    }

    private func cargar() async {
        guard id_carga != ultimo_id_cargado else { return }
        ultimo_id_cargado = id_carga
        estado = .cargando
        entidad = nil

        let nombre_animacion = personaje.animaciones.indices.contains(indice_animacion)
            ? personaje.animaciones[indice_animacion]
            : nil

        let ruta = nombre_animacion ?? personaje.id
        do {
            let escena = try await Entity(named: ruta, in: MundoVirtual)
            escena.position = SIMD3<Float>(0, 0, -1.5)

            if let primera = escena.availableAnimations.first {
                escena.playAnimation(primera.repeat(), transitionDuration: 0.2, startsPaused: false)
                print("[VisorModelo3D] reproduciendo animacion en \(ruta)")
            } else {
                print("[VisorModelo3D] sin animaciones disponibles en \(ruta)")
            }

            entidad = escena
            estado = .cargado
        } catch {
            print("[VisorModelo3D] error al cargar \(ruta): \(error)")
            estado = .error(error.localizedDescription)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        VisorModelo3D()
        VisorModelo3D(personaje: CatalogoPersonajes.personaje_b, indice_animacion: 1)
    }
    .padding()
    .background(Color.sistema_arena)
}
