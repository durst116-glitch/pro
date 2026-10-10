import SwiftUI

/// Arrastra, pellizca y gira la tarjeta. Doble toque para reiniciar.
struct GestosView: View {
    @State private var escala: CGFloat = 1
    @State private var escalaBase: CGFloat = 1
    @State private var angulo: Angle = .zero
    @State private var anguloBase: Angle = .zero
    @State private var desplazamiento: CGSize = .zero
    @State private var desplazamientoBase: CGSize = .zero

    var body: some View {
        let pellizco = MagnifyGesture()
            .onChanged { escala = escalaBase * $0.magnification }
            .onEnded { _ in escalaBase = escala }

        let giro = RotateGesture()
            .onChanged { angulo = anguloBase + $0.rotation }
            .onEnded { _ in anguloBase = angulo }

        let arrastre = DragGesture()
            .onChanged { valor in
                desplazamiento = CGSize(
                    width: desplazamientoBase.width + valor.translation.width,
                    height: desplazamientoBase.height + valor.translation.height
                )
            }
            .onEnded { _ in desplazamientoBase = desplazamiento }

        RoundedRectangle(cornerRadius: 24)
            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 220, height: 220)
            .overlay {
                Image(systemName: "hand.draw")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
            }
            .shadow(radius: 10)
            .scaleEffect(escala)
            .rotationEffect(angulo)
            .offset(desplazamiento)
            .gesture(arrastre.simultaneously(with: pellizco.simultaneously(with: giro)))
            .onTapGesture(count: 2, perform: reiniciar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                Text(String(format: "Escala %.2f · Ángulo %.0f° · Doble toque para reiniciar", escala, angulo.degrees))
                    .font(.footnote.monospacedDigit())
                    .padding(10)
                    .background(.thinMaterial, in: Capsule())
                    .padding()
            }
            .navigationTitle("Gestos")
    }

    private func reiniciar() {
        withAnimation(.spring) {
            escala = 1
            escalaBase = 1
            angulo = .zero
            anguloBase = .zero
            desplazamiento = .zero
            desplazamientoBase = .zero
        }
    }
}
