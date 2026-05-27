import SwiftUI

protocol ProcesarComandos{
    func realizar_comando(tipo: Comandos, carga_util: String) -> Bool

    func realizar_comando(_ comanda: Comando) -> Bool 
}

enum Comandos: String, Codable{
    case activar_animacion
    case activar_pantalla
}

public struct Comando: Identifiable, Codable{
    public var id = UUID()
    
    let tipo: Comandos
    let carga_util: String
}

protocol CargaUtil {
    
}
