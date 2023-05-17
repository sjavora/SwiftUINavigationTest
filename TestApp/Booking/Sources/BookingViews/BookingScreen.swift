import SwiftUI
import Navigation

// TODO: Booking Flow wrapper around screens
public struct BookingScreen: View {

    enum Modal {
        case dummyAlert
        case dummySheet
    }

    @Environment(\.presentationMode) var presentationMode
    @StateObject var bookingDismissalConfirmation = BookingDismissalConfirmationModel()
    @State var modal: Modal?

    public let token: String
    public let finish: (_ bookingID: String) -> Void

    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Token: \(token)")

                Button("Show dummy alert") {
                    modal = .dummyAlert
                }

                Button("Show dummy sheet") {
                    modal = .dummySheet
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
        .sheet(selection: $modal, case: .dummySheet) {
            Text("dummy")
        }
        .alert(selection: $modal, case: .dummyAlert) {
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
        // TODO: Presentation crashes
        BookingScreen(token: "123", finish: { _ in })
    }
}
