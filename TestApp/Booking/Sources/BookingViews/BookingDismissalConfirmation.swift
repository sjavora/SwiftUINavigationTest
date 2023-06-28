import SwiftUI

public struct BookingDismissalPreferenceKey: PreferenceKey {

    public typealias Value = BookingDismissalConfirmationModel?

    public static var defaultValue: Value = nil

    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

@MainActor public final class BookingDismissalConfirmationModel: ObservableObject {

    @Published public internal(set) var isDismissalConfirmationPresented = false
    var dismissalConfirmationContinuation: CheckedContinuation<Bool, Never>?

    public init() {
        
    }

    public func canBeDismissed() async -> Bool {

        if isDismissalConfirmationPresented {
            return false
        }

        isDismissalConfirmationPresented = true

        return await withCheckedContinuation { continuation in
            dismissalConfirmationContinuation = continuation
        }
    }

    public func dismissAlert() {
        deniedDismissal()
        isDismissalConfirmationPresented = false
    }

    func confirmedDismissal() {
        dismissalConfirmationContinuation?.resume(returning: true)
        dismissalConfirmationContinuation = nil
    }

    func deniedDismissal() {
        dismissalConfirmationContinuation?.resume(returning: false)
        dismissalConfirmationContinuation = nil
    }
}

extension BookingDismissalConfirmationModel: Equatable {

    nonisolated public static func == (
        lhs: BookingDismissalConfirmationModel,
        rhs: BookingDismissalConfirmationModel
    ) -> Bool {
        lhs === rhs
    }
}

struct BookingDismissalConfirmation: ViewModifier {

    @ObservedObject var handler: BookingDismissalConfirmationModel

    func body(content: Content) -> some View {
        content
            .preference(key: BookingDismissalPreferenceKey.self, value: handler)
            .alert(isPresented: $handler.isDismissalConfirmationPresented) {
                Alert(
                    title: Text("Dismiss booking?"),
                    primaryButton: .destructive(Text("Dismiss")) {
                        handler.confirmedDismissal()
                    },
                    secondaryButton: .cancel {
                        handler.deniedDismissal()
                    }
                )
            }
    }
}

extension View {

    public func bookingDismissalConfirmation(_ handler: BookingDismissalConfirmationModel) -> some View {
        modifier(BookingDismissalConfirmation(handler: handler))
    }
}
