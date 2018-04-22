import Foundation
import SwiftyJSON

final class RestaurantParsing {
    var average_rate: Double = 0.0
    var address: String = ""
    var id: Int = 0
    var image_url: String = ""
    var is_place_tippting_available: Bool = false
    var is_tipping_available: Bool = true
    var location_latitude: Double = 0.0
    var location_longitude: Double = 0.0
    var directionURLString: String = ""
    var name: String = ""
    var rating: Double = 0.0
    var tips: [TipTransaction] = []
    
    func toRestaraunt() -> Restaurant {
        let model = Restaurant()
        model.id = id
        model.name = name
        model.imageUrlString = image_url
        let location = Location()
        location.latitude = location_latitude
        location.longitude = location_longitude
        model.location = location
        model.address = address
        model.rating = rating
        model.tipTransactions = tips
        model.directionsURLString = directionURLString
        model.imageStrings = [image_url]
        
        return model
    }
}

extension RestaurantParsing: JSONable {
    static func fromJSON(_ json: JSON) throws -> RestaurantParsing {
        let model = RestaurantParsing()
        model.average_rate = json["average_rate"].doubleValue
        model.address = json["address"].stringValue
        model.id = json["id"].intValue
        model.image_url = json["image_url"].stringValue
        model.is_place_tippting_available = json["is_place_tippting_available"].boolValue
        model.is_tipping_available = json["is_tipping_available"].boolValue
        model.location_latitude = json["location_latitude"].doubleValue
        model.location_longitude = json["location_longitude"].doubleValue
        model.directionURLString = json["here_directions_url"].stringValue
        model.name = json["name"].stringValue
        model.rating = json["rating"].doubleValue
        model.tips = json["tips"].array?.compactMap { try? TipTransaction.fromJSON($0) } ?? []
        return model
    }
}
