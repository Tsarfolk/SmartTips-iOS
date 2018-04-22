import UIKit

class RestaurantRouter: RouterContract {
    var view: UIViewController?
    
    static func assemble(_ restaurant: Restaurant) -> UIViewController {
        let router = RestaurantRouter.init()
        let view = RestaurantViewController(router: router, restaurant: restaurant)
        
        router.view = view
        return view
    }
}
