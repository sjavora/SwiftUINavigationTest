import Combine

public final class FakeUserStorage: UserStoring {

    @Published public var isLoggedIn = false
    @Published public var bookings = [String]()

    public var loggedInPublisher: AnyPublisher<Bool, Never> { $isLoggedIn.dropFirst().eraseToAnyPublisher() }
    public var bookingsPublisher: AnyPublisher<[String], Never> { $bookings.dropFirst().eraseToAnyPublisher() }
}

public extension UserStoring where Self == FakeUserStorage {

    static var mock: Self {
        self.init()
    }
}
