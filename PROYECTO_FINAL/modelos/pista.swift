import Foundation

public struct Pista: Identifiable, Hashable {
    public let id: String
    public let letra: String
    public let valor_romano: Int
    public let descripcion: String
    public let edificio_destino: String
    public let objeto: String
    public let acertijo: String
    public let pista_objeto: String
    public let nombre_imagen: String
    public let latitud: Double
    public let longitud: Double
    public let siguiente_id: String?

    public init(
        id: String,
        letra: String,
        valor_romano: Int,
        descripcion: String,
        edificio_destino: String,
        objeto: String,
        acertijo: String,
        pista_objeto: String,
        nombre_imagen: String,
        latitud: Double,
        longitud: Double,
        siguiente_id: String?
    ) {
        self.id = id
        self.letra = letra
        self.valor_romano = valor_romano
        self.descripcion = descripcion
        self.edificio_destino = edificio_destino
        self.objeto = objeto
        self.acertijo = acertijo
        self.pista_objeto = pista_objeto
        self.nombre_imagen = nombre_imagen
        self.latitud = latitud
        self.longitud = longitud
        self.siguiente_id = siguiente_id
    }
}
