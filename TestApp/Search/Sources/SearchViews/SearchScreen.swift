import SwiftUI
import Navigation
import Search

struct SearchScreen: View {

    let searchResults: () -> Void

    var body: some View {
        VStack {
            Button("Go to results") {
                searchResults()
            }
        }
        .navigationTitle("Search")
    }
}
