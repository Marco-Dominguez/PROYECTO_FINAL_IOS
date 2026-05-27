import RealityKit
import SwiftUI

extension RealityKit.Scene{
    func enviar_notificacion(_ nombre: String){
        let nombre_notificacion = Notification.Name("RealityKit.NotificationTrigger")
        let informacion_general: [String: Any] = [
            "RealityKit.NotificationTrigger.Scene": self,
            "RealityKit.NotificationTrigger.Identifier": nombre
        ]
        
        NotificationCenter.default.post(name: nombre_notificacion, object: nil, userInfo: informacion_general)
    }
}
