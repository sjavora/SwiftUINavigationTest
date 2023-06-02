import SwiftUI

extension View {

    public func fullScreenCover<Value, Content>(
        selection: Binding<Value?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> Content
    ) -> some View where Content: View {
        fullScreenCover(
            isPresented: selection.isPresent(),
            onDismiss: onDismiss,
            content: {
                Binding(unwrapping: selection).map { binding in
                    content(binding.wrappedValue)
                }
            }
        )
    }

    public func fullScreenCover<Enum, Case, Content>(
        selection: Binding<Enum?>,
        extract: @escaping (Enum) -> Case?,
        embed: @escaping (Case) -> Enum,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Case) -> Content
    ) -> some View where Case: Equatable, Content: View {
        fullScreenCover(
            selection: selection.case(extract: extract, embed: embed),
            onDismiss: onDismiss,
            content: content
        )
    }
}
