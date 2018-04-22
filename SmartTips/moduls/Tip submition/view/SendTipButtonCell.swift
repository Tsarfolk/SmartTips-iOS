import UIKit
import Reusable
import RxSwift

class SendTipButtonCell: UICollectionViewCell, Reusable {
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.setTitle("TIP!", for: .normal)
        button.backgroundColor = UIColor.stBlue
        button.titleLabel?.font = UIFont.stHelveticaBold(ofSize: 15)
        return button
    }()
    
    var bag = DisposeBag()
    
    var buttonDidTouch: Observable<Void> {
        return button.rx.tap.mapToVoid()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews() {
        addSubview(button)
        
        button.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(50)
            $0.top.equalToSuperview().inset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
}
