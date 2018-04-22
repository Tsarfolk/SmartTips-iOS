import UIKit

class ViewController: UIViewController {
    private var isNavBarHidden: Bool
    private var prevStateIsNavBatHidden: Bool = false
    
    init(isNavBarHidden: Bool) {
        self.isNavBarHidden = isNavBarHidden
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        isNavBarHidden = false
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
//        prevStateIsNavBatHidden = navigationController?.isNavigationBarHidden ?? true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        navigationController?.setNavigationBarHidden(isNavBarHidden, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        navigationController?.setNavigationBarHidden(prevStateIsNavBatHidden, animated: true)
    }
    
    func setNavBarState(isHidden: Bool) {
//        isNavBarHidden = isHidden
    }
}
