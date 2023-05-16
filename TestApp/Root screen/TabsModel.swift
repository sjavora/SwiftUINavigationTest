import Navigation
import SwiftUI

final class TabsModel: ObservableObject {
    @Published private var tab: TabBarTab = .search
    @Published private var tabsToPopToRoot: Set<TabBarTab> = []

    var selectedTab: Binding<TabBarTab> {
        Binding(
            get: { self.tab },
            set: { newValue in
                if newValue == self.tab {
                    self.popTabToRoot(newValue)
                }

                self.tab = newValue
            }
        )
    }

    func selectTab(_ tab: TabBarTab) {
        self.tab = tab
    }

    func popTabToRoot(_ tab: TabBarTab) {
        tabsToPopToRoot.insert(tab)
    }

    func popToRootBinding(_ tab: TabBarTab) -> Binding<Bool> {
        Binding(
            get: { self.tabsToPopToRoot.contains(tab) },
            set: { shouldPop in
                if shouldPop == false {
                    self.tabsToPopToRoot.remove(tab)
                }
            }
        )
    }
}
