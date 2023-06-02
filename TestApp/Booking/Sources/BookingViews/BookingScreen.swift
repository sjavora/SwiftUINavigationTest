import SwiftUI
import Navigation

// TODO: Booking Flow wrapper around screens
public struct BookingScreen: View {

    enum PresentedDestination {
        case dummyAlert
        case dummySheet
    }

    @Environment(\.presentationMode) var presentationMode
    @StateObject var bookingDismissalConfirmation = BookingDismissalConfirmationModel()
    @State var presented: PresentedDestination?

    public let token: String
    public let finish: (_ bookingID: String) -> Void

    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Token: \(token)")

                Button("Show dummy alert") {
                    presented = .dummyAlert
                }

                Button("Show dummy sheet") {
                    presented = .dummySheet
                }

                Button("Go to booking detail in MMB") {
                    finish("123")
                }

                Button("Dismiss") {
                    Task {
                        if await bookingDismissalConfirmation.canBeDismissed() {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Booking")
            .bookingDismissalConfirmation(bookingDismissalConfirmation)
        }
        .sheet(selection: $presented, case: .dummySheet) {
            Text("dummy")
        }
        .alert(selection: $presented, case: .dummyAlert) {
            Alert(title: Text("test"))
        }
    }

    public init(token: String, finish: @escaping (_ bookingID: String) -> Void) {
        self.token = token
        self.finish = finish
    }
}

struct BookingScreenPreviews: PreviewProvider {

    static var previews: some View {
        BookingScreen(token: "123", finish: { _ in })
            .environmentObject(ModalDismissalHandlers())
    }
}
