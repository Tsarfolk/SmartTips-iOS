import UIKit
import RxSwift
import Reusable
import SnapKit

class ImageAlbumPagingCell: UICollectionViewCell, Reusable {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    private let pageControl = UIPageControl()
    private let gradientView: GradientView = {
        let view = GradientView()
        view.backgroundColor = .stClear
        view.colors = [.stClear, .stWhite]
        view.dimmedColors = [.stClear, .stWhite]
        view.isUserInteractionEnabled = false
        view.direction = .vertical
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.stHelveticaBold(ofSize: 16)
        label.textColor = UIColor.stBlack
        label.textAlignment = .left
        return label
    }()
    private let ratingContentView = RatingView()
    private var images: [UIImageView] = []
    private let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.stSeparatorLine
        return view
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.stHelveticaBold(ofSize: 16)
        label.textColor = UIColor.stBlack
        label.textAlignment = .left
        return label
    }()
    private let directionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Direction", for: .normal)
        button.backgroundColor = UIColor.stBlue
        button.titleLabel?.textColor = UIColor.stWhite
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    private let tipsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.stBlack
        label.textAlignment = .left
        label.font = UIFont.stHelveticaBold(ofSize: 24)
        label.text = "Tips:"
        return label
    }()
    private let udnerlyingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.stBlack
        return view
    }()
    
    var buttonDidTouch: Observable<Void> {
        return directionButton.rx.tap.mapToVoid()
    }
    
    var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ restaurant: Restaurant) {
        images.forEach { (imageView) in
            imageView.removeFromSuperview()
        }
        images.removeAll()
        
        var leftConstraint: ConstraintItem = scrollView.snp.left
        restaurant.imageStrings.forEach { (str) in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            images.append(imageView)
            NukeManager.loadImage(with: str, placeholder: #imageLiteral(resourceName: "rest_placeholder"), target: imageView)

            scrollView.addSubview(imageView)

            imageView.snp.makeConstraints {
                $0.left.equalTo(leftConstraint)
                $0.top.equalToSuperview()
                $0.width.equalTo(frame.width)
                $0.height.equalTo(150)

                if images.count == restaurant.imageStrings.count {
                    $0.right.equalToSuperview()
                }
            }

            leftConstraint = imageView.snp.right
        }

        pageControl.numberOfPages = restaurant.imageStrings.count
        titleLabel.text = restaurant.name
        addressLabel.text = restaurant.address
        ratingContentView.configure(Int(restaurant.rating))
    }
    
    private func setViews() {
        contentView.addSubview(scrollView)
        contentView.addSubview(gradientView)
        contentView.addSubview(pageControl)
        
        scrollView.delegate = self
        scrollView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        gradientView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(pageControl).offset(-5)
            $0.bottom.equalTo(scrollView)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(scrollView.snp.bottom).offset(-10)
//            $0.height.equalTo(20)
        }
        
        // end of header
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingContentView)
        contentView.addSubview(separatorLineView)
        contentView.addSubview(addressLabel)
        contentView.addSubview(directionButton)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(udnerlyingView)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(scrollView.snp.bottom).offset(20)
        }
        
        ratingContentView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalToSuperview().inset(10)
            $0.width.equalTo(100)
            $0.bottom.equalTo(separatorLineView.snp.top)
        }
        
        separatorLineView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1.5)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        addressLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(separatorLineView.snp.bottom).offset(5)
        }
        
        directionButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(50)
            $0.top.equalTo(addressLabel.snp.bottom).offset(15)
        }
        
        tipsLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(directionButton.snp.bottom).offset(15)
        }
        
        udnerlyingView.snp.makeConstraints {
            $0.left.right.equalTo(tipsLabel)
            $0.top.equalTo(tipsLabel.snp.bottom)
            $0.height.equalTo(1)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
    }
}

extension ImageAlbumPagingCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let page = Int(floor(offsetX / scrollView.frame.width))
        pageControl.currentPage = max(0, min(images.count - 1, page))
    }
}
