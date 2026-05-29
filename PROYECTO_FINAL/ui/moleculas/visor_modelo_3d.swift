import SwiftUI

struct VisorModelo3D: View {
    var personaje: PersonajeModelo = CatalogoPersonajes.personaje_a
    var indice_animacion: Int = 0
    var tamano: CGFloat = 140
    var offset_y: Float = 0
    var distancia_z: Float = 1.5

    var body: some View {
        VisorEscenaAnimada(
            ruta_escena: ruta_escena,
            tamano: tamano,
            offset_y: offset_y,
            distancia_z: distancia_z,
            en_loop: true
        )
    }

    private var ruta_escena: String {
        guard personaje.animaciones.indices.contains(indice_animacion) else {
            return personaje.id
        }

        return personaje.animaciones[indice_animacion]
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
