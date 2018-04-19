import Cocoa

class UsernameButton: TrackedButton, HoverableDelegate {
    let size: CGFloat = 18
    lazy var whiteLogInTitle = createAttributedString(color: .white, size: size)
    let logIn = "Log In"
    
    var selected: Bool = false {
        didSet {
//            if self.title == logIn { return }
//            let color: NSColor = selected ? .gistMediumGray : .white
//            self.attributedTitle = createAttributedString(color: color, size: size)
//            self.imagePosition = selected ? .imageLeft : .noImage
        }
    }
    
    override var title: String {
        didSet {
            self.attributedTitle = createAttributedString(color: .white, size: size, title: title)
        }
    }
    
    override func customize() {
        self.attributedTitle = whiteLogInTitle
        self.delegate = self
        
        let image = NSImage(named: .visible)
        self.image = image
        self.imagePosition = .noImage
        
        super.customize()
    }
    
    func hoverStart() {
        if self.title == logIn { return }
        self.attributedTitle = createAttributedString(color: .lightGray, size: size)
        //self.imagePosition = .imageLeft
    }
    
    func hoverStop() {
        if self.title == logIn { return }
        self.attributedTitle = createAttributedString(color: .white, size: size)
//        if !selected {
//            self.imagePosition = .noImage
//        }
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        self.trackHover()
    }
}

extension NSImage.Name {
    static let visible = NSImage.Name("visible")
}

