class PersonajeNeutro: Estado{
    var contexto: (any MaquinaEstadosGenerica)? = nil
    
    var descripcion: String = "NUestro queridisimo personaje se comporta de forma neutra como cualqueir otra persona sobre la faz de la tierra"
    
    var posibles_estados: [String] = [PersonajeFeliz.nombre]
    
    static var nombre: String = "PersonajeEnEstadoNeutro"
    
    func inicializar() { }
    
    func actualizar(_ tipo_interaccion: TiposDeInteraccion, _ interaccion: BotonesDisponibles) {
        
    }
    
    func finalizar() { }
    
    func reaccion(estimulo: String) { }
}
