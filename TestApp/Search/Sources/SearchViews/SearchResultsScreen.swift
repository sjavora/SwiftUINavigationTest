import SwiftUI
import Navigation
import Booking
import Search

@MainActor final class SearchResultsViewModel: ObservableObject {

    @Published var results = (1...10).map { "Search result \($0)" }
}

struct SearchResultsScreen: View {

    @StateObject var viewModel: SearchResultsViewModel

    let booking: (_ token: String) -> Void

    public var body: some View {
        List(viewModel.results, id: \.self) { result in
            Button(result) {
                booking(result)
            }
        }
        .navigationTitle("Search results")
    }
}

struct SearchResultsScreenPreviews: PreviewProvider {

    static var previews: some View {
        PreviewWrapper {
            SearchResultsScreen(
                viewModel: .init()
            ) { _ in
                // trigger router
            }
        }
    }
}
