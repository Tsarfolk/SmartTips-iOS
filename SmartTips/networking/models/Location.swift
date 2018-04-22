import Foundation
import NMAKit

final class Location {
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    static func distance(lhs: Location, rhs: Location) -> Double {
        let earthRadius = 6371.0; // Radius of the earth in km
        let dLat = (lhs.latitude - rhs.latitude).toRadians
        let dLon = (lhs.longitude - rhs.longitude).toRadians
        let tmp = sin(dLat / 2) * sin(dLat / 2) + cos(lhs.latitude.toRadians / 2) * cos(rhs.latitude.toRadians) * sin(dLon / 2) * sin(dLon / 2)
        return 2 * atan2(sqrt(tmp), sqrt(1 - tmp)) * earthRadius
    }
    
    init() {}
    
    init(_ nmalocation: NMAGeoCoordinates) {
        longitude = nmalocation.longitude
        latitude = nmalocation.latitude
    }
}

extension NMAGeoCoordinates {
    var toLocation: Location {
        return Location.init(self)
    }
}

extension Location {
    var toNMALocation: NMAGeoCoordinates {
        return NMAGeoCoordinates(latitude: self.latitude, longitude: self.longitude)
    }
}

extension Location: SampleDataProvider {
    static var sampleData: Location {
        let location = Location()
        location.latitude = LocationManager.shared.moscowCoordinate.latitude + 0.2 * randomScale()
        location.longitude = LocationManager.shared.moscowCoordinate.longitude + 0.2 * randomScale()
        return location
    }
}

// Generate numebr from -1 to 1

func randomScale() -> Double {
    return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
}
