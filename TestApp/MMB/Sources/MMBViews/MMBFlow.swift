import SwiftUI
import Navigation
import MMB
import UserStorage
import LoginViews

public struct MMBFlow: View {

    enum NavigationDestination: Hashable {
        case bookingDetail(bid: String)
        case itineraryDetail
    }

    enum PresentedDestination {
        case login
    }

    @Environment(\.userStorage) var userStorage

    @StateObject var path = PushNavigationPath()
    @State var presented: PresentedDestination?

    @Binding var popToRoot: Bool

    let switchToSearchTab: () -> Void

    public var body: some View {
        PushNavigationStack(path: path) {
            bookingList
                .navigationDestination(for: NavigationDestination.self) { route in
                    switch route {
                        case .bookingDetail(let bookingID):
                            bookingDetail(forBookingID: bookingID)
                        case .itineraryDetail:
                            itineraryDetail
                    }
                }
        }
        .popsToRoot(path, trigger: $popToRoot)
        .sheet(selection: $presented, case: .login) {
            LoginScreen(viewModel: LoginScreenViewModel(userStorage: userStorage))
        }
        .onDeeplink(BookingDetailDeeplink.self) { deeplink in
            path.push(NavigationDestination.bookingDetail(bid: deeplink.bid))
        }
    }

    @ViewBuilder var bookingList: some View {
        BookingListScreen(
            viewModel: BookingListViewModel(userStorage: userStorage),
            logIn: {
                presented = .login
            },
            search: { switchToSearchTab() },
            detail: { bid in
                path.push(NavigationDestination.bookingDetail(bid: bid))
            }
        )
    }

    @ViewBuilder func bookingDetail(forBookingID bookingID: String) -> some View {
        BookingDetailScreen(bookingID: bookingID) {
            path.push(NavigationDestination.bookingDetail(bid: UUID().uuidString))
        } itineraryDetail: {
            path.push(NavigationDestination.itineraryDetail)
        }
    }

    @ViewBuilder var itineraryDetail: some View {
        Text("Itinerary detail")
    }

    public init(popToRoot: Binding<Bool>, switchToSearchTab: @escaping () -> Void) {
        self._popToRoot = popToRoot
        self.switchToSearchTab = switchToSearchTab
    }
}

struct MMBFlowPreviews: PreviewProvider {

    struct MMBFlowWrapper: View {

        @State var popToRoot = false

        let userStorage: any UserStoring = .mock

        init() {
            self.popToRoot = popToRoot

            UserStorageKey.$defaultValue.injectedValue = userStorage
        }

        var body: some View {
            MMBFlow(
                popToRoot: $popToRoot,
                switchToSearchTab: {}
            )
            .environmentObject(DeeplinkRouter())
            .environmentObject(ModalDismissalHandlers())
            .environment(\.userStorage, userStorage)
        }
    }

    static var previews: some View {
        MMBFlowWrapper()
    }
}
