import SwiftUI
import Navigation
import Search
import UserStorageMocks

// Shared wrapper for search feature views (+ later fonts,...)
struct PreviewWrapper<Content: View>: View {

    @StateObject var modalDismissalHandlers = PresentedDismissalHandlers()
    @StateObject var deeplinkRouter = DeeplinkRouter()

    @ViewBuilder var content: Content

    var body: some View {
        content
            .environmentObject(modalDismissalHandlers)
            .environmentObject(deeplinkRouter)
            .environment(\.userStorage, .mock)
    }
}
