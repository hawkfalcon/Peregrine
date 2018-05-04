import Cocoa

protocol Hoverable {
    func trackHover()
}

class TrackedButton: BasicButton, Hoverable {
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        self.trackHover()
    }
    
    override func resetCursorRects() {
        self.discardCursorRects()
        self.addCursorRect(self.bounds, cursor: .pointingHand)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        hoverStart()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        hoverStop()
    }
    
    func hoverStart() {}
    func hoverStop() {}
}

extension Hoverable where Self: NSView {
    func trackHover() {
        if let trackingArea = self.trackingAreas.first {
            self.removeTrackingArea(trackingArea)
        }
        
        let area = NSTrackingArea.init(rect: self.bounds,
            options: [.mouseEnteredAndExited, .activeInKeyWindow],
            owner: self, userInfo: nil)
        self.addTrackingArea(area)
    }
}
