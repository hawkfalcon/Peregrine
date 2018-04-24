import Cocoa

class TextField: NSTextField {
    let size: CGFloat = 14
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.placeholderAttributedString = NSAttributedString.createAttributedString(color: .gistMediumGray, size: size, title: self.placeholderString!, alignment: .left)

        self.textColor = .black
    }
    
    override func textDidEndEditing(_ notification: Notification) {
        self.textColor = .black
        self.nextKeyView?.nextKeyView?.becomeFirstResponder()
    }
}
