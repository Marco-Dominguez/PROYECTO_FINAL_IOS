import Foundation

@MainActor
@Observable
public class GestorJuego {

    public enum FaseJuego {
        case terminal
        case jugando
    }

    public let pistas_disponibles: [Pista] = [
        Pista(
            id: "X",
            letra: "X",
            valor_romano: 10,
            descripcion: "Fragmento descifrado: X",
            edificio_destino: "R",
            objeto: "lata",
            acertijo: "Donde empieza el rescate, busca una senal pequena: guarda forma de cilindro, suena hueca al caer y suele quedar olvidada tras una pausa. El edificio responde con la primera letra de ROMA.",
            pista_objeto: "Busca una lata.",
            nombre_imagen: "X",
            latitud: 31.743685,
            longitud: -106.431380,
            siguiente_id: "C"
        ),
        Pista(
            id: "C",
            letra: "C",
            valor_romano: 100,
            descripcion: "Fragmento descifrado: C",
            edificio_destino: "O",
            objeto: "balon",
            acertijo: "El siguiente punto vive donde el eco rueda. No camina, no vuela, pero cruza el piso cuando alguien lo impulsa. Ve al edificio marcado por la segunda letra de ROMA.",
            pista_objeto: "Busca un balon.",
            nombre_imagen: "C",
            latitud: 31.741749,
            longitud: -106.432372,
            siguiente_id: "L"
        ),
        Pista(
            id: "L",
            letra: "L",
            valor_romano: 50,
            descripcion: "Fragmento descifrado: L",
            edificio_destino: "M",
            objeto: "camiseta",
            acertijo: "La ruta continua donde algo se viste sin tener cuerpo propio. Tela, identidad y equipo se juntan en una sola pista. Ve al edificio marcado por la tercera letra de ROMA.",
            pista_objeto: "Busca una camiseta.",
            nombre_imagen: "L",
            latitud: 31.741838,
            longitud: -106.432400,
            siguiente_id: "V"
        ),
        Pista(
            id: "V",
            letra: "V",
            valor_romano: 5,
            descripcion: "Fragmento descifrado: V",
            edificio_destino: "A",
            objeto: "regla",
            acertijo: "El ultimo fragmento se localiza explorando y se recupera escaneando. Cuando estes cerca del destino final, busca aquello que mide distancias pequenas para cerrar una distancia enorme. Ve al edificio marcado por la ultima letra de ROMA.",
            pista_objeto: "Busca una regla.",
            nombre_imagen: "V",
            latitud: 31.742097,
            longitud: -106.433407,
            siguiente_id: nil
        ),
    ]

    public let respuesta_correcta: String = "10100505"

    public var fase: FaseJuego = .terminal
    public var pistas_obtenidas: Set<String> = []
    public var pista_recien_obtenida: Pista? = nil
    public var puzzle_resuelto: Bool = false
    public private(set) var usuario_actual: String? = nil

    public init() {}

    public var total_pasos_progreso: Int {
        pistas_disponibles.count + 1
    }

    public var pasos_progreso_completados: Int {
        pistas_obtenidas.count + (puzzle_resuelto ? 1 : 0)
    }

    public var porcentaje_progreso: Int {
        guard total_pasos_progreso > 0 else { return 0 }
        return Int((Double(pasos_progreso_completados) / Double(total_pasos_progreso)) * 100)
    }

    public var pista_actual_para_acertijo: Pista? {
        pistas_disponibles.first { !pistas_obtenidas.contains($0.id) }
    }

    public func pista_siguiente_despues_de(_ id: String) -> Pista? {
        guard let pista = pistas_disponibles.first(where: { $0.id == id }),
              let siguiente_id = pista.siguiente_id else {
            return nil
        }

        return pistas_disponibles.first { $0.id == siguiente_id }
    }

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

    public func reiniciar_partida() {
        if let usuario = usuario_actual {
            borrar_progreso(usuario: usuario)
        }

        pistas_obtenidas = []
        puzzle_resuelto = false
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

    private func borrar_progreso(usuario: String) {
        let prefijo = "progreso.\(usuario)"
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "\(prefijo).pistas_obtenidas")
        defaults.removeObject(forKey: "\(prefijo).puzzle_resuelto")
    }
}
