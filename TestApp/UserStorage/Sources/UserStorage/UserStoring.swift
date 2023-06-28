import Combine
import SwiftUI
import Navigation

public protocol UserStoring: AnyObject {

    var isLoggedIn: Bool { get set }
    var bookings: [String] { get }

    var loggedInPublisher: AnyPublisher<Bool, Never> { get }
    var bookingsPublisher: AnyPublisher<[String], Never> { get }
}

public struct UserStorageKey: EnvironmentKey {
    public typealias Value = any UserStoring

    public static var defaultValue: any UserStoring = InitialUserStorage()
}

public extension EnvironmentValues {
    var userStorage: any UserStoring {
        get { self[UserStorageKey.self] }
        set { self[UserStorageKey.self] = newValue }
    }
}

// FIXME: can we do better than this? Perhaps macros will make it shorter...
private final class InitialUserStorage: UserStoring {

    var isLoggedIn: Bool {
        get { fatalError() }
        set { fatalError() }
    }

    var bookings: [String] { fatalError() }
    var loggedInPublisher: AnyPublisher<Bool, Never> { fatalError() }
    var bookingsPublisher: AnyPublisher<[String], Never> { fatalError() }
}
