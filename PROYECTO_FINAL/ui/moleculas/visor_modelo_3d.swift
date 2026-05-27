import SwiftUI
import RealityKit
import mundo_virtual

struct VisorModelo3D: View {
    var nombre_modelo: String = escenario_planeta
    var tamano: CGFloat = 140

    @State private var entidad: Entity? = nil
    @State private var estado: EstadoCarga = .cargando

    enum EstadoCarga {
        case cargando
        case cargado
        case error
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
            case .error:
                Text("MODELO NO DISPONIBLE")
                    .font(.sistema_dato)
                    .foregroundStyle(Color.sistema_marron_tenue)
            }
        }
        .frame(width: tamano, height: tamano)
        .overlay(Rectangle().stroke(Color.sistema_marron, lineWidth: 1))
        .task {
            await cargar()
        }
    }

    private func cargar() async {
        guard entidad == nil else { return }
        if let cargada = try? await Entity(named: nombre_modelo, in: MundoVirtual) {
            cargada.position = SIMD3<Float>(0, 0, 1.5)
            entidad = cargada
            estado = .cargado
        } else {
            estado = .error
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        VisorModelo3D()
        VisorModelo3D(nombre_modelo: "nombre_invalido")
    }
    .padding()
    .background(Color.sistema_arena)
}
