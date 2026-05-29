import SwiftUI
import RealityKit

struct EscanerAR: View {
    @Environment(GestorJuego.self) private var gestor
    @State private var suscripcion: EventSubscription? = nil

    private let pistas_ar: [String] = ["X", "C", "L"]

    var body: some View {
        ZStack {
            RealityView { contenido in
                contenido.camera = .spatialTracking

                for nombre in pistas_ar {
                    let ancla = AnchorEntity(.image(group: "imagenes", name: nombre))
                    ancla.name = nombre

                    let caja = ModelEntity(
                        mesh: .generateBox(size: 0.05),
                        materials: [SimpleMaterial(color: .orange, isMetallic: false)]
                    )
                    ancla.addChild(caja)
                    contenido.add(ancla)
                }

                suscripcion = contenido.subscribe(to: SceneEvents.AnchoredStateChanged.self) { evento in
                    guard evento.isAnchored else { return }
                    let id_detectado = evento.anchor.name
                    Task { @MainActor in
                        gestor.desbloquear_pista(id: id_detectado)
                    }
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 12) {
                hud_superior

                Spacer()

                hud_inferior
            }
            .padding(16)
        }
        .alerta_fragmento_obtenido(gestor: gestor)
    }

    private var hud_superior: some View {
        PanelHUD {
            VStack(alignment: .leading, spacing: 6) {
                EtiquetaCorchete(texto: "/// ESCANER AR  /  IMAGE TRACKING ///")

                Text("Apunta la camara a los objetivos AR: lata, balon y camiseta. Cada objeto recupera un fragmento.")
                    .font(.sistema_cuerpo)
                    .foregroundStyle(Color.sistema_marron)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var hud_inferior: some View {
        PanelHUD {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    EtiquetaCorchete(texto: "/// DETECCIONES ///")
                    Spacer()
                    Text("\(conteo_detectadas)/\(pistas_ar.count)")
                        .font(.sistema_dato)
                        .foregroundStyle(Color.sistema_marron)
                }

                VStack(spacing: 0) {
                    ForEach(pistas_ar, id: \.self) { id in
                        FilaPistaInventario(
                            identificador: id,
                            descripcion: descripcion_pista(id),
                            obtenida: gestor.pistas_obtenidas.contains(id)
                        )
                    }
                }
            }
        }
    }

    private var conteo_detectadas: Int {
        pistas_ar.filter { gestor.pistas_obtenidas.contains($0) }.count
    }

    private func descripcion_pista(_ id: String) -> String {
        guard let pista = gestor.pistas_disponibles.first(where: { $0.id == id }) else {
            return "Fragmento"
        }

        return "\(pista.objeto.capitalized): \(pista.pista_objeto)"
    }
}

#Preview {
    EscanerAR()
        .environment(GestorJuego())
}
