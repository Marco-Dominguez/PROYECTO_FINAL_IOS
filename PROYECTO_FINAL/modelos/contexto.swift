import Foundation

struct Contexto: Codable{
    var historia: String
    var personalidad: String
    var estados_disponibles: [String]
    var estado_actual: String
    var descripcion: String
}

