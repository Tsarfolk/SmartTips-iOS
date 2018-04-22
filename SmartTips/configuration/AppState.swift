import Foundation
import AVFoundation
import CoreLocation
import RxSwift

enum PermissionStatus: String {
    case granted
    case denied
    case notDetermined
}

class AppState {
    private(set) static var shared: AppState!
    static func configureSharedState() {
        shared = AppState()
    }
    
    private var locationPermissionStatus: PermissionStatus
    let isLocationGranted: Variable<Bool> = Variable(false)
    
    init() {
        let locationStatus = CLLocationManager.authorizationStatus()
        switch locationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationPermissionStatus = .granted
            isLocationGranted.value = true
        case .notDetermined:
            locationPermissionStatus = .notDetermined
            isLocationGranted.value = false
        default:
            locationPermissionStatus = .denied
            isLocationGranted.value = false
        }
    }
    
    func setLocationPermission(status: PermissionStatus) {
        locationPermissionStatus = status
    }
}
