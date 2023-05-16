import SwiftUI

extension View {

    @MainActor public func popsToRoot(_ path: PushNavigationPath, trigger: Binding<Bool>) -> some View {
        onChange(of: trigger.wrappedValue) { shouldPopToRoot in
            if shouldPopToRoot {
                path.popToRoot()
                trigger.wrappedValue = false
            }
        }
    }
}
