import Cocoa

class TextField: NSTextField {
    let size: CGFloat = 14
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.placeholderAttributedString = NSAttributedString.createAttributedString(color: .gistMediumGray, size: 14, title: self.placeholderString!, alignment: .left)

        self.textColor = .black
        self.currentEditor()?.textColor = .black
    }
}
