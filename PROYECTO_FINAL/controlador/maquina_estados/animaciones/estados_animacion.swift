class MaquinaEstadosAnimacion: MaquinaEstadosGenerica{
    func realizar_cambio_de_estado(a nombre_del_estado_nuevo: String) { }
    
    var posibles_estados: [String] = []
    
    static var nombre: String = "MaquinaDeEstados"
    
    var descripcion: String = "Hola este es la maquina de estados"
    
    var contexto: (any MaquinaEstadosGenerica)?
    
    var controlador_general: (any ProcesarComandos)?
    

    var estados_disponibles: [String: Estado] = [
        ReposoAnimacion.nombre: ReposoAnimacion(),
        SaltoAnimacion.nombre: SaltoAnimacion(),
        PlanetasDesaparecidos.nombre: PlanetasDesaparecidos()
    ]
    
    var estado_actual: Estado? = nil
    
    init(){
        estado_actual = estados_disponibles[ReposoAnimacion.nombre]
        estado_actual?.contexto = self
    }
    

    
    func actualizar(_ tipo_interaccion: TiposDeInteraccion, _ interaccion: BotonesDisponibles) {
        estado_actual?.actualizar(tipo_interaccion, interaccion)
    }
    

    
    func inicializar() { }
    
    func finalizar() { }
    
    func reaccion(estimulo: String) { }
    
    func generar_descripcion() -> String {
        return ""
    }
    
    func generar_contexto_textual() -> Contexto {
        let contexto = Contexto(
            historia: "La histoira de este perosnaje",
            personalidad: "La personaldiad de esta agente",
            estados_disponibles: estado_actual!.posibles_estados,
            estado_actual: "",
            descripcion: "",
        )
        
        return contexto
    }
}
