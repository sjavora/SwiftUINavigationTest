import SwiftUI

extension Binding {

    public init?(unwrapping binding: Binding<Value?>) {
        guard var value = binding.wrappedValue else { return nil }

        self.init(
            get: {
                value = binding.wrappedValue ?? value
                return value
            },
            set: { newValue, transaction in
                value = newValue
                binding.transaction(transaction).wrappedValue = newValue
            }
        )
    }

    public func isPresent<Wrapped>() -> Binding<Bool> where Value == Wrapped? {        
        .init(
            get: {
                self.wrappedValue != nil
            },
            set: { isPresent, transaction in
                if isPresent == false {
                    self.transaction(transaction).wrappedValue = nil
                }
            }
        )
    }

    public func `case`<Enum, Case>(
        extract: @escaping (Enum) -> Case?,
        embed: @escaping (Case) -> Enum
    ) -> Binding<Case?> where Value == Enum? {
        Binding<Case?>(
            get: {
                wrappedValue.flatMap(extract)
            },
            set: { newValue, transaction in
                self.transaction(transaction).wrappedValue = newValue.map(embed)
            }
        )
    }
}
