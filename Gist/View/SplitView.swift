import Cocoa

class SplitView: NSSplitView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    override var dividerThickness: CGFloat{
        return 0.0
    }
    
    override var dividerColor: NSColor {
        return .clear
    }
}
