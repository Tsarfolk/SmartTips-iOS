import UIKit

class RatingView: UIView {
    private let ratingImageView = CircleImageView(#imageLiteral(resourceName: "star"))
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .stBlue
        label.textAlignment = .right
        label.font = UIFont.stGeometria(ofSize: 16)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ rating: Int) {
        ratingLabel.text = "\(rating) / 10"
    }
    
    private func setViews() {
        addSubview(ratingImageView)
        addSubview(ratingLabel)
        
        ratingImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
}
