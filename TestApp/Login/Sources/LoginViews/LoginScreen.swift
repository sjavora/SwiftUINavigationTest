import SwiftUI
import Combine
import Navigation
import Login
import UserStorageMocks

enum PresentedDestination {
    case dummySheet
}

@MainActor public final class LoginScreenViewModel: ObservableObject {

    @Published var presented: PresentedDestination?

    let userStorage: any UserStoring
    let dismissalPublisher = PassthroughSubject<Void, Never>()

    public init(userStorage: any UserStoring) {
        self.userStorage = userStorage
    }

    func didConfirmLogin() {
        userStorage.isLoggedIn = true
        dismissalPublisher.send()
    }
}

public struct LoginScreen: View {

    @ObservedObject var viewModel: LoginScreenViewModel
    @Environment(\.presentationMode) var presentationMode

    public init(viewModel: LoginScreenViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button("Finish login") {
                    viewModel.didConfirmLogin()
                }

                Button("Show dummy sheet") {
                    viewModel.presented = .dummySheet
                }
            }
            .navigationTitle("Login")
            .onReceive(viewModel.dismissalPublisher) {
                presentationMode.wrappedValue.dismiss()
            }
            .sheet(selection: $viewModel.presented) { _ in
                Text("dummy")
            }
            .onDeeplink(LoginDeeplink.self, preferences: .preserveExistingUI) { deeplink in
                viewModel.didConfirmLogin()
                // FIXME: why is this necessary?
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct LoginScreenPreviews: PreviewProvider {

    static var previews: some View {
        LoginScreen(
            viewModel: .init(
                userStorage: .mock
            )
        )
        .environmentObject(DeeplinkRouter())
        .environmentObject(PresentedDismissalHandlers())
    }
}
