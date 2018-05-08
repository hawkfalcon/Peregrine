import Cocoa

protocol Hoverable {
    func trackHover()
}

class TrackedButton: BasicButton, Hoverable {
    var isHoverCursorHand = true {
        didSet {
            // Remove hand cursor for disabled buttons
            self.window?.invalidateCursorRects(for: self)
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            isHoverCursorHand = isEnabled
        }
    }
        
    // Swich to hand cursor over button
    override func resetCursorRects() {
        if isHoverCursorHand {
            self.discardCursorRects()
            self.addCursorRect(self.bounds, cursor: .pointingHand)
        }
    }
    
    // Recalculate tracking bounds if frame changes
    override func updateTrackingAreas() {
        if isHoverCursorHand {
            super.updateTrackingAreas()
            self.trackHover()
        }
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
    func untrackHover() {
        if let trackingArea = self.trackingAreas.first {
            self.removeTrackingArea(trackingArea)
        }
    }
    
    func trackHover() {
        untrackHover()
        
        let area = NSTrackingArea.init(rect: self.bounds,
            options: [.mouseEnteredAndExited, .activeInKeyWindow],
            owner: self, userInfo: nil)
        self.addTrackingArea(area)
    }
}
