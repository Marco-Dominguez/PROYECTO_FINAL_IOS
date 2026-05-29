struct MaquinaEstadosVisorNPC {
    private(set) var estado_actual: EstadoAnimacionNPC

    init(estado_inicial: EstadoAnimacionNPC = .estando) {
        estado_actual = estado_inicial
    }

    mutating func actualizar(_ evento: EventoVisorNPC) {
        switch evento {
        case .cambiar_estado(let nuevo_estado):
            estado_actual = nuevo_estado
        case .animacion_finalizada:
            break
        }
    }
}

enum EventoVisorNPC {
    case cambiar_estado(EstadoAnimacionNPC)
    case animacion_finalizada
}

enum EstadoAnimacionNPC: Hashable {
    case estando
    case negando
    case viendo_lados

    var ruta: String {
        switch self {
        case .estando: return "personajes/escenas/npc-estando"
        case .negando: return "personajes/escenas/npc-negando"
        case .viendo_lados: return "personajes/escenas/npc-viendo-lados"
        }
    }

    var en_loop: Bool {
        true
    }
}
