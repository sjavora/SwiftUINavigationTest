import Foundation
import Combine
import BookingViews

@MainActor final class BookingPresenter: ObservableObject {

    @Published var currentBookingToken: String?
    weak var bookingDismissalModel: BookingDismissalConfirmationModel?

    var bookingIsPresented: Bool {
        currentBookingToken != nil
    }

    func presentBooking(withToken token: String) {
        Task {
            try await dismissCurrentBookingIfPossible()

            currentBookingToken = token
        }
    }

    func currentBookingCanBeDismissed() async -> Bool {

        if let bookingDismissalModel {
            if await bookingDismissalModel.canBeDismissed() == false {
                print("one of the handlers denied dismissal")
                return false
            }
        }

        return true
    }

    func dismissCurrentBookingIfPossible() async throws {

        struct BookingDismissalCancelledError: Error {}

        guard bookingIsPresented else { return }

        if await currentBookingCanBeDismissed() {
            currentBookingToken = nil
        } else {
            throw BookingDismissalCancelledError()
        }
    }

    func forceDismissCurrentBooking() async {
        if bookingIsPresented {
            currentBookingToken = nil
        }

        try? await Task.sleep(nanoseconds: NSEC_PER_MSEC * 300)
    }
}
