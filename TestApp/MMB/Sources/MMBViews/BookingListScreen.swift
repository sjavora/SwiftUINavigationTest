import SwiftUI
import Combine
import Navigation
import UserStorageMocks
import Login
import MMB

@MainActor public final class BookingListViewModel: ObservableObject {

    @Published var isLoggedIn = false
    @Published var bookings: [String] = []

    let userStorage: any UserStoring

    public init(userStorage: any UserStoring) {
        self.userStorage = userStorage

        userStorage.loggedInPublisher.assign(to: &$isLoggedIn)
        userStorage.bookingsPublisher.assign(to: &$bookings)
    }
}

public struct BookingListScreen: View {

    @ObservedObject var viewModel: BookingListViewModel

    let logIn: () -> Void
    let search: () -> Void
    let detail: (_ bid: String) -> Void

    public var body: some View {
        content
            .navigationTitle("Booking list")            
    }

    @ViewBuilder var content: some View {
        VStack(spacing: 20) {
            if viewModel.isLoggedIn {
                bookingList
            } else {
                Button("Log in") {
                    logIn()
                }

                Button("Go to search") {
                    search()
                }
            }
        }
    }

    @ViewBuilder var bookingList: some View {
        List(viewModel.bookings, id: \.self) { bookingID in
            Button(bookingID) {
                detail(bookingID)
            }
        }
    }

    public init(
        viewModel: BookingListViewModel,
        logIn: @escaping () -> Void,
        search: @escaping () -> Void,
        detail: @escaping (String) -> Void
    ) {
        self.viewModel = viewModel
        self.logIn = logIn
        self.search = search
        self.detail = detail
    }
}

struct BookingListScreenPreviews: PreviewProvider {

    static var previews: some View {
        BookingListScreen(
            viewModel: .init(userStorage: .mock),
            // VM should do all that
            logIn: {},
            search: {},
            detail: { _ in }
        )
    }
}
