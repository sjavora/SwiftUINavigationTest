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

    @LateInit public static var defaultValue: any UserStoring
}

public extension EnvironmentValues {
    var userStorage: any UserStoring {
        get { self[UserStorageKey.self] }
        set { self[UserStorageKey.self] = newValue }
    }
}

