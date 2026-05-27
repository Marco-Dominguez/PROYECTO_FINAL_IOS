import SwiftUI
import RealityKit

struct EscanerAR: View {
    @Environment(GestorJuego.self) private var gestor
    @State private var suscripcion: EventSubscription? = nil

    private let pistas_ar: [String] = ["X", "C", "L"]

    var body: some View {
        @Bindable var gestor_bindable = gestor

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

            VStack {
                Text("ESCANER AR")
                Text("Apunta la camara a las imagenes marcadas X, C y L")
                Spacer()
                Text("Detectadas: \(gestor.pistas_obtenidas.sorted().joined(separator: ", "))")
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
    EscanerAR()
        .environment(GestorJuego())
}
