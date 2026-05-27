class ReposoAnimacion: Estado{
    var descripcion: String = ""
    
    static var nombre: String = "Reposo"
    
    var posibles_estados: [String] = [SaltoAnimacion.nombre]
    
    func actualizar(_ tipo_interaccion: TiposDeInteraccion, _ interaccion: BotonesDisponibles) {
        
        // print("\(#function):\(ReposoAnimacion.nombre) recibiendo informacion del tipo evento con datos \(evento)")
        
        switch tipo_interaccion{
            case .entidad:
                _ = contexto?.enviar_peticion(Comando(tipo: .activar_animacion, carga_util: "vuelta_rapida"))
                
            case .boton:
                switch interaccion{
                    case .realizar_accion:
                        _ = contexto?.enviar_peticion(Comando(tipo: .activar_animacion, carga_util: "da_un_salto"))
                        contexto?.realizar_cambio_de_estado(a: SaltoAnimacion.nombre)
                    default:
                        print("Comanod no especifciado")
                }
                
            default:
                print("Comanod no especifciado")
        }
    }
    
    var contexto: (any MaquinaEstadosGenerica)? = nil
    
    func inicializar() { }
    
    func finalizar() { }
    
    func reaccion(estimulo: String) { }

}
