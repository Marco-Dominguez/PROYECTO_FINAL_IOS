import SwiftUI

struct PantallaConfiguracion: View {
    @Environment(PerfilUsuario.self) private var perfil
    @Environment(GestorJuego.self) private var gestor
    @State private var servicio_chat = ServicioChat()
    @State private var confirmar_reinicio: Bool = false

    var body: some View {
        ZStack {
            Color.sistema_arena.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    EncabezadoPantalla(
                        preheader: "> SISTEMA R.O.M.A.  /  SESION",
                        titulo: "Configuracion"
                    )

                    BarraPuntos()

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 10) {
                            EtiquetaCorchete(texto: "/// OPERADOR ///")
                            FilaDato(etiqueta: "Nombre", valor: perfil.nombre ?? "SIN REGISTRO")
                            FilaDato(etiqueta: "ID sesion", valor: perfil.identificador_corto, valor_tenue: true)
                        }
                    }

                    BarraPuntos()

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 12) {
                            EtiquetaCorchete(texto: "/// PROGRESO ///")
                            FilaDato(
                                etiqueta: "Estado",
                                valor: "\(gestor.pasos_progreso_completados)/\(gestor.total_pasos_progreso) - \(gestor.porcentaje_progreso)%"
                            )
                            BarraProgresoSistema(
                                progreso: Double(gestor.pasos_progreso_completados) / Double(gestor.total_pasos_progreso),
                                alto: 8
                            )
                            estados_progreso
                        }
                    }

                    BarraPuntos()

                    PanelSistema {
                        VStack(alignment: .leading, spacing: 12) {
                            EtiquetaCorchete(texto: "/// CONTROL DE SESION ///")

                            Button("REINICIAR PARTIDA") {
                                confirmar_reinicio = true
                            }
                            .buttonStyle(.sistema)

                            Button("SALIR") {
                                perfil.cerrar_sesion()
                            }
                            .buttonStyle(.sistema)
                        }
                    }
                }
                .padding(24)
            }
        }
        .alert("Reiniciar partida", isPresented: $confirmar_reinicio) {
            Button("CANCELAR", role: .cancel) {}
            Button("REINICIAR", role: .destructive) {
                Task { await reiniciar_partida() }
            }
        } message: {
            Text("Se borraran pistas, victoria y mensajes de esta sesion. Tu nombre y llave se conservaran.")
        }
    }

    private var estados_progreso: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(gestor.pistas_disponibles) { pista in
                FilaDato(
                    etiqueta: "Fragmento \(pista.id)",
                    valor: gestor.pistas_obtenidas.contains(pista.id) ? "RECUPERADO" : "PENDIENTE",
                    valor_tenue: !gestor.pistas_obtenidas.contains(pista.id)
                )
            }
            FilaDato(
                etiqueta: "Rescate",
                valor: gestor.puzzle_resuelto ? "COMPLETADO" : "PENDIENTE",
                valor_tenue: !gestor.puzzle_resuelto
            )
        }
    }

    private func reiniciar_partida() async {
        if let usuario = perfil.identificador_sesion {
            await servicio_chat.borrar_mensajes(usuario: usuario)
        }
        gestor.reiniciar_partida()
    }
}

#Preview {
    PantallaConfiguracion()
        .environment({
            let g = GestorJuego()
            g.cargar_para(usuario: "sesion_demo")
            g.desbloquear_pista(id: "X")
            g.desbloquear_pista(id: "C")
            g.descartar_popup()
            g.iniciar_juego()
            return g
        }())
        .environment({
            let p = PerfilUsuario()
            p.establecer(nombre: "operador_demo", llave: "demo")
            return p
        }())
}
