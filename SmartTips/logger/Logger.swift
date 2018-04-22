import Foundation
import SwiftyBeaver

let logger = LoggerProvider(SwiftyBeaver.self)

public enum LogLevel: String {
  case verbose
  case debug
  case info
  case warning
  case error
}

/// Protocol with basic logger operations
public protocol Logger {
  func log(_ message: Any, withLevel level: LogLevel, file: String, function: String, line: Int)
}

/// Protocol with basic logger operations for loggers with static methods
public protocol StaticLogger {
  static func log(_ message: Any, withLevel level: LogLevel, file: String, function: String, line: Int)
}

/// Adapter to user static logger as simple logger
public struct StaticLoggerAdapter: Logger {
  let staticLoggerType: StaticLogger.Type

  init(_ type: StaticLogger.Type) {
    self.staticLoggerType = type
  }

  public func log(_ message: Any, withLevel level: LogLevel, file: String, function: String, line: Int) {
    staticLoggerType.log(message, withLevel: level, file: file, function: function, line: line)
  }
}

/// Generic logging system wrapper
public struct LoggerProvider: Logger, Equatable {
  fileprivate let logger: Logger

  public init(_ logger: Logger) {
    self.logger = logger
  }

  public init(_ staticLogger: StaticLogger.Type) {
    self.logger = StaticLoggerAdapter(staticLogger)
  }

  // MARK: - Logger implementation
  public func log(_ message: Any, withLevel level: LogLevel = .debug, file: String = #file,
                  function: String = #function, line: Int = #line) {
    logger.log(message, withLevel: level, file: file, function: function, line: line)
  }
}

public func == (left: LoggerProvider, right: LoggerProvider) -> Bool {
  return "\(left.logger)" == "\(right.logger)"
}

public struct LoggingGroup: Logger {
  private var providers: [LoggerProvider] = []
  public var size: Int {
    return providers.count
  }

  init(providers: [LoggerProvider]) {
    self.providers = providers
  }

  public mutating func add(provider: LoggerProvider) {
    providers.append(provider)
  }

  public mutating func remove(provider: LoggerProvider) {
    guard let index = providers.index(of: provider) else { return }

    providers.remove(at: index)
  }

  // MARK: - Logger implementation
  public func log(_ message: Any, withLevel level: LogLevel, file: String = #file,
                  function: String = #function, line: Int = #line) {
    providers.forEach { $0.log(message, withLevel: level, file: file, function: function, line: line) }
  }
}
