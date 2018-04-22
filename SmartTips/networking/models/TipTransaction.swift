import UIKit
import SwiftyJSON

final class TipTransaction {
    var recepient: String = ""
    var recepientImageUrl: String = ""
    var comment: String?
    var value: Int = 0
}

private let imageUrls: [String] = [
    "https://images.pexels.com/photos/736716/pexels-photo-736716.jpeg?auto=compress&cs=tinysrgb&h=350",
    "https://images.pexels.com/photos/428341/pexels-photo-428341.jpeg?auto=compress&cs=tinysrgb&h=350",
    "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwiflf6RgMzaAhWEJJoKHVgcDc0QjRx6BAgAEAU&url=http%3A%2F%2Fwww.dailymail.co.uk%2Fnews%2Farticle-5298197%2FMinnesota-teen-girl-19-dies-skiing-tree.html&psig=AOvVaw3BjDzJCezuiA0dgfz5k6Fe&ust=1524421865156877"
]

private let comments: [String?] = [
    "https://images.pexels.com/photos/736716/pexels-photo-736716.jpeg?auto=compress&cs=tinysrgb&h=350",
    nil, nil,
    "https://images.pexels.com/photos/428341/pexels-photo-428341.jpeg?auto=compress&cs=tinysrgb&h=350",
    "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwiflf6RgMzaAhWEJJoKHVgcDc0QjRx6BAgAEAU&url=http%3A%2F%2Fwww.dailymail.co.uk%2Fnews%2Farticle-5298197%2FMinnesota-teen-girl-19-dies-skiing-tree.html&psig=AOvVaw3BjDzJCezuiA0dgfz5k6Fe&ust=1524421865156877"
]

extension TipTransaction: SampleDataProvider {
    static var sampleData: TipTransaction {
        let transaction = TipTransaction()
        transaction.recepient = "Mikhail Maslo"
        transaction.recepientImageUrl = imageUrls[sampleDataProviderCounter % imageUrls.count]
        transaction.value = Int(150 + 50 * randomScale())
        transaction.comment = comments[sampleDataProviderCounter % comments.count]
        return transaction
    }
}

extension TipTransaction: JSONable {
    static func fromJSON(_ json: JSON) throws -> TipTransaction {
        let transaction = TipTransaction()
        transaction.value = json["amount"].intValue
        transaction.comment = json["comment"].stringValue
        transaction.recepient = json["user"]["first_name"].stringValue + " " + json["user"]["last_name"].stringValue
        transaction.recepientImageUrl = json["user"]["image_url"].stringValue
        return transaction
    }
}
