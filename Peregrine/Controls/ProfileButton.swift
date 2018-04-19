import Cocoa

class ProfileButton: TrackedButton, HoverableDelegate {
    var logIn = false {
        didSet {
            size = logIn ? 14 : 16
            hoverTitle = logIn ? "Log Out" : "Log In"
        }
    }
  
    var size: CGFloat = 14
    var hoverTitle = "Log In"
    
    override var title: String {
        didSet {
            self.attributedTitle = createAttributedString(color: .white, size: size, title: title)
        }
    }
    
    override func customize() {
        self.delegate = self
        
        super.customize()
    }
    
    func hoverStart() {
        title = hoverTitle
    }
    
    func hoverStop() {
        title = ""
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        self.trackHover()
    }
}
