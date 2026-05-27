import SwiftUI
import FirebaseFirestore

struct PruebaConexionFirebase: View {
    @State private var resultado: String = "Sin probar"

    var body: some View {
        VStack(spacing: 20) {
            Text(resultado)
                .multilineTextAlignment(.center)
                .padding()

            Button {
                probar_conexion()
            } label: {
                Text("Probar conexión con Firebase")
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
    }

    private func probar_conexion() {
        let db = Firestore.firestore()
        db.collection("prueba").addDocument(data: [
            "mensaje": "Hola desde iOS",
            "fecha": Date()
        ]) { error in
            if let error = error {
                resultado = "Error: \(error.localizedDescription)"
            } else {
                resultado = "Mensaje guardado en la base de datos"
            }
        }
    }
}

#Preview {
    PruebaConexionFirebase()
}

