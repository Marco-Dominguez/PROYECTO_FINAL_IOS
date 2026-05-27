import SwiftUI
import RealityKit
import ARKit
import mundo_virtual
import FirebaseFirestore


@Observable
@MainActor
public class ControladorAplicacion{
    public var escenario: RealityViewCameraContent? = nil
    
    public var raiz_escena: Entity = Entity()

    public var estado: EstadosAplicacion = .inciando
    
    public var pantallas_emergentes: [PantallasDisponibles] = []
    
    private var planetas_cargados: [Entity] = []
    var entidades_ancla: [AnchorEntity] = []

    var historial_comandos: [Comando] = []
    
    var maquinas_de_estados: [MaquinaEstadosGenerica] = [PersonajeGestorEstados()]
    
    private var servicio = ARReferenceImage.referenceImages(inGroupNamed: "imagenes", bundle: nil)
    
    init(){
        // entidad_ia = ServicioAgente()
        
        for indice in 0...maquinas_de_estados.count - 1{
            maquinas_de_estados[indice].controlador_general = self as ProcesarComandos
        }
        
        Task.detached(priority: .high) {
            await self.cargar_planetas()
        }
    }
    
    func cargar_planetas() async {
        defer {
            estado = .todo_cargado
        }
        
        var contador_de_bucle_for = 0
        
        for planeta in planetas{
            guard let planeta = try? await Entity(named: planeta, in: MundoVirtual) else {
                fatalError("NO SE HA PODIDO CARGAR EL PLANETA EN \(#function)")
            }
            
            planeta.position.y = Float(contador_de_bucle_for / 3) * 0.2
            planeta.position.x = Float(contador_de_bucle_for % 3) * 0.2
            
            raiz_escena.addChild(planeta)
            // guard let escenario = raiz_escena.scene else { fatalError("Escena no cargada") }
            // escenario.add(planeta)
            planetas_cargados.append(planeta)
            
            contador_de_bucle_for += 1
        }
        /// Region de prueba
        let ancla_rostro = AnchorEntity(.face)
        ancla_rostro.name = "Rostro"
        
        let ancla_imagen = AnchorEntity(.image(group: "imagenes", name: "oyla"))
        ancla_imagen.name = "imagen"
        
        let ancla = AnchorEntity(plane: .horizontal)
        ancla.name = "tabla o plana"
        
        let caja_1 = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
        caja_1.name = "caja o tabla"
        caja_1.generateCollisionShapes(recursive: true)
        caja_1.components.set(InputTargetComponent())
        
        let caja_2 = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .green, isMetallic: true)])
        let caja_3 = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: true)])
        
        ancla.addChild(caja_1)
        ancla_rostro.addChild(caja_2)
        ancla_imagen.addChild(caja_3)
        
        entidades_ancla.append(ancla)
        entidades_ancla.append(ancla_imagen)
        entidades_ancla.append(ancla_rostro)
        
    }
    
    func alejar_planetas(lejitud: Float) {
        for planeta_cargado in planetas_cargados {
            planeta_cargado.position.z -= lejitud
        }
    }
    
    func actualizar_estados(_ tipo_interaccion: TiposDeInteraccion, _ interaccion: BotonesDisponibles){
        for maquina in maquinas_de_estados{
            maquina.actualizar(tipo_interaccion, interaccion)
        }
    }
    
    func servicio_ar() async {
        if entidades_ancla.isEmpty{
            let ancla_rostro = AnchorEntity(.face)
            ancla_rostro.name = "Rostro"
            
            let ancla_imagen = AnchorEntity(.image(group: "imagenes", name: "oyla"))
            ancla_imagen.name = "imagen"
            
            let ancla = AnchorEntity(plane: .horizontal)
            ancla.name = "tabla o plana"
            
            let caja_1 = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .blue, isMetallic: true)])
            let caja_2 = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .green, isMetallic: true)])
            let caja_3 = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: true)])
            
            ancla.addChild(caja_1)
            ancla_rostro.addChild(caja_2)
            ancla_imagen.addChild(caja_3)
            
            raiz_escena.scene?.addAnchor(ancla)
            raiz_escena.scene?.addAnchor(ancla_imagen)
            raiz_escena.scene?.addAnchor(ancla_rostro)
            
            if escenario != nil{
                print("En este momento ya existe el escenario.")
            }
            else {
                print("En este momento todavia no existe el escenario.")
                return

            }
            
            escenario?.add(ancla)
            escenario?.add(ancla_imagen)
            escenario?.add(ancla_rostro)
            //raiz_escena.scene?.anchors.append(ancla_imagen)
            //raiz_escena.scene?.anchors.append(ancla_rostro)
            
            entidades_ancla.append(ancla)
            entidades_ancla.append(ancla_imagen)
            entidades_ancla.append(ancla_rostro)
            return
        }
        
        for ancla in entidades_ancla{
            print("[\(#file.split(separator: "/").last ?? "Sin respuesta"):\(#function)] se esta viendo la ancla \(ancla.name) ? \(ancla.isEnabled)")
        }
    }
    
    func generar_contexto() -> Contexto{
        let personaje_actual = maquinas_de_estados[0]
        print("personaje actual: \(personaje_actual)")
        return personaje_actual.generar_contexto_textual()
    }
}

