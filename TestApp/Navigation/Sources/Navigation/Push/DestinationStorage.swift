import SwiftUI

public final class DestinationStorage: ObservableObject {

    private static let viewNotFound = AnyView(Text("View not found!").foregroundColor(.red))

    private var dictionary: [String: (Any) -> AnyView] = [:]

    public init() {

    }

    func set<Path>(pathIdentifier: String, destination: @escaping (Path) -> some View) {
        dictionary[pathIdentifier] = { key in
            if let path = key as? Path {
                return AnyView(destination(path))
            } else {
                return Self.viewNotFound
            }
        }
    }

    func destination(for route: some Hashable) -> AnyView {
        destination(for: ItemWithIdentifier(route))
    }

    func destination(for identifier: ItemWithIdentifier) -> AnyView {
        guard let closure = dictionary[identifier.identifier] else {
            return Self.viewNotFound
        }

        return closure(identifier.value)
    }
}

struct DestinationModifier<Path, Destination: View>: ViewModifier {

    @EnvironmentObject var storage: DestinationStorage

    let pathIdentifier: String
    let destination: (Path) -> Destination

    init(type: Path.Type, destination: @escaping (Path) -> Destination) {
        self.init(identifier: ItemWithIdentifier.identifier(for: type), destination: destination)
    }

    init(identifier: String, destination: @escaping (Path) -> Destination) {
        self.pathIdentifier = identifier
        self.destination = destination
    }

    func body(content: Content) -> some View {
        storage.set(pathIdentifier: pathIdentifier, destination: destination)

        return content
            .environmentObject(storage)
    }
}
