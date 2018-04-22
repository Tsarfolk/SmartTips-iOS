import Foundation

class AppConfigurator {
    static let shared = AppConfigurator()
    
    func run() {
        AppState.configureSharedState()
        LocationManager.configureSharedState()
    }
}
