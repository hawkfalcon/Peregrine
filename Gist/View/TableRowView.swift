import Cocoa

class TableRowView: NSTableRowView, Hoverable {
    
    @IBOutlet weak var text: NSTextField!
    @IBOutlet weak var button: NSButton!
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        trackHover()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
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
