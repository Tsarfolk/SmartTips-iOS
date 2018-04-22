import UIKit
import SnapKit
import RxSwift

class TipOnboardingViewController: ViewController {
    private var items: [OnboardingItemView] = []
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "logo")
        return imageView
    }()
    private let scanButton: UIButton = {
        let button = UIButton()
        button.setTitle("SCAN", for: .normal)
        button.layer.cornerRadius = 6
        button.backgroundColor = UIColor(red: 255/255, green: 160/255, blue: 160/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.stHelveticaBold(ofSize: 15)
        return button
    }()
    private let titles: [String] = [
        "Scan QR code in your bill",
        "Choose the amount of tips you would like to give - pick one of the options or fill it manually",
        "Leave a comment if you want",
        "Press \"Tips\""
    ]
    
    private let bag = DisposeBag()
    
    init() {
        super.init(isNavBarHidden: false)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tip!"
        
        tabBarItem = UITabBarItem(title: "Scanning", image: #imageLiteral(resourceName: "qr").withRenderingMode(.alwaysTemplate), selectedImage: nil)
        view.backgroundColor = UIColor.stWhite
        
        setViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if navigationController?.isNavigationBarHidden == false {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func setViews() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(35)
        }
        var topConstraint = logoImageView.snp.bottom
        var offset: CGFloat = 0.0
        titles.enumerated().forEach { (index, title) in
            let item = OnboardingItemView()
            view.addSubview(item)
            
            item.configre(index, text: title)
            item.snp.makeConstraints {
                $0.right.left.equalToSuperview().inset(20)
                $0.top.equalTo(topConstraint).offset(offset)
            }
            
            topConstraint = item.snp.bottom
            offset = 20
        }
        
        view.addSubview(scanButton)

        scanButton.rx.tap.bind { [weak self] in
            // present
            let view = CameraViewController()
            self?.navigationController?.pushViewController(view, animated: true)
        }.disposed(by: bag)
        scanButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(30 + 44)
        }
    }
}
