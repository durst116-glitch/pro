import SwiftUI
import UIKit

struct InfoView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Environment(\.colorScheme) private var esquema
    @State private var bateria: Float = -1

    var body: some View {
        GeometryReader { geo in
            List {
                Section("Dispositivo") {
                    LabeledContent("Modelo", value: UIDevice.current.model)
                    LabeledContent("Nombre", value: UIDevice.current.name)
                    LabeledContent("Sistema", value: "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)")
                }

                Section("Pantalla") {
                    LabeledContent("Tamaño de la vista", value: "\(Int(geo.size.width)) × \(Int(geo.size.height)) pt")
                    LabeledContent("Orientación", value: geo.size.width > geo.size.height ? "Horizontal" : "Vertical")
                    LabeledContent("Clase de tamaño", value: sizeClass == .regular ? "Regular" : "Compacta")
                    LabeledContent("Apariencia", value: esquema == .dark ? "Oscura" : "Clara")
                }

                Section("Batería") {
                    LabeledContent("Nivel", value: bateria < 0 ? "No disponible" : "\(Int(bateria * 100)) %")
                }
            }
        }
        .navigationTitle("Dispositivo")
        .onAppear {
            UIDevice.current.isBatteryMonitoringEnabled = true
            bateria = UIDevice.current.batteryLevel
        }
    }
}
