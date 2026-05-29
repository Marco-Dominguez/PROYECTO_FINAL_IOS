import SwiftUI
import CoreLocation

struct Radar: View {
    @Environment(GestorJuego.self) private var gestor
    @State private var servicio = ServicioUbicacion()

    private let destino = CLLocation(latitude: 31.695353, longitude: -106.426460)
    //private let destino = CLLocation(latitude: 31.742145, longitude: -106.432353)
    private let radio_metros: Double = 20
    private let id_pista_geo: String = "V"

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    EncabezadoPantalla(
                        preheader: "> RADAR  /  POSICION EN VIVO",
                        titulo: "Radar de ubicacion"
                    )

                    BarraPuntos()

                    panel_gps

                    panel_objetivo
                }
                .padding(24)
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
        .alerta_fragmento_obtenido(gestor: gestor)
    }

    private var panel_gps: some View {
        PanelSistema {
            VStack(alignment: .leading, spacing: 10) {
                EtiquetaCorchete(texto: "/// STATUS GPS ///")

                MensajeEstado(
                    texto: servicio.autorizado ? "PERMISO CONCEDIDO" : "ESPERANDO AUTORIZACION",
                    tono: servicio.autorizado ? .exito : .neutro
                )

                if let ubicacion = servicio.ubicacion_actual {
                    VStack(spacing: 0) {
                        FilaDato(etiqueta: "Latitud", valor: formato(ubicacion.coordinate.latitude))
                        LineaDivisora(color: .sistema_marron_tenue)
                        FilaDato(etiqueta: "Longitud", valor: formato(ubicacion.coordinate.longitude))
                    }
                } else {
                    Text("Esperando primera lectura de GPS...")
                        .font(.sistema_cuerpo)
                        .foregroundStyle(Color.sistema_marron_tenue)
                        .padding(.vertical, 6)
                }
            }
        }
    }

    private var panel_objetivo: some View {
        PanelSistema {
            VStack(alignment: .leading, spacing: 12) {
                EtiquetaCorchete(texto: "/// OBJETIVO ///")

                Text("Localiza el punto final y busca la regla para recuperar el ultimo fragmento.")
                    .font(.sistema_cuerpo)
                    .foregroundStyle(Color.sistema_marron)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 0) {
                    FilaDato(etiqueta: "Lat objetivo", valor: formato(destino.coordinate.latitude), valor_tenue: true)
                    LineaDivisora(color: .sistema_marron_tenue)
                    FilaDato(etiqueta: "Lon objetivo", valor: formato(destino.coordinate.longitude), valor_tenue: true)
                    LineaDivisora(color: .sistema_marron_tenue)
                    FilaDato(etiqueta: "Distancia", valor: distancia_legible)
                    LineaDivisora(color: .sistema_marron_tenue)
                    FilaDato(etiqueta: "Radio", valor: String(format: "%.0f m", radio_metros), valor_tenue: true)
                }

                BarraProgresoSistema(progreso: progreso_proximidad)

                MensajeEstado(
                    texto: estado_objetivo.texto,
                    tono: estado_objetivo.tono
                )
            }
        }
    }

    private var distancia_actual: Double? {
        servicio.ubicacion_actual?.distance(from: destino)
    }

    private var distancia_legible: String {
        guard let d = distancia_actual else { return "--" }
        return String(format: "%.1f m", d)
    }

    private var progreso_proximidad: Double {
        guard let d = distancia_actual else { return 0 }
        let cota_max = max(radio_metros * 10, 200)
        return 1.0 - min(1.0, d / cota_max)
    }

    private var estado_objetivo: (texto: String, tono: MensajeEstado.Tono) {
        if gestor.pistas_obtenidas.contains(id_pista_geo) {
            return ("FRAGMENTO YA RECUPERADO", .exito)
        }
        guard let d = distancia_actual else {
            return ("SIN LECTURA DE POSICION", .neutro)
        }
        if d <= radio_metros {
            return ("DENTRO DEL RANGO. DESBLOQUEANDO...", .exito)
        }
        return ("ACERCATE AL OBJETIVO PARA RECUPERAR", .neutro)
    }

    private func formato(_ coord: Double) -> String {
        String(format: "%.6f", coord)
    }
}

#Preview {
    Radar()
        .environment(GestorJuego())
}
