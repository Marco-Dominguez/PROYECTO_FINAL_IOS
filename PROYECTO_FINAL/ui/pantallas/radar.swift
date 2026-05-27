import SwiftUI
import CoreLocation

struct Radar: View {
    @Environment(GestorJuego.self) private var gestor
    @State private var servicio = ServicioUbicacion()

    private let destino = CLLocation(latitude: 31.74254476501048, longitude: -106.43205493849756)
    private let radio_metros: Double = 20
    private let id_pista_geo: String = "V"

    var body: some View {
        @Bindable var gestor_bindable = gestor

        VStack {
            Text("RADAR DE UBICACION")

            Text(servicio.autorizado ? "Permiso concedido" : "Esperando autorizacion de ubicacion...")

            if let ubicacion = servicio.ubicacion_actual {
                Text("Latitud: \(ubicacion.coordinate.latitude)")
                Text("Longitud: \(ubicacion.coordinate.longitude)")

                let distancia = ubicacion.distance(from: destino)
                Text(String(format: "Distancia al objetivo: %.1f m", distancia))
                Text(String(format: "Radio de desbloqueo: %.0f m", radio_metros))

                if gestor.pistas_obtenidas.contains(id_pista_geo) {
                    Text("Fragmento de esta zona ya recuperado.")
                } else if distancia <= radio_metros {
                    Text("Dentro del rango. Desbloqueando...")
                } else {
                    Text("Acercate al objetivo para recuperar el fragmento.")
                }
            } else {
                Text("Esperando primera lectura de GPS...")
            }
        }
        .task {
            servicio.iniciar()
        }
        .onChange(of: servicio.ubicacion_actual) {
            guard let ubicacion = servicio.ubicacion_actual else { return }
            if ubicacion.distance(from: destino) <= radio_metros {
                gestor.desbloquear_pista(id: id_pista_geo)
            }
        }
        .alert(
            "Fragmento obtenido",
            isPresented: Binding(
                get: { gestor_bindable.pista_recien_obtenida != nil },
                set: { nuevo in if !nuevo { gestor_bindable.descartar_popup() } }
            ),
            presenting: gestor_bindable.pista_recien_obtenida
        ) { _ in
            Button("OK", role: .cancel) { gestor_bindable.descartar_popup() }
        } message: { pista in
            Text("Has recuperado el fragmento: \(pista.letra) (valor \(pista.valor_romano))")
        }
    }
}

#Preview {
    Radar()
        .environment(GestorJuego())
}
