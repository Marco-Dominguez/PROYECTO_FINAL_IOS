import SwiftUI
import RealityKit
import mundo_virtual

struct SeguimientoImagenes: View {
    var body: some View {
        RealityView{ contenido in
            contenido.camera = .virtual
            
            // let ancla = AnchorEntity(.image(group: "imagenes", name: "oyla") )
            
            let modelo_a_colocar = ModelEntity(mesh: .generateBox(size: 0.75), materials: [SimpleMaterial(color: .green, isMetallic: true)])
            modelo_a_colocar.generateCollisionShapes(recursive: true)
            modelo_a_colocar.components.set(InputTargetComponent())
            //if let modelo_a_colocar = try? await Entity(named: "planetas", in: MundoVirtual){
                //ancla.addChild(modelo_a_colocar)
            //}
            
            //contenido.add(ancla)
            contenido.add(modelo_a_colocar)
        }
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({
            accion_realizada in
                print("Accion realizada es: \(accion_realizada.entity)")
        }))
        .gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({ entidad_apachurrada in
           print("Se ha pulsado \(entidad_apachurrada)")
        }))
                 
            
        .background(Color.black)
    }
}

#Preview {
    SeguimientoImagenes()
}
