import Cocoa

class HoverTextButton: TrackedButton {
    @IBInspectable var size: CGFloat = 0.0
    @IBInspectable var baseColor: NSColor = .gistGray
    @IBInspectable var hoverColor: NSColor = .lightGray
    
    override var title: String {
        didSet {
            self.attributedTitle = createAttributedString(color: baseColor, size: size)
        }
    }
    
    override func customize() {
        self.attributedTitle = createAttributedString(color: baseColor, size: size)
    }
    
    override func hoverStart() {
        if self.isEnabled {
            self.attributedTitle = createAttributedString(color: hoverColor, size: size)
        }
    }
    
    override func hoverStop() {
        if self.isEnabled {
            self.attributedTitle = createAttributedString(color: baseColor, size: size)
        }
    }
}
