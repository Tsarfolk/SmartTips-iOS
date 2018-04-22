import UIKit
import NMAKit

class UserLocationPin: NMAMapMarker {
    init(_ location: Location) {
        let image = #imageLiteral(resourceName: "circle").withRenderingMode(.alwaysTemplate)
        super.init(geoCoordinates: location.toNMALocation, image: image)
    }
}
