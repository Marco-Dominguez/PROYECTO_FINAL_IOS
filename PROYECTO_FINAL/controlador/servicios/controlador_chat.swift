import FirebaseFirestore
import Combine


@Observable
class ServicioChat{
    var mensajes: [Mensaje] = []

    private var base_de_datos = Firestore.firestore()
    private var listener: ListenerRegistration? = nil
    private var usuario_suscrito: String? = nil

    func obtener_mensajes(usuario: String){
        guard usuario_suscrito != usuario else { return }
        listener?.remove()
        usuario_suscrito = usuario
        mensajes = []

        listener = base_de_datos.collection("mensajes")
            .whereField("usuario", isEqualTo: usuario)
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error {
                    print("[ServicioChat] error: \(error.localizedDescription)")
                    return
                }
                guard let documento = snapshot?.documents else { return }
                self.mensajes = documento.compactMap{ elemento in
                    try? elemento.data(as: Mensaje.self)
                }
            }
    }

    func enviar_mensaje(texto: String, remitente: String = "yo", usuario: String){
        let mensaje = Mensaje(
            id: UUID().uuidString,
            texto: texto,
            remitente: remitente,
            timestamp: Date(),
            usuario: usuario
        )

        do{
            _ = try base_de_datos.collection("mensajes").addDocument(from: mensaje)
        }
        catch {
            print("Hey, tiene un error \(error)")
        }
    }
}
