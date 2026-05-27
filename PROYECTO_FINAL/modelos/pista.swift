import Foundation

public struct Pista: Identifiable, Hashable {
    public let id: String
    public let letra: String
    public let valor_romano: Int
    public let descripcion: String

    public init(id: String, letra: String, valor_romano: Int, descripcion: String) {
        self.id = id
        self.letra = letra
        self.valor_romano = valor_romano
        self.descripcion = descripcion
    }
}
