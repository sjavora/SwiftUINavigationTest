import Foundation
import Navigation

public struct BookingDeeplink: Deeplink {

    public let bookingToken: String

    public init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.host == "booking",
              let token = components.queryItems?.first(where: { $0.name == "token" })?.value
        else {
            return nil
        }

        self.bookingToken = token
    }
}
