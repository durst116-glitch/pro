import SwiftUI

struct Tarea: Identifiable, Codable {
    var id = UUID()
    var titulo: String
    var hecha = false
}

/// Guarda las tareas en UserDefaults para que sobrevivan al cerrar la app.
final class TareasStore: ObservableObject {
    private let clave = "tareas"

    @Published var tareas: [Tarea] = [] {
        didSet { guardar() }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: clave),
           let guardadas = try? JSONDecoder().decode([Tarea].self, from: data) {
            tareas = guardadas
        }
    }

    private func guardar() {
        if let data = try? JSONEncoder().encode(tareas) {
            UserDefaults.standard.set(data, forKey: clave)
        }
    }
}

struct TareasView: View {
    @StateObject private var store = TareasStore()
    @State private var nueva = ""

    private var textoValido: Bool {
        !nueva.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Nueva tarea", text: $nueva)
                        .onSubmit(agregar)
                    Button(action: agregar) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(!textoValido)
                }
            }

            Section("Pendientes: \(store.tareas.filter { !$0.hecha }.count)") {
                ForEach($store.tareas) { $tarea in
                    Button {
                        tarea.hecha.toggle()
                    } label: {
                        HStack {
                            Image(systemName: tarea.hecha ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(tarea.hecha ? Color.green : Color.secondary)
                            Text(tarea.titulo)
                                .strikethrough(tarea.hecha)
                                .foregroundStyle(tarea.hecha ? Color.secondary : Color.primary)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .onDelete { store.tareas.remove(atOffsets: $0) }
                .onMove { store.tareas.move(fromOffsets: $0, toOffset: $1) }
            }
        }
        .navigationTitle("Tareas")
        .toolbar {
            EditButton()
        }
    }

    private func agregar() {
        guard textoValido else { return }
        store.tareas.append(Tarea(titulo: nueva.trimmingCharacters(in: .whitespaces)))
        nueva = ""
    }
}
