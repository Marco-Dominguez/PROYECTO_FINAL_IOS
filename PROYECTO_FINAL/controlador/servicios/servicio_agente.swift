//
//  servicio_agente.swift
//  Shimeji
//
//  Created by Jadzia Galletas on 06/05/26.
//
import FirebaseFirestore
import Combine


@Observable
class ServicioAgente{
    var peticion: Peticion? = nil
    
    private var base_de_datos: Firestore = Firestore.firestore()
    
    func crear_peticion(contexto: Contexto, mensaje_del_usario: String){
        print("HOla desde \(#function)")

        let peticion = Peticion(
            id: UUID().uuidString,
            estado: .creacion,
            contexto: contexto,
            mensaje: mensaje_del_usario,
            comando_a_ejecutar: nil,
            respuesta: nil
        )
        
        do{
            var resultado_enviar_peticion = try base_de_datos.collection("peticiones").addDocument(from: peticion)

            resultado_enviar_peticion.addSnapshotListener { snapshot, error  in
                guard let snapshot = try? snapshot?.data(as: Peticion.self) else { return }
                self.peticion = snapshot
            }
        }
        catch {
            print("Hey, tiene un error \(error)")
        }
    }
}

