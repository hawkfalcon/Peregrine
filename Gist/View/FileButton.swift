import Cocoa

class FileButton: BasicButton {
    override func customize() {
        super.customize()

        setupHover()
        self.wantsLayer = false
    }
    
    override func mouseEntered(with event: NSEvent) {
        if !self.isHighlighted {
            self.image = NSImage(named: .documentLightGray)
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        self.image = NSImage(named: .documentGray)
    }
    
    override func mouseMoved(with event: NSEvent) {
        cursorUpdate(with: event)
    }
    
    override func resetCursorRects() {
        discardCursorRects()
        self.addCursorRect(self.bounds, cursor: .pointingHand)
    }
    
    func setupHover() {
        let area = NSTrackingArea.init(rect: self.bounds,
            options: [.mouseMoved, .mouseEnteredAndExited, .activeAlways],
            owner: self, userInfo: nil)
        self.addTrackingArea(area)
    }
}

extension NSImage.Name {
    static let documentLightGray = NSImage.Name("document-light-gray")
    static let documentGray = NSImage.Name("document-gray")
}
