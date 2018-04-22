import UIKit

protocol RouterContract {
    var view: UIViewController? { get }
}

extension RouterContract {
    var navigation: UINavigationController? {
        return view?.navigationController
    }
}
