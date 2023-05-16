import SwiftUI
import Navigation
import SearchViews
import Booking
import BookingViews
import MMB
import MMBViews

struct RootFlow: View {

    @StateObject var tabsModel = TabsModel()
    @EnvironmentObject var bookingPresenter: BookingPresenter
    @EnvironmentObject var deeplinkRouter: DeeplinkRouter
    @Environment(\.userStorage) var userStorage

    var body: some View {
        TabView(selection: tabsModel.selectedTab) {
            searchTab
            bookingsTab
        }
        .fullScreenCover(selection: $bookingPresenter.currentBookingToken) { token in
            BookingScreen(token: token) { bookingID in
                switchFromBookingToMMB(bookingID: bookingID)
            }
            // FIXME: ideally this would be in RootDeeplinkPreparationModifier, but it seems that
            //        PreferenceKey changes are not propagated to parents of modal views :/
            .onPreferenceChange(BookingDismissalPreferenceKey.self) { model in
                bookingPresenter.bookingDismissalModel = model
            }
        }
        .onOpenURL { url in
            handleDeeplink(url)
        }
        .onDeeplink(BookingDeeplink.self, preferences: .switchToTab(.search, clearCurrentUI: true)) { deeplink in
            bookingPresenter.presentBooking(withToken: deeplink.bookingToken)
        }
        .deeplinkPreparation(tabsModel: tabsModel)
    }

    @ViewBuilder var searchTab: some View {
        SearchFlow(popToRoot: tabsModel.popToRootBinding(.search)) { bookingToken in
            bookingPresenter.presentBooking(withToken: bookingToken)
        }
        .tag(TabBarTab.search)
        .tabItem {
            Label("Search tab", systemImage: "1.magnifyingglass")
        }
        .environment(\.currentTab, .search)
    }

    @ViewBuilder var bookingsTab: some View {
        MMBFlow(popToRoot: tabsModel.popToRootBinding(.bookings)) {
            tabsModel.selectTab(.search)
        }
        .tag(TabBarTab.bookings)
        .tabItem {
            Label("Bookings tab", systemImage: "ticket")
        }
        .environment(\.currentTab, .bookings)
    }

    func handleDeeplink(_ url: URL) {
        if let deeplink = anyDeeplink(from: url) {
            deeplinkRouter.send(deeplink)
        }
    }

    func switchFromBookingToMMB(bookingID: String) {

        // TODO: remove debug - user must be logged in to access booking detail screen
        if userStorage.isLoggedIn == false {
            userStorage.isLoggedIn = true
        }

        tabsModel.popTabToRoot(.bookings)

        if tabsModel.selectedTab.wrappedValue != .bookings {
            // dismiss the current tab as well - most likely search
            tabsModel.popTabToRoot(tabsModel.selectedTab.wrappedValue)

            tabsModel.selectTab(.bookings)
        }

        Task {
            await bookingPresenter.forceDismissCurrentBooking()

            // present booking detail... using a deeplink
            deeplinkRouter.send(BookingDetailDeeplink(bid: bookingID))
        }
    }
}
