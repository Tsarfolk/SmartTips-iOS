import UIKit
import NMAKit
import SnapKit
import RxSwift
import RxGesture

class MapViewController: ViewController {
    @IBOutlet weak var mapView: NMAMapView!
    var router: MapRouter!
    
    private let bag = DisposeBag()
    
    private var locationManager: LocationManager {
        return LocationManager.shared
    }
    private var dataManager: DataManager {
        return DataManager.shared
    }
    private var restaurants: [Restaurant] = [] {
        didSet {
            mapView.remove(objects: restaurantPins)
            let pins = restaurants.map { RestaurantPin(restaurant: $0) }
            
            mapView.add(objects: pins)
            mapView.add(UserLocationPin.init(locationManager.currentCoordinate))
        }
    }
    
    private var restaurantPins: [RestaurantPin] = []
    private var restaurantDetailesView: RestaurantDetailesView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
        
        setNavBarState(isHidden: true)
        
        configureMapView()
        triggerDataUpdate()
        setBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController?.isNavigationBarHidden == false {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func triggerDataUpdate() {
        dataManager.loadRestaurants()
    }
    
    private func setBindings() {
        dataManager.restarauntObserver
            .subscribe(onNext: { [weak self] (restaurants) in
                guard let `self` = self else { return }
                
                self.restaurants = self.dataManager.restaurants
            }).disposed(by: bag)
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.useHighResolutionMap = true
        mapView.zoomLevel = 12.5
        mapView.set(geoCenter: locationManager.currentCoordinate.toNMALocation, animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
    }
    
    private func showRestaurantDetails(_ restaurant: Restaurant) {
        mapView.set(geoCenter: restaurant.location.toNMALocation, animation: .linear)
        if let prevDetailesView = restaurantDetailesView {
            UIView.animate(withDuration: 0.2, animations: {
                prevDetailesView.alpha = 0.0
            }) { (_) in
                prevDetailesView.removeFromSuperview()
            }
        }
        
        let selectedDetailesView = RestaurantDetailesView()
        view.addSubview(selectedDetailesView)
        
        selectedDetailesView.alpha = 0
        selectedDetailesView.configure(restaurant)
        selectedDetailesView.rx
            .tapGesture()
            .when(.recognized)
            .bind { [weak self] (_) in
                self?.router.presentRestaurantViewController(restaurant)
        }.disposed(by: bag)
        selectedDetailesView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(70)
            $0.bottom.equalToSuperview().inset(40 + 44)
        }
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            selectedDetailesView.alpha = 1
        })
        
        restaurantDetailesView = selectedDetailesView
    }
}

extension MapViewController: NMAMapViewDelegate {
    func mapViewDidDraw(_ mapView: NMAMapView) {
        
    }
    
    func mapViewDidEndMovement(_ mapView: NMAMapView) {
        
    }
    func mapViewDidEndAnimation(_ mapView: NMAMapView) {
        
    }
    
    func mapViewDidBeginMovement(_ mapView: NMAMapView) {
        
    }
    
    func mapViewDidBeginAnimation(_ mapView: NMAMapView) {
        
    }
    func mapViewDidSelectObjects(_ mapView: NMAMapView, objects: [NMAMapObject]) {
        if let firstObject = objects.first as? RestaurantPin {
            let restaurant = firstObject.restaurant
            firstObject.infoBubbleEventBlock = { [weak self] in
                self?.showRestaurantDetails(restaurant)
            }
            if firstObject.isBubbleVisible {
                firstObject.hideDetailes()
            } else {
                firstObject.showInfoBubble()
            }
            
            showRestaurantDetails(restaurant)
            return
        }
    }
}
