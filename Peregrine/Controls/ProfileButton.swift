import Cocoa

class ProfileButton: TrackedButton {
    var logIn = false {
        didSet {
            size = logIn ? 16 : 12
            hoverTitle = logIn ? Constants.Labels.logOut : Constants.Labels.logIn
        }
    }
  
    var size: CGFloat = 12
    var hoverTitle = Constants.Labels.logIn
    
    override var title: String {
        didSet {
            self.attributedTitle = NSAttributedString.create(color: .white, size: size, title: title, alignment: .center)
        }
    }
    
    override func hoverStart() {
        self.title = hoverTitle
    }
    
    override func hoverStop() {
        self.title = ""
    }
}
