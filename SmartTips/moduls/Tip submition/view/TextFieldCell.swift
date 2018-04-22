import UIKit
import Reusable

class TextFieldCell: UICollectionViewCell, Reusable {
    private let imageView = UIImageView()
    private let textField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        textField.placeholder = "Put your tips amount here"
        return textField
    }()
    private let textView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        return textView
    }()
    
    var tipAmount: Int? {
        return Int(textField.text ?? "")
    }
    
    var comment: String? {
        if let text = textView.text, !text.isEmpty {
            return text
        }
        
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ isSelected: Bool) {
        imageView.image = State(bool: isSelected).image
    }
    
    private func setViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(textField)
        
        imageView.image = State.normal.image
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.left.equalTo(imageView.snp.right).offset(20)
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textView.becomeFirstResponder()
        return true
    }
}

extension TextFieldCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
