import Foundation
import Navigation
import Booking
import MMB
import Login
import Search

func anyDeeplink(from url: URL) -> (any Deeplink)? {
    BookingDetailDeeplink(url: url)
        ?? BookingDeeplink(url: url)
        ?? LoginDeeplink(url: url)
        ?? SearchDeeplink(url: url)
        ?? SearchResultsDeeplink(url: url)
}
