class PersonajeGestorEstados: MaquinaEstadosGenerica{
    var controlador_general: (any ProcesarComandos)?
    
    var contexto: (any MaquinaEstadosGenerica)?
    
    var descripcion: String = "Esta no la vmaos a tomar en cuenta"
    
    var posibles_estados: [String] = []
    
    static var nombre: String = "GEstor de estados basico"
    
    var estados_disponibles: [String: Estado] = [
        PersonajeNeutro.nombre: PersonajeNeutro(),
        PersonajeFeliz.nombre: PersonajeFeliz()
    ]
    
    var estado_actual: Estado? = nil
    var nombre_estado_actual: String?
    
    init(){
        realizar_cambio_de_estado(a: PersonajeNeutro.nombre)
        
        estado_actual?.contexto = self
    }
    
    func generar_contexto_textual() -> Contexto {
        print("Traza")
        
        let contexto_actual = Contexto(
            historia: "Aqui colocamos la historia de nuestro perosnaje",
            personalidad: "Aqui colocamos la personalidad de nuestro agente ",
            estados_disponibles: estado_actual!.posibles_estados,
            estado_actual: nombre_estado_actual!,
            descripcion: estado_actual!.descripcion
        )
        
        return contexto_actual
    }

    func inicializar() { }
    
    func actualizar(_ tipo_interaccion: TiposDeInteraccion, _ interaccion: BotonesDisponibles) {
        estado_actual?.actualizar(tipo_interaccion, interaccion)
    }
    
    func finalizar() { }
    
    func reaccion(estimulo: String) { }
    
    func realizar_cambio_de_estado(a nombre_del_estado_nuevo: String) {
        guard var estado_nuevo = estados_disponibles[nombre_del_estado_nuevo] else {
            fatalError("Parece que el estado \(nombre_del_estado_nuevo) no esta disponible o registrado, por favor revisa.")
        }
        
        nombre_estado_actual = nombre_del_estado_nuevo
        
        estado_actual?.finalizar()
        
        estado_nuevo.contexto = self as MaquinaEstadosGenerica
        estado_nuevo.inicializar()
        
        estado_actual = estado_nuevo
    }
    
}
