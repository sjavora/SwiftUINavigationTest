import SwiftUI
import Navigation
import Search
import UserStorage

public struct SearchFlow: View {

    enum Path: Hashable {
        case results
    }

    @StateObject private var path = PushNavigationPath()
    @Binding private var popToRoot: Bool

    let booking: (_ token: String) -> Void

    public var body: some View {
        PushNavigationStack(path: path) {
            search
        }
        .popsToRoot(path, trigger: $popToRoot)
        .destination(for: Path.self) { path in
            switch path {
                case .results:
                    results
            }
        }
        .onDeeplink(SearchDeeplink.self) { _ in
            // do nothing - default preferences will already pop the stack and switch to this tab
        }
        .onDeeplink(SearchResultsDeeplink.self) { _ in
            path.push(Path.results)
        }
    }

    @ViewBuilder var search: some View {
        SearchScreen {
            path.push(Path.results)
        }
    }

    @ViewBuilder var results: some View {
        SearchResultsScreen(viewModel: SearchResultsViewModel()) { bookingToken in
            booking(bookingToken)
        }
    }

    public init(popToRoot: Binding<Bool>, booking: @escaping (_ token: String) -> Void) {
        self._popToRoot = popToRoot
        self.booking = booking
    }
}

struct SearchFlowPreviews: PreviewProvider {

    struct SearchFlowWrapper: View {

        @State var popToRoot = false

        var body: some View {
            SearchFlow(
                popToRoot: $popToRoot,
                booking: { _ in }
            )
        }
    }

    static var previews: some View {
        // TODO: Crashes
        PreviewWrapper {
            SearchFlowWrapper()
        }
    }
}
