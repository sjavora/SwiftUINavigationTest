import SwiftUI

public extension View {

    func destination<Path>(
        for _: Path.Type,
        @ViewBuilder destination: @escaping (Path) -> some View
    ) -> some View {
        modifier(DestinationModifier(type: Path.self, destination: destination))
    }

    func destination(
      isPresented: Binding<Bool>,
      destination: () -> some View
    ) -> some View {
        EmptyView()
    }
}

//extension View {
//
//    public func navigationDestination<Value, Destination: View>(
//        selection: Binding<Value?>,
//        @ViewBuilder destination: (Value) -> Destination
//    ) -> some View {
//        navigationDestination(isPresented: selection.isPresent()) {
//            Binding(unwrapping: selection).map { binding in
//                destination(binding.wrappedValue)
//            }
//        }
//    }
//}
