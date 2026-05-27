import Foundation

struct Mensaje: Identifiable, Codable{
    var id: String
    var texto: String
    var remitente: String
    var timestamp: Date
    var usuario: String? = nil
}
