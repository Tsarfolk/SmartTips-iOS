import UIKit
import NMAKit

class RestaurantPin: NMAMapMarker {
    let restaurant: Restaurant
    
    var isBubbleVisible: Bool = false
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init(geoCoordinates: restaurant.location.toNMALocation, image: #imageLiteral(resourceName: "pin").withRenderingMode(.alwaysTemplate))
        self.title = restaurant.name
    }
    
    func showDetailes() {
        showInfoBubble()
        isBubbleVisible = true
    }
    
    func hideDetailes() {
        hideInfoBubble()
        isBubbleVisible = false
    }
}
