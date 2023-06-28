import SwiftUI

public struct BookingDetailScreen: View {

    let bookingID: String
    let more: () -> Void
    let itineraryDetail: () -> Void

    public var body: some View {
        VStack(spacing: 16) {
            Text("BID: \(bookingID)")
                .navigationTitle("Booking detail")

            Button("Push another screen") {
                more()
            }

            Button("Itinerary detail") {
                itineraryDetail()
            }
        }
    }

    public init(bookingID: String, more: @escaping () -> Void, itineraryDetail: @escaping () -> Void) {
        self.bookingID = bookingID
        self.more = more
        self.itineraryDetail = itineraryDetail
    }
}

struct BookingDetailScreenPreviews: PreviewProvider {

    static var previews: some View {
        BookingDetailScreen(
            bookingID: "123",
            more: {},
            itineraryDetail: {}
        )
    }
}
