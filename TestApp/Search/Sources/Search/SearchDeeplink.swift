import Foundation
import Navigation

public struct SearchDeeplink: Deeplink {

    public init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.host == "search"
        else {
            return nil
        }
    }
}
