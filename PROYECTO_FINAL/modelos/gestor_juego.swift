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
    public private(set) var usuario_actual: String? = nil

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
        guardar()
    }

    public func descartar_popup() {
        pista_recien_obtenida = nil
    }

    @discardableResult
    public func validar_respuesta(_ texto: String) -> Bool {
        let acierto = texto == respuesta_correcta
        if acierto {
            puzzle_resuelto = true
            guardar()
        }
        return acierto
    }

    public func cargar_para(usuario: String) {
        usuario_actual = usuario
        let prefijo = "progreso.\(usuario)"
        let defaults = UserDefaults.standard

        let pistas = defaults.stringArray(forKey: "\(prefijo).pistas_obtenidas") ?? []
        pistas_obtenidas = Set(pistas)
        puzzle_resuelto = defaults.bool(forKey: "\(prefijo).puzzle_resuelto")
        pista_recien_obtenida = nil
        fase = .terminal
    }

    private func guardar() {
        guard let usuario = usuario_actual else { return }
        let prefijo = "progreso.\(usuario)"
        let defaults = UserDefaults.standard
        defaults.set(Array(pistas_obtenidas), forKey: "\(prefijo).pistas_obtenidas")
        defaults.set(puzzle_resuelto, forKey: "\(prefijo).puzzle_resuelto")
    }
}
