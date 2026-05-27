import Foundation

/// Bundle for the mundo_virtual project
public let MundoVirtual = Bundle.module


public let escenario_planeta = "planetario/escena"

public let planetas = [
    "planetario/escena",
]

enum Notificaciones{
    case da_un_salto
}

let Notificacion: [Notificaciones: String] = [
    Notificaciones.da_un_salto: "da_un_salto"
]


