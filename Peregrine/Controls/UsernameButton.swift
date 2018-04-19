import Cocoa

class UsernameButton: TrackedButton, HoverableDelegate {
    let size: CGFloat = 18
    let logIn = "Log In"
    
    override var title: String {
        didSet {
            self.attributedTitle = createAttributedString(color: .white, size: size, title: title)
        }
    }
    
    override func customize() {
        self.attributedTitle = createAttributedString(color: .white, size: size)
        self.delegate = self
        
        super.customize()
    }
    
    func hoverStart() {
        self.attributedTitle = createAttributedString(color: .lightGray, size: size)
    }
    
    func hoverStop() {
        self.attributedTitle = createAttributedString(color: .white, size: size)
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        self.trackHover()
    }
}
