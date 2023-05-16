import SwiftUI

public struct DeeplinkPreparationConfiguration {
    public let destinationTab: TabBarTab?
    public let shouldClearCurrentUI: Bool
}

extension View {

    public func onDeeplinkPreparation(
        perform action: @escaping (DeeplinkPreparationConfiguration) async throws -> Void
    ) -> some View {
        modifier(DeeplinkPreparationModifier(action: action))
    }
}

struct DeeplinkPreparationModifier: ViewModifier {

    @EnvironmentObject var deeplinkRouter: DeeplinkRouter

    let action: (DeeplinkPreparationConfiguration) async throws -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(deeplinkRouter.$configuration) { configuration in
                if let configuration {
                    Task {
                        try await action(configuration)

                        deeplinkRouter.finishPreparation()
                    }
                }
            }
    }
}
