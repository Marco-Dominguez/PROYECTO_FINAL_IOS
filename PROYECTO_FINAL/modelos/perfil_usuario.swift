import Foundation
import CryptoKit

@MainActor
@Observable
public class PerfilUsuario {
    private let clave_nombre_userdefaults: String = "nombre_usuario"
    private let clave_llave_hash_userdefaults: String = "llave_hash_usuario"

    public var nombre: String? = nil
    public var llave_hash: String? = nil

    public init() {
        cargar()
    }

    public var identificador_sesion: String? {
        guard let nombre, let llave_hash else { return nil }
        return Self.identificador_sesion(nombre: nombre, llave_hash: llave_hash)
    }

    public var identificador_corto: String {
        guard let identificador_sesion else { return "SIN SESION" }
        return String(identificador_sesion.suffix(8)).uppercased()
    }

    public func cargar() {
        let nombre_guardado = UserDefaults.standard.string(forKey: clave_nombre_userdefaults)
        let llave_guardada = UserDefaults.standard.string(forKey: clave_llave_hash_userdefaults)

        if let nombre_guardado,
           let llave_guardada,
           !nombre_guardado.isEmpty,
           !llave_guardada.isEmpty {
            nombre = nombre_guardado
            llave_hash = llave_guardada
        } else {
            nombre = nil
            llave_hash = nil
        }
    }

    public func establecer(nombre nuevo: String, llave nueva_llave: String) {
        let nombre_limpio = nuevo.trimmingCharacters(in: .whitespacesAndNewlines)
        let llave_limpia = nueva_llave.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !nombre_limpio.isEmpty, !llave_limpia.isEmpty else { return }

        let hash = Self.hash_para(llave_limpia)
        UserDefaults.standard.set(nombre_limpio, forKey: clave_nombre_userdefaults)
        UserDefaults.standard.set(hash, forKey: clave_llave_hash_userdefaults)
        nombre = nombre_limpio
        llave_hash = hash
    }

    public func cerrar_sesion() {
        UserDefaults.standard.removeObject(forKey: clave_nombre_userdefaults)
        UserDefaults.standard.removeObject(forKey: clave_llave_hash_userdefaults)
        nombre = nil
        llave_hash = nil
    }

    private static func identificador_sesion(nombre: String, llave_hash: String) -> String {
        let base = "\(normalizar(nombre)):\(llave_hash)"
        return "sesion_\(hash_para(base))"
    }

    private static func hash_para(_ valor: String) -> String {
        let datos = Data(valor.utf8)
        let hash = SHA256.hash(data: datos)
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    private static func normalizar(_ valor: String) -> String {
        valor.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
