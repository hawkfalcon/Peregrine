import Cocoa

class TrackedButton: BasicButton {
    
    override func customize() {
        let area = NSTrackingArea.init(rect: self.bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self, userInfo: nil)
        self.addTrackingArea(area)
        print("cl")
    }
    
    override func mouseEntered(with event: NSEvent) {
        self.cursorUpdate(with: NSEvent.init())
        hoverOver()
    }
    
    override func mouseExited(with event: NSEvent) {
        self.cursorUpdate(with: NSEvent.init())
        hoverOff()
    }
    
    func hoverOver() {}
    func hoverOff() {}
    
    override func resetCursorRects() {
        self.addCursorRect(self.bounds, cursor: .pointingHand)
    }
}
