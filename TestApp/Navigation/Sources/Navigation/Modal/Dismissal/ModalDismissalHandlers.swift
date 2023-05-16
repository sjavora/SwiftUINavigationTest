import SwiftUI

@MainActor public final class ModalDismissalHandlers: ObservableObject {

    public private(set) var handlers: [ModalDismissalHandler] = []

    public init() {

    }

    func add(_ handler: ModalDismissalHandler) {
        if handlers.contains(where: { $0 === handler }) { return }

        handlers.append(handler)
    }

    func remove(_ handler: ModalDismissalHandler) {
        handlers.removeAll(where: { $0 === handler })
    }
}

@MainActor public final class ModalDismissalHandler: ObservableObject {

    public enum Kind {
        case sheet
        case alert

        var dismissalAnimationDurationMilliseconds: UInt64 {
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

    public func dismissModal() async {
        presentationOverride = false

        // Wait until the dismissal animation is complete before proceeding
        try? await Task.sleep(nanoseconds: NSEC_PER_MSEC * kind.dismissalAnimationDurationMilliseconds)
    }
}
