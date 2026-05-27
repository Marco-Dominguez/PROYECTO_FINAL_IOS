class SaltoAnimacion: Estado{
    var descripcion: String = "Estamos dadno un salto"
    
    var posibles_estados: [String] = []
    
  
    var contexto: (any MaquinaEstadosGenerica)? = nil
    
    static var nombre = "Salto"

    
    func inicializar() {
        print("HOla desde Saltillo Hermosillo \(#file)")
    }
    
    func actualizar(_ tipo_interaccion: TiposDeInteraccion, _ interaccion: BotonesDisponibles) {
        switch tipo_interaccion{
            case .entidad:
                contexto?.enviar_peticion(Comando(tipo: .activar_animacion, carga_util: "da_un_salto"))
            
            default:
                print("Error: No tenemos instrucciones para ese comando")
        }
    }
    
    func finalizar() {}
    
    func reaccion(estimulo: String) {
    }
    
    
}
