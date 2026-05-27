import Foundation

enum EstadosPeticion: String, Codable{
    case creacion
    case procesamiento
    case resultado
}

struct Peticion: Codable, Identifiable{
    var id: String
    var estado: EstadosPeticion
    var contexto: Contexto
    var mensaje: String
    var comando_a_ejecutar: Comando?
    var respuesta: String?
}

