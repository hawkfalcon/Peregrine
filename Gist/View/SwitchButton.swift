import Cocoa

class SwitchButton: TrackedButton, HoverableDelegate {
    let size: CGFloat = 16
    lazy var whiteTitle = createAttributedString(color: .white, size: size)
    lazy var grayTitle = createAttributedString(color: .gistLightGray, size: size)

    override func customize() {
        super.customize()
        
        self.delegate = self
        self.attributedTitle = whiteTitle
    }
    
    func hoverStart() {
        self.attributedTitle = grayTitle
    }
    
    func hoverStop() {
        self.attributedTitle = whiteTitle
    }
}
