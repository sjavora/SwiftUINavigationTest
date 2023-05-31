import SwiftUI

public struct PushNavigationStack<Root: View>: View {

    @ObservedObject var path: PushNavigationPath
    let root: Root

    public init(path: PushNavigationPath, @ViewBuilder root: () -> Root) {
        self._path = .init(wrappedValue: path)
        self.root = root()
    }

    public var body: some View {
        NavigationView {
            root
                .background(
                    navigationLink
                        .hidden()
                )
        }
        .navigationViewStyle(.stack)
    }

    @MainActor var navigationLink: some View {
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
            LinkContainer(allItems: path.items, index: 0) { index in
                path.pop(toLength: index)
            }
        } label: {
            EmptyView()
        }
    }
}

struct LinkContainer: View {

    @EnvironmentObject var destinationStorage: DestinationStorage
    @State var isVisible = false
    let allItems: [ItemWithIdentifier]
    let index: Int

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
        destinationStorage.destination(for: allItems[index])
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
            LinkContainer(allItems: allItems, index: index + 1, dismiss: dismiss)
        } label: {
            EmptyView()
        }
    }
}
