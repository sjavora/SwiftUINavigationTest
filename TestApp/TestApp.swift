import SwiftUI
import Navigation
import BookingViews

@main
@MainActor struct TestApp: App {

    @StateObject var modalDismissalHandlers = PresentedDismissalHandlers()
    @StateObject var deeplinkRouter = DeeplinkRouter()
    @StateObject var bookingPresenter = BookingPresenter()

    let dependencies = Dependencies()

    var body: some Scene {
        WindowGroup {
            RootFlow()
                .environmentObject(modalDismissalHandlers)
                .environmentObject(deeplinkRouter)
                .environmentObject(bookingPresenter)
                .environment(\.userStorage, dependencies.userStorage)
        }
    }
}
