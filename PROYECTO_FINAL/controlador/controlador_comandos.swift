extension ControladorAplicacion: ProcesarComandos {
    func realizar_comando(tipo: Comandos, carga_util: String) -> Bool {
        switch tipo{
            case .activar_animacion:
                activar_comportamiento(carga_util)
                historial_comandos.append(
                        Comando(tipo: tipo, carga_util: carga_util)
                )
                return true
                
            default:
                fatalError("[\(#file):\(#function)] NO has implentado esto campeon \(tipo)")
                return false
        }
        
        return false
    }
    
    func realizar_comando(_ comanda: Comando) -> Bool {
        switch comanda.tipo{
            case .activar_animacion:
                activar_comportamiento(comanda.carga_util)
                historial_comandos.append(
                        comanda
                )
                return true
            case .activar_pantalla:
                do {
                    try? pantallas_emergentes.append( PantallasDisponibles(from: comanda.carga_util as! Decoder) )
                }
                
            default:
                fatalError("[\(#file):\(#function)] NO has implentado esto campeon \(comanda.tipo)")
                return false
        }
        
        return false
    }
}
