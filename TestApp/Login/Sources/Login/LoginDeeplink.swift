import Foundation
import Navigation

public struct LoginDeeplink: Deeplink {

    public let token: String

    public init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.host == "magicLogin",
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value
        else {
            return nil
        }

        self.token = token
    }
}
