import SwiftUI
import Combine
import Navigation
import Login
import UserStorage

enum Route {
    case dummySheet
}

@MainActor public final class LoginScreenViewModel: ObservableObject {

    @Published var route: Route?

    let userStorage: any UserStoring
    let dismissalPublisher = PassthroughSubject<Void, Never>()

    public init(userStorage: any UserStoring) {
        self.userStorage = userStorage
    }

    func didConfirmLogin() {
        userStorage.isLoggedIn = true
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
                    presentationMode.wrappedValue.dismiss()
                }

                Button("Show dummy sheet") {
                    viewModel.route = .dummySheet
                }
            }
            .navigationTitle("Login")
            .onReceive(viewModel.dismissalPublisher) {
                presentationMode.wrappedValue.dismiss()
            }
            .sheet(selection: $viewModel.route) { _ in
                Text("dummy")
            }
            .onDeeplink(LoginDeeplink.self, preferences: .preserveExistingUI) { deeplink in
                viewModel.didConfirmLogin()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
