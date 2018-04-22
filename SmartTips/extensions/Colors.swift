import UIKit

struct Color {
  var red: CGFloat
  var green: CGFloat
  var blue: CGFloat
  var alpha: CGFloat

  init(color: UIColor) {
    red = 0.0
    green = 0.0
    blue = 0.0
    alpha = 0.0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
  }

  init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }
}

extension UIColor {
  class func make(withPercentage percentage: CGFloat, fromColor: UIColor, toColor: UIColor) -> UIColor {
    let startColor = Color(color: fromColor)
    let endColor = Color(color: toColor)

    let k = 1 - percentage
    return UIColor(red: startColor.red * k + endColor.red * percentage,
                   green: startColor.green * k + endColor.green * percentage,
                   blue: startColor.blue * k + endColor.blue * percentage,
                   alpha: startColor.alpha * k + endColor.alpha * percentage)
  }

  class var stSeparatorLine: UIColor {
    return UIColor(red: 50.0 / 255, green: 50.0 / 255, blue: 50.0 / 255, alpha: 1.0)
  }

  class var stBlue: UIColor {
    return UIColor(red: 255/255, green: 160/255, blue: 160/255, alpha: 1.0)
  }

  class var stLightBlue: UIColor {
    return UIColor(hex: "#4839DD")
  }

  class var stBlack: UIColor {
    return UIColor(hex: "#000000")
  }

  class var stWhite: UIColor {
    return UIColor(hex: "#FFFFFF")
  }

  class var fromGradientColor: UIColor {
    return UIColor(hex: "#CC000000")
  }

  class var toGradientColor: UIColor {
    return UIColor(hex: "#00000000")
  }

  class var stClear: UIColor {
    return UIColor.clear
  }

  class var stRed: UIColor {
    return UIColor(red: 245.0 / 255, green: 0, blue: 0, alpha: 1.0)
  }
}
