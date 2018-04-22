import UIKit
import Reusable

class TransactionCell: UICollectionViewCell, Reusable {
    private let imageView = CircleImageView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.stHelveticaNeue(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    private let priceContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.stBlue.cgColor
        return view
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.stGeometria(ofSize: 15)
        label.textAlignment = .right
        return label
    }()
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.stGeometria(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    func configure(_ transaction: TipTransaction) {
        NukeManager.loadImage(with: transaction.recepientImageUrl, placeholder: #imageLiteral(resourceName: "user_placeholder"), target: imageView)
        nameLabel.text = transaction.recepient
        valueLabel.text = "\(transaction.value) ₽"
        
        removeCommentLabel()
        if let comment = transaction.comment {
            appendCommentLabel()
            commentLabel.text = comment
        }
    }
    
    private func removeCommentLabel() {
        commentLabel.removeFromSuperview()
    }
    
    private func appendCommentLabel() {
        contentView.addSubview(commentLabel)
        
        commentLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(10)
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }
    }
    
    private func setViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceContentView)
        
        imageView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(10)
            $0.width.height.equalTo(40)
            $0.top.equalToSuperview().inset(10)
        }
        
        nameLabel.snp.makeConstraints {
            $0.left.equalTo(imageView.snp.right).offset(10)
            $0.centerY.equalTo(imageView)
        }
        
        priceContentView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalTo(imageView)
        }
        
        priceContentView.addSubview(valueLabel)
        
        valueLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(6)
            $0.top.bottom.equalToSuperview().inset(15)
        }
    }
}
