import SwiftUI

enum Seccion: String, CaseIterable, Identifiable {
    case tareas, dibujo, gestos, dispositivo

    var id: String { rawValue }

    var titulo: String {
        switch self {
        case .tareas: return "Tareas"
        case .dibujo: return "Dibujo"
        case .gestos: return "Gestos"
        case .dispositivo: return "Dispositivo"
        }
    }

    var icono: String {
        switch self {
        case .tareas: return "checklist"
        case .dibujo: return "pencil.tip"
        case .gestos: return "hand.draw"
        case .dispositivo: return "ipad"
        }
    }
}

struct ContentView: View {
    @State private var seleccion: Seccion? = .tareas

    var body: some View {
        NavigationSplitView {
            List(Seccion.allCases, selection: $seleccion) { seccion in
                NavigationLink(value: seccion) {
                    Label(seccion.titulo, systemImage: seccion.icono)
                }
            }
            .navigationTitle("Pruebas iPad")
        } detail: {
            NavigationStack {
                detalle
            }
        }
    }

    @ViewBuilder
    private var detalle: some View {
        switch seleccion {
        case .tareas:
            TareasView()
        case .dibujo:
            DibujoView()
        case .gestos:
            GestosView()
        case .dispositivo:
            InfoView()
        case nil:
            ContentUnavailableView("Elige una sección", systemImage: "sidebar.left")
        }
    }
}
