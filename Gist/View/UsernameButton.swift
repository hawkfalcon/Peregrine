import Cocoa

class UsernameButton: TrackedButton, HoverableDelegate {
    let size: CGFloat = 18
    lazy var whiteLogInTitle = createAttributedString(color: .white, size: size)
    
    var selected: Bool = false {
        didSet {
            self.attributedTitle = createAttributedString(color: .gistMediumGray, size: size)
            self.imagePosition = selected ? .imageLeft : .noImage
        }
    }
    
    override var title: String {
        didSet {
            self.attributedTitle = createAttributedString(color: .white, size: size, title: title)
            //let textSize = self.attributedTitle.size()
        }
    }
    
    override func customize() {
        self.attributedTitle = whiteLogInTitle
        self.delegate = self
        
        let image = NSImage(named: NSImage.Name("visible"))
        self.image = image
        self.imagePosition = .noImage
        
        super.customize()
    }
    
    func hoverStart() {
        self.attributedTitle = createAttributedString(color: .gistLightGray, size: size)
        self.imagePosition = .imageLeft
    }
    
    func hoverStop() {
        let color: NSColor = selected ? .gistMediumGray : .white
        self.attributedTitle = createAttributedString(color: color, size: size)
        if !selected {
            self.imagePosition = .noImage
        }
    }
}
