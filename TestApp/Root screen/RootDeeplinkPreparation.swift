import SwiftUI
import Navigation

extension View {

    func deeplinkPreparation(tabsModel: TabsModel) -> some View {
        modifier(RootDeeplinkPreparationModifier(tabsModel: tabsModel))
    }
}

struct RootDeeplinkPreparationModifier: ViewModifier {

    @EnvironmentObject var modalDismissalHandlers: ModalDismissalHandlers
    @EnvironmentObject var bookingPresenter: BookingPresenter
    @ObservedObject var tabsModel: TabsModel

    func body(content: Content) -> some View {
        content
            .onDeeplinkPreparation { configuration in
                try await prepareStateForDeeplinkPresentation(configuration)
            }
    }

    func prepareStateForDeeplinkPresentation(_ configuration: DeeplinkPreparationConfiguration) async throws {

        await dismissAlertIfNeeded()

        var wasDismissing = false

        if configuration.shouldClearCurrentUI {
            await dismissModals()

            if bookingPresenter.bookingIsPresented {
                wasDismissing = true
                try await bookingPresenter.dismissCurrentBookingIfPossible()
            }
        }

        if let destinationTab = configuration.destinationTab {

            if destinationTab != tabsModel.selectedTab.wrappedValue {
                tabsModel.selectTab(destinationTab)
            }

            if configuration.shouldClearCurrentUI {
                tabsModel.popTabToRoot(destinationTab)
                wasDismissing = true
            }
        }

        if wasDismissing {
            // This is the smallest value where the navigation stack
            // doesn't get popped immediately after pushing the new screen
            try await Task.sleep(nanoseconds: 1000 * NSEC_PER_MSEC)
        }
    }

    func dismissAlertIfNeeded() async {

        var wasDismissing = false

        if let alertHandler = modalDismissalHandlers.handlers.last, alertHandler.kind == .alert {
            await alertHandler.dismissModal()
        } else if let bookingDismissalModel = bookingPresenter.bookingDismissalModel,
                  bookingDismissalModel.isDismissalConfirmationPresented {
            bookingDismissalModel.dismissAlert()
            wasDismissing = true
        }

        if wasDismissing {
            // There is no way to know when the dismissal is complete, but doing something else immediately
            // could conflict with the dismissal.
            try? await Task.sleep(nanoseconds: 500 * NSEC_PER_MSEC)
        }
    }

    func dismissModals() async {
        for handler in modalDismissalHandlers.handlers.reversed() {
            await handler.dismissModal()
        }
    }
}
