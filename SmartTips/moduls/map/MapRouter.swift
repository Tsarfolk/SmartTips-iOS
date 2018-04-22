import UIKit

class MapRouter: RouterContract {
    weak var view: UIViewController?
    
    static func assemble() -> UIViewController {
        let router = MapRouter()
        guard let view = UIStoryboard(name: storyboardMapIdentifier, bundle: Bundle.main).instantiateInitialViewController() as? MapViewController else { fatalError() }
        view.router = router
        view.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map").withRenderingMode(.alwaysTemplate), selectedImage: nil)
        router.view = view
        return view
    }
    
    func presentRestaurantViewController(_ restaurant: Restaurant) {
        let view = RestaurantRouter.assemble(restaurant)
        navigation?.pushViewController(view, animated: true)
    }
}
