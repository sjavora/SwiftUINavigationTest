import SwiftUI

public struct BookingDetailScreen: View {

    let bookingID: String
    let more: () -> Void
    let itineraryDetail: () -> Void

    public var body: some View {
        Text("BID: \(bookingID)")
            .navigationTitle("Booking detail")

        Button("Push another screen") {
            more()
        }

        Button("Itinerary detail") {
            itineraryDetail()
        }
    }

    public init(bookingID: String, more: @escaping () -> Void, itineraryDetail: @escaping () -> Void) {
        self.bookingID = bookingID
        self.more = more
        self.itineraryDetail = itineraryDetail
    }
}
