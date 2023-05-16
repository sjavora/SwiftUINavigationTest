import UserStorageImplementation
import SwiftUI

final class Dependencies {

    let userStorage = UserStorage()

    init() {
        UserStorageKey.$defaultValue.injectedValue = userStorage
    }
}
