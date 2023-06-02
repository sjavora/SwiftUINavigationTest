import SwiftUI

extension View {

    @available(iOS, introduced: 14, obsoleted: 16, message: "Use native SwiftUI API.")
    public func navigationDestination<Destination>(
        for type: Destination.Type,
        @ViewBuilder destinationView: @escaping (Destination) -> some View
    ) -> some View {
        preference(
            key: NavigationDestinationsKey.self,
            value: NavigationDestinations(
                destinations: [
                    ItemWithIdentifier.identifier(for: type): { value in
                        guard let destination = value as? Destination else {
                            fatalError("Value \(value) is not of type \(Destination.self)!")
                        }

                        return AnyView(destinationView(destination))
                    }
                ]
            )
        )
    }
}

struct NavigationDestinations: Equatable {

    private var destinations: [String: (Any) -> AnyView]

    init(destinations: [String: (Any) -> AnyView] = [:]) {
        self.destinations = destinations
    }

    mutating func merge(_ other: Self) {
        destinations.merge(other.destinations, uniquingKeysWith: { _, _ in fatalError() })
    }

    func destination(for identifier: ItemWithIdentifier) -> AnyView {
        guard let closure = destinations[identifier.identifier] else {
            return AnyView(Text("View not found!").background(Color.red))
        }

        return closure(identifier.value)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.destinations.keys == rhs.destinations.keys
    }
}

struct NavigationDestinationsKey: PreferenceKey {

    public static let defaultValue = NavigationDestinations()

    public static func reduce(value: inout NavigationDestinations, nextValue: () -> NavigationDestinations) {
        value.merge(nextValue())
    }
}
