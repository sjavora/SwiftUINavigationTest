import SwiftUI

@available(iOS, introduced: 14, obsoleted: 16, message: "Use native SwiftUI API.")
public struct NavigationStack<Root: View>: View {

    @ObservedObject var path: NavigationPath
    @State var destinations = NavigationDestinations()
    let root: Root

    public init(path: NavigationPath, @ViewBuilder root: () -> Root) {
        self._path = .init(wrappedValue: path)
        self.root = root()
    }

    public var body: some View {
        NavigationView {
            root
                .onPreferenceChange(NavigationDestinationsKey.self) { destinations in
                    self.destinations = destinations
                }
                .background(
                    navigationLink
                        .hidden()
                )
        }
        .navigationViewStyle(.stack)
    }

    var navigationLink: some View {
        NavigationLink(
            isActive: Binding(
                get: { path.isEmpty == false },
                set: { isDisplayed in
                    if isDisplayed == false {
                        path.popToRoot()
                    }
                }
            )
        ) {
            LinkContainer(allItems: path.items, index: 0, destinations: destinations) { index in
                path.pop(toLength: index)
            }
        } label: {
            EmptyView()
        }
    }
}

struct LinkContainer: View {

    @State var isVisible = false
    let allItems: [ItemWithIdentifier]
    let index: Int
    let destinations: NavigationDestinations

    let dismiss: (Int) -> Void

    var body: some View {
        VStack {
            screen
                .background(
                    navigationLink
                        .hidden()
                )
                .onAppear {
                    isVisible = true
                }
                .onDisappear {
                    isVisible = false
                }
        }
    }

    var screen: some View {
        destinations.destination(for: allItems[index])
    }

    var navigationLink: some View {
        NavigationLink(
            isActive: Binding(
                get: { index + 1 < allItems.endIndex },
                set: { shouldBeDisplayed in
                    if isVisible, shouldBeDisplayed == false {
                        dismiss(index + 1)
                    }
                }
            )
        ) {
            LinkContainer(allItems: allItems, index: index + 1, destinations: destinations, dismiss: dismiss)
        } label: {
            EmptyView()
        }
    }
}
