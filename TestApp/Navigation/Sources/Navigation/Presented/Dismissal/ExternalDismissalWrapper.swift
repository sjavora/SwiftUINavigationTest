import SwiftUI

/// A wrapper that makes it possible to dismiss a presented view using ``PresentedDismissalHandlers``
struct ExternalDismissalWrapper<Content: View>: View {

    @EnvironmentObject var dismissalHandlers: PresentedDismissalHandlers
    @StateObject var handler: PresentedDismissalHandlers.Handler
    let isPresented: Binding<Bool>
    let content: (Binding<Bool>) -> Content

    init(
        _ kind: PresentedDismissalHandlers.Handler.Kind,
        isPresented: Binding<Bool>,
        content: @escaping (Binding<Bool>) -> Content
    ) {
        self._handler = StateObject(wrappedValue: PresentedDismissalHandlers.Handler(kind: kind))
        self.isPresented = isPresented
        self.content = content
    }

    var body: some View {
        content(
            Binding(
                get: {
                    isPresented.wrappedValue && handler.presentationOverride
                },
                set: { isPresented, transaction in
                    if isPresented == false {
                        self.isPresented.transaction(transaction).wrappedValue = false
                        handler.presentationOverride = true
                    }
                }
            )
        )
        .onChange(of: isPresented.wrappedValue) { isPresented in
            // The `isPresented` binding's setter above is not triggered during presentation, only dismissal.
            // Here in onChange, both value changes are correctly observed.
            if isPresented {
                dismissalHandlers.add(handler)
            } else {
                dismissalHandlers.remove(handler)
            }
        }
    }
}
