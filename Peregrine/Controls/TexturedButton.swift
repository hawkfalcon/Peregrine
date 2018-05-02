import Cocoa

class TexturedButton: TrackedButton {
    lazy var size = CGFloat(self.tag)
    lazy var blackTitle = createAttributedString(color: .black, size: size)
    lazy var grayTitle = createAttributedString(color: .gistGray, size: size)
    
    override func customize() {
        self.attributedTitle = grayTitle
    }
    
    override func hoverStart() {
        if self.isEnabled {
            self.attributedTitle = blackTitle
        }
    }
    
    override func hoverStop() {
        if self.isEnabled {
            self.attributedTitle = grayTitle
        }
    }
    
    func reset() {
        self.attributedTitle = grayTitle
    }
}
