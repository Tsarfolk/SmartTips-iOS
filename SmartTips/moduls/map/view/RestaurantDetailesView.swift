import UIKit
import Cosmos

class RestaurantDetailesView: UIView {
    private let contentView = UIView()
    private let restaurantImageView = CircleImageView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.stBlack
        label.font = UIFont.stHelvetica(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.stSeparatorLine
        label.font = UIFont.stHelveticaNeue(ofSize: 14)
        return label
    }()
    private let ratingContentView: RatingView = {
        let view = RatingView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.stLightBlue.cgColor
        view.layer.cornerRadius = 4
        return view
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
    
    func configure(_ restaurant: Restaurant) {
        NukeManager.loadImage(with: restaurant.imageUrlString, placeholder: #imageLiteral(resourceName: "placeholder"), target: restaurantImageView)
        nameLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        ratingContentView.configure(Int(restaurant.rating))
    }
    
    private func setViews() {
        addSubview(contentView)
        contentView.addSubview(restaurantImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(ratingContentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    
        restaurantImageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
    
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(restaurantImageView.snp.right).offset(8)
            $0.centerY.equalTo(restaurantImageView).multipliedBy(0.70)
        }
        
        addressLabel.snp.makeConstraints {
            $0.left.equalTo(nameLabel)
            $0.centerY.equalTo(restaurantImageView).multipliedBy(1.3)
            $0.right.equalTo(ratingContentView.snp.left).offset(-5)
        }
        
        ratingContentView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(100)
        }
    }
}
