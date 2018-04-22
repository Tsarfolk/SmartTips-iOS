import Foundation
import RxSwift
import SwiftyJSON
import Moya

#if DEBUG
let networkLogger = NetworkLoggerPlugin(verbose: true, output: { (_, _, items: Any...) in
    for item in items {
        guard let stringItem = item as? String else { return }
        if stringItem.lengthOfBytes(using: .utf8) > 0 && stringItem[stringItem.startIndex] == "{" {
            guard let data = stringItem.data(using: .utf8, allowLossyConversion: false) else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                logger.log(JSON(json), withLevel: .info)
            } catch {
                logger.log(stringItem, withLevel: .info)
            }
        } else {
            logger.log(item, withLevel: .info)
        }
    }
})

private let defaultPlugins: [PluginType] = [
    networkLogger,
    NetworkActivityManager.shared.plugin
]
#else
private let defaultPlugins: [PluginType] = [
    NetworkActivityManager.shared.plugin
]

#endif

class NetworkingManager {
    static var shared: NetworkingManager = NetworkingManager()
    let provider = MoyaProvider<ServerAPI>(plugins: defaultPlugins)
}

extension NetworkingManager {
    func request(_ token: ServerAPI) -> Observable<Moya.Response> {
        return provider.rx.request(token).asObservable()
    }
    
    func requestWithSuccessStatus(_ token: ServerAPI) -> Observable<Moya.Response> {
        return provider.rx.request(token).filterSuccessfulStatusAndRedirectCodes().asObservable()
    }
}
