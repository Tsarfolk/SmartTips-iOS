import Moya

class NetworkActivityManager {
  static let shared = NetworkActivityManager()
  private var numberOfProcesses: Int = 0
  var plugin: PluginType {
    return NetworkActivityPlugin(networkActivityClosure: { (change, _) in
      switch change {
      case .began:
        self.numberOfProcesses += 1
      case .ended:
        self.numberOfProcesses -= 1
        if self.numberOfProcesses < 0 {
          self.numberOfProcesses = 0
        }
      }

      UIApplication.shared.isNetworkActivityIndicatorVisible = self.numberOfProcesses > 0
    })
  }
}
