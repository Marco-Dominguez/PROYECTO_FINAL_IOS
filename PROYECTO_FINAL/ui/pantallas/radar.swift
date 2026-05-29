import SwiftUI
import CoreLocation

struct Radar: View {
    @Environment(GestorJuego.self) private var gestor
    @State private var servicio = ServicioUbicacion()

    private let radio_senal_metros: Double = 20
    private let radio_objetivo_metros: Double = 2

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

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 10) {
                            EtiquetaCorchete(texto: "/// OBJETIVOS ABIERTOS ///")
                            Text("El radar solo guia tu exploracion. Para recuperar un fragmento debes escanear la imagen AR del objeto cuando estes cerca.")
                                .font(.sistema_cuerpo)
                                .foregroundStyle(Color.sistema_marron)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(gestor.pistas_disponibles) { pista in
                            panel_objetivo(para: pista)
                        }
                    }
                }
                .padding(24)
            }
        }
        .task {
            servicio.iniciar()
        }
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

    private func panel_objetivo(para pista: Pista) -> some View {
        let estado = estado_objetivo(para: pista)
        let objeto = texto_objeto(para: pista)
        let edificio = texto_edificio(para: pista)

        return PanelSistema {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    EtiquetaCorchete(texto: "/// \(pista.id)  /  \(objeto) ///")
                    Spacer()
                    Text("EDIFICIO \(edificio)")
                        .font(.sistema_dato)
                        .foregroundStyle(Color.sistema_marron_tenue)
                }

                VStack(spacing: 0) {
                    FilaDato(etiqueta: "Objeto", valor: objeto)
                    LineaDivisora(color: .sistema_marron_tenue)
                    FilaDato(etiqueta: "Lat objetivo", valor: formato(pista.latitud), valor_tenue: true)
                    LineaDivisora(color: .sistema_marron_tenue)
                    FilaDato(etiqueta: "Lon objetivo", valor: formato(pista.longitud), valor_tenue: true)
                    LineaDivisora(color: .sistema_marron_tenue)
                    FilaDato(etiqueta: "Distancia", valor: distancia_legible(para: pista))
                }

                BarraProgresoSistema(progreso: progreso_proximidad(para: pista))

                MensajeEstado(
                    texto: estado.texto,
                    tono: estado.tono
                )
            }
        }
    }

    private func distancia_actual(para pista: Pista) -> Double? {
        guard let ubicacion = servicio.ubicacion_actual else { return nil }
        return ubicacion.distance(from: ubicacion_objetivo(para: pista))
    }

    private func distancia_legible(para pista: Pista) -> String {
        guard let distancia = distancia_actual(para: pista) else { return "--" }
        return String(format: "%.1f m", distancia)
    }

    private func progreso_proximidad(para pista: Pista) -> Double {
        guard let distancia = distancia_actual(para: pista) else { return 0 }
        return 1.0 - min(1.0, max(0, distancia) / radio_senal_metros)
    }

    private func estado_objetivo(para pista: Pista) -> (texto: String, tono: MensajeEstado.Tono) {
        if gestor.pistas_obtenidas.contains(pista.id) {
            return ("FRAGMENTO RECUPERADO", .exito)
        }

        guard let distancia = distancia_actual(para: pista) else {
            return ("SIN LECTURA DE POSICION", .neutro)
        }

        if distancia <= radio_objetivo_metros {
            return ("OBJETIVO CERCA: ESCANEA LA IMAGEN", .exito)
        }

        if distancia <= radio_senal_metros {
            return ("SENAL DETECTADA. ACERCATE Y BUSCA LA IMAGEN AR", .neutro)
        }

        return ("FUERA DE RANGO DE SENAL", .neutro)
    }

    private func pista_descubierta(_ pista: Pista) -> Bool {
        gestor.pistas_obtenidas.contains(pista.id)
    }

    private func texto_objeto(para pista: Pista) -> String {
        pista_descubierta(pista) ? pista.objeto.uppercased() : "???"
    }

    private func texto_edificio(para pista: Pista) -> String {
        pista_descubierta(pista) ? pista.edificio_destino : "???"
    }

    private func ubicacion_objetivo(para pista: Pista) -> CLLocation {
        CLLocation(latitude: pista.latitud, longitude: pista.longitud)
    }

    private func formato(_ coord: Double) -> String {
        String(format: "%.6f", coord)
    }
}

#Preview {
    Radar()
        .environment(GestorJuego())
}
