import SwiftUI

public struct DeeplinkHandlerPreferences {

    enum DestinationTab {
        case basedOnHandler
        case custom(TabBarTab)
    }

    let destinationTab: DestinationTab?
    let shouldClearCurrentUI: Bool

    public static let `default` = Self(destinationTab: .basedOnHandler, shouldClearCurrentUI: true)

    public static func switchToTab(_ tab: TabBarTab, clearCurrentUI: Bool = false) -> Self {
        Self.init(destinationTab: .custom(tab), shouldClearCurrentUI: clearCurrentUI)
    }

    public static let switchToTab = Self(destinationTab: .basedOnHandler, shouldClearCurrentUI: true)

    public static let preserveExistingUI = Self(destinationTab: nil, shouldClearCurrentUI: false)
}

extension View {

    public func onDeeplink<D: Deeplink>(
        _: D.Type,
        preferences: DeeplinkHandlerPreferences = .default,
        perform action: @escaping (D) -> Void
    ) -> some View {
        modifier(DeeplinkHandlerModifier(preferences: preferences, action: action))
    }

    public func onDeeplink<D: Deeplink>(
        _: D.Type,
        preferences: DeeplinkHandlerPreferences = .default,
        perform action: @escaping () -> Void
    ) -> some View {
        modifier(
            DeeplinkHandlerModifier<D>(preferences: preferences) { _ in
                action()
            }
        )
    }
}

struct DeeplinkHandlerModifier<D: Deeplink>: ViewModifier {

    @EnvironmentObject var deeplinkRouter: DeeplinkRouter
    @Environment(\.associatedTab) var associatedTab

    let preferences: DeeplinkHandlerPreferences
    let action: (D) -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(deeplinkRouter.$deeplink) { deeplink in
                if let deeplink = deeplink as? D {
                    Task {
                        await deeplinkRouter.claimCurrentDeeplink(with: preferences, associatedTab: associatedTab)
                        action(deeplink)
                    }
                }
            }
    }
}
