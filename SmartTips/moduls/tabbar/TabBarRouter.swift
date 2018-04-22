import UIKit

class TabBarRouter: RouterContract {
    weak var view: UIViewController?
    
    static func assemble() -> UITabBarController {
        let router = TabBarRouter()
        let view = TabBarViewController(router: router)
        
        let tipsNavigationController = UINavigationController(rootViewController: TipOnboardingViewController())
        let mapNaivgationController = UINavigationController(rootViewController: MapRouter.assemble())
        let profileNavigationController = UINavigationController(rootViewController: ProfileRouter.assembleCustomer())
        
        view.viewControllers = [
            tipsNavigationController,
            mapNaivgationController,
            profileNavigationController
        ]
        router.view = view
        return view
    }
}
