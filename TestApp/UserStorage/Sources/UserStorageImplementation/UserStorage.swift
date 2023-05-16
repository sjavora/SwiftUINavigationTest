import Combine
import UserStorage

public final class UserStorage: ObservableObject, UserStoring {

    @Published public var isLoggedIn = false
    @Published public private(set) var bookings: [String] = []

    public var loggedInPublisher: AnyPublisher<Bool, Never> {
        $isLoggedIn.eraseToAnyPublisher()
    }

    public var bookingsPublisher: AnyPublisher<[String], Never> {
        $bookings.eraseToAnyPublisher()
    }

    public init() {
        $isLoggedIn
            .map { $0 ? ["123", "456"] : [] }
            .assign(to: &$bookings)
    }
}
