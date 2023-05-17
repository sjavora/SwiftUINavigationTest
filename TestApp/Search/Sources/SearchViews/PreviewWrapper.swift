import SwiftUI
import Navigation
import Search
import UserStorage

// Shared wrapper for search feature views (+ later fonts,...)
struct PreviewWrapper<Content: View>: View {

    @StateObject var destinations = DestinationStorage()
    @StateObject var modalDismissalHandlers = ModalDismissalHandlers()
    @StateObject var deeplinkRouter = DeeplinkRouter()

    @ViewBuilder var content: Content

    let userStorage: any UserStoring = .mock

    init(@ViewBuilder content: () -> Content) {
        self.content = content()

        UserStorageKey.$defaultValue.injectedValue = userStorage
    }

    var body: some View {
        content
            .environmentObject(destinations)
            .environmentObject(modalDismissalHandlers)
            .environmentObject(deeplinkRouter)
            .environment(\.userStorage, .mock)
    }
}
