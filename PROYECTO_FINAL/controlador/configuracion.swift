import Foundation

public enum Configuracion {
    public static var nvidia_api_key: String? {
        let valor = valores["NVIDIA_API_KEY"]
        guard let valor, !valor.isEmpty, valor != "pega-tu-api-key-aqui" else { return nil }
        return valor
    }

    private static let valores: [String: String] = leer_env()

    private static func leer_env() -> [String: String] {
        guard let url = Bundle.main.url(forResource: ".env", withExtension: nil),
              let contenido = try? String(contentsOf: url, encoding: .utf8) else {
            print("[Configuracion] .env no encontrado en el bundle")
            return [:]
        }

        var dict: [String: String] = [:]
        for linea in contenido.split(separator: "\n") {
            let l = linea.trimmingCharacters(in: .whitespaces)
            guard !l.isEmpty, !l.hasPrefix("#") else { continue }
            let partes = l.split(separator: "=", maxSplits: 1).map {
                String($0).trimmingCharacters(in: .whitespaces)
            }
            guard partes.count == 2 else { continue }
            var v = partes[1]
            if (v.hasPrefix("\"") && v.hasSuffix("\"")) || (v.hasPrefix("'") && v.hasSuffix("'")) {
                v = String(v.dropFirst().dropLast())
            }
            dict[partes[0]] = v
        }
        return dict
    }
}
