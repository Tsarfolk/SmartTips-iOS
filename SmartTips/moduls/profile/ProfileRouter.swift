import UIKit

class ProfileRouter: RouterContract {
    weak var view: UIViewController?
    
    static func assembleCustomer() -> UIViewController {
        let router = ProfileRouter()
        guard let view = UIStoryboard(name: storyboardMapIdentifier, bundle: Bundle.main).instantiateViewController(withIdentifier: "profile") as? ProfileViewController else { fatalError() }
//        view.router = router
        view.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "profileTabBar").withRenderingMode(.alwaysTemplate), selectedImage: nil)
        router.view = view
        return view
    }
    
    static func assembleWaiter() -> UIViewController {
        let router = ProfileRouter()
        guard let view = UIStoryboard(name: storyboardMapIdentifier, bundle: Bundle.main).instantiateViewController(withIdentifier: "waiter") as? WaiterViewController else { fatalError() }
        router.view = view
        return view
    }
}
