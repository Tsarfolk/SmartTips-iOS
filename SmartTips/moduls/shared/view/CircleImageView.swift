import UIKit

class CircleImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        
        setClipping()
    }
    init(_ image: UIImage) {
        super.init(image: image)
        
        setClipping()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setClipping() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
    }
}
