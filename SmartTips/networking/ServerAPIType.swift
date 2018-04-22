import Moya

#if DEBUG
private let developmentUrlString = "https://smart-tips.herokuapp.com/"
#else
private let developmentUrlString = "https://smart-tips.herokuapp.com/"
#endif

protocol ServerAPIType {}

extension ServerAPIType where Self: TargetType {
    private var baseURLString: String {
        return developmentUrlString
    }
    
    var baseURL: URL {
        return URL(string: baseURLString.appending("api/"))!
    }
}
