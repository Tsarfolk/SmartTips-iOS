import Foundation
import CoreLocation
import RxSwift

protocol LocationManagerDelegate: class {
  func newUserLocation(_ location: Location)
}

class LocationManager: NSObject {

  private(set) static var shared: LocationManager!

  private let locManager = CLLocationManager()
  weak var delegate: LocationManagerDelegate?

  let moscowCoordinate = CLLocationCoordinate2D(latitude: 55.75, longitude: 37.616667)

  var currentCoordinate: Location {
    let location = locManager.location?.coordinate ?? moscowCoordinate
    let internalLocation = Location()
    internalLocation.latitude = location.latitude
    internalLocation.longitude = location.longitude
    return internalLocation
  }

  static func configureSharedState() {
    LocationManager.shared = LocationManager()
  }

  override init() {
    super.init()
    locManager.delegate = self
    locManager.requestWhenInUseAuthorization()
    locManager.startUpdatingLocation()
  }

  func startUpdatingUserLocation() {
    locManager.startUpdatingLocation()
  }

  func stopUpdatingUserLocation() {
    locManager.stopUpdatingLocation()
  }
}

extension LocationManager: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .notDetermined:
      AppState.shared.setLocationPermission(status: .notDetermined)
    case .authorizedWhenInUse, .authorizedAlways:
      AppState.shared.setLocationPermission(status: .granted)
    case .restricted, .denied:
      AppState.shared.setLocationPermission(status: .denied)
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let coordinate = locations.first?.coordinate else { return }
    let location = Location()
    location.latitude = coordinate.latitude
    location.longitude = coordinate.longitude
    delegate?.newUserLocation(location)
  }
}
