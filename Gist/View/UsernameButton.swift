import Cocoa

class UsernameButton: TrackedButton, HoverableDelegate {
    let size: CGFloat = 18
    lazy var whiteLogInTitle = createAttributedString(color: .white, size: size)
    
    override var title: String {
        didSet {
            self.attributedTitle = createAttributedString(color: .white, size: size, title: title)
        }
    }
    
    override func customize() {
        self.attributedTitle = whiteLogInTitle
        self.delegate = self
        
        let image = NSImage(named: NSImage.Name("anonymous"))
        let imageView = NSImageView()
        imageView.image = image
        self.addSubview(imageView)
        
        super.customize()
    }
    
    func hoverStart() {
        self.attributedTitle = createAttributedString(color: .gistLightGray, size: size)
    }
    
    func hoverStop() {
        self.attributedTitle = createAttributedString(color: .white, size: size)
    }
}
