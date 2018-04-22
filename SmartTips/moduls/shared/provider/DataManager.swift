import Foundation
import RxSwift

class DataManager {
    static let shared = DataManager()
    private let bag = DisposeBag()
    
    private let restaurantPublisher: BehaviorSubject<[Restaurant]>
    var restaurants: [Restaurant] {
        guard let values = try? restaurantPublisher.value() else {
            return []
        }
        return values
    }
    var restarauntObserver: Observable<[Restaurant]> {
        return restaurantPublisher.asObserver()
    }
    
    init() {
        restaurantPublisher = BehaviorSubject(value: [])
    }
    
    func loadRestaurants() {
        NetworkingManager.shared.requestWithSuccessStatus(.places(location: LocationManager.shared.currentCoordinate))
            .mapArray(to: RestaurantParsing.self, jsonPath: ["places"])
            .map { $0.map({ (value) -> Restaurant in
                return value.toRestaraunt()
            })}
            .subscribe(onNext: { (restaurants) in
                self.restaurantPublisher.onNext(restaurants)
            }).disposed(by: bag)
    }
}
