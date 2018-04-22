import Foundation
import Moya

enum ServerAPI {
    case places(location: Location)
    case rates(id: Int)
    case waiter(id: Int)
    case postTip(id: Int, amount: Double, rate: Double, comment: String?)
}

extension ServerAPI: TargetType, ServerAPIType {
    var path: String {
        switch self {
        case .places:
            return "places/"
        case .rates(let id):
            return "places/\(id)/rates/"
        case .waiter(let id):
            return "waiters/\(id)/"
        case .postTip(_, _, _, _):
            return "tips/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .places, .rates, .waiter:
            return .get
        case .postTip:
            return .post
        }
    }
    
    var headers: [String: String]? {
        return ["Authorization": "uwfbT3DYE1sQ3cHQf_ym-B4--qcQJu-PHu7GpuDXbdI"]
    }
    
    var queryParams: [String: Any]? {
        switch self {
        case .places(let location):
            return ["latitude": location.latitude, "longitude": location.longitude]
        default:
            return nil
        }
    }
    
    var bodyParams: [String: Any]? {
        switch self {
        case .postTip(let id, let amount, let rate, let comment):
            if let comment = comment {
                return [
                    "place_id": id,
                    "amount": amount,
                    "rate": rate,
                    "comment": comment
                ]
            } else {
                return [
                    "place_id": id,
                    "amount": amount,
                    "rate": rate
                ]
            }
        default:
            return nil
        }
    }
    
    var multipartformData: [MultipartFormData]? {
        switch self {
        default:
            return nil
        }
    }
    
    var task: Moya.Task {
        if let multipartDataParams = multipartformData {
            return .uploadMultipart(multipartDataParams)
        }
        
        if let urlParams = queryParams, let bodyParams = bodyParams {
            return .requestCompositeParameters(bodyParameters: bodyParams, bodyEncoding: JSONEncoding.default,
                                               urlParameters: urlParams)
        }
        
        if let urlParams = queryParams {
            return .requestParameters(parameters: urlParams, encoding: URLEncoding.default)
        }
        
        if let bodyParams = bodyParams {
            return .requestParameters(parameters: bodyParams, encoding: JSONEncoding.default)
        }
        
        return .requestPlain
    }
    
    var validate: Bool {
        return false
    }
    
    var sampleData: Data {
        return Data()
    }
}
