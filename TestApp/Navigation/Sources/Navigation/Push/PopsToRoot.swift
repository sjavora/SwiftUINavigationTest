import SwiftUI

extension View {

    @available(iOS, introduced: 14, obsoleted: 16, message: "Use native SwiftUI API.")
    @MainActor public func popsToRoot(_ path: NavigationPath, trigger: Binding<Bool>) -> some View {
        onChange(of: trigger.wrappedValue) { shouldPopToRoot in
            if shouldPopToRoot {
                path.popToRoot()
                trigger.wrappedValue = false
            }
        }
    }
}
