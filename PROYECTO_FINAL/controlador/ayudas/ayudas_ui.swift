enum BotonesDisponibles{
    case realizar_accion
    case cerrar_aplicacion
    case so_on_so_on
}

enum TiposDeInteraccion{
    case entidad
    case boton
    case notificacion
}

enum AccionesARealizar: String, Codable {
    case abrir_pantalla
    case avanzar_historia
}

public enum PantallasDisponibles: String, Codable {
    case ataque
    case platicar
}
