import Foundation
import SwiftyJSON

public protocol JSONable {
  static func fromJSON(_ json: JSON) throws -> Self
}

enum JSONError: Error {
  case couldntParseJSON
}
