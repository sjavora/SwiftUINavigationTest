import SwiftUI

@MainActor public final class PresentedDismissalHandlers: ObservableObject {

    @MainActor public final class Handler: ObservableObject {

        public enum Kind {
            case sheet
            case alert

            var dismissalDurationMilliseconds: UInt64 {
                switch self {
                    case .sheet: return 300
                    case .alert: return 500
                }
            }
        }

        @Published var presentationOverride = true
        public let kind: Kind

        init(kind: Kind) {
            self.kind = kind
        }

        public func dismiss() async {
            presentationOverride = false

            // Wait until the dismissal animation is complete before proceeding
            try? await Task.sleep(nanoseconds: NSEC_PER_MSEC * kind.dismissalDurationMilliseconds)
        }
    }

    public private(set) var handlers: [Handler] = []

    public init() {

    }

    func add(_ handler: Handler) {
        if handlers.contains(where: { $0 === handler }) { return }

        handlers.append(handler)
    }

    func remove(_ handler: Handler) {
        handlers.removeAll(where: { $0 === handler })
    }
}
