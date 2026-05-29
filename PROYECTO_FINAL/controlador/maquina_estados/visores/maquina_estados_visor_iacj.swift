struct MaquinaEstadosVisorIACJ {
    private(set) var estado_actual: EstadoAnimacionIACJ = .saludando
    private var procesando: Bool = false

    mutating func actualizar(_ evento: EventoVisorIACJ) {
        switch evento {
        case .aparecer:
            estado_actual = .saludando
        case .procesando_cambio(let nuevo_valor):
            procesando = nuevo_valor
            guard estado_actual != .saludando else { return }
            estado_actual = nuevo_valor ? .pensando : .estando
        case .animacion_finalizada:
            guard estado_actual == .saludando else { return }
            estado_actual = procesando ? .pensando : .estando
        }
    }
}

enum EventoVisorIACJ {
    case aparecer
    case procesando_cambio(Bool)
    case animacion_finalizada
}

enum EstadoAnimacionIACJ: Hashable {
    case saludando
    case estando
    case pensando

    var ruta: String {
        switch self {
        case .saludando: return "personajes/escenas/iacj-saludando"
        case .estando: return "personajes/escenas/iacj-estando"
        case .pensando: return "personajes/escenas/iacj-pensando"
        }
    }

    var en_loop: Bool {
        switch self {
        case .saludando: return false
        case .estando, .pensando: return true
        }
    }
}
