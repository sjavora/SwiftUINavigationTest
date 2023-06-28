import SwiftUI

public enum TabBarTab {
    case search
    case bookings
}

public extension EnvironmentValues {
    var associatedTab: TabBarTab? {
        get { self[AssociatedTabKey.self] }
        set { self[AssociatedTabKey.self] = newValue }
    }
}

private struct AssociatedTabKey: EnvironmentKey {
    static let defaultValue: TabBarTab? = nil
}
