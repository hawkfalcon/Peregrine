import Cocoa

class BasicText: NSTextField, ClearControl {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textColor = .white
        self.stringValue = ""
        
        applyClear()
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
}
