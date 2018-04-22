import UIKit

class CollectionView: UICollectionView {
  init(minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat, scrollDirection: UICollectionViewScrollDirection = .vertical) {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = minimumLineSpacing
    layout.minimumInteritemSpacing = minimumInteritemSpacing
    layout.scrollDirection = scrollDirection
    super.init(frame: .zero, collectionViewLayout: layout)
    backgroundColor = .clear

    if #available(iOS 11.0, *) {
      contentInsetAdjustmentBehavior = .never
    } else {
      contentInset = .zero
    }
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
