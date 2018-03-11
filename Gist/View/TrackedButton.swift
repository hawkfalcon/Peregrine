import Cocoa

protocol Hoverable {
    func trackHover()
}

protocol HoverableDelegate {
    func hoverStart()
    func hoverStop()
}

class TrackedButton: BasicButton, Hoverable {
    var delegate: HoverableDelegate?
    var trackingArea: NSTrackingArea?
    
    override func customize() {
        trackHover()
    }
    
    override func mouseEntered(with event: NSEvent) {
        delegate?.hoverStart()
    }
    
    override func mouseExited(with event: NSEvent) {
        delegate?.hoverStop()
    }
    
    override func resetCursorRects() {
        discardCursorRects()
        self.addCursorRect(self.bounds, cursor: .pointingHand)
    }
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
