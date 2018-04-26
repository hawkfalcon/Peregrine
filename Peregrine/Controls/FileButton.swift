import Cocoa

class FileButton: TrackedButton, HoverableDelegate {
    
    lazy var blackTitle = createAttributedString(color: .black, size: 13)
    lazy var grayTitle = createAttributedString(color: .gistGray, size: 13)
    
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

