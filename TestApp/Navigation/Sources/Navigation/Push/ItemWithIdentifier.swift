
struct ItemWithIdentifier {
    let value: Any
    let identifier: String

    init(_ value: some Hashable) {
        self.value = value
        self.identifier = Self.identifier(for: type(of: value))
    }

    static func identifier(for value: Any) -> String {
        String(reflecting: value)
    }
}

extension ItemWithIdentifier: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

extension ItemWithIdentifier: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
