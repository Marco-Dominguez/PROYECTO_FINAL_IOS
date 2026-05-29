import Foundation

public struct PersonajeModelo: Identifiable, Hashable {
    public let id: String
    public let nombre_legible: String
    public let animaciones: [String]

    public init(id: String, nombre_legible: String, animaciones: [String]) {
        self.id = id
        self.nombre_legible = nombre_legible
        self.animaciones = animaciones
    }
}

public enum CatalogoPersonajes {
    public static let personaje_a = PersonajeModelo(
        id: "personajes/personaje_a",
        nombre_legible: "IA-CJ Prototipo A",
        animaciones: [
            "personajes/personaje_a_anim_idle",
            "personajes/personaje_a_anim_saltar",
            "personajes/personaje_a_anim_caminar"
        ]
    )

    public static let personaje_b = PersonajeModelo(
        id: "personajes/personaje_b",
        nombre_legible: "IA-CJ Prototipo B",
        animaciones: [
            "personajes/personaje_b_anim_idle",
            "personajes/personaje_b_anim_saltar",
            "personajes/personaje_b_anim_caminar"
        ]
    )

    public static let todos: [PersonajeModelo] = [personaje_a, personaje_b]
}
