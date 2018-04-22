import UIKit

class OnboardingItemView: UIView {
    private let contentView = UIView()
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = .stGeometria(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(frame: .zero)
        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.white
        
        layer.shadowColor = UIColor.stBlack.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 2, height: 4)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configre(_ index: Int, text: String) {
        let firstPart = "\(index): "
        let secondPart = text
        let attributedString = NSMutableAttributedString(string: firstPart + secondPart)
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.stGeometriaMedium(ofSize: 25)],
                                       range: NSRange.init(location: 0, length: firstPart.count))
        attributedString.addAttributes([NSAttributedStringKey.font : UIFont.stGeometriaMedium(ofSize: 20)],
                                       range: NSRange.init(location: firstPart.count, length: secondPart.count))
        label.attributedText = attributedString
    }
    
    private func setViews() {
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(10)
        }
    }
}
