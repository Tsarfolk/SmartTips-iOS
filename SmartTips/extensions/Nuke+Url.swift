import Foundation
import Nuke
import RxSwift

enum InternalError: Error {
    case inconsistenceData
}

class NukeManager {
  static func loadImage(with urlString: String?, placeholder: UIImage?, target: UIImageView) {
    target.image = placeholder

    guard let url = urlString?.toURL else { return }
    let urlRequest = URLRequest(url: url)
    let request = Request(urlRequest: urlRequest)
    Nuke.Manager.shared.loadImage(with: request, token: nil) { (result) in
      switch result {
      case .success(let image):
        target.image = image
      case .failure(let error):
        logger.log(error)
      }
    }
  }

  static func retriveImage(with urlString: String, completionHandler: ((UIImage?) -> ())? = nil) {
    guard let url = urlString.toURL else { return }
    Nuke.Manager.shared.loadImage(with: url, token: nil) { (result) in
      switch result {
      case .success(let image):
        completionHandler?(image)
      case .failure:
        completionHandler?(nil)
      }
    }
  }

  static func loadImage(with urlString: String?, completionHandler: ((UIImage?) -> ())? = nil) {
    guard let url = urlString?.toURL else { return }
    Nuke.Manager.shared.loadImage(with: url, token: nil) { (result) in
      switch result {
      case .success(let image):
        completionHandler?(image)
      case .failure(_):
        completionHandler?(nil)
      }
    }
  }

  static func loadImage(with urlString: String?) -> Observable<UIImage> {
    return Observable.create({ (observer) -> Disposable in
      guard let url = urlString?.toURL else {
        observer.onError(InternalError.inconsistenceData)
        return Disposables.create()
      }

      Nuke.Manager.shared.loadImage(with: url, token: nil) { (result) in
        switch result {
        case .success(let image):
          observer.onNext(image)
        case .failure(_):
          observer.onError(InternalError.inconsistenceData)
        }
      }

      return Disposables.create()
    })
  }
}
