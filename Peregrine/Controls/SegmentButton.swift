import Cocoa

class SegmentButton: NSSegmentedControl, Hoverable {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        trackHover()
    }
    
    override func resetCursorRects() {
        discardCursorRects()
        self.addCursorRect(self.bounds, cursor: .pointingHand)
    }
}
