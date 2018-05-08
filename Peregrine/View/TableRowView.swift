import Cocoa

class TableRowView: NSTableRowView, Hoverable {
    
    @IBOutlet weak var text: NSTextField!
    @IBOutlet weak var button: NSButton!
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        self.trackHover()
        self.selectionHighlightStyle = .regular
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

/*  Uncomment to show hand cursor
    override func resetCursorRects() {
        self.discardCursorRects()
        self.addCursorRect(self.bounds, cursor: .pointingHand)
    }
 */
 
    override var isEmphasized: Bool {
        set {}
        get {
            return true
        }
    }
    
    override func updateTrackingAreas() {
        self.trackHover()
        super.updateTrackingAreas()
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        self.isSelected = true
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        self.isSelected = false
    }
}
