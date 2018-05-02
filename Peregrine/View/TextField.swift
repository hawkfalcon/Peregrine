import Cocoa

class TextField: NSTextField {
    let size: CGFloat = 14
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.placeholderAttributedString = NSAttributedString.create(color: .gistLightGray, size: size, title: self.placeholderString!, alignment: .left)

        self.textColor = .black
    }
}
