import FirebaseFirestore
import Combine


@MainActor
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
            .addSnapshotListener { [weak self] snapshot, error in
                Task { @MainActor in
                    guard let self else { return }
                    if let error {
                        print("[ServicioChat] ERROR listener: \(error.localizedDescription)")
                        print("[ServicioChat] detalle completo: \(error)")
                        return
                    }
                    guard let documentos = snapshot?.documents else {
                        return
                    }
                    let nuevos = documentos.compactMap { doc -> Mensaje? in
                        do {
                            return try doc.data(as: Mensaje.self)
                        } catch {
                            print("[ServicioChat] decode fallido para doc \(doc.documentID): \(error)")
                            return nil
                        }
                    }
                    self.fusionar(con: nuevos)
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

        fusionar(con: [mensaje])

        do{
            _ = try base_de_datos.collection("mensajes").addDocument(from: mensaje)
        }
        catch {
            print("[ServicioChat] error al guardar: \(error)")
        }
    }

    func borrar_mensajes(usuario: String) async {
        let consulta = base_de_datos.collection("mensajes")
            .whereField("usuario", isEqualTo: usuario)

        await withCheckedContinuation { continuation in
            consulta.getDocuments { [weak self] snapshot, error in
                if let error {
                    print("[ServicioChat] error al consultar mensajes para borrar: \(error)")
                    continuation.resume()
                    return
                }

                Task { @MainActor in
                    guard let self else {
                        continuation.resume()
                        return
                    }

                    guard let documentos = snapshot?.documents, !documentos.isEmpty else {
                        if self.usuario_suscrito == usuario {
                            self.mensajes = []
                        }
                        continuation.resume()
                        return
                    }

                    let lote = self.base_de_datos.batch()
                    for documento in documentos {
                        lote.deleteDocument(documento.reference)
                    }

                    lote.commit { error in
                        Task { @MainActor in
                            if let error {
                                print("[ServicioChat] error al borrar mensajes: \(error)")
                            } else if self.usuario_suscrito == usuario {
                                self.mensajes = []
                            }
                            continuation.resume()
                        }
                    }
                }
            }
        }
    }

    private func fusionar(con nuevos: [Mensaje]) {
        var dict = Dictionary(uniqueKeysWithValues: mensajes.map { ($0.id, $0) })
        for m in nuevos {
            dict[m.id] = m
        }
        mensajes = dict.values.sorted { $0.timestamp < $1.timestamp }
    }
}
