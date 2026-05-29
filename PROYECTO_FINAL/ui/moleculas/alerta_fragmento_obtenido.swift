import SwiftUI

struct AlertaFragmentoObtenido: ViewModifier {
    @Bindable var gestor: GestorJuego

    func body(content: Content) -> some View {
        content.alert(
            "Fragmento obtenido",
            isPresented: Binding(
                get: { gestor.pista_recien_obtenida != nil },
                set: { nuevo in if !nuevo { gestor.descartar_popup() } }
            ),
            presenting: gestor.pista_recien_obtenida
        ) { _ in
            Button("OK", role: .cancel) { gestor.descartar_popup() }
        } message: { pista in
            Text(mensaje_para(pista))
        }
    }

    private func mensaje_para(_ pista: Pista) -> String {
        var partes: [String] = [
            "Recuperaste el fragmento \(pista.letra) (valor \(pista.valor_romano))."
        ]

        if let siguiente = gestor.pista_siguiente_despues_de(pista.id) {
            partes.append("Nuevo acertijo desbloqueado: edificio \(siguiente.edificio_destino). \(siguiente.pista_objeto)")
        } else {
            partes.append("Todos los fragmentos recuperados. Ve al Inventario para descifrar.")
        }

        return partes.joined(separator: "\n\n")
    }
}

extension View {
    func alerta_fragmento_obtenido(gestor: GestorJuego) -> some View {
        modifier(AlertaFragmentoObtenido(gestor: gestor))
    }
}
