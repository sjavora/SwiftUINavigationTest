import Foundation
import Navigation

public struct BookingDetailDeeplink: Deeplink {

    public let bid: String

    public init(bid: String) {
        self.bid = bid
    }

    public init?(url: URL) {
        guard let items = URLComponents(url: url, resolvingAgainstBaseURL: false),
              items.host == "detail",
              let bid = items.queryItems?.first(where: { $0.name == "bid" })?.value
        else {
            return nil
        }

        self.bid = bid
    }
}
