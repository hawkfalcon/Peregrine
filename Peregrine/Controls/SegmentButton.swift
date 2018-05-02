import Cocoa

class SegmentedControl: NSSegmentedControl, Hoverable {
    
    override func awakeFromNib() {
        trackHover()
    }
    
    override func resetCursorRects() {
        self.discardCursorRects()
        self.addCursorRect(self.bounds, cursor: .pointingHand)
    }
}
