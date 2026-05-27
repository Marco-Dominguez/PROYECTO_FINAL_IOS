import Foundation

@MainActor
@Observable
public class GestorJuego {

    public enum FaseJuego {
        case terminal
        case jugando
    }

    public let pistas_disponibles: [Pista] = [
        Pista(id: "X", letra: "X", valor_romano: 10,  descripcion: "Fragmento decifrado: X"),
        Pista(id: "C", letra: "C", valor_romano: 100, descripcion: "Fragmento decifrado: C"),
        Pista(id: "L", letra: "L", valor_romano: 50,  descripcion: "Fragmento decifrado: L"),
        Pista(id: "V", letra: "V", valor_romano: 5,   descripcion: "Fragmento decifrado: V"),
    ]

    public let respuesta_correcta: String = "10100505"

    public var fase: FaseJuego = .terminal
    public var pistas_obtenidas: Set<String> = []
    public var pista_recien_obtenida: Pista? = nil
    public var puzzle_resuelto: Bool = false

    public init() {}

    public func iniciar_juego() {
        fase = .jugando
    }

    public func desbloquear_pista(id: String) {
        guard !pistas_obtenidas.contains(id) else { return }
        guard let pista = pistas_disponibles.first(where: { $0.id == id }) else {
            fatalError("Pista desconocida: \(id) en \(#function)")
        }
        pistas_obtenidas.insert(id)
        pista_recien_obtenida = pista
    }

    public func descartar_popup() {
        pista_recien_obtenida = nil
    }

    @discardableResult
    public func validar_respuesta(_ texto: String) -> Bool {
        let acierto = texto == respuesta_correcta
        if acierto { puzzle_resuelto = true }
        return acierto
    }
}
