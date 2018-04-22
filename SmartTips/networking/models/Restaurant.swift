import Foundation

private let names: [String] = [
    "Shoko",
    "FARSH",
    "FishCut",
    "Grow food"
]
private let imageUrls: [String] = [
    "https://www.wien.info/media/images/41993-das-loft-sofitel-19to1.jpeg",
    "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwjXhvaqsMvaAhWLhVQKHQUYBIMQjRx6BAgAEAU&url=http%3A%2F%2Fmoneyinc.com%2Fthree-key-financing-options-for-restaurant-owners%2F&psig=AOvVaw1WC3uFNIN8M_P8uqfYP-Jq&ust=1524400407506342",
    "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwih-ta3sMvaAhWKv1QKHctqDFwQjRx6BAgAEAU&url=https%3A%2F%2Fwww.tripadvisor.com%2FRestaurant_Review-g196538-d1082778-Reviews-Maison_Lameloise-Chagny_Saone_et_Loire_Bourgogne_Franche_Comte.html&psig=AOvVaw1WC3uFNIN8M_P8uqfYP-Jq&ust=1524400407506342",
    "https://www.hurawalhi.com/wp-content/uploads/2016/11/5.8_1-1030x579.jpg"
]

private let addresses: [String] = [
    "Udalcova street, 18",
    "Konovalova steet, 89",
    "Sheremetievo airport",
    "Old Arbat, 1"
]

final class Restaurant {
    var id: Int = 0
    var name: String = ""
    var imageUrlString: String = ""
    var location: Location = Location()
    var contacts: [Contact] = []
    var address: String = ""
    var rating: Double = 0
    var directionsURLString: String = ""
    var imageStrings: [String] = []
    var tipTransactions: [TipTransaction] = []

    var directionsURL: URL {
        return URL(string: self.directionsURLString)!
    }
}

extension Restaurant: SampleDataProvider {
    static var sampleData: Restaurant {
        defer { sampleDataProviderCounter += 1 }

        let data = Restaurant()
        data.contacts = [Contact.sampleData, Contact.sampleData, Contact.sampleData]
        data.name = names[sampleDataProviderCounter % names.count]
        data.imageUrlString = imageUrls[sampleDataProviderCounter % imageUrls.count]
        data.location = Location.sampleData
        data.address = addresses[sampleDataProviderCounter % addresses.count]
        data.directionsURLString = "here-route://55.76996,37.595914/55.78176,37.599056"
        data.rating = Double(6 + 2 * randomScale())
        data.imageStrings = imageUrls
        data.tipTransactions = [
            TipTransaction.sampleData,
            TipTransaction.sampleData,
            TipTransaction.sampleData,
            TipTransaction.sampleData
        ]
        return data
    }
}
