import Foundation
import Navigation

public struct SearchResultsDeeplink: Deeplink {

    public init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.host == "searchResults"
        else {
            return nil
        }
    }
}
