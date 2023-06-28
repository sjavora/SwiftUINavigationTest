import SwiftUI
import Navigation

struct BookingScreen: View {

    let token: String
    var alert: () -> Void = {}
    var sheet: () -> Void = {}
    var dismiss: () -> Void = {}
    var finish: () -> Void = {}

    var body: some View {
        VStack(spacing: 20) {
            Text("Token: \(token)")

            Button("Show dummy alert") {
                alert()
            }

            Button("Show dummy sheet") {
                sheet()
            }

            Button("Go to booking detail in MMB") {
                finish()
            }

            Button("Dismiss") {
                dismiss()
            }
        }
        .navigationTitle("Booking")
    }
}

struct BookingScreenPreviews: PreviewProvider {

    static var previews: some View {
        BookingScreen(token: "123")
            .environmentObject(PresentedDismissalHandlers())
    }
}
