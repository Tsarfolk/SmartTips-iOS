import UIKit
import RxSwift

class RestaurantViewController: ViewController {
    private let collectionView = CollectionView(minimumLineSpacing: 20, minimumInteritemSpacing: 20)
    private let router: RestaurantRouter
    private let restaurant: Restaurant
    
    private let bag = DisposeBag()
    
    init(router: RestaurantRouter, restaurant: Restaurant) {
        self.router = router
        self.restaurant = restaurant
        super.init(isNavBarHidden: false)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        title = restaurant.name
        view.backgroundColor = UIColor.stWhite
        
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    private func loadRestauranInfo() {
        NetworkingManager.shared.request(.rates(id: restaurant.id))
            .map(to: RestaurantParsing.self)
            .subscribe(onNext: { [weak self] (data) in
                guard let `self` = self else { return }
                self.restaurant.tipTransactions = data.tips
                self.collectionView.reloadData()
        }).disposed(by: bag)
    }
    
    private func setViews() {
        view.addSubview(collectionView)
     
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: TransactionCell.self)
        collectionView.register(cellType: ImageAlbumPagingCell.self)
        collectionView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(64)
        }
    }
}

extension RestaurantViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        guard section > 0 else { return .zero }
        
        return UIEdgeInsets(top: 15, left: 20, bottom: 50, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let section = indexPath.section
        guard section > 0 else {
            return CGSize(width: width, height: 360)
        }
        
        let mainHeight: CGFloat = 60
        let transactionWidth: CGFloat = width - 20 * 2
        guard let comment = restaurant.tipTransactions[indexPath.item].comment, !comment.isEmpty else {
            return CGSize(width: transactionWidth, height: mainHeight)
        }
        let commentHeight = comment.height(withConstrainedWidth: transactionWidth, font: .stGeometria(ofSize: 15))
        
        return CGSize(width: transactionWidth, height: 60 + commentHeight + 15)
    }
}

extension RestaurantViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section > 0 else { return 1 }
        
        return restaurant.tipTransactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let section = indexPath.section
        
        switch section {
        case 0:
            let cell: ImageAlbumPagingCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(restaurant)
            cell.buttonDidTouch.subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                let application = UIApplication.shared
                let url = self.restaurant.directionsURL
                application.open(url)
            }).disposed(by: cell.bag)
            return cell
        case 1:
            let cell: TransactionCell = collectionView.dequeueReusableCell(for: indexPath)
            let transaction = restaurant.tipTransactions[index]
            cell.configure(transaction)
            return cell
        default:
            fatalError()
        }
    }
}
