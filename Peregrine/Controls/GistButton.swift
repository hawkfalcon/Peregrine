import Cocoa

class GistButton: TrackedButton, HoverableDelegate {
    
    lazy var whiteTitle = createAttributedString(color: .white, size: 24)
    lazy var blackTitle = createAttributedString(color: .black, size: 24)
    lazy var grayTitle = createAttributedString(color: .gistGray, size: 24)

    override func customize() {
        self.attributedTitle = grayTitle
        self.layer?.backgroundColor = .white
        self.delegate = self

        super.customize()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if self.isHighlighted {
            self.attributedTitle = whiteTitle
        }
        else {
            self.attributedTitle = blackTitle
        }
    }
    
    func hoverStart() {
        self.layer?.backgroundColor = .gistMediumGray
        self.attributedTitle = whiteTitle
        //self.attributedTitle = grayTitle
    }
    
    func hoverStop() {
        self.layer?.backgroundColor = .white
        if self.isEnabled {
            self.attributedTitle = grayTitle
        }
    }
}
