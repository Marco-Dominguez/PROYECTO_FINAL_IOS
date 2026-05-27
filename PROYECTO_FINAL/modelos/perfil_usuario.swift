import Foundation

@MainActor
@Observable
public class PerfilUsuario {
    private let clave_userdefaults: String = "nombre_usuario"

    public var nombre: String? = nil

    public init() {
        cargar()
    }

    public func cargar() {
        let valor = UserDefaults.standard.string(forKey: clave_userdefaults)
        if let valor, !valor.isEmpty {
            nombre = valor
        } else {
            nombre = nil
        }
    }

    public func establecer(nombre nuevo: String) {
        let limpio = nuevo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !limpio.isEmpty else { return }
        UserDefaults.standard.set(limpio, forKey: clave_userdefaults)
        nombre = limpio
    }

    public func cerrar_sesion() {
        UserDefaults.standard.removeObject(forKey: clave_userdefaults)
        nombre = nil
    }
}
