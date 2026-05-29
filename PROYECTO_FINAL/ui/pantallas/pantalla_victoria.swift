import SwiftUI

struct PantallaVictoria: View {
    let al_volver_inventario: () -> Void

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    EncabezadoPantalla(
                        preheader: "> PROTOCOLO R.O.M.A.  /  RESCATE COMPLETADO",
                        titulo: "Victoria"
                    )

                    BarraPuntos()

                    BloqueTransmision(
                        etiqueta: "/// IA-CJ ///",
                        cuerpo: "Codigo aceptado. La secuencia romana estabilizo la brecha y cerro el ciclo corrupto antes del colapso. Ernesto fue extraido de la simulacion con signos vitales estables; el canal de rescate queda asegurado y el sistema vuelve a operar bajo control humano."
                    )

                    BarraPuntos()

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 12) {
                            EtiquetaCorchete(texto: "/// EQUIPO RECUPERADO ///")

                            HStack(alignment: .center, spacing: 14) {
                                Spacer(minLength: 0)
                                VStack(spacing: 8) {
                                    VisorEscenaAnimada(
                                        ruta_escena: "personajes/escenas/npc-estando",
                                        tamano: 160,
                                        en_loop: true
                                    )
                                    Text("ERNESTO")
                                        .font(.sistema_dato)
                                        .foregroundStyle(Color.sistema_marron)
                                }
                                VStack(spacing: 8) {
                                    VisorIACJ(procesando: false, tamano: 132)
                                    Text("IA-CJ")
                                        .font(.sistema_dato)
                                        .foregroundStyle(Color.sistema_marron)
                                }
                                Spacer(minLength: 0)
                            }
                        }
                    }

                    BarraPuntos()

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 12) {
                            EtiquetaCorchete(texto: "/// ESTADO FINAL ///")
                            MensajeEstado(
                                texto: "COMPANERO RESCATADO A TIEMPO",
                                tono: .exito
                            )

                            HStack {
                                Spacer()
                                Button("VOLVER AL INVENTARIO") {
                                    al_volver_inventario()
                                }
                                .buttonStyle(.sistema)
                            }
                        }
                    }
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    PantallaVictoria {}
        .background(Color.sistema_arena)
}
