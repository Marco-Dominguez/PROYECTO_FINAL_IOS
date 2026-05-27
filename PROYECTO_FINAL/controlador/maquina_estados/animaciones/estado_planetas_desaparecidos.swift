class PlanetasDesaparecidos: Estado{
    var descripcion: String = ""
    
    var posibles_estados: [String] = []
    

    var contexto: (any MaquinaEstadosGenerica)?
    static var nombre = "Planetas de23parecidos"
    
    func inicializar() {
        
    }
    
    func actualizar(_ tipo_interaccion: TiposDeInteraccion, _ interaccion: BotonesDisponibles) {
        print("HOla desde planetas desaparecidos")
    }
    
    
    func finalizar() {
        
    }
    
    func reaccion(estimulo: String) {
        
    }
    
    
}

