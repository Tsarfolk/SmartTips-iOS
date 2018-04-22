import Foundation

extension String {
  var toURL: URL? {
    return URL(string: self)
  }
}
