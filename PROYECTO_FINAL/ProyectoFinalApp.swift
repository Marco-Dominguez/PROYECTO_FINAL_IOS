import SwiftUI
import FirebaseCore

@main
struct ProyectoFinalApp: App {
    @State var controlador_general = ControladorAplicacion()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SeguimientoImagenes()
                .environment(controlador_general)
            
            // PruebaConexionFirebase()
        }
    }
}
