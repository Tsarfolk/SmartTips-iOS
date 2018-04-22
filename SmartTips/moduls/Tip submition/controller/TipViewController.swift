import UIKit
import RxSwift

class TipViewController: ViewController {
    private let collectionView = CollectionView(minimumLineSpacing: 0, minimumInteritemSpacing: 0)
    private let id: Int
    private let orderSum: Double
    
    private var restaurant: Restaurant? = Restaurant.sampleData
    private var titles: [String] = []
    private var percentages: [Double] = []
    private var selectedIndex: Int = 1
    
    private let bag = DisposeBag()
    
    private let activityIndicator: UIActivityIndicatorView = {
       let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return view
    }()
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    init(id: Int, orderSum: Double) {
        self.id = id
        self.orderSum = orderSum
        super.init(isNavBarHidden: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
        
        setLoadingState()
        loadRestaurantInfo()
    }
    
    private func setLoadingState() {
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func removeLoadingState() {
        loadingView.removeFromSuperview()
    }
    
    private func getPercentage(by number: Double) -> [Double] {
        var procents: [Double] = []
        if number > 5.0 {
            procents = [5, number, 10]
        } else if abs(number.round(toDigits: 2) - 10.0) < 0.01 {
            procents = [5, 10, 15]
        } else {
            procents = [10, number, 15]
        }
        
        return procents.sorted(by: { $0 < $1 })
    }
    
    private func setTitles(_ average: Double) {
        guard self.restaurant != nil else { return }
        
        percentages = getPercentage(by: average)
     
        titles = percentages.map { (value) in
            return "\(value) % - \(orderSum * value / 100) ₽"
        }
        collectionView.reloadData()
    }
    
    private func loadRestaurantInfo() {
        NetworkingManager.shared.requestWithSuccessStatus(.rates(id: id)).map(to: RestaurantParsing.self)
            .subscribe(onNext: { [weak self] (data) in
                guard let `self` = self else { return }
                self.removeLoadingState()
                self.setViews()
                self.setTitles(data.average_rate)
            }, onError: { [weak self] (_) in
                guard let `self` = self else { return }
                let alert = UIAlertController(title: "Unable to download data, retry?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "yes", style: .default, handler: { (_) in
                    self.loadRestaurantInfo()
                }))
                alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (_) in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }).disposed(by: bag)
    }
    
    private func setViews() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: RestaurantTipCell.self)
        collectionView.register(cellType: MultipleChoiceCell.self)
        collectionView.register(cellType: TextFieldCell.self)
        collectionView.register(cellType: SendTipButtonCell.self)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(64)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    private func sendTips() {
        var amount: Double = 0.0
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as? TextFieldCell else { return }
        if let cellAmount = cell.tipAmount, selectedIndex >= percentages.count {
            amount = Double(cellAmount)
        } else {
            amount = percentages[selectedIndex]
        }
        
        NetworkingManager.shared.requestWithSuccessStatus(.postTip(id: id, amount: amount, rate: (Double(orderSum) / amount / 100).round(toDigits: 2), comment: cell.comment))
            .subscribe(onNext: { (_) in
                let alert = UIAlertController(title: "\((Double(self.orderSum) / amount).round(toDigits: 2)) RUB was sent!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: { (_) in
                    self.tabBarController?.selectedIndex = 1
                    self.navigationController?.popToRootViewController(animated: false)
                }))
                self.present(alert, animated: true, completion: nil)
            }, onError: { (error) in
                let alert = UIAlertController(title: "Unable to send tips!", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okey", style: .default, handler: { (_) in }))
                self.present(alert, animated: true, completion: nil)
            }).disposed(by: bag)
    }
}

extension TipViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        switch indexPath.item {
        case 0:
            return CGSize(width: width - 20 * 2, height: 140)
        case 1:
            return CGSize(width: width - 20 * 2, height: 35 * 3 + 10 * 2)
        case 2:
            return CGSize(width: width - 20 * 2, height: 50)
        case 3:
            return CGSize(width: width, height: 80)
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item == 2 else { return }
        
        selectedIndex = titles.count
        collectionView.reloadData()
    }
}

extension TipViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard restaurant != nil else { return 0 }
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        switch index {
        case 0:
            guard let restaurant = self.restaurant else { fatalError() }
            let cell: RestaurantTipCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(restaurant, sum: orderSum)
            return cell
        case 1:
            let cell: MultipleChoiceCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(titles, selectedIndex: selectedIndex)
            return cell
        case 2:
            let cell: TextFieldCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(selectedIndex == titles.count)
            return cell
        case 3:
            let cell: SendTipButtonCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.buttonDidTouch.bind { [weak self] in
                self?.sendTips()
            }.disposed(by: cell.bag)
            return cell
        default:
            fatalError()
        }
    }
}

extension TipViewController: DidSelectCellDelegate {
    func didSelect(_ tag: Int) {
        selectedIndex = tag - 1
        collectionView.reloadData()
    }
}
