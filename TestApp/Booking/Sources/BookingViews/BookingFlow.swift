import SwiftUI
import Navigation

public struct BookingFlow: View {

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
            bookingScreen
                .bookingDismissalConfirmation(bookingDismissalConfirmation)
        }
        .sheet(selection: $presented, case: .dummySheet) {
            Text("dummy")
        }
        .alert(selection: $presented, case: .dummyAlert) {
            Alert(title: Text("test"))
        }
    }

    @ViewBuilder var bookingScreen: some View {
        BookingScreen(
            token: token,
            alert: { presented = .dummyAlert },
            sheet: { presented = .dummySheet },
            dismiss: {
                Task {
                    if await bookingDismissalConfirmation.canBeDismissed() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            },
            finish: { finish("123") }
        )
    }

    public init(token: String, finish: @escaping (_ bookingID: String) -> Void) {
        self.token = token
        self.finish = finish
    }
}

struct BookingFlowPreviews: PreviewProvider {

    static var previews: some View {
        BookingFlow(token: "123", finish: { _ in })
            .environmentObject(PresentedDismissalHandlers())
    }
}
