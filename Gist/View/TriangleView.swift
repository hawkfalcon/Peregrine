import Cocoa

class TriangleView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    // All of this is required to make the triangle colored...
    override func viewDidMoveToWindow() {
        guard let frameView = window?.contentView?.superview else {
            return
        }
        
        let bounds = frameView.bounds
        let offset: CGFloat = 20.0
        let frame = NSRect(x: bounds.minX, y: bounds.maxY - offset, width: bounds.width, height: offset)
        let backgroundView = NSView(frame: frame)
        backgroundView.wantsLayer = true
        backgroundView.layer?.backgroundColor = CGColor.gistGray
        backgroundView.autoresizingMask = [.width, .height]
        
        frameView.addSubview(backgroundView, positioned: .below, relativeTo: frameView)
    }
    
}
