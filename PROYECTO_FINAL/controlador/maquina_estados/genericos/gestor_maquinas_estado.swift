protocol MaquinaEstadosGenerica: Estado{
    var controlador_general: ProcesarComandos? { get set }
    
    
    var estados_disponibles: [String: Estado] { get set }
    
    var estado_actual: Estado? { get set }
    
    func realizar_cambio_de_estado(a nombre_del_estado_nuevo: String) -> Void
    
    func enviar_peticion(_ comando: Comando) -> Bool
    
    func generar_contexto_textual() -> Contexto
}


extension MaquinaEstadosGenerica{
    mutating func realizar_cambio_de_estado(a nombre_del_estado_nuevo: String) {
        guard var estado_nuevo = estados_disponibles[nombre_del_estado_nuevo] else {
            fatalError("Parece que el estado \(nombre_del_estado_nuevo) no esta disponible o registrado, por favor revisa.")
        }
        
        estado_actual?.finalizar()
        
        estado_nuevo.contexto = self as MaquinaEstadosGenerica
        estado_nuevo.inicializar()
        
        estado_actual = estado_nuevo
    }
    
    func enviar_peticion(_ comando: Comando) -> Bool {
        guard let respuesta = controlador_general?.realizar_comando(comando) else {
            return false
        }
        
        return respuesta
    }
}
