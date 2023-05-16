import SwiftUI

public enum TabBarTab {
    case search
    case bookings
}

public extension EnvironmentValues {
    var currentTab: TabBarTab? {
        get { self[CurrentTabKey.self] }
        set { self[CurrentTabKey.self] = newValue }
    }
}

private struct CurrentTabKey: EnvironmentKey {
    static let defaultValue: TabBarTab? = nil
}
