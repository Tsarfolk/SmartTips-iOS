import UIKit
import Reusable

class RestaurantTipCell: UICollectionViewCell, Reusable {
    private let restaurantView = RestaurantDetailesView()
    private let billSumLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.stGeometria(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ restaurant: Restaurant, sum: Double) {
        restaurantView.configure(restaurant)
        billSumLabel.text = "\(sum.round(toDigits: 2)) ₽"
    }
    
    private func setViews() {
        contentView.addSubview(restaurantView)
        contentView.addSubview(billSumLabel)
        
        restaurantView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(90)
        }
        
        billSumLabel.snp.makeConstraints {
            $0.top.equalTo(restaurantView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
