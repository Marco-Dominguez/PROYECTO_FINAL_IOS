import Foundation
import CoreLocation

@MainActor
@Observable
public class ServicioUbicacion: NSObject {
    public var ubicacion_actual: CLLocation? = nil
    public var autorizado: Bool = false

    private let gestor_cl = CLLocationManager()

    public override init() {
        super.init()
        gestor_cl.delegate = self
        gestor_cl.desiredAccuracy = kCLLocationAccuracyBest
    }

    public func iniciar() {
        gestor_cl.requestWhenInUseAuthorization()
        gestor_cl.startUpdatingLocation()
    }
}

extension ServicioUbicacion: CLLocationManagerDelegate {
    nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let estado = manager.authorizationStatus
        let nuevo_valor: Bool
        #if os(macOS)
        nuevo_valor = (estado == .authorizedAlways)
        #else
        nuevo_valor = (estado == .authorizedWhenInUse || estado == .authorizedAlways)
        #endif
        Task { @MainActor in
            self.autorizado = nuevo_valor
        }
    }

    nonisolated public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let ultima = locations.last else { return }
        Task { @MainActor in
            self.ubicacion_actual = ultima
        }
    }

    nonisolated public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[ServicioUbicacion] error: \(error.localizedDescription)")
    }
}
