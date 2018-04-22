import UIKit

enum State {
    case selected
    case normal
    
    init(bool: Bool) {
        if bool {
            self = .selected
        } else {
            self = .normal
        }
    }
    
    var image: UIImage {
        switch self {
        case .normal:
            return #imageLiteral(resourceName: "NotSelectedCell")
        case .selected:
            return #imageLiteral(resourceName: "SelectedCell")
        }
    }
}
