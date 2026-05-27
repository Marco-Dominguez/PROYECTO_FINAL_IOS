import SwiftUI
import FirebaseCore

@main
struct ProyectoFinalApp: App {
    @State var controlador_general = ControladorAplicacion()
    @State var gestor_juego = GestorJuego()
    @State var perfil_usuario = PerfilUsuario()

    init(){
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RaizJuego()
                .environment(controlador_general)
                .environment(gestor_juego)
                .environment(perfil_usuario)

            // PruebaConexionFirebase()
        }
    }
}
