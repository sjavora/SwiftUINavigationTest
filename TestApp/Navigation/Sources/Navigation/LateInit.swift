
@propertyWrapper
public final class LateInit<Value> {

    public var injectedValue: Value?

    public var projectedValue: LateInit<Value> {
        self
    }

    public var wrappedValue: Value {
        guard let injectedValue else {
            fatalError()
        }

        return injectedValue
    }

    public init() {

    }
}
