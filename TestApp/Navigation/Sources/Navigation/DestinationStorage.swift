import SwiftUI

public final class DestinationStorage: ObservableObject {

    private static let viewNotFound = AnyView(Text("View not found!").foregroundColor(.red))

    private var dictionary: [String: (Any) -> AnyView] = [:]

    public init() {

    }

    public func callAsFunction(for route: some Hashable) -> AnyView {
        destination(for: ItemWithIdentifier(route))
    }

    func callAsFunction(for identifier: ItemWithIdentifier) -> AnyView {
        destination(for: identifier)
    }

    func set<Path>(path: Path.Type, destination: @escaping (Path) -> some View) {
        dictionary[ItemWithIdentifier.identifier(for: path)] = { key in
            if let path = key as? Path {
                return AnyView(destination(path))
            } else {
                return Self.viewNotFound
            }
        }
    }

    func destination(for identifier: ItemWithIdentifier) -> AnyView {
        guard let closure = dictionary[identifier.identifier] else {
            return Self.viewNotFound
        }

        return closure(identifier.value)
    }
}

public extension View {

    func destination<Path>(
        for _: Path.Type,
        @ViewBuilder destination: @escaping (Path) -> some View
    ) -> some View {
        modifier(DestinationModifier(type: Path.self, destination: destination))
    }
}

struct DestinationModifier<Path, Destination: View>: ViewModifier {

    @EnvironmentObject var storage: DestinationStorage

    let destination: (Path) -> Destination

    init(type _: Path.Type, destination: @escaping (Path) -> Destination) {
        self.destination = destination
    }

    func body(content: Content) -> some View {
        storage.set(path: Path.self, destination: destination)

        return content
            .environmentObject(storage)
    }
}
