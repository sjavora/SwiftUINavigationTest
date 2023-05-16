import SwiftUI

extension View {

    public func sheet<Value, Content>(
        selection: Binding<Value?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) -> some View where Content: View {
        ExternallyDismissableModal(.sheet, isPresented: selection.isPresent()) { isPresented in
            self
                .sheet(isPresented: isPresented, onDismiss: onDismiss) {
                    Binding(unwrapping: selection).map { binding in
                        content(binding.wrappedValue)
                    }
                }
        }
    }

    public func sheet<Enum, Case, Content>(
        selection: Binding<Enum?>,
        extract: @escaping (Enum) -> Case?,
        embed: @escaping (Case) -> Enum,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Case) -> Content
    ) -> some View where Content: View {
        sheet(
            selection: selection.case(extract: extract, embed: embed),
            onDismiss: onDismiss,
            content: content
        )
    }

    public func sheet<Value, Content>(
        selection: Binding<Value?>,
        case: Value,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Value: Equatable, Content: View {
        sheet(
            selection: selection,
            extract: { value in
                if value == `case` {
                    return ()
                } else {
                    return nil
                }
            },
            embed: {
                `case`
            },
            onDismiss: onDismiss,
            content: {
                content()
            }
        )

//        sheet(
//            isPresented: Binding(
//                get: { selection.wrappedValue == `case` },
//                set: { isPresent, transaction in
//                    if isPresent == false {
//                        selection.transaction(transaction).wrappedValue = nil
//                    }
//                }
//            ),
//            onDismiss: onDismiss,
//            content: content
//        )
    }    
}
