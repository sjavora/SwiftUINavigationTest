import SwiftUI

@MainActor public final class DeeplinkRouter: ObservableObject {

    @Published public private(set) var deeplink: Deeplink?
    @Published public private(set) var configuration: DeeplinkPreparationConfiguration?
    private var preparationContinuation: CheckedContinuation<Void, Never>?

    public init() {
        
    }

    public func send(_ deeplink: Deeplink) {
        print("Deeplink sent to environment: \(deeplink)")
        self.deeplink = deeplink
    }

    func claimCurrentDeeplink(with preparation: DeeplinkHandlerPreferences, currentTab: TabBarTab?) async {
        if #available(iOS 15.0, *) { // TODO: remove
            if let deeplink = await $deeplink.values.compactMap({ $0 }).first(where: { _ in true }) {
                print("Deeplink claimed \(deeplink)")
            }
        }
        assert(deeplink != nil)
        deeplink = nil

        let destinationTab: TabBarTab?

        switch preparation.destinationTab {
            case .basedOnHandler:   destinationTab = associatedTab
            case .custom(let tab):  destinationTab = tab
            case nil:               destinationTab = nil
        }

        let configuration = DeeplinkPreparationConfiguration(
            destinationTab: destinationTab,
            shouldClearCurrentUI: preparation.shouldClearCurrentUI
        )

        await prepareForDeeplinkPresentation(configuration)
    }

    func prepareForDeeplinkPresentation(_ configuration: DeeplinkPreparationConfiguration) async {
        self.configuration = configuration

        await withCheckedContinuation { continuation in
            preparationContinuation = continuation
        }
    }

    func finishPreparation() {
        preparationContinuation?.resume()
        preparationContinuation = nil

        configuration = nil
    }
}
