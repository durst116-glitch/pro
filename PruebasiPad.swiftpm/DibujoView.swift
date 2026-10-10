import SwiftUI

struct Trazo {
    var puntos: [CGPoint]
    var color: Color
    var grosor: CGFloat
}

/// Lienzo simple: funciona con el dedo o con Apple Pencil.
struct DibujoView: View {
    @State private var trazos: [Trazo] = []
    @State private var actual: Trazo?
    @State private var color: Color = .blue
    @State private var grosor: CGFloat = 6

    var body: some View {
        Canvas { context, _ in
            let todos = trazos + (actual.map { [$0] } ?? [])
            for trazo in todos {
                var path = Path()
                path.addLines(trazo.puntos)
                context.stroke(
                    path,
                    with: .color(trazo.color),
                    style: StrokeStyle(lineWidth: trazo.grosor, lineCap: .round, lineJoin: .round)
                )
            }
        }
        .background(Color(.systemBackground))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { valor in
                    if actual == nil {
                        actual = Trazo(puntos: [valor.location], color: color, grosor: grosor)
                    } else {
                        actual?.puntos.append(valor.location)
                    }
                }
                .onEnded { _ in
                    if let trazo = actual {
                        trazos.append(trazo)
                    }
                    actual = nil
                }
        )
        .navigationTitle("Dibujo")
        .toolbar {
            ToolbarItemGroup {
                ColorPicker("Color", selection: $color)
                    .labelsHidden()
                Slider(value: $grosor, in: 1...30)
                    .frame(width: 150)
                Button {
                    if !trazos.isEmpty { trazos.removeLast() }
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                }
                .disabled(trazos.isEmpty)
                Button(role: .destructive) {
                    trazos.removeAll()
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(trazos.isEmpty)
            }
        }
    }
}
