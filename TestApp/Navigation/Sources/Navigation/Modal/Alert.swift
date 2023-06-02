import SwiftUI

extension View {

    public func alert<Value>(
        selection: Binding<Value?>,
        case: Value,
        content: @escaping () -> Alert
    ) -> some View where Value: Equatable {
        ExternallyDismissableModal(
            .alert,
            isPresented: Binding(
                get: { selection.wrappedValue == `case` },
                set: { isPresent, transaction in
                    if isPresent == false {
                        selection.transaction(transaction).wrappedValue = nil
                    }
                }
            ),
            content: { isPresented in
                self
                    .alert(isPresented: isPresented, content: content)
            }
        )
    }

    public func alert<Enum, Case>(
        selection: Binding<Enum?>,
        extract: @escaping (Enum) -> Case?,
        embed: @escaping (Case) -> Enum,
        onDismiss: (() -> Void)? = nil,
        content: @escaping (Case) -> Alert
    ) -> some View {
        let binding = selection.case(extract: extract, embed: embed)

        return ExternallyDismissableModal(
            .alert,
            isPresented: binding.isPresent(),
            content: { isPresented in
                self
                    .alert(isPresented: isPresented) {
                        guard let value = binding.wrappedValue else {
                            fatalError("Alert binding's value is nil.")
                        }

                        return content(value)
                    }
            }
        )
    }
}
