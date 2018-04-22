import UIKit
import Reusable
import SnapKit
import RxSwift

protocol DidSelectCellDelegate: class {
    func didSelect(_ tag: Int)
}

class MultipleChoiceCell: UICollectionViewCell, Reusable {
    private var cells: [Cell] = []
    
    weak var delegate: DidSelectCellDelegate?
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ strings: [String], selectedIndex: Int) {
        cells.forEach { $0.removeFromSuperview() }
        cells.removeAll()
        var topConstraint: ConstraintItem = contentView.snp.top
        var offset: CGFloat = 0.0
        strings.enumerated().forEach { (index, str) in
            let cell = Cell()
            contentView.addSubview(cell)
            cells.append(cell)
            cell.tag = index + 1
            cell.setState(index == selectedIndex)
            cell.configure(str)
            cell.isUserInteractionEnabled = true
            cell.rx
                .tapGesture()
                .when(.recognized)
                .bind(onNext: { (recognizer) in
                    guard let tag = recognizer.view?.tag else { return }
                    
                    self.delegate?.didSelect(tag)
                }).disposed(by: bag)
            cell.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.top.equalTo(topConstraint).offset(offset)
                $0.height.equalTo(35)
            }
            
            topConstraint = cell.snp.bottom
            offset = 10
        }
    }
}

private class Cell: UIView {
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.stHelveticaNeue(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setState(_ state: Bool) {
        imageView.image = State(bool: state).image
    }
    
    func configure(_ title: String) {
        titleLabel.text = title
    }
    
    private func setViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(imageView.snp.right).offset(15)
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
        }
    }
}
