import Foundation

extension Double {
  func round(toDigits numberOfDigits: Int) -> Double {
    let value = NSDecimalNumber(decimal: pow(10.0, numberOfDigits)).doubleValue
    return floor(value * self) / value
  }
}
