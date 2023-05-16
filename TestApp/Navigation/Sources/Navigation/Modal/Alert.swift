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

    // TODO: associated value variant
}
