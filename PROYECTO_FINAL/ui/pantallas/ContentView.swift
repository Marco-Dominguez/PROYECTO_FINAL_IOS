import SwiftUI
import RealityKit
import mundo_virtual

struct Inicio: View{
    @State var lejitud: Float = 0
    @Environment(ControladorAplicacion.self) var controlador
    
    var body: some View {
        ZStack{
            Rectangle()
            VStack{
                switch controlador.estado{
                    case .inciando:
                        Text("Cargando aplciacion, por favor espera")
                            .foregroundStyle(Color.red)
                        
                    case .todo_cargado:
                        ZStack(alignment: .bottom){
                            RealityView{ raiz_de_escena in
                                raiz_de_escena.camera = .spatialTracking
                                
                                //controlador.escenario = raiz_de_escena
                                
                                raiz_de_escena.add(controlador.raiz_escena)
                                
                                for ancla in controlador.entidades_ancla{
                                    raiz_de_escena.add(ancla)
                                }
                                
                            }
                            
                            .gesture(
                                SpatialTapGesture().targetedToAnyEntity().onEnded(
                                    { entidad in
                                        print("[Inicio:gesture] \(entidad.entity.name)")
                                        controlador.actualizar_estados(.entidad, .so_on_so_on)
                                    }
                                )
                            )
                            
                            .task {
                                await controlador.servicio_ar()
                            }
                            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("RealityKit.NotificationTrigger"))){ notificacion in
                                guard notificacion.userInfo?["RealityKit.NotificationTrigger.Identifier"] is String else { return }
                                
                                // controlador.escuchar_comportamiento(notificacion)
                                controlador.actualizar_estados(.notificacion, .so_on_so_on)
                            }
                            
                            ChatView()
                        }
                     
                }
                
            }
        }
        
        Slider(value: $lejitud, in: 0...5)
            .onChange(of: lejitud) {
                controlador.alejar_planetas(lejitud: lejitud)
            }
        
        HStack{
            
            Button{
                controlador.actualizar_estados(.boton, .realizar_accion)

            }
            label: {
                Text("Realizar accion")
                    .foregroundStyle(Color.red)
            }
            
            Button {
                controlador.actualizar_estados(.boton, .cerrar_aplicacion)
            }
            label: {
                Text("Cerrar app")
            }
        }
        
        HStack{
            ForEach(controlador.historial_comandos){ comando in
                Text("Comando ejectudado \(comando.carga_util) ")
            }
        }
    }
}

#Preview {
    Inicio()
        .environment(ControladorAplicacion())
}
