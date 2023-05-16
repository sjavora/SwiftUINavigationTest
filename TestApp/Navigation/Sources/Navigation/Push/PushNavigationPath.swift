import SwiftUI

@MainActor public final class PushNavigationPath: ObservableObject {

    @Published private(set) var items: [ItemWithIdentifier] = []

    private var pendingStateChanges: [ItemWithIdentifier] = [] {
        didSet {
            Task {
                await processPendingChanges()
            }
        }
    }

    private var isProcessingStateChanges = false

    public init() {

    }

    public var isEmpty: Bool {
        items.isEmpty
    }

    public func push(_ item: some Hashable) {
        items.append(ItemWithIdentifier(item))
    }

    public func push(_ items: [some Hashable]) {
        if items.count == 1 {
            push(ItemWithIdentifier(items[0]))
        } else {
            pendingStateChanges = self.items + items.map(ItemWithIdentifier.init)
        }
    }

    public func pop() {
        items.removeLast()
    }

    public func pop(to item: some Hashable) {
        if let index = items.lastIndex(of: ItemWithIdentifier(item)) {
            items = Array(items.prefix(through: index))
        }
    }

    public func popToRoot() {
        items = []
    }

    func pop(toLength length: Int) {
        items = Array(items.prefix(length))
    }

    private func processPendingChanges() async {

        guard isProcessingStateChanges == false, pendingStateChanges.isEmpty == false else { return }

        isProcessingStateChanges = true

        let steps = steps(from: items, to: pendingStateChanges)
        self.pendingStateChanges.removeAll()

        await runSteps(steps)

        isProcessingStateChanges = false

        await processPendingChanges()
    }

    private func runSteps(_ steps: [[ItemWithIdentifier]]) async {

        if steps.isEmpty { return }

        let firstStep = steps[0]
        let remainingSteps = Array(steps.dropFirst())

        items = firstStep

        if remainingSteps.isEmpty == false {
            // the shortest wait that lets the push animation finish without glitches
            try? await Task.sleep(nanoseconds: NSEC_PER_MSEC * 650)

            await runSteps(remainingSteps)
        }
    }

    private func steps(from current: [ItemWithIdentifier], to new: [ItemWithIdentifier]) -> [[ItemWithIdentifier]] {

        var steps: [[ItemWithIdentifier]] = []
        var step = current

        for change in new.difference(from: current) {
            switch change {
                case .insert(let offset, let element, _):
                    step.insert(element, at: offset)
                case .remove(let offset, _, _):
                    step.remove(at: offset)
            }

            steps.append(step)
        }

        return steps
    }
}
