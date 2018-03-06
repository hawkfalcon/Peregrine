import Cocoa

class SwitchButton: TrackedButton {
    let size: CGFloat = 16
    
    override func customize() {
        super.customize()
        
        self.attributedTitle = createAttributedString(color: .white, size: size)
    }
}
