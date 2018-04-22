import SwiftyBeaver

extension SwiftyBeaver: StaticLogger {
  public static func log(_ message: Any, withLevel level: LogLevel,
                         file: String, function: String, line: Int) {
    self.custom(level: createBeaverLevel(from: level), message: message, file: file, function: function, line: line)
  }

  private static func createBeaverLevel(from level: LogLevel) -> Level {
    switch level {
    case .verbose: return .verbose
    case .debug: return .debug
    case .info: return .info
    case .warning: return .warning
    case .error: return .error
    }
  }
}
