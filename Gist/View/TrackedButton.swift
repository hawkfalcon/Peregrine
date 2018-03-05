import Cocoa

protocol Hoverable {
    func setupHover()
}

protocol HoverableDelegate {
    func hoverStart()
    func hoverStop()
}

class TrackedButton: BasicButton, Hoverable {
    var delegate: HoverableDelegate?
    
    override func customize() {
        setupHover()
    }
    
    override func mouseEntered(with event: NSEvent) {
        delegate?.hoverStart()
    }
    
    override func mouseExited(with event: NSEvent) {
        delegate?.hoverStop()
    }
    
    override func resetCursorRects() {
        self.addCursorRect(self.bounds, cursor: .pointingHand)
    }
}

extension Hoverable where Self: NSControl {
    func setupHover() {
        let area = NSTrackingArea.init(rect: self.bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self, userInfo: nil)
        self.addTrackingArea(area)
    }
}
