import SwiftUI
import RealityKit

extension ControladorAplicacion{
    func activar_comportamiento(_ nombre: String){
        raiz_escena.scene?.enviar_notificacion(nombre)
    }
    
    func escuchar_comportamiento(_ tipo_interaccion: TiposDeInteraccion, _ accion: BotonesDisponibles){
        /// print("nombre de finalizacion comprotamiento: \(nombre)")
        actualizar_estados(tipo_interaccion, accion)
    }
}



