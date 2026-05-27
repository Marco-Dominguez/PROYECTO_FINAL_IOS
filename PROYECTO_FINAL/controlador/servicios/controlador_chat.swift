import FirebaseFirestore
import Combine


@Observable
class ServicioChat{
    var mensajes: [Mensaje] = []
    
    private var base_de_datos = Firestore.firestore()
    
    func obtener_mensajes(){
        base_de_datos.collection("mensajes")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                guard let documento = snapshot?.documents else { return }
                self.mensajes = documento.compactMap{ elemento in
                    try? elemento.data(as: Mensaje.self)
                }
        }
    }
    
    func enviar_mensaje(texto: String){
        let mensaje = Mensaje(
            id: UUID().uuidString,
            texto: texto,
            remitente: "yo",
            timestamp: Date()
        )
        
        do{
            _ = try base_de_datos.collection("mensajes").addDocument(from: mensaje)
        }
        catch {
            print("Hey, tiene un error \(error)")
        }
    }
}
