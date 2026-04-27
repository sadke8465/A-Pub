import SwiftUI

struct GoToLocationSheet: View {

    let onGo: (Double) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var percentage: Double
    @State private var percentageText: String

    init(currentPercentage: Double, onGo: @escaping (Double) -> Void) {
        let clampedPercentage = (currentPercentage * 100).clamped(to: 0...100)
        self.onGo = onGo
        _percentage = State(initialValue: clampedPercentage)
        _percentageText = State(initialValue: String(Int(clampedPercentage.rounded())))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Location") {
                    LabeledContent("Progress") {
                        Text("\(Int(percentage.rounded()))%")
                            .monospacedDigit()
                    }

                    Slider(value: percentageBinding, in: 0...100, step: 1)

                    TextField("Percent", text: $percentageText)
                        .keyboardType(.numberPad)
                        .onChange(of: percentageText) { _, text in
                            updatePercentageText(text)
                        }
                }
            }
            .navigationTitle("Go to Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Go") {
                        onGo(percentage.clamped(to: 0...100) / 100)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.fraction(0.32), .medium])
    }

    private var percentageBinding: Binding<Double> {
        Binding(
            get: { percentage },
            set: { newValue in
                percentage = newValue
                percentageText = String(Int(newValue.rounded()))
            }
        )
    }

    private func updatePercentageText(_ text: String) {
        let filtered = text.filter(\.isNumber)
        if filtered != text {
            percentageText = filtered
        }
        if let value = Double(filtered) {
            percentage = value.clamped(to: 0...100)
        }
    }
}
