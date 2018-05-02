import Cocoa

class UsernameButton: TrackedButton {
    let size: CGFloat = 20
    
    override var title: String {
        didSet {
            self.attributedTitle = createAttributedString(color: .white, size: size)
        }
    }
    
    override func customize() {
        self.attributedTitle = createAttributedString(color: .white, size: size)
    }
    
    override func hoverStart() {
        self.attributedTitle = createAttributedString(color: .lightGray, size: size)
    }
    
    override func hoverStop() {
        self.attributedTitle = createAttributedString(color: .white, size: size)
    }
}
