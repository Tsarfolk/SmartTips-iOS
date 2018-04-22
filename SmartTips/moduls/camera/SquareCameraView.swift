import UIKit

class SquareCameraView: UIView {
  override func draw(_ rect: CGRect) {
    super.draw(rect)

    let lineLength: CGFloat = rect.width / 7
    let topPath = UIBezierPath()
    topPath.lineWidth = 2
    topPath.lineCapStyle = .square
    UIColor.white.setFill()
    // top
    topPath.move(to: CGPoint(x: lineLength, y: 0))
    topPath.addLine(to: CGPoint.zero)
    topPath.addLine(to: CGPoint(x: 0, y: lineLength))

    topPath.move(to: CGPoint(x: 0, y: frame.height - lineLength))
    topPath.addLine(to: CGPoint(x: 0, y: frame.height))
    topPath.addLine(to: CGPoint(x: lineLength, y: frame.height))

    topPath.move(to: CGPoint(x: frame.width - lineLength, y: frame.height))
    topPath.addLine(to: CGPoint(x: frame.width, y: frame.height))
    topPath.addLine(to: CGPoint(x: frame.width, y: frame.height - lineLength))

    topPath.move(to: CGPoint(x: frame.width, y: lineLength))
    topPath.addLine(to: CGPoint(x: frame.width, y: 0))
    topPath.addLine(to: CGPoint(x: frame.width - lineLength, y: 0))

    let shapeLayer = CAShapeLayer()
    shapeLayer.path = topPath.cgPath
    shapeLayer.strokeColor = UIColor.white.cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineWidth = 2

    layer.addSublayer(shapeLayer)
  }
}
