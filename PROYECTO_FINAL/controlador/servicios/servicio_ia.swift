import Foundation

public struct MensajeIA {
    public let rol: String
    public let contenido: String

    public init(rol: String, contenido: String) {
        self.rol = rol
        self.contenido = contenido
    }
}

@MainActor
@Observable
public class ServicioIA {
    public var enviando: Bool = false
    public var ultimo_error: String? = nil
    public var ventana_contexto: Int = 1

    public let prompt_sistema: String = """
    Eres el agente R.O.M.A., un sistema de inteligencia artificial de soporte tactico.
    Ayudas al jugador a resolver acertijos relacionados con numeros romanos y a recuperar 4 fragmentos de un codigo (X, C, L, V).
    Responde de forma breve, tecnica y en espanol. No reveles directamente la contrasena final.
    """

    private let endpoint = URL(string: "https://integrate.api.nvidia.com/v1/chat/completions")!
    private let modelo: String = "nvidia/nemotron-3-nano-omni-30b-a3b-reasoning"

    public init() {}

    public func generar_respuesta(historial: [MensajeIA]) async -> String? {
        enviando = true
        defer { enviando = false }

        guard let api_key = Configuracion.nvidia_api_key else {
            ultimo_error = "NVIDIA_API_KEY no configurada en recursos/.env"
            return nil
        }

        let recortado = Array(historial.suffix(max(1, ventana_contexto)))
        var mensajes_payload: [[String: String]] = [
            ["role": "system", "content": prompt_sistema]
        ]
        for m in recortado {
            mensajes_payload.append(["role": m.rol, "content": m.contenido])
        }

        let cuerpo: [String: Any] = [
            "model": modelo,
            "messages": mensajes_payload,
            "temperature": 0.6,
            "top_p": 0.95,
            "max_tokens": 4096,
            "stream": false,
            "chat_template_kwargs": ["enable_thinking": true],
            "reasoning_budget": 16384
        ]

        var peticion = URLRequest(url: endpoint)
        peticion.httpMethod = "POST"
        peticion.setValue("Bearer \(api_key)", forHTTPHeaderField: "Authorization")
        peticion.setValue("application/json", forHTTPHeaderField: "Content-Type")
        peticion.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            peticion.httpBody = try JSONSerialization.data(withJSONObject: cuerpo)
            let (datos, respuesta) = try await URLSession.shared.data(for: peticion)

            guard let http = respuesta as? HTTPURLResponse else {
                ultimo_error = "Respuesta HTTP invalida"
                return nil
            }
            guard (200..<300).contains(http.statusCode) else {
                let texto = String(data: datos, encoding: .utf8) ?? "<sin cuerpo>"
                ultimo_error = "Codigo \(http.statusCode): \(texto.prefix(200))"
                return nil
            }

            guard let json = try JSONSerialization.jsonObject(with: datos) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let primero = choices.first,
                  let mensaje = primero["message"] as? [String: Any],
                  let contenido = mensaje["content"] as? String else {
                ultimo_error = "Formato de respuesta inesperado"
                return nil
            }

            ultimo_error = nil
            return contenido.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            ultimo_error = error.localizedDescription
            return nil
        }
    }
}
