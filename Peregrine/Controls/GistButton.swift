import Cocoa

class GistButton: TrackedButton, HoverableDelegate {
    
    lazy var blackTitle = createAttributedString(color: .black, size: 24)
    lazy var grayTitle = createAttributedString(color: .gistGray, size: 24)

    override func customize() {
        self.attributedTitle = blackTitle
        self.delegate = self

        super.customize()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    func hoverStart() {
        self.attributedTitle = grayTitle
    }
    
    func hoverStop() {
        if self.isEnabled {
            self.attributedTitle = blackTitle
        }
    }
}
