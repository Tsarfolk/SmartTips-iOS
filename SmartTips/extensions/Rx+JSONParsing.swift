import Foundation
import RxSwift
import Moya
import SwiftyJSON

public extension ObservableType where E == Moya.Response {
  func map<Model: JSONable>(to classType: Model.Type, jsonPath path: [JSONSubscriptType]? = nil) -> Observable<Model> {
    return self.map { response in
      return try Model.fromJSON(self.createJSON(fromData: response.data, onPath: path))
    }
  }

  func mapArray<Model: JSONable>(to classType: Model.Type, jsonPath path: [JSONSubscriptType]? = nil) -> Observable<[Model]> {
    return self.map { response in
      let json = try self.createJSON(fromData: response.data, onPath: path)
      guard let array = json.array else {
        throw JSONError.couldntParseJSON
      }
      return try array.map(Model.fromJSON)
    }
  }

  private func createJSON(fromData jsonData: Data, onPath path: [JSONSubscriptType]?) throws -> JSON {
    let json: JSON
    do {
      if let path = path {
        json = try JSON(data: jsonData)[path]
      } else {
        json = try JSON(data: jsonData)
      }
      return json
    } catch {
      throw JSONError.couldntParseJSON
    }
  }
}

extension ObservableType {
  public func mapToVoid() -> Observable<Void> {
    return self.map { _ -> Void in
      return ()
    }
  }
}
